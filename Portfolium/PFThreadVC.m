//
//  PFThreadVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFThreadVC.h"
#import "PFContentView.h"
#import "PFThreadViewCell.h"
#import "PFActivityIndicatorView.h"
#import "PFApi.h"
#import "PFProfileVC.h"
#import "PFThread.h"
#import "TTTAttributedLabel.h"
#import "PFMessage.h"
#import "PFProfile.h"
#import "PFRootViewController.h"
#import "PFImage.h"
#import "PFUsersVC.h"
#import "PFAvatar.h"
#import "UIImageView+PFImageLoader.h"
#import "UITabBarController+PFExtensions.h"
#import "PFConstraints.h"
#import "PFButton.h"
#import "PFMessagesReplyVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFAuthenticationProvider.h"
#import "PFMVVModel.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "PFDateUtils.h"
#import "PFErrorHandler.h"
#import "PFHomeVC.h"
#import "UITableView+PFExtensions.h"
#import "PFNavigationController.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"
#import "PFSize.h"
#import "PFAppDelegate.h"
#import "PFMessagesVC.h"

static const NSInteger kTabReply = 0;
static const NSInteger kTabArchive = 1;
static const NSInteger kTabUp = 2;
static const NSInteger kTabDown = 3;

static NSInteger kButtonCount = 4;
static CGFloat kTabbarFontSize = 22;

@interface PFThreadVC ()

@property(nonatomic, strong) NSNumber *threadId;
@property(nonatomic, strong) NSString *subject;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, strong) UIView *tabBar;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, assign) BOOL archived;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, strong) NSNumber *previousThreadId;
@property(nonatomic, strong) NSNumber *nextThreadId;
@property(nonatomic, weak) PFMessagesVC *delegate;

@end

@implementation PFThreadVC

@synthesize shimmed = _shimmed;

+ (PFThreadVC *)_new:(NSNumber *)threadId
             subject:(NSString *)subject
            archived:(BOOL)archived
            delegate:(PFMessagesVC *)delegate; {
    
    PFThreadVC *vc = [[PFThreadVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setThreadId:threadId];
    [vc setSubject:subject];
    [vc setArchived:archived];
    [vc setDelegate:delegate];
    
    return vc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nil bundle:nil];
    
    if(self) {
        
        @weakify(self)
        
        [self setErrorBlock:^NSError *(NSError *error) {
            
            @strongify(self)
            
            [[PFErrorHandler shared] showInErrorBar:error
                                           delegate:nil
                                             inView:[self view]
                                             header:PFHeaderOpaque];
            return error;
        }];
    }
    
    return self;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentOffset:-44.0f];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFThreadViewCell class]
      forCellReuseIdentifier:[PFThreadViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[PFColor lighterGrayColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setTableFooterView:[UIView new]];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageSent:)
                                                 name:kMessageSent
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteArchiveSent:)
                                                 name:kDeleteArchiveSent
                                               object:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setTitle:[self subject]];
    
    UIButton *usersButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [usersButton setFrame:CGRectMake(0, 0, 30, 30)];
    [usersButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *normalIcon = [FAKFontAwesome usersIconWithSize:22];
    [normalIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *selectedIcon = [FAKFontAwesome usersIconWithSize:22];
    [selectedIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    
    [usersButton setAttributedTitle:[normalIcon attributedString]
                           forState:UIControlStateNormal];
    [usersButton setAttributedTitle:[selectedIcon attributedString]
                           forState:UIControlStateSelected];
    [usersButton setAttributedTitle:[selectedIcon attributedString]
                           forState:UIControlStateSelected | UIControlStateHighlighted];

    [usersButton addTarget:self
                   action:@selector(usersButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *usersItem = [[UIBarButtonItem alloc] initWithCustomView:usersButton];
    [[self navigationItem] setRightBarButtonItem:usersItem];
    
    UIView *tabBar = [[UIView alloc] initWithFrame:
                      CGRectMake(0, [PFSize screenHeight] - 48, [PFSize screenWidth], 48)];
    
    [tabBar setBackgroundColor:[UIColor clearColor]];
    [[self view] addSubview:tabBar];
    [self setTabBar:tabBar];
    
    for(int i = 0; i < kButtonCount; i++) {
        [self buildTabbarButton:i];
    }
    
    [self setUpImageBackButton];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], 64)];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [[self view] addSubview:shim];
    [self setShim:shim];
    
    [shim setHidden:YES];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self state] == PFViewControllerLaunching) {
    
        [[[self contentView] spinner] startAnimating];
        [self loadData];
    }
    
    [[[self navigationController] navigationBar] restyleNavigationBarTranslucentBlack];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kMessageThreadPage
                       withIdentifier:[self threadId]];
    
    [[[PFHomeVC shared] tabBarController] setTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    [[[PFHomeVC shared] tabBarController] setMainTabBarHidden:NO animated:YES];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
    
    [[self tableView] setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (void)loadData; {
    
    @weakify(self)
    
    [self setState:PFViewControllerLoading];
    
    [[PFApi shared] getThread:[self threadId]
                      success:^(PFThread *thread) {
                          
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              @strongify(self)
                              
                              [self setDataSource:[NSMutableArray arrayWithArray:[thread messages]]];
                              
                              [self setTitle:[thread subject]];
                              
                              [self setPreviousThreadId:[thread previousThreadId]];
                              [self setNextThreadId:[thread nextThreadId]];
                              
                              [self returnFromApi];
                              
                              if([[self dataSource] count] > 0) {
                                  //[[self tableView] setSeparatorColor:[PFColor lightGrayColor]];
                              }
                              
                              if([thread readAt] == nil) {
                                  [[PFAppDelegate shared] messageRead];
                              }
                              
                              [[self delegate] markMessageRead:[self threadId]];
                            
                              [[self tableView] reloadData];
                          });
                          
                      } failure:^NSError *(NSError *error) {
                          
                          @strongify(self)
                          
                          [self returnFromApi];
                          
                          return [self errorBlock](error);
                      }];
}

- (void)returnFromApi; {
    
    [[[self contentView] spinner] stopAnimating];
    
    [self setState:PFViewControllerReady];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return [[self dataSource] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFThreadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                [PFThreadViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFThreadViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:[PFThreadViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    PFMessage *message = [[self dataSource] objectAtIndex:[indexPath row]];
    
    [cell setVc:self];
    [cell setUserId:[[message profile] userId]];
    [cell setThreadId:[message threadId]];
    
    [[cell nameLabel] setText:[[PFMVVModel shared] generateName:[message profile]]];
    
    @weakify(cell)
    
    [RACObserve([PFMVVModel shared], fullname) subscribeNext:^(NSString *fullname){
        
        @strongify(cell)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[cell userId]]) {
            
            [[cell nameLabel] setText:fullname];
        }
    }];
    
    [cell setMessage:[message body]];
    [[cell dateLabel] setText:[PFDateUtils dateStringToDateString:
                               [message createdAt]]];
    
    PFFilename *filename = [[PFFilename alloc] init];
    [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:[message profile]]];
    
    [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFThreadViewCell preferredAvatarSize]]
                   postProcessingBlock:nil
                         progressBlock:nil
                      placeholderImage:nil
                                fadeIn:YES];
    
    [RACObserve([PFMVVModel shared], avatarUrl) subscribeNext:^(NSString *avatarUrl){
        
        @strongify(cell)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[cell userId]]) {
            
            PFFilename *filename = [[PFFilename alloc] init];
            [filename setDynamic:avatarUrl];
            
            [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFThreadViewCell preferredAvatarSize]]
                           postProcessingBlock:nil
                                 progressBlock:nil
                              placeholderImage:nil
                                        fadeIn:YES];
        }
    }];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFMessage *message = [[self dataSource] objectAtIndex:[indexPath row]];
    
    return [PFThreadViewCell heightForRowAtThread:message];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    
    return [[UIView alloc] init];
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (void)usersButtonAction:(UIButton *)button; {
    
    PFUsersVC *vc = [PFUsersVC _new:[self threadId]];
    
    [[self navigationController] pushViewController:vc
                                           animated:YES];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

- (UIButton *)buildTabbarButton:(NSInteger)index; {
    
    UIButton *button = [PFButton tabBarButton];
    
    [button addTarget:self
               action:@selector(tabBarAction:)
     forControlEvents:UIControlEventTouchDown];
    
    if(index == kTabReply) {
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome replyIconWithSize:kTabbarFontSize];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome replyIconWithSize:kTabbarFontSize];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [button setAttributedTitle:[normalIcon attributedString]
                          forState:UIControlStateNormal];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        
    } else if(index == kTabArchive) {
        
        if(![self archived]) {
            
            FAKFontAwesome *normalIcon = [FAKFontAwesome archiveIconWithSize:kTabbarFontSize];
            [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
            
            FAKFontAwesome *selectedIcon = [FAKFontAwesome archiveIconWithSize:kTabbarFontSize];
            [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
            
            [button setAttributedTitle:[normalIcon attributedString]
                              forState:UIControlStateNormal];
            [button setAttributedTitle:[selectedIcon attributedString]
                              forState:UIControlStateSelected];
            [button setAttributedTitle:[selectedIcon attributedString]
                              forState:UIControlStateSelected | UIControlStateHighlighted];
            
        } else {
            
            FAKFontAwesome *normalIcon = [FAKFontAwesome trashIconWithSize:kTabbarFontSize];
            [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
            
            FAKFontAwesome *selectedIcon = [FAKFontAwesome trashIconWithSize:kTabbarFontSize];
            [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
            
            [button setAttributedTitle:[normalIcon attributedString]
                              forState:UIControlStateNormal];
            [button setAttributedTitle:[selectedIcon attributedString]
                              forState:UIControlStateSelected];
            [button setAttributedTitle:[selectedIcon attributedString]
                              forState:UIControlStateSelected | UIControlStateHighlighted];
        }
        
    } else if(index == kTabUp) {
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome chevronUpIconWithSize:kTabbarFontSize];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome chevronUpIconWithSize:kTabbarFontSize];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [button setAttributedTitle:[normalIcon attributedString]
                          forState:UIControlStateNormal];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        
    } else if(index == kTabDown) {
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome chevronDownIconWithSize:22];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome chevronDownIconWithSize:22];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [button setAttributedTitle:[normalIcon attributedString]
                          forState:UIControlStateNormal];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
    }

    CGFloat fourthOfScreen = roundf([PFSize screenWidth] / kButtonCount);
    
    [button setFrame:CGRectMake((fourthOfScreen * index), 1.0, fourthOfScreen,
                                [self tabBar].frame.size.height - 1.0)];
    
    [[self tabBar] addSubview:button];
    [button setTag:index];
    
    return button;
}

- (void)tabBarAction:(UIButton *)button; {
    
    switch ([button tag]) {
        
        case kTabReply: {
            
            PFMessage *message = [[self dataSource] objectAtIndex:0];
            PFMessagesReplyVC *vc = [PFMessagesReplyVC _new:[message threadId] name:[self subject]];
            
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
            [[nc navigationBar] restyleNavigationBarSolidBlack];
            
            [self presentViewController:nc animated:YES completion:^{
            }];
            
            break;
        }
            
        case kTabArchive: {
            
            if([self archived]) {
                
                [[PFApi shared] deleteThread:[self threadId]
                                     success:^{
                                         
                                         [[PFGoogleAnalytics shared] deletedMessageFromTabBar];
                                         
                                         [[NSNotificationCenter defaultCenter]
                                          postNotificationOnMainThreadName:kDeleteArchiveSent
                                          object:self
                                          userInfo:@{ @"threadId" : [self threadId] }];
                                         
                                         [[self navigationController] popViewControllerAnimated:YES];
                                         
                                     } failure:^NSError *(NSError *error) {
                                         
                                         return [self errorBlock](error);
                                     }];
                break;
                
            } else {

                [[PFApi shared] archiveThread:[self threadId]
                                      success:^{
                                          
                                          [[PFGoogleAnalytics shared] archivedMessageFromTabBar];
                                          
                                          [[NSNotificationCenter defaultCenter]
                                           postNotificationOnMainThreadName:kArchiveSent
                                           object:self
                                           userInfo:@{ @"threadId" : [self threadId] }];
                                          
                                          [[self navigationController] popViewControllerAnimated:YES];
                                          
                                      } failure:^NSError *(NSError *error) {
                                          
                                          return [self errorBlock](error);
                                      }];
                break;
            }
        }
            
        case kTabUp: {
            
            if([self nextThreadId] != nil && [self state] == PFViewControllerReady) {
                
                [self setThreadId:[self nextThreadId]];
                [self loadData];
            }
            
            break;
        }
            
        case kTabDown: {
            
            if([self previousThreadId] != nil && [self state] == PFViewControllerReady) {
                
                [self setThreadId:[self previousThreadId]];
                [self loadData];
            }
            
            break;
        }

        default: {
            break;
        }
    }
}

- (void)messageSent:(NSNotification *)notification; {
    
    PFMessage *message = [[notification userInfo] objectForKey:@"message"];
    
    [[self dataSource] insertObject:message atIndex:0];
    
    [[self tableView] reloadData];
    
    [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                            atScrollPosition:UITableViewScrollPositionTop
                                    animated:YES];
}

- (void)archiveSent:(NSNotification *)notification; {
    
    [self setArchived:YES];
}

- (void)deleteArchiveSent:(NSNotification *)notification; {
}

- (void)showShim; {
    
    [[self shim] setHidden:NO];
}

- (void)hideShim; {
    
    [[self shim] setHidden:YES];
}

- (BOOL)shimmed; {
    
    return _shimmed;
}

- (void)setShimmed:(BOOL)shimmed; {
    
    _shimmed = shimmed;
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
