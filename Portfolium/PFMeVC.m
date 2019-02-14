//
//  PFMeVC.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMeVC.h"
#import "PFMeTypeVC.h"
#import "PFCView.h"
#import "PFContentView.h"
#import "PFImage.h"
#import "PFApi.h"
#import "PFAuthenticationProvider.h"
#import "PFProfileHeaderView.h"
#import "UIImageView+PFImageLoader.h"
#import "PFMessagesNewVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFSettingsVC.h"
#import "PFEditProfileVC.h"
#import "PFMVVModel.h"
#import "PFAvatar.h"
#import "UINavigationBar+PFExtensions.h"
#import "NSString+PFExtensions.h"
#import "PFFont.h"
#import "PFMessagesVC.h"
#import "PFNotificationsVC.h"
#import "PFNetworkViewItem.h"
#import "PFProfileVC.h"
#import "PFNavigationController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFMVVModel.h"
#import "PFAuthenticationProvider.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFDetailVC.h"
#import "PFAuthenticationProvider.h"
#import "PFGoogleAnalytics.h"
#import "PFColor.h"
#import "FAKFontAwesome.h"
#import "PFSize.h"
#import "PFJeweledButton.h"
#import "PFAppDelegate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

static const NSInteger kEditProfile = 0;
static const NSInteger kSettings = 1;
static const NSInteger kHelp = 2;

static NSString *kUrl = @"https://portfolium.zendesk.com/hc/en-us"\
                         "/categories/200213075-Getting-Started-with-Portfolium";
@interface PFMeVC ()

@property(nonatomic, strong) PFMeTypeVC *entriesVC;
@property(nonatomic, strong) PFMeTypeVC *aboutVC;
@property(nonatomic, strong) PFMeTypeVC *connectionsVC;
@property(nonatomic, strong) PFUzer *user;
@property(nonatomic, strong) UIButton *cogButton;
@property(nonatomic, strong) UIView *titleLabel;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, strong) UIButton *cogButtonForView;
@property(nonatomic, strong) PFJeweledButton *bellButton;
@property(nonatomic, strong) PFJeweledButton *mailButton;
@property(nonatomic, strong) PFJeweledButton *mailButtonForView;
@property(nonatomic, strong) PFJeweledButton *bellButtonForView;

@end

@implementation PFMeVC

+ (PFMeVC *)_new; {
    
    PFMeVC *vc = [[PFMeVC alloc] initWithNibName:nil bundle:nil];
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setEntriesVC:[PFMeTypeVC _entries:self]];
        [self setAboutVC:[PFMeTypeVC _about:self]];
        [self setConnectionsVC:[PFMeTypeVC _connections:self]];
        
        [[self entriesVC] view];
        [[self aboutVC] view];
        [[self connectionsVC] view];
    }
    
    return self;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [[[self navigationController] navigationBar] setHidden:YES];
    
    UIButton *cogButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cogButton setFrame:CGRectMake(0, 0, 30, 30)];
    [cogButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *cogIcon = [FAKFontAwesome cogIconWithSize:18];
    [cogIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *selectedCogIcon = [FAKFontAwesome cogIconWithSize:18];
    [selectedCogIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    
    [cogButton setAttributedTitle:[cogIcon attributedString]
                          forState:UIControlStateNormal];
    [cogButton setAttributedTitle:[selectedCogIcon attributedString]
                          forState:UIControlStateHighlighted];
    [cogButton setAttributedTitle:[selectedCogIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [cogButton addTarget:self
                  action:@selector(cogButtonAction:)
        forControlEvents:UIControlEventTouchUpInside];
    [self setCogButton:cogButton];
    
    UIBarButtonItem *cogItem = [[UIBarButtonItem alloc] initWithCustomView:cogButton];
    [[self navigationItem] setLeftBarButtonItem:cogItem];
    
    UIButton *cogButtonForView =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cogButtonForView setFrame:CGRectMake(16, 27, 30, 30)];
    [cogButtonForView setAlpha:0];
    [cogButtonForView setBackgroundColor:[UIColor clearColor]];
    
    [cogButtonForView setAttributedTitle:[cogIcon attributedString]
                                forState:UIControlStateNormal];
    [cogButtonForView setAttributedTitle:[selectedCogIcon attributedString]
                                forState:UIControlStateHighlighted];
    [cogButtonForView setAttributedTitle:[selectedCogIcon attributedString]
                                forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [cogButtonForView addTarget:self
                          action:@selector(cogButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
    
    [self setCogButtonForView:cogButtonForView];
    [[self view] addSubview:cogButtonForView];
    
    UIButton *mailButtonForView =  [PFJeweledButton _mail:^(id sender) {
        [self mailButtonAction:sender];
    }];
    
    [mailButtonForView setFrame:CGRectMake([PFSize screenWidth] - 84, 27, 30, 30)];
    [mailButtonForView setAlpha:0];
    [mailButtonForView setBackgroundColor:[UIColor clearColor]];
    [self setMailButtonForView:mailButtonForView];
    [[self view] addSubview:mailButtonForView];
    
    UIButton *bellButtonForView = [PFJeweledButton _bell:^(id sender) {
        [self bellButtonAction:sender];
    }];
    
    [bellButtonForView setAlpha:0];
    [bellButtonForView setFrame:CGRectMake([PFSize screenWidth] - 46, 27, 30, 30)];
    [bellButtonForView setBackgroundColor:[UIColor clearColor]];
    [self setBellButtonForView:bellButtonForView];
    [[self view] addSubview:bellButtonForView];
    
    PFJeweledButton *mailButton = [PFJeweledButton _mail:^(id sender) {
        [self mailButtonAction:sender];
    }];
    
    UIBarButtonItem *mailItem = [[UIBarButtonItem alloc] initWithCustomView:mailButton];
    [self setMailButton:mailButton];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                target:nil action:nil];
    [fixedSpaceBarButtonItem setWidth:0];
    
    PFJeweledButton *bellButton = [PFJeweledButton _bell:^(id sender) {
        [self bellButtonAction:sender];
    }];
    
    UIBarButtonItem *bellItem = [[UIBarButtonItem alloc] initWithCustomView:bellButton];
    [self setBellButton:bellButton];
    
    self.navigationItem.rightBarButtonItems = @[bellItem, fixedSpaceBarButtonItem,  mailItem];
    
    @weakify(self)
    
    [RACObserve([PFAppDelegate shared], notifications) subscribeNext:^(NSNumber *notifications) {
        
        @strongify(self)
        
        [[self bellButtonForView] setCount:notifications];
        [[self bellButton] setCount:notifications];
    }];
    
    [RACObserve([PFAppDelegate shared], messages) subscribeNext:^(NSNumber *messages) {
        
        @strongify(self)
        
        [[self mailButtonForView] setCount:messages];
        [[self mailButton] setCount:messages];
    }];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 64)];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [shim setHidden:YES];
    [[self view] addSubview:shim];
    [self setShim:shim];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self activeVC] != nil) {
        [[self activeVC] viewWillAppear:animated];
    }
    
    if([self state] == PFViewControllerLaunching) {
        
        [[PFApi shared] me:^(PFUzer *user) {
            
            [self setUser:user];
            [self setHeaderForVC:[self entriesVC] user:user];
            [self setHeaderForVC:[self aboutVC] user:user];
            [self setHeaderForVC:[self connectionsVC] user:user];
            
            [self layoutVC:[self entriesVC]];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
            [titleLabel setFont:[PFFont systemFontOfLargeSize]];
            [titleLabel setTextColor:[UIColor whiteColor]];
            [titleLabel setBackgroundColor:[UIColor clearColor]];
            [[self navigationItem] setTitleView:titleLabel];
            [self setTitleLabel:titleLabel];
            
            RAC(titleLabel, text) = RACObserve([PFMVVModel shared], fullname);
            
            [self setState:PFViewControllerReady];
            
            [[[self navigationController] navigationBar] setHidden:NO];
            [[[self navigationController] navigationBar] setAlpha:0.01f];
            
        } failure:^NSError *(NSError *error) {
            
            return error;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [self showTitleElements];
    
    [[PFGoogleAnalytics shared] track:kMePage];
    
    if([self activeVC] != nil) {
        
        [[self activeVC] viewDidAppear:animated];
    }
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
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

- (void)layoutVC:(PFMeTypeVC *)vc; {
    
    PFContentView *view = (PFContentView *)[vc view];
    [[self contentView] setContentView:view];
    [self setActiveVC:vc];
    
    [self viewDidLayout];
}

- (void)viewDidLayout; {
    
    [[self activeVC] viewWillAppear:YES];
    [[self activeVC] viewDidAppear:YES];
}

- (void)setHeaderForVC:(PFMeTypeVC *)vc user:(PFUzer *)user; {
    
    PFProfileHeaderView *headerView = [vc headerView];
    
    RAC([headerView nameLabel], text) = RACObserve([PFMVVModel shared], fullname);
    
    [[vc headerView] setSchool:[user school]];
    [[[vc headerView] schoolLabel] setText:[[self user] school]];
    
    [RACObserve([PFMVVModel shared], avatarUrl) subscribeNext:^(NSString *avatarUrl) {
        
        PFFilename *avatar = [[PFFilename alloc] init];
        [avatar setDynamic:avatarUrl];
        
        [[headerView avatarView] setImageWithUrl:[avatar croppedToSize:[PFProfileHeaderView preferredAvatarSize]]
                             postProcessingBlock:nil
                                placeholderImage:nil];
    }];
    
    [RACObserve([PFMVVModel shared], coverUrl) subscribeNext:^(NSString *coverUrl) {
        
        [[headerView imageView] setImageWithUrl:coverUrl
                            postProcessingBlock:nil
                               placeholderImage:nil];
    }];
    
    [[headerView imageView] setAlpha:0];
    [[headerView avatarView] setAlpha:0];
    
    [[headerView imageView] setImageWithUrl:[[user cover] url]
                        postProcessingBlock:nil
                              progressBlock:nil
                           placeholderImage:nil
                                        tag:0
                                   callback:^(UIImage *image, NSInteger tag) {
                                       
                                       [UIView animateWithDuration:0.4
                                                        animations:^{
                                                            
                                                            [headerView addBorderToAvatar];
                                                            
                                                            [[self cogButtonForView] setAlpha:1];
                                                            [[self mailButtonForView] setAlpha:1];
                                                            [[self bellButtonForView] setAlpha:1];
                                                            
                                                            [[headerView gradient] setHidden:NO];
                                                            [[headerView imageView] setAlpha:1.0f];
                                                            [[headerView avatarView] setAlpha:1.0f];
                                                        }];
                                   }
     ];

}

- (void)cogButtonAction:(UIButton *)button; {
    
    NSString *editProfileButtonName = NSLocalizedString(@"Edit Profile", @"");
    NSString *settingsButtonName = NSLocalizedString(@"Settings", @"");
    NSString *helpButtonName = NSLocalizedString(@"Help", @"");
    NSString *cancelButtonName = NSLocalizedString(@"Cancel", @"");
    
    NSArray *buttons = [NSArray arrayWithObjects:
                        editProfileButtonName,
                        settingsButtonName,
                        helpButtonName,
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
        
        case kEditProfile: {
            
            [[self navigationController] pushViewController:[PFEditProfileVC _new:[self user]]
                                                   animated:YES]; break;
        }
            
        case kSettings: {
            
            [[self navigationController] pushViewController:[PFSettingsVC _new:[self user]]
                                                   animated:YES]; break;
        }
            
        case kHelp: {
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kUrl]]; break;
        }
            
        default: {
            break;
        }
    }
}

- (void)hideTitleElements; {
    
    [[self titleLabel] setHidden:YES];
    
    [[self cogButton] setHidden:YES];
    [[self mailButton] setHidden:YES];
    [[self bellButton] setHidden:YES];
}

- (void)showTitleElements; {
    
    [[self titleLabel] setHidden:NO];
    
    [[self cogButton] setHidden:NO];
    [[self mailButton] setHidden:NO];
    [[self bellButton] setHidden:NO];
}

- (void)mailButtonAction:(UIButton *)button; {
    
    [[self navigationController] pushViewController:[PFMessagesVC _new]
                                           animated:YES];
}

- (void)bellButtonAction:(UIButton *)button; {
    
    [[self navigationController] pushViewController:[PFNotificationsVC _new]
                                           animated:YES];
}

-(void)pushUserProfile:(NSNumber *)userId; {
    
    if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:userId]) {
        
        [[self contentView] shake];
        
    } else {
        
        [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                                   animated:YES];
    }
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedPushAtIndex:(NSInteger)index; {
    
    PFProfile *profile = [[[self dataSource] data] objectAtIndex:index];
    
    [self pushUserProfile:[profile userId]];
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [[self rootNavigationController] pushDetailVC:[PFDetailVC _new:[entry entryId] delegate:self]
                                         animated:YES];
}

- (CGFloat)currentNavigationBarAlpha; {
    
    return [[self activeVC] currentNavigationBarAlpha];
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFCView *)contentView; {
    
    return (PFCView *)[self view];
}

@end
