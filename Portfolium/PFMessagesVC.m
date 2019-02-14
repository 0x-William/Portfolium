//
//  PFMessagesVC.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMessagesVC.h"
#import "PFContentView.h"
#import "PFMessagesViewCell.h"
#import "PFPagedDatasource.h"
#import "PFActivityIndicatorView.h"
#import "PFProfileVC.h"
#import "PFApi.h"
#import "PFThread.h"
#import "PFProfile.h"
#import "TTTAttributedLabel.h"
#import "PFImage.h"
#import "PFMessagesNewVC.h"
#import "PFThreadVC.h"
#import "PFRootViewController.h"
#import "PFAvatar.h"
#import "UIImageView+PFImageLoader.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFMessage.h"
#import "PFMVVModel.h"
#import "UIViewController+PFExtensions.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFColor.h"
#import "PFImage.h"
#import "PFErrorHandler.h"
#import "UIViewController+PFExtensions.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFFont.h"
#import "PFNavigationController.h"
#import "UIView+BlocksKit.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFAuthenticationProvider.h"
#import "PFShim.h"
#import "PFGoogleAnalytics.h"
#import "UITableView+PFExtensions.h"
#import "PFSize.h"
#import "FAKFontAwesome.h"
#import "PFAppDelegate.h"

const static int kMessages = 0;
const static int kArchived = 1;

static NSString *kEmptyCellIdentifier = @"EmptyCell";

@interface PFMessagesVC ()

@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataSource;
@property(nonatomic, assign) BOOL archived;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *comment;

@end

@implementation PFMessagesVC

@synthesize shimmed = _shimmed;

+ (PFMessagesVC *)_new; {
    
    PFMessagesVC *vc = [[PFMessagesVC alloc] initWithNibName:nil bundle:nil];
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
    [tableView registerClass:[PFMessagesViewCell class]
      forCellReuseIdentifier:[PFMessagesViewCell preferredReuseIdentifier]];
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:kEmptyCellIdentifier];
    [tableView setBackgroundColor:[PFColor lighterGrayColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setTableFooterView:[UIView new]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(messageSent:)
                                                 name:kMessageSent
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(threadSent:)
                                                 name:kThreadSent
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(archiveSent:)
                                                 name:kArchiveSent
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deleteArchiveSent:)
                                                 name:kDeleteArchiveSent
                                               object:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Inbox", nil)];
    
    [self setUpImageBackButtonForShim];
    [self setShim:[PFShim blackOpaqueFor:self]];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [titleLabel setFont:[PFFont systemFontOfLargeSize]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setUserInteractionEnabled:YES];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setUserInteractionEnabled:YES];
    [titleLabel setText:NSLocalizedString(@"Inbox", nil)];
    [[self navigationItem] setTitleView:titleLabel];
    [self setTitleLabel:titleLabel];
    
    @weakify(self);
    
    [titleLabel bk_whenTapped:^{
        
        @strongify(self);
        
        [self coronButtonAction:nil];
    }];
    
    UIButton *caron = [UIButton buttonWithType:UIButtonTypeCustom];
    [caron setFrame:CGRectMake(70, 0, 30, 30)];
    [caron setBackgroundColor:[UIColor clearColor]];
    [caron setImage:[PFImage chevronDown] forState:UIControlStateNormal];
    [titleLabel addSubview:caron];
    
    [caron bk_addEventHandler:^(id sender) {
        
        @strongify(self);
        
        [self coronButtonAction:sender];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, [self applicationFrameOffset] + 20,
                                                                [PFSize screenWidth], 30)];
    label1.font = [PFFont fontOfLargeSize];
    label1.textAlignment = NSTextAlignmentCenter;
    [self setLabel1:label1];
    [label1 setHidden:YES];
    
    label1.textColor = [PFColor grayColor];
    [[self contentView] addSubview:label1];
    
    FAKFontAwesome *commentIcon = [FAKFontAwesome envelopeIconWithSize:100];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UILabel *comment = [[UILabel alloc] initWithFrame:CGRectZero];
    comment.attributedText = [commentIcon attributedString];
    [comment sizeToFit];
    comment.center = CGPointMake([PFSize screenWidth]/2, [self applicationFrameOffset] + 100);
    comment.textColor = [PFColor lightGrayColor];
    [comment setHidden:YES];
    [self setComment:comment];
    
    [[self contentView] addSubview:comment];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self state] == PFViewControllerLaunching) {

        [self loadData]; [self setState:PFViewControllerReady];
    
    } else {
        
        [[self tableView] reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kMessagesPage];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (void)loadData; {
    
    [[[self contentView] spinner] startAnimating];
    
    if([self archived]) {
        
        [[self titleLabel] setTextAlignment:NSTextAlignmentLeft];
        [[self titleLabel] setText:NSLocalizedString(@"Archived", nil)];
        
        [self label1].text = @"You have no archived messages";
    
    } else {
        
        [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
        [[self titleLabel] setText:NSLocalizedString(@"Inbox", nil)];
        
        [self label1].text = @"You have no messages in your inbox";
    }
    
    [[self label1] setHidden:YES];
    [[self comment] setHidden:YES];
    
    [[PFApi shared] getThreads:[self archived]
                       success:^(NSArray *data) {
                           
                           [self setDataSource:[NSMutableArray arrayWithArray:data]];
                           
                           @weakify(self);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                           
                               @strongify(self);
                               
                               if([[self dataSource] count] > 0) {
                                   
                                   [self tableView].userInteractionEnabled = YES;
                                   [[self tableView] setSeparatorColor:[PFColor lightGrayColor]];
                               
                               } else {
                                   
                                   [self tableView].userInteractionEnabled = NO;
                                   
                                   [[self label1] setHidden:NO];
                                   [[self comment] setHidden:NO];
                               }
  
                               [[self tableView] reloadData];
                               [self returnFromApi];
                           });
                           
                       } failure:^NSError *(NSError *error) {
                           
                           @weakify(self);
                           
                           dispatch_async(dispatch_get_main_queue(), ^{
                               
                               @strongify(self);
                               
                               [self returnFromApi];
                           });
                           
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
    
    PFMessagesViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                [PFMessagesViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFMessagesViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:[PFMessagesViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:
                              [PFColor imageOfColor:[PFColor lighterGrayColor]]];
    
    [cell setSelectedBackgroundView:imageView];
    
    PFThread *thread = [[self dataSource] objectAtIndex:[indexPath row]];
    
    [cell setVc:self];
    [cell setDelegate:self];
    [cell setUserId:[thread lastUserId]];
    [cell setThreadId:[thread threadId]];
    
    @weakify(cell)
    
    [RACObserve([PFMVVModel shared], username) subscribeNext:^(NSString *username){

        @strongify(cell)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[cell userId]]) {
            
            [[cell usernameLabel] setText:username];
        }
    }];
    
    [[cell usernameLabel] setText:[[PFMVVModel shared] generateUsername:[thread profile]]];
    [[cell subjectLabel] setText:[thread subject]];
    
    [cell setMessage:[thread lastBody]];
    
    PFFilename *filename = [[PFFilename alloc] init];
    [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:[thread profile]]];
    
    [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFMessagesViewCell preferredAvatarSize]]
                   postProcessingBlock:nil
                         progressBlock:nil
                      placeholderImage:nil
                                fadeIn:YES];
    
    [RACObserve([PFMVVModel shared], avatarUrl) subscribeNext:^(NSString *avatarUrl){
        
        @strongify(cell)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[cell userId]]) {
            
            PFFilename *filename = [[PFFilename alloc] init];
            [filename setDynamic:avatarUrl];
            
            [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFMessagesViewCell preferredAvatarSize]]
                           postProcessingBlock:nil
                                 progressBlock:nil
                              placeholderImage:nil
                                        fadeIn:YES];
        }
    }];
    
    if(![self archived]) {
        
        [cell setRightUtilityButtons:[self rightButtons:
                                      NSLocalizedString(@"Archive", nil)]];
    
    } else {
        
        [cell setRightUtilityButtons:[self rightButtons:
                                      NSLocalizedString(@"Delete", nil)]];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFThread *thread = [[self dataSource] objectAtIndex:[indexPath row]];
    
    if([thread readAt] != nil) {
    
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
        
    } else {
        
        [[cell contentView] setBackgroundColor:[PFColor blueHighlight]];
    }
}


- (NSArray *)rightButtons:(NSString *)title; {
    
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    
    [rightUtilityButtons sw_addUtilityButtonWithColor:[UIColor redColor]
                                                title:NSLocalizedString(title, nil)];
    return rightUtilityButtons;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFThread *thread = [[self dataSource] objectAtIndex:[indexPath row]];
    
    return [PFMessagesViewCell heightForRowAtThread:thread];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFThread *thread = [[self dataSource] objectAtIndex:[indexPath row]];
    
    [thread setReadAt:[NSDate new]];
     
    [[self navigationController] pushViewController:[PFThreadVC _new:[thread threadId]
                                                             subject:[thread subject]
                                                            archived:[self archived]
                                                            delegate:self]
                                           animated:YES];
        
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    
    return [[UIView alloc] init];
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index; {
    
    @weakify(self);
    
    if(![self archived]) {
     
        [[PFApi shared] archiveThread:[(PFMessagesViewCell *)cell threadId]
                              success:^{
                                  
                                  [[PFGoogleAnalytics shared] archivedMessageFromSwipe];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      @strongify(self);
                                      
                                      NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
                                      
                                      [self deleteRowAtIndex:[indexPath row]];
                                      [[PFAppDelegate shared] messageRead];
                                  });
                                  
                              } failure:^NSError *(NSError *error) {
                                  
                                  @strongify(self);
                                  
                                  return [self errorBlock](error);
                              }];
    } else {
        
        [[PFApi shared] deleteThread:[(PFMessagesViewCell *)cell threadId]
                             success:^{
                                 
                                 [[PFGoogleAnalytics shared] archivedMessageFromSwipe];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     @strongify(self);
                                     
                                     NSIndexPath *indexPath = [[self tableView] indexPathForCell:cell];
                                     
                                     [self deleteRowAtIndex:[indexPath row]];
                                 });
                                 
                             } failure:^NSError *(NSError *error) {
                                 
                                 @strongify(self);
                                 
                                 return [self errorBlock](error);
                             }];
    }
}

- (void)newButtonAction:(UIButton *)button; {
    
    [[self navigationController] pushViewController:[PFMessagesNewVC _new]
                                           animated:YES];
}

- (void)messageSent:(NSNotification *)notification; {
    
    PFMessage *message = [[notification userInfo] objectForKey:@"message"];
    PFThread *thread;
    
    for(int i = 0; i < [[self dataSource] count]; i++) {
        
        thread = [[self dataSource] objectAtIndex:i];
        
        if([[thread threadId] integerValue] == [[message threadId] integerValue]) {
            
            [thread setLastUserId:[[message profile] userId]];
            [thread setProfile:[message profile]];
            [thread setLastBody:[self trimMessageBody:message]];
            
            [self setArchived:NO];
            [self loadData];
        }
    }

    [[self tableView] reloadData];
    [[self tableView] setContentOffset:CGPointZero animated:NO];
}

- (void)threadSent:(NSNotification *)notification; {
    
    PFThread *thread = [[notification userInfo] objectForKey:@"thread"];
    
    [[self dataSource] insertObject:thread atIndex:0];
    
    [[self tableView] reloadData];
    [[self tableView] setContentOffset:CGPointZero animated:NO];
}

- (void)archiveSent:(NSNotification *)notification; {
    
    NSNumber *threadId = [[notification userInfo] objectForKey:@"threadId"];
    PFThread *thread;
    
    for(int i = 0; i < [[self dataSource] count]; i++) {
        thread = [[self dataSource] objectAtIndex:i];
        if([[thread threadId] integerValue] == [threadId integerValue]) {
            [self deleteRowAtIndex:i];
        }
    }
}

- (void)deleteArchiveSent:(NSNotification *)notification; {
    
    NSNumber *threadId = [[notification userInfo] objectForKey:@"threadId"];
    PFThread *thread;
    
    for(int i = 0; i < [[self dataSource] count]; i++) {
        thread = [[self dataSource] objectAtIndex:i];
        if([[thread threadId] integerValue] == [threadId integerValue]) {
            [self loadData];
        }
    }
}

- (void)deleteRowAtIndex:(NSInteger)index; {
    
    [[self dataSource] removeObjectAtIndex:index];
    [[self tableView] reloadData];
    
    if([[self dataSource] count] == 0) {
        
        [[self label1] setHidden:NO];
        [[self comment] setHidden:NO];
    }
}

- (NSString *)trimMessageBody:(PFMessage *)message; {
    
    if([[message body] length] > 30) {
    
        NSRange range = NSMakeRange(0, 30);
        NSString *subString = [[message body] substringWithRange:range];
        
        return [NSString stringWithFormat:@"%@...", subString];
    
    } else {
        
        return [message body];
    }
}

- (void)coronButtonAction:(UIButton *)button; {
    
    NSString *messagesButtonName = NSLocalizedString(@"Inbox", @"");
    NSString *archivedButtonName = NSLocalizedString(@"Archived", @"");
    NSString *cancelButtonName = NSLocalizedString(@"Cancel", @"");
    
    NSArray *buttons = [NSArray arrayWithObjects:
                        messagesButtonName,
                        archivedButtonName,
                        nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:(id)self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    
    for(NSString *title in buttons)  {
        [actionSheet addButtonWithTitle:title];
    }
    
    [actionSheet addButtonWithTitle:cancelButtonName];
    [actionSheet setCancelButtonIndex:[buttons count]];
    [actionSheet showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex; {
    
    switch (buttonIndex) {
            
        case kMessages: {
            
            if([self archived]) {
            
                [self setArchived:NO];
                [self loadData];
            }
            
            break;
        }
            
        case kArchived: {
            
            if(![self archived]) {
            
                [self setArchived:YES];
                [self loadData];
            }
            
            break;
        }
            
        default: {
            break;
        }
    }
}

- (void)markMessageRead:(NSNumber *)threadId; {
    
    PFThread *thread = nil;
    for(int i = 0; i < [[self dataSource] count]; i++) {
        thread = [[self dataSource] objectAtIndex:i];
        if([[thread threadId] integerValue] == [threadId integerValue]) {
            [thread setReadAt:[NSDate new]]; break;
        }
    }
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

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
