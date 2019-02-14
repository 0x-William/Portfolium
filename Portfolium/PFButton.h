//
//  PFButtons.h
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFButton : NSObject

+ (UIButton *)tabBarButton;

+ (UIButton *)signUpButton;

+ (UIButton *)loginButton;

+ (UIButton *)tabBarStepButton:(NSInteger)index;

+ (UIButton *)connectButton;

+ (UIButton *)threadTabBarButton;

@end
