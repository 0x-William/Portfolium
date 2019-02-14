//
//  PFHomeVC.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFHomeVC.h"
#import "PFMessagesVC.h"
#import "PFDiscoverVC.h"
#import "PFNetworkVC.h"
#import "PFMeVC.h"
#import "PFButton.h"
#import "PFNavigationControllerDelegate.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFEntryTypeView.h"
#import "PFImage.h"
#import "PFColor.h"
#import "UIColor+PFEntensions.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFInterestsVC.h"
#import "PFOnboarding.h"
#import "PFRootViewController.h"
#import "PFAppContainerVC.h"
#import "PFHomeFeedVC.h"
#import "PFNavigationController.h"
#import "PFSize.h"
#import "PFAddEntryVC.h"
#import "PFGoogleAnalytics.h"
#import "PFDetailVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFMeTypeVC.h"
#import "FAKFontAwesome.h"

static const NSInteger kTabHome = 0;
static const NSInteger kTabSearch = 1;
static const NSInteger kTabSocial = 3;
static const NSInteger kTabProfile = 4;

static const NSInteger kTabFont = 20;

@interface PFHomeVC ()

@property(nonatomic, strong) NSPointerArray *weakButtons;
@property(nonatomic, strong) NSMutableArray *interests;

@end

@implementation PFHomeVC

+ (PFHomeVC *)shared; {
    
    return [[[[PFAppContainerVC shared] navigationController] viewControllers] objectAtIndex:0];
}

+ (PFHomeVC *)_new; {
    
    return [[PFHomeVC alloc] initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setInterests:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (void)loadView; {
    
    [self setTabBarController:[[UITabBarController alloc] init]];
    [[[self tabBarController] tabBar] setBackgroundColor:[UIColor clearColor]];
    
    PFHomeFeedVC *homeFeedVC = [PFHomeFeedVC _new];
    UINavigationController *homeFeedNC = [[PFNavigationController alloc]
                                          initWithRootViewController:homeFeedVC];
    [[homeFeedNC navigationBar] restyleNavigationBarTranslucentBlack];
    
    PFDiscoverVC *discoverVC = [PFDiscoverVC _new];
    UINavigationController *discoverNC = [[PFNavigationController alloc]
                                          initWithRootViewController:discoverVC];
    [[discoverNC navigationBar] restyleNavigationBarTranslucentWhite];
    
    PFMessagesVC *messagesVC = [PFMessagesVC _new];
    UINavigationController *messagesNC = [[PFNavigationController alloc]
                                          initWithRootViewController:messagesVC];
    
    PFNetworkVC *networkVC = [PFNetworkVC _new];
    UINavigationController *networkNC = [[PFNavigationController alloc]
                                          initWithRootViewController:networkVC];
    [[networkNC navigationBar] restyleNavigationBarTranslucentBlack];
    
    PFMeVC *meVC = [PFMeVC _new];
    UINavigationController *meNC = [[PFNavigationController alloc]
                                         initWithRootViewController:meVC];
    [[meNC navigationBar] restyleNavigationBarTranslucentBlack];
    [[meNC navigationBar] setAlpha:0.01f];
    
    NSArray *controllers = [NSArray arrayWithObjects:homeFeedNC,
                            discoverNC, messagesNC, networkNC, meNC, nil];
    
    [[self tabBarController] setViewControllers:controllers];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view addSubview:[self.tabBarController view]];
    [self setView:view];
    
    UIButton *newsFeedButton = [self buildTabbarButton:kTabHome];
    UIButton *discoverButton = [self buildTabbarButton:kTabSearch];
    UIButton *entryButton = [self buildEntryButton];
    UIButton *networkButton = [self buildTabbarButton:kTabSocial];
    UIButton *meButton = [self buildTabbarButton:kTabProfile];
    
    NSPointerArray *weakButtons = [NSPointerArray weakObjectsPointerArray];
    [weakButtons addPointer:(void *)newsFeedButton];
    [weakButtons addPointer:(void *)discoverButton];
    [weakButtons addPointer:(void *)entryButton];
    [weakButtons addPointer:(void *)networkButton];
    [weakButtons addPointer:(void *)meButton];
    [self setWeakButtons:weakButtons];
}

- (UIButton *)buildEntryButton; {
    
    UIButton *entryButton = [self buildTabbarButton:2];
    
    [entryButton removeTarget:self
                       action:@selector(tabBarAction:)
             forControlEvents:UIControlEventTouchDown];
    [entryButton setAdjustsImageWhenHighlighted:NO];
    [entryButton addTarget:self
                    action:@selector(plusButtonAction)
          forControlEvents:UIControlEventTouchDown];
    
    UIButton *actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [actionButton setFrame:[entryButton frame]];
    [actionButton setBackgroundColor:[UIColor colorWithHexString:[PFColor blueTabBarColor]]];
    
    FAKFontAwesome *normalIcon = [FAKFontAwesome plusCircleIconWithSize:36];
    [normalIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *selectedIcon = [FAKFontAwesome plusIconWithSize:36];
    [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [actionButton setAttributedTitle:[normalIcon attributedString]
                            forState:UIControlStateNormal];
    [actionButton setAttributedTitle:[selectedIcon attributedString]
                            forState:UIControlStateSelected];
    [actionButton setAttributedTitle:[selectedIcon attributedString]
                            forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [actionButton setAdjustsImageWhenHighlighted:NO];
    [[[self tabBarController] tabBar] addSubview:actionButton];
    [self setActionButton:actionButton];
    
    [actionButton addTarget:self
                     action:@selector(plusButtonAction)
           forControlEvents:UIControlEventTouchDown];
    
    return entryButton;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES];
    
    [self setSender:[[self weakButtons] pointerAtIndex:kTabHome]
        selectedAtIndex:kTabHome];
}

- (UIButton *)buildTabbarButton:(NSInteger)index; {
    
    CGRect frame = [[[self tabBarController] tabBar] frame];
    
    UIButton *button = [PFButton tabBarButton];
    
    @weakify(self)
    
    if(index == kTabHome) {
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome homeIconWithSize:kTabFont];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome homeIconWithSize:kTabFont];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [button setAttributedTitle:[normalIcon attributedString]
                          forState:UIControlStateNormal];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [button bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            if([sender isSelected]) {
                
                UINavigationController *nc = [self navigationControllerAtIndex:kTabHome];
                
                if([[nc viewControllers] count] > 1) {
            
                    [nc popToRootViewControllerAnimated:YES];
                    
                } else {
                    
                    PFHomeFeedVC *vc = (PFHomeFeedVC *)[self viewControllerAtIndex:kTabHome];
                    CGPoint offset = CGPointMake(0, -[self applicationFrameOffset]);
                    
                    [[vc collectionView] setContentOffset:offset
                                                 animated:YES];
                }
                
            } else {
                
                [self tabBarDeselect];
                [sender setSelected:YES];
                [[self tabBarController] setSelectedIndex:kTabHome];
            }
            
        } forControlEvents:UIControlEventTouchDown];
        
    
    } else if(index == kTabSearch) {
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome searchIconWithSize:kTabFont];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome searchIconWithSize:kTabFont];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [button setAttributedTitle:[normalIcon attributedString]
                          forState:UIControlStateNormal];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [button bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            if([sender isSelected]) {
                
                UINavigationController *nc = [self navigationControllerAtIndex:kTabSearch];
                
                if([[nc viewControllers] count] > 1) {
                    
                    [nc popToRootViewControllerAnimated:YES];
                    
                } else {
                    
                    PFDiscoverVC *vc = (PFDiscoverVC *)[self viewControllerAtIndex:kTabSearch];
                    CGPoint offset = CGPointMake(0, -[self applicationFrameOffset]);
                    
                    [[vc collectionView] setContentOffset:offset
                                                 animated:YES];
                }
                
            } else {
                
                [self tabBarDeselect];
                [sender setSelected:YES];
                [[self tabBarController] setSelectedIndex:kTabSearch];
            }
            
        } forControlEvents:UIControlEventTouchDown];
    
    } else if(index == kTabSocial) {
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome paperPlaneIconWithSize:kTabFont];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome paperPlaneIconWithSize:kTabFont];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [button setAttributedTitle:[normalIcon attributedString]
                          forState:UIControlStateNormal];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [button bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            if([sender isSelected]) {
                
                UINavigationController *nc = [self navigationControllerAtIndex:kTabSocial];
                
                if([[nc viewControllers] count] > 1) {
                    
                    [nc popToRootViewControllerAnimated:YES];
                    
                } else {
                    
                    PFNetworkVC *vc = (PFNetworkVC *)[self viewControllerAtIndex:kTabSocial];
                    CGPoint offset = CGPointMake(0, -[self applicationFrameOffset]);
                    
                    [[vc collectionView] setContentOffset:offset
                                                 animated:YES];
                }
                
            } else {
                
                [self tabBarDeselect];
                [sender setSelected:YES];
                [[self tabBarController] setSelectedIndex:kTabSocial];
            }
            
        } forControlEvents:UIControlEventTouchDown];
    
    } else if(index == kTabProfile) {
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome userIconWithSize:kTabFont];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome userIconWithSize:kTabFont];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [button setAttributedTitle:[normalIcon attributedString]
                          forState:UIControlStateNormal];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected];
        [button setAttributedTitle:[selectedIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [button bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            if([sender isSelected]) {
                
                UINavigationController *nc = [self navigationControllerAtIndex:kTabProfile];
                
                if([[nc viewControllers] count] > 1) {
                    
                    [nc popToRootViewControllerAnimated:YES];
                    
                } else {
                    
                    PFMeVC *vc = (PFMeVC *)[self viewControllerAtIndex:kTabProfile];
                    CGPoint offset = CGPointMake(0, 0);
                    
                    [[[vc activeVC] collectionView] setContentOffset:offset
                                                            animated:YES];
                }
                
            } else {
                
                [self tabBarDeselect];
                [sender setSelected:YES];
                [[self tabBarController] setSelectedIndex:kTabProfile];
            }
            
        } forControlEvents:UIControlEventTouchDown];
    }
    
    NSInteger controllerCount = [[[self tabBarController] viewControllers] count];
    [button setFrame:CGRectMake(((frame.size.width/controllerCount) * index), 0,
                                frame.size.width/controllerCount, frame.size.height)];
    
    [[[self tabBarController] tabBar] addSubview:button];
    
    return button;
}

#pragma mark -
#pragma mark Custom Button Handlers

- (void)tabBarDeselect; {
    
    for(int i = 0; i < [[self weakButtons] count]; i++) {
        
        UIButton *tabBarButton = [[self weakButtons] pointerAtIndex:i];
        [tabBarButton setSelected:NO];
    }
}

- (void)setSender:(id)sender selectedAtIndex:(NSInteger)index; {
    
    [self tabBarDeselect];
    [sender setSelected:YES];
    [[self tabBarController] setSelectedIndex:index];
}

- (void)plusButtonAction; {
    
    if(![[PFEntryTypeView shared] isShowing]) {
        [[PFEntryTypeView shared] launch];
    }
}

- (void)gridButtonAction:(UIButton *)button; {
    
    [[self interests] removeAllObjects];
    
    for(int i = 0; i < [[[PFOnboarding shared] categories] count]; i++) {
        
        [[self interests] addObject:[[[PFOnboarding shared] categories] objectAtIndex:i]];
    }
    
    UINavigationController *nc = [[UINavigationController alloc]
                                  initWithRootViewController:[PFInterestsVC _new]];
    
    [[nc navigationBar] restyleNavigationBarTranslucentBlack];
    
    [[self navigationController] presentViewController:nc
                                              animated:YES
                                            completion:^{
    }];
}

- (void)dismissGridButtonAction; {
    
    @weakify(self)
    
    [[self navigationController] dismissViewControllerAnimated:YES
                                                    completion:^{
        
        @strongify(self)
                                                
        if(![[self interests] isEqualToArray:[[PFOnboarding shared] categories]]) {
            
            UINavigationController *nc = [self navigationControllerAtIndex:kTabHome];
            [nc popToRootViewControllerAnimated:NO];
            
            _PFEntryFeedVC *vc = (_PFEntryFeedVC *)[self viewControllerAtIndex:kTabHome];
            [vc refreshAnimated:NO];
        }
    }];
}

- (void)entryButtonAction:(UIButton *)button; {
    
    [self gridButtonAction:button];
}

- (UINavigationController *)navigationControllerAtIndex:(NSInteger)index; {
    
    return [[[self tabBarController] viewControllers] objectAtIndex:index];
}

- (UIViewController *)viewControllerAtIndex:(NSInteger)index; {
    
    UINavigationController *nc = [self navigationControllerAtIndex:index];
    UIViewController *rootViewController = nc.viewControllers[0];
    
    return rootViewController;
}

- (void)goToNetworkTab; {
    
    [self tabBarDeselect];
    
    UIButton *button = [[self weakButtons] pointerAtIndex:kTabSocial];
    
    [button setSelected:YES];
    [[self tabBarController] setSelectedIndex:kTabSocial];
}

- (void)launchAddEntry:(PFEntryType)entryType; {
    
    [[PFGoogleAnalytics shared] selectedEntryType:entryType];
    
    PFNavigationController *nc = [[PFNavigationController alloc]
                                  initWithRootViewController:[PFAddEntryVC _new:entryType]];
    
    [[nc navigationBar] restyleNavigationBarTranslucentBlack];
    
    [[self navigationController] presentViewController:nc animated:YES completion:^{
    }];
}

- (void)launchAddedEntry:(NSNumber *)entryId; {
    
    [self tabBarDeselect];
    
    UIButton *tabBarButton = [[self weakButtons] pointerAtIndex:0];
    [tabBarButton setSelected:YES];
    
    [[self tabBarController] setSelectedIndex:kTabHome];
    
    PFNavigationController *nc = (PFNavigationController *)
    [self navigationControllerAtIndex:kTabHome];
    [nc popToRootViewControllerAnimated:NO];
    
    PFHomeFeedVC *homeFeed = (PFHomeFeedVC *)
    [self viewControllerAtIndex:kTabHome];
    
    [[homeFeed navigationController] pushViewController:[PFDetailVC _upload:entryId delegate:homeFeed]
                                               animated:NO];
}

@end
