//
//  PFProfileVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfileVC.h"
#import "PFProfileTypeVC.h"
#import "PFCView.h"
#import "PFApi.h"
#import "PFProfileHeaderView.h"
#import "UIImageView+PFImageLoader.h"
#import "PFRootViewController.h"
#import "PFImage.h"
#import "PFMessagesNewVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFAuthenticationProvider.h"
#import "PFNetworkViewItem.h"
#import "PFCommentsVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFProfile.h"
#import "PFAvatar.h"
#import "PFProfileSectionHeaderView.h"
#import "PFActivityIndicatorView.h"
#import "PFCover.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "NSString+PFExtensions.h"
#import "PFApi.h"
#import "PFErrorHandler.h"
#import "PFStatus.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFApi.h"
#import "PFNavigationController.h"
#import "PFContentView.h"
#import "PFDetailVC.h"
#import "PFBarButtonContainer.h"
#import "PFFont.h"
#import "PFColor.h"
#import "UIColor+PFEntensions.h"
#import "PFEntryView.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"
#import "NSAttributedString+CCLFormat.h"
#import "PFSize.h"
#import "PFFontAwesome.h"
#import "PFProfile+PFExtensions.h"
#import "UIButton+PFExtensions.h"
#import "PFUzer+PFExtensions.h"

@interface PFProfileVC ()

@property(nonatomic, strong) NSString *username;
@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, weak)   PFProfileTypeVC *activeVC;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *mailButton;
@property(nonatomic, strong) UIButton *mailButtonForView;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, strong) PFProfile *profile;
@property(nonatomic, strong) UIView *rightBarButtonContainer;
@property(nonatomic, strong) UIButton *acceptButton;
@property(nonatomic, strong) UIButton *acceptButtonForView;
@property(nonatomic, strong) UILabel *titleLabel;

@end

@implementation PFProfileVC

+ (PFProfileVC *)_new:(NSNumber *)userId; {
    
    PFProfileVC *vc = [[PFProfileVC alloc] initWithNibName:nil
                                                    bundle:nil
                                                    userId:(NSNumber *)userId];
    [vc setUserId:userId];
    
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
               userId:(NSNumber *)userId; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setEntriesVC:[PFProfileTypeVC _entries:self userId:userId]];
        [self setAboutVC:[PFProfileTypeVC _about:self userId:userId]];
        [self setConnectionsVC:[PFProfileTypeVC _connections:self userId:userId]];
        
        [[self entriesVC] view];
        [[self aboutVC] view];
        [[self connectionsVC] view];
        
        @weakify(self)
        
        [self setErrorBlock:^NSError *(NSError *error) {
            
            @strongify(self)
            
            [[PFErrorHandler shared] showInErrorBar:error
                                           delegate:nil
                                             inView:[self view]
                                             header:PFHeaderHiding];
            return error;
        }];
    }
    
    return self;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [titleLabel setFont:[PFFont systemFontOfLargeSize]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setUserInteractionEnabled:YES];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setUserInteractionEnabled:YES];
    [[self navigationItem] setTitleView:titleLabel];
    [self setTitleLabel:titleLabel];
    
    UIView *blackHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height)];
    blackHeader.layer.backgroundColor = [PFColor blackColorOpaque].CGColor;
    [self.view addSubview:blackHeader];
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, [PFSize screenWidth], [PFSize screenHeight])];
    emptyView.layer.backgroundColor = [PFColor lighterGrayColor].CGColor;
    //[emptyView setHidden:YES];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 50, [PFSize screenWidth], 30)];
    label1.font = [PFFont fontOfLargeSize];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"This is a private profile";
    label1.textColor = [PFColor grayColor];
    [label1 setHidden:YES];
    [emptyView addSubview:label1];
    
    FAKFontAwesome *userIcon = [FAKFontAwesome lockIconWithSize:150];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UILabel *user = [[UILabel alloc] initWithFrame:CGRectZero];
    user.attributedText = [userIcon attributedString];
    [user sizeToFit];
    user.center = CGPointMake([PFSize screenWidth] / 2, 180);
    user.textColor = [PFColor lightGrayColor];
    [user setHidden:YES];
    
    [emptyView addSubview:user];
    [self.view addSubview:emptyView];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(5, 29, 36, 26)];
    [backButton setImage:[PFImage chevronBack] forState:UIControlStateNormal];
    [backButton bk_addEventHandler:^(id sender) {
        [[self navigationController] popViewControllerAnimated:YES];
    } forControlEvents:UIControlEventTouchUpInside];
    [[self view] addSubview:backButton];
    [self setBackButton:backButton];

    @weakify(self);
    
    [[PFApi shared] getUserWithId:[self userId]
                          success:^(PFUzer *user) {
                              
                              @strongify(self)
                              
                              [emptyView setHidden:YES];
                              
                              PFProfile *profile = [[PFProfile alloc] init];
                              [profile setUserId:[user userId]];
                              [profile setStatus:[user status]];
                              [self setProfile:profile];
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  [blackHeader setHidden:YES];
                                  
                                  [self setHeaderForVC:[self entriesVC] user:user];
                                  [self setHeaderForVC:[self aboutVC] user:user];
                                  [self setHeaderForVC:[self connectionsVC] user:user];
                                  [self setUsername:[user username]];
                                  
                                  [[self titleLabel] setText:[NSString stringWithFormat:@"%@ %@",
                                                              [user firstname], [user lastname]]];
                                  
                                  if([user isConnected]) {
                                      
                                      [self initMailButton];
                                      
                                  } else {
                                      
                                      if([user isPending]) {
                                          
                                          [self initConnectButton];
                                          
                                          [[self connectButton] toPendingState];
                                          [[self connectButtonForView] toPendingState];
                                          
                                      } else if([user isAwaitingAccept]) {
                                          
                                          [self initAcceptButton];
                                          
                                      } else {
                                          
                                          if(![[PFAuthenticationProvider shared]
                                               userIdIsLoggedInUser:[user userId]]) {
                                              
                                              [self initConnectButton];
                                          }
                                      }
                                  }
                              });
                              
                          } failure:^NSError *(NSError *error, NSInteger code) {
                              
                              if (code == 403) {
                                  [label1 setHidden:NO];
                                  [user setHidden:NO];
                              }

                              return error;
                          }];
    
    UIView *shim = [[UIView alloc] initWithFrame:
                    CGRectMake(0, 0, [PFSize screenWidth], [self applicationFrameOffset])];
    
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [shim setHidden:YES];
    [[self view] addSubview:shim];
    [self setShim:shim];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userConnected:)
                                                 name:kUserConnected
                                               object:nil];
}

- (void)initMailButton; {
    
    UIButton *mailButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [mailButton setFrame:CGRectMake(0, 0, 30, 30)];
    [mailButton setBackgroundColor:[UIColor clearColor]];
    [mailButton setImage:[PFImage mailWhite]
                forState:UIControlStateNormal];
    [mailButton setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [mailButton addTarget:self
                   action:@selector(mailButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *mailItem = [[UIBarButtonItem alloc] initWithCustomView:mailButton];
    [mailButton setAlpha:0];
    [self setMailButton:mailButton];
    
    self.navigationItem.rightBarButtonItems = @[mailItem];
    
    UIButton *mailButtonForView =  [UIButton buttonWithType:UIButtonTypeCustom];
    [mailButtonForView setFrame:CGRectMake([PFSize screenWidth] - 46, 27, 30, 30)];
    [mailButtonForView setBackgroundColor:[UIColor clearColor]];
    [mailButtonForView setImage:[PFImage mailWhite]
                       forState:UIControlStateNormal];
    [mailButtonForView setImageEdgeInsets:UIEdgeInsetsMake(5, 0, 5, 0)];
    [mailButtonForView addTarget:self
                          action:@selector(mailButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    [mailButtonForView setAlpha:0];
    
    [self setMailButtonForView:mailButtonForView];
    [[self view] addSubview:mailButtonForView];
    
    @weakify(self)
    
    [UIView animateWithDuration:0.4 animations:^{
        
        @strongify(self)
        
        [[self mailButton] setAlpha:1];
        [[self mailButtonForView] setAlpha:1];
    }];
}

- (void)initConnectButton; {
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer connect:^(id sender) {
        
        @strongify(self) [self doConnectButton:sender];
    }];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:rightBarButtonContainer]];
    
    [self setConnectButton:[[rightBarButtonContainer subviews] objectAtIndex:0]];
    [self setRightBarButtonContainer:rightBarButtonContainer];
    
    UIButton *connectButtonForView = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [connectButtonForView setBackgroundColor:[UIColor clearColor]];
    [connectButtonForView setAlpha:0.0f];
    [connectButtonForView setAdjustsImageWhenHighlighted:NO];
    [connectButtonForView setFrame:CGRectMake([PFSize screenWidth] - 56, 25.0f, 50.0f, 36.0f)];
    [connectButtonForView toConnectState];
    [[connectButtonForView titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    [[self view] addSubview:connectButtonForView];
    [self setConnectButtonForView:connectButtonForView];
    
    [connectButtonForView bk_addEventHandler:^(id sender) {
        
        @strongify(self); [self doConnectButton:sender];
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)doConnectButton:(UIButton *)button; {
    
    [button setUserInteractionEnabled:NO];
    
    @weakify(self)
    
    [[PFApi shared] connect:[self userId] success:^{
        
        @strongify(self);
        
        NSDictionary *userInfo = @{ @"profile" : [self profile] };
        
        [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kUserConnected
                                                                        object:self
                                                                      userInfo:userInfo];
        
    } failure:^NSError *(NSError *error) {
        
        @strongify(self);
        
        [button setUserInteractionEnabled:YES];
        
        return [self errorBlock](error);
    }];
}

- (void)initAcceptButton; {
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer accept:^(id sender) {
        
        @strongify(self); [self doAcceptButton];
    }];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:[self rightBarButtonContainer]]];
    
    [self setAcceptButton:[[rightBarButtonContainer subviews] objectAtIndex:0]];
    [self setRightBarButtonContainer:rightBarButtonContainer];
    [[self acceptButton] toAcceptState];
    
    UIButton *acceptButtonForView = [UIButton buttonWithType:UIButtonTypeCustom];
    [acceptButtonForView setFrame:CGRectMake([PFSize screenWidth] - 56, 25, 50.0f, 36)];
    [acceptButtonForView setAdjustsImageWhenHighlighted:NO];
    [acceptButtonForView toAcceptState];
    [[acceptButtonForView titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    [self setAcceptButtonForView:acceptButtonForView];
    [[self view] addSubview:acceptButtonForView];
    
    [[self acceptButtonForView] bk_addEventHandler:^(id sender) {
        
        @strongify(self); [self doAcceptButton];
        
    } forControlEvents:UIControlEventTouchUpInside];
}

- (void)doAcceptButton; {
    
    NSDictionary *userInfo = @{ @"profile" : [self profile] };
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kUserConnected
                                                                    object:self
                                                                  userInfo:userInfo];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self activeVC] != nil) {
        [[self activeVC] viewWillAppear:animated];
    }
    
    if([self state] == PFViewControllerLaunching) {
        
        [self layoutVC:[self entriesVC]];
        [self setState:PFViewControllerReady];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kProfilePage
                       withIdentifier:[self userId]];
    
    [self showTitleElements];
    
    if([self activeVC] != nil) {
        [[self activeVC] viewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    [self hideTitleElements];
    
    [[self shim] setAlpha:[self currentNavigationBarAlpha]];
    [[self shim] setHidden:NO];
}

- (void)viewDidDisappear:(BOOL)animated; {
    
    [super viewDidDisappear:animated];
    
    [self hideTitleElements];
    
    [[self shim] setAlpha:[self currentNavigationBarAlpha]];
    [[self shim] setHidden:YES];
}

- (void)entriesButtonAction:(UIButton *)button; {
    
    [self layoutVC:[self entriesVC]];
}

- (void)aboutButtonAction:(UIButton *)button; {
    
    [self layoutVC:[self aboutVC]];
}

- (void)connectionsButtonAction:(UIButton *)button; {
    [self layoutVC:[self connectionsVC]];
}

- (void)layoutVC:(PFProfileTypeVC *)vc; {
    
    PFContentView *view = (PFContentView *)[vc view];
    [[self contentView] setContentView:view];
    [self setActiveVC:vc];
    
    [self viewDidLayout];
}

- (void)viewDidLayout; {
    
    [[self activeVC] viewWillAppear:YES];
    [[self activeVC] viewDidAppear:YES];
}

- (void)setHeaderForVC:(PFProfileTypeVC *)vc user:(PFUzer *)user; {
    
    PFProfileHeaderView *headerView = [vc headerView];
    
    [[headerView imageView] setAlpha:0.0f];
    [[headerView avatarView] setAlpha:0.0f];
    
    [headerView setName:[NSString stringWithFormat:@"%@ %@",
                         [user firstname],
                         [user lastname]]];
    
    [headerView setSchool:[user school]];
    
    [[headerView avatarView] setImageWithUrl:[[user avatar] url]
                         postProcessingBlock:nil
                            placeholderImage:nil];
    
    [[headerView nameLabel] setText:[NSString stringWithFormat:@"%@ %@",
                                     [user firstname],
                                     [user lastname]]];
    
    [[headerView schoolLabel] setText:[user school]];
    
    [[headerView imageView] setImageWithUrl:[[user cover] url]
                        postProcessingBlock:nil
                              progressBlock:nil
                           placeholderImage:nil
                                        tag:0
                                   callback:^(UIImage *image, NSInteger tag) {
                                       
                                       [UIView animateWithDuration:0.2
                                                        animations:^{
                                                            
                                                            [[self connectButtonForView] setAlpha:1.0f];
                                                            [headerView addBorderToAvatar];
                                                            
                                                            [[headerView gradient] setHidden:NO];
                                                            [[headerView imageView] setAlpha:1.0f];
                                                            [[headerView avatarView] setAlpha:1.0f];
                                                        }];
                                   }
     ];
    
    [headerView setNeedsLayout];
}

- (void)mailButtonAction:(UIButton *)button; {
    
    PFMessagesNewVC *vc = [PFMessagesNewVC _new:[self userId] username:[self username]];
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    [[nc navigationBar] restyleNavigationBarSolidBlack];
    
    [self presentViewController:nc animated:YES completion:^{
    }];
}

- (void)hideTitleElements; {
    
    [[self titleLabel] setHidden:YES];
    [[self mailButton] setHidden:YES];
}

- (void)showTitleElements; {
    
    [[self titleLabel] setHidden:NO];
    [[self mailButton] setHidden:NO];
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    if([userId integerValue] == [[self userId] integerValue]) {
        
        [[self contentView] shake];
        
    } else {
        
        [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                                   animated:YES];
    }
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [[self rootNavigationController] pushDetailVC:[PFDetailVC _new:[entry entryId] delegate:self]
                                         animated:YES];
}

- (CGFloat)currentNavigationBarAlpha; {
    
    return [[self activeVC] currentNavigationBarAlpha];
}

- (void)userConnected:(NSNotification *)notification; {
    
    PFProfile *profile = [[notification userInfo] objectForKey:@"profile"];
    
    if([[[self profile] userId] integerValue] == [[profile userId] integerValue]) {
        
        if([[profile status] token] == nil) {
            
            @weakify(self)
            
            [UIView animateWithDuration:0.2 animations:^{
                
                @strongify(self)
                
                [[self connectButton] toPendingState];
                [[self connectButtonForView] toPendingState];
            }];
            
            PFStatus *status = [[PFStatus alloc] init];
            [status setStatus:kPending];
            [profile setStatus:status];
            
        } else {
            
            [[[self navigationController] navigationBar] setUserInteractionEnabled:NO];
            
            [[PFApi shared] accept:[[[self profile] status] token]
                           success:^(PFUzer *user) {
                               
                               @weakify(self)
                               
                               [UIView animateWithDuration:0.2 animations:^{
                                   
                                   @strongify(self)
                                   
                                   [[self acceptButton] setAlpha:0];
                                   [[self acceptButtonForView] setAlpha:0];
                                   
                               } completion:^(BOOL finished) {
                                   
                                   @strongify(self)
                                   
                                   [self initMailButton];
                               }];
                               
                               PFStatus *status = [[PFStatus alloc] init];
                               [status setStatus:kConnected];
                               
                               [[self profile] setStatus:status];
                               [[self profile] setConnected:@1];
                               
                           } failure:^NSError *(NSError *error) {
                               
                               return [self errorBlock](error);
                           }];
            
            [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
        }
    }
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFCView *)contentView; {
    
    return (PFCView *)[self view];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
