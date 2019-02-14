//
//  PFFontAwesome.m
//  Portfolium
//
//  Created by John Eisberg on 12/13/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFFontAwesome.h"
#import "FAKFontAwesome.h"
#import "NSAttributedString+CCLFormat.h"

@implementation PFFontAwesome

+ (NSAttributedString *)connectIcon; {
    
    FAKFontAwesome *plusIcon = [FAKFontAwesome plusIconWithSize:12];
    [plusIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *userIcon = [FAKFontAwesome userIconWithSize:16];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    NSAttributedString *plus = [plusIcon attributedString];
    NSAttributedString *user = [userIcon attributedString];;
    NSAttributedString *combined = [NSAttributedString attributedStringWithFormat:@"%@ %@", plus, user];
    
    return combined;
}

+ (NSAttributedString *)connectedIcon; {
    
    FAKFontAwesome *plusIcon = [FAKFontAwesome checkIconWithSize:12];
    [plusIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *userIcon = [FAKFontAwesome userIconWithSize:16];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];

    NSAttributedString *plus = [plusIcon attributedString];
    NSAttributedString *user = [userIcon attributedString];;
    NSAttributedString *combined = [NSAttributedString attributedStringWithFormat:@"%@ %@", plus, user];
    
    return combined;
}

@end
