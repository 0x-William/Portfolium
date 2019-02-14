//
//  PFTabbedVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTabbedVC.h"
#import "PFButton.h"

static const NSInteger kTabBarTag = 1000;

@interface PFTabbedVC ()

@property(nonatomic, strong) NSPointerArray *weakButtons;

@end

@implementation PFTabbedVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
}

- (UIButton *)buildTabbarButton:(NSInteger)index; {
    
    CGRect frame = [[[self tabBarController] tabBar] frame];
    
    UIButton *button = [PFButton tabBarButton];
    
    [button addTarget:self
               action:@selector(tabBarAction:)
     forControlEvents:UIControlEventTouchDown];
    
    NSInteger controllerCount = [[[self tabBarController] viewControllers] count];
    [button setFrame:CGRectMake((frame.size.width/controllerCount) * index , 0,
                                frame.size.width/controllerCount, frame.size.height)];
    
    [[[self tabBarController] tabBar] addSubview:button];
    [button setTag:kTabBarTag + index];
    
    return button;
}

#pragma mark -
#pragma mark Custom Button Handlers

- (void)tabBarAction:(UIButton *)tabBarButton; {
    
    [self tabBarDeselect];
    [tabBarButton setSelected:YES];
    
    [[self tabBarController] setSelectedIndex:[tabBarButton tag] % kTabBarTag];
}

- (void)tabBarDeselect; {
    
    for(int i = 0; i < [[self weakButtons] count]; i++) {
        
        UIButton *tabBarButton = [[self weakButtons] pointerAtIndex:i];
        [tabBarButton setSelected:NO];
    }
}

@end
