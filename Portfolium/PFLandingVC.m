//
//  PFLandingVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLandingVC.h"
#import "PFIntroVC.h"
#import "PFIntro2VC.h"
#import "PFLoginVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFJoinVC.h"
#import "PFButton.h"
#import "PFColor.h"
#import "PFCategoriesVC.h"
#import "UITabBarController+PFExtensions.h"
#import <BlocksKit/UIControl+BlocksKit.h>
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFAppContainerVC.h"
#import "PFSwipeNavigationController.h"
#import "PFLandingNavigationController.h"
#import "PFLandingNavigationControllerDelegate.h"

static const NSInteger kSignupButton = 1;
static const NSInteger kLoginButton = 2;

@interface PFLandingVC ()

@property(nonatomic, strong) NSPointerArray *weakButtons;

@end

@implementation PFLandingVC

+ (PFLandingVC *)shared; {
    
    return [[[[PFAppContainerVC shared] navigationController] viewControllers] objectAtIndex:0];
}

+ (PFLandingVC *)_new; {
    
    return [[PFLandingVC alloc] initWithNibName:nil bundle:nil];
}

- (void)loadView; {
    
    [super loadView];
    
    PFLandingNavigationControllerDelegate *delegate =
        [[PFLandingNavigationControllerDelegate alloc] init];
    
    [self setStrongDelegate:delegate];
    [[self navigationController] setDelegate:delegate];
    
    [self setTabBarController:[[UITabBarController alloc] init]];
    [[self tabBarController] setDelegate:self];
    
    [[[self tabBarController] tabBar] setBackgroundImage:[PFColor imageOfColor:[UIColor clearColor]]];
    [[[self tabBarController] tabBar] setBackgroundColor:[UIColor clearColor]];
    
    CGRect frame = [[self tabBarController] tabBar].frame;
    frame.origin.y = frame.origin.y + frame.size.height;
    [[self tabBarController] tabBar].frame = frame;
    
    UINavigationController *introNC;
    
    if(![PFIntro2VC isViewed]) {
        
        //PFIntroVC *introVC = [PFIntroVC _new:0];
        PFIntro2VC *introVC = [PFIntro2VC _new];
        introNC = [[PFSwipeNavigationController alloc]
                   initWithRootViewController:introVC];

        [[introNC navigationBar] restyleNavigationBarTranslucentWhite];
        [introNC setNavigationBarHidden:NO];
        
    } else {
     
        PFCategoriesVC *categoriesVC = [PFCategoriesVC _new];
        introNC = [[PFLandingNavigationController alloc]
                        initWithRootViewController:categoriesVC];
        
        [[introNC navigationBar] restyleNavigationBarTranslucentBlack];
        [introNC setNavigationBarHidden:NO];
    }
    
    [self setIntroNC:introNC];
    
    PFJoinVC *joinVC = [PFJoinVC _new];
    UINavigationController *joinNC = [[UINavigationController alloc]
                                        initWithRootViewController:joinVC];
    
    PFLoginVC *loginVC = [PFLoginVC _new];
    UINavigationController *loginNC = [[UINavigationController alloc]
                                          initWithRootViewController:loginVC];
    
    NSArray *controllers = [NSArray arrayWithObjects:introNC, joinNC, loginNC, nil];
    
    [[self tabBarController] setViewControllers:controllers];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view addSubview:[self.tabBarController view]];
    [self setView:view];
    
    UIButton *onboardingButton = [self buildTabbarButton:0];
    
    UIButton *signupButton = [self buildTabbarButton:kSignupButton];
    [signupButton setTitle:NSLocalizedString(@"Join For Free", nil)
                  forState:UIControlStateNormal];
    
    UIButton *loginButton = [self buildTabbarButton:kLoginButton];
    [loginButton setTitle:NSLocalizedString(@"Login", nil)
                 forState:UIControlStateNormal];
    
    @weakify(self)
    
    [signupButton bk_addEventHandler:^(id sender) {
        
        @strongify(self)
        
        [[self introNC] pushViewController:[PFJoinVC _new]
                                               animated:YES];
    
    } forControlEvents:UIControlEventTouchUpInside];
    
    [loginButton bk_addEventHandler:^(id sender) {
        
        @strongify(self)
    
        [[self introNC] pushViewController:[PFLoginVC _new]
                                  animated:YES];

    } forControlEvents:UIControlEventTouchUpInside];
    
    NSPointerArray *weakButtons = [NSPointerArray weakObjectsPointerArray];
    [weakButtons addPointer:(void *)onboardingButton];
    [weakButtons addPointer:(void *)signupButton];
    [weakButtons addPointer:(void *)loginButton];
    [self setWeakButtons:weakButtons];
    
    [self tabBarAction:onboardingButton];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [[[self navigationController] navigationBar] restyleNavigationBarSolidBlack];
    [[self navigationController] setNavigationBarHidden:YES];
    
    [[self tabBarController] setMainTabBarHidden:NO animated:YES];
}

- (UIButton *)buildTabbarButton:(NSInteger)index; {
    
    CGRect frame = [[[self tabBarController] tabBar] frame];
    
    UIButton *button = [PFButton tabBarButton];
    
    if(index == kSignupButton) {
        button = [PFButton signUpButton];
    } else if(index == kLoginButton){
        button = [PFButton loginButton];
    }
    
    [button setTag:index];
    
    NSInteger controllerCount = [[[self tabBarController] viewControllers] count] - 1;
    
    if(index == 0) {
        
        [button setFrame:CGRectZero];
    
    } else {
        
        [button setFrame:CGRectMake((frame.size.width/controllerCount) * (index - 1) , 0,
                                    frame.size.width/controllerCount, frame.size.height)];
    }
    
    [[[self tabBarController] tabBar] addSubview:button];
    
    return button;
}

- (void)pushJoinVC; {
    
    [[self introNC] pushViewController:[PFJoinVC _new] animated:YES];
}

@end
