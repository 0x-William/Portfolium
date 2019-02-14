//
//  PFOnboardingVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOnboardingVC.h"
#import "PFColor.h"
#import "PFOBCategoriesVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFButton.h"
#import "UITabBarController+PFExtensions.h"
#import "NSString+PFExtensions.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFSwipeNavigationController.h"
#import "PFAuthenticationProvider.h"
#import "PFClassification.h"
#import "NSDate+PFExtensions.h"
#import "PFAppContainerVC.h"

@interface PFOnboardingVC ()

@property(nonatomic, strong) NSPointerArray *weakButtons;

@end

@implementation PFOnboardingVC

+ (PFOnboardingVC *)shared; {
    
    return [[[[PFAppContainerVC shared] navigationController] viewControllers] objectAtIndex:0];
}

+ (PFOnboardingVC *)_new; {
    
    return [[PFOnboardingVC alloc] initWithNibName:nil bundle:nil];
}

- (void)loadView; {
    
    [super loadView];
    
    [self setTabBarController:[[UITabBarController alloc] init]];
    [[self tabBarController] setDelegate:self];
    
    [[[self tabBarController] tabBar] setBackgroundImage:
        [PFColor imageOfColor:[[UIColor blackColor] colorWithAlphaComponent:0.6]]];
    
    [[self tabBarController] setTabBarHidden:YES];
    
    PFOBCategoriesVC *categoriesVC = [PFOBCategoriesVC _new];
    UINavigationController *categoriesNC = [[PFSwipeNavigationController alloc]
                                            initWithRootViewController:categoriesVC];
    
    NSArray *controllers = [NSArray arrayWithObjects:categoriesNC, nil];
    
    [[self tabBarController] setViewControllers:controllers];
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view addSubview:[self.tabBarController view]];
    [self setView:view];
    
    CGRect frame = [[[self tabBarController] tabBar] frame];
    frame.size.height = frame.size.height - 32.0f;
    frame.origin.y = frame.origin.y + 32.0f;
    [[[self tabBarController] tabBar] setFrame:frame];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:YES];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[self tabBarController] setTabBarHidden:NO animated:YES];
}

- (UIButton *)buildTabbarButton:(NSInteger)index; {
    
    CGRect frame = [[[self tabBarController] tabBar] frame];
    
    UIButton *button = [PFButton tabBarStepButton:index];
    
    NSInteger controllerCount = [[[self tabBarController] viewControllers] count];
    [button setFrame:CGRectMake((frame.size.width/controllerCount) * 0 , 0,
                                frame.size.width/controllerCount, frame.size.height)];
    
    for(UIView *view in [[[self tabBarController] tabBar] subviews]) {
        if([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        }
    }
    
    [[[self tabBarController] tabBar] addSubview:button];
    
    return button;
}

@end
