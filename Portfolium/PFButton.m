//
//  PFButtons.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFButton.h"
#import "PFColor.h"
#import "PFFont.h"
#import "PFSize.h"

@implementation PFButton

+ (UIButton *)tabBarButton; {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor blackColorOpaque]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor blackColorOpaque]]
                      forState:UIControlStateSelected];
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor blackColorOpaque]]
                      forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    [[button titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    
    return button;
}

+ (UIButton *)signUpButton; {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor blueColorOpaque]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[PFColor imageOfColor:[UIColor blackColor]]
                      forState:UIControlStateSelected];
    [button setBackgroundImage:[PFColor imageOfColor:[UIColor blackColor]]
                      forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    [[button titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    
    return button;
}

+ (UIButton *)loginButton; {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor blackColorOpaque]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[PFColor imageOfColor:[UIColor blackColor]]
                      forState:UIControlStateSelected];
    [button setBackgroundImage:[PFColor imageOfColor:[UIColor blackColor]]
                      forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    [[button titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    
    return button;
}

+ (UIButton *)tabBarStepButton:(NSInteger)index; {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    UIView *step1 = [[UIView alloc] initWithFrame:CGRectMake(([PFSize screenWidth] / 2) - 20, 5, 8, 8)];
    [step1 setBackgroundColor:(index == 0 ? [PFColor blueColor]:[PFColor grayColor])];
    [button addSubview:step1];
    
    step1.layer.cornerRadius = 4;
    step1.layer.masksToBounds = YES;
    
    UIView *step2 = [[UIView alloc] initWithFrame:CGRectMake(([PFSize screenWidth] / 2) - 4, 5, 8, 8)];
    [step2 setBackgroundColor:(index == 1 ? [PFColor blueColor]:[PFColor grayColor])];
    [button addSubview:step2];
    
    step2.layer.cornerRadius = 4;
    step2.layer.masksToBounds = YES;
    
    UIView *step3 = [[UIView alloc] initWithFrame:CGRectMake(([PFSize screenWidth] / 2) + 12, 5, 8, 8)];
    [step3 setBackgroundColor:(index == 2 ? [PFColor blueColor]:[PFColor grayColor])];
    [button addSubview:step3];
    
    step3.layer.cornerRadius = 4;
    step3.layer.masksToBounds = YES;
    
    return button;
}

+ (UIButton *)connectButton; {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    return button;
}

+ (UIButton *)threadTabBarButton; {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor lightGrayColor]]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor lightGrayColor]]
                      forState:UIControlStateSelected];
    [button setBackgroundImage:[PFColor imageOfColor:[PFColor lightGrayColor]]
                      forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [button setContentEdgeInsets:UIEdgeInsetsMake(5.0f, 5.0f, 5.0f, 5.0f)];
    
    return button;
}


@end
