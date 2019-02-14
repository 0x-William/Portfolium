//
//  PFBarButtonContainer.m
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFBarButtonContainer.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFImage.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "FAKFontAwesome.h"
#import "NSAttributedString+CCLFormat.h"
#import "PFFontAwesome.h"


@implementation PFBarButtonContainer

+ (UIView *)_continue:(void (^)(id sender))handler; {
    
    return [self rightBarButtonWithTitle:@"Continue"
                                 handler:handler];
}

+ (UIView *)done:(void (^)(id sender))handler; {
    
    return [self buttonWithTitle:@"Done" handler:handler];
}

+ (UIView *)save:(void (^)(id sender))handler; {
    
    return [self buttonWithTitle:@"Save" handler:handler];
}

+ (UIView *)add:(void (^)(id sender))handler; {
    
    UIView *buttonView = [self buttonWithTitle:@"+ Add" handler:handler];
    UIButton *button = [[buttonView subviews] objectAtIndex:0];
    
    FAKFontAwesome *cloudIcon = [FAKFontAwesome cloudUploadIconWithSize:14];
    [cloudIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    NSAttributedString *cloud = [cloudIcon attributedString];
    UIFont *font = [UIFont systemFontOfSize:14];
    NSAttributedString *add = [[NSAttributedString alloc] initWithString:@"Add" attributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    NSAttributedString *combined = [NSAttributedString attributedStringWithFormat:@"%@ %@", cloud, add];
    
    [button setAttributedTitle:combined
                    forState:UIControlStateNormal];
    
    return buttonView;
}

+ (UIView *)accept:(void (^)(id sender))handler; {
    
    UIButton *rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonItem setBackgroundColor:[UIColor clearColor]];
    [rightBarButtonItem setFrame:CGRectMake(10.0f, 1.0f, 50.0f, 36.0f)];
    [rightBarButtonItem setAdjustsImageWhenHighlighted:NO];
    
    [rightBarButtonItem setAttributedTitle:[PFFontAwesome connectedIcon]
                                  forState:UIControlStateNormal];
    
    [rightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[rightBarButtonItem titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    [rightBarButtonItem setBackgroundImage:[PFImage accept] forState:UIControlStateNormal];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [rightBarButtonItem bk_addEventHandler:handler
                          forControlEvents:UIControlEventTouchUpInside];
    
#pragma clang diagnostic pop
    
    UIView *rightBarButtonContainer = [[UIView alloc] initWithFrame:rightBarButtonItem.frame];
    [rightBarButtonContainer addSubview:rightBarButtonItem];
    
    return rightBarButtonContainer;
}

+ (UIView *)connect:(void (^)(id sender))handler; {
    
    UIButton *rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonItem setBackgroundColor:[UIColor clearColor]];
    [rightBarButtonItem setFrame:CGRectMake(10.0f, 1.0f, 50.0f, 36.0f)];
    [rightBarButtonItem setAdjustsImageWhenHighlighted:NO];
    
    [rightBarButtonItem setAttributedTitle:[PFFontAwesome connectIcon]
                                  forState:UIControlStateNormal];
    
    [rightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[rightBarButtonItem titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    [rightBarButtonItem setBackgroundImage:[PFImage like] forState:UIControlStateNormal];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [rightBarButtonItem bk_addEventHandler:handler
                          forControlEvents:UIControlEventTouchUpInside];
    
#pragma clang diagnostic pop
    
    UIView *rightBarButtonContainer = [[UIView alloc] initWithFrame:rightBarButtonItem.frame];
    [rightBarButtonContainer addSubview:rightBarButtonItem];
    
    return rightBarButtonContainer;
}

+ (UIView *)buttonWithTitle:(NSString *)title
                    handler:(void (^)(id sender))handler; {
    
    UIButton *rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonItem setBackgroundColor:[UIColor clearColor]];
    [rightBarButtonItem setFrame:CGRectMake(10.0f, 1.0f, 60.0f, 36.0f)];
    [rightBarButtonItem setAdjustsImageWhenHighlighted:NO];
    [rightBarButtonItem setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [rightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[rightBarButtonItem titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    [rightBarButtonItem setBackgroundImage:[PFImage like] forState:UIControlStateNormal];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [rightBarButtonItem bk_addEventHandler:handler
                          forControlEvents:UIControlEventTouchUpInside];
    
#pragma clang diagnostic pop
    
    UIView *rightBarButtonContainer = [[UIView alloc] initWithFrame:rightBarButtonItem.frame];
    [rightBarButtonContainer addSubview:rightBarButtonItem];
    
    return rightBarButtonContainer;
}

+ (UIView *)backButton:(UIViewController *)delegate; {
    
    UIButton *leftBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [leftBarButtonItem setBackgroundColor:[UIColor greenColor]];
    [leftBarButtonItem setFrame:CGRectMake(10.0f, 1.0f, 80.0f, 40.0f)];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [leftBarButtonItem addTarget:delegate
                           action:@selector(leftBarButtonItemAction:)
                 forControlEvents:UIControlEventTouchUpInside];
    
#pragma clang diagnostic pop
    
    UIView *leftBarButtonContainer = [[UIView alloc] initWithFrame:leftBarButtonItem.frame];
    [leftBarButtonContainer addSubview:leftBarButtonItem];
    
    return leftBarButtonContainer;
}

+ (UIView *)rightBarButtonWithTitle:(NSString *)title
                            handler:(void (^)(id sender))handler; {
    
    UIButton *rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonItem setBackgroundColor:[UIColor clearColor]];
    [rightBarButtonItem setAdjustsImageWhenHighlighted:NO];
    [rightBarButtonItem setFrame:CGRectMake(10.0f, 1.0f, 80.0f, 40.0f)];
    [rightBarButtonItem setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [rightBarButtonItem setTitleColor:[PFColor blueColor] forState:UIControlStateNormal];
    [[rightBarButtonItem titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [rightBarButtonItem bk_addEventHandler:handler
                          forControlEvents:UIControlEventTouchUpInside];
    
#pragma clang diagnostic pop
    
    UIView *rightBarButtonContainer = [[UIView alloc] initWithFrame:rightBarButtonItem.frame];
    [rightBarButtonContainer addSubview:rightBarButtonItem];
    
    return rightBarButtonContainer;
}

/*+ (UIView *)rightBarButtonContainerWithWidth:(CGFloat)width
                                       title:(NSString *)title
                                     handler:(void (^)(id sender))handler; {
    
    UIButton *rightBarButtonItem = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [rightBarButtonItem setBackgroundColor:[UIColor clearColor]];
    [rightBarButtonItem setFrame:CGRectMake(10.0f, 1.0f, width, 36.0f)];
    [rightBarButtonItem setAdjustsImageWhenHighlighted:NO];
    [rightBarButtonItem setTitle:NSLocalizedString(title, nil) forState:UIControlStateNormal];
    [rightBarButtonItem setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[rightBarButtonItem titleLabel] setFont:[PFFont systemFontOfMediumSize]];
    [rightBarButtonItem setBackgroundImage:[PFImage like] forState:UIControlStateNormal];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    [rightBarButtonItem bk_addEventHandler:handler
                          forControlEvents:UIControlEventTouchUpInside];
    
#pragma clang diagnostic pop
    
    UIView *rightBarButtonContainer = [[UIView alloc] initWithFrame:rightBarButtonItem.frame];
    [rightBarButtonContainer addSubview:rightBarButtonItem];
    
    return rightBarButtonContainer;
}*/

@end
