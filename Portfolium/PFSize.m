//
//  PFSize.m
//  Portfolium
//
//  Created by John Eisberg on 11/13/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSize.h"

@implementation PFSize

+ (CGFloat)screenWidth; {
    
    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight; {
    
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (CGSize)preferredHeaderSize; {
    
    if([self screenHeight] == IPHONE_4_HEIGHT) {
        return CGSizeMake([PFSize screenWidth], 315.0f);
    } else if ([self screenHeight] == IPHONE_5_HEIGHT) {
        return CGSizeMake([PFSize screenWidth], 315.0f);
    } else {
        return CGSizeMake([PFSize screenWidth], 369.0f);
    }
}

+ (CGSize)preferredDetailSize; {
    
    if([self screenHeight] == IPHONE_4_HEIGHT) {
        return CGSizeMake([PFSize screenWidth], 233.0f);
    } else if ([self screenHeight] == IPHONE_5_HEIGHT) {
        return CGSizeMake([PFSize screenWidth], 253.0f);
    } else {
        return CGSizeMake([PFSize screenWidth], 307.0f);
    }
}

+ (CGSize)preferredImageCrop; {
    
    if([self screenHeight] == IPHONE_4_HEIGHT) {
        return CGSizeMake([PFSize screenWidth], 180.0f);
    } else if ([self screenHeight] == IPHONE_5_HEIGHT) {
        return CGSizeMake([PFSize screenWidth], 180.0f);
    } else {
        return CGSizeMake([PFSize screenWidth], 240.0f);
    }
}

+ (CGSize)adjustedImageSize:(CGSize)size; {
    
    if([self screenHeight] == IPHONE_4_HEIGHT) {
        return CGSizeMake(size.width * 2, size.height * 2);
    } else if ([self screenHeight] == IPHONE_5_HEIGHT || [self screenHeight] == IPHONE_6_HEIGHT) {
        return CGSizeMake(size.width * 2, size.height * 2);
    } else {
        return CGSizeMake(size.width * 3, size.height * 3);
    }
}

+ (CGFloat)joinVCPFLogo {
    if([self screenWidth] == IPHONE_SMALL){
        return 82.5;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 110;
    } else {
        return 129.5;
    }
}

+ (CGFloat)joinVCFBLKButton {
    if([self screenWidth] == IPHONE_SMALL){
        return ([self screenWidth]/10.6);
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return ([self screenWidth]/6.5);
    } else  {
        return ([self screenWidth]/5.3);
    }
}

+ (CGFloat)joinVCEmailText {
    if([self screenWidth] == IPHONE_SMALL){
        return ([self screenWidth]/5.3);
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return ([self screenWidth]/4.2);
    } else {
        return ([self screenWidth]/3.8);
    }
}

+ (CGFloat)loginVCFBButton {
    if([self screenWidth] == IPHONE_SMALL){
        return ([self screenWidth]/4.6);
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return ([self screenWidth]/3.8);
    } else {
        return ([self screenWidth]/3.5);
    }
}

+ (CGFloat)loginVCLKButton {
    if([self screenWidth] == IPHONE_SMALL){
        return ([self screenWidth]/1.9);
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return ([self screenWidth]/1.9);
    } else {
        return ([self screenWidth]/1.9);
    }
}

+ (CGFloat)loginVCORText {
    if([self screenWidth] == IPHONE_SMALL){
        return ([self screenWidth]/2.2);
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return ([self screenWidth]/2.1);
    } else {
        return ([self screenWidth]/2.1);
    }
}

+ (CGFloat)loginVCForgotPwdText {
    if([self screenWidth] == IPHONE_SMALL){
        return ([self screenWidth]/5.6);
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return ([self screenWidth]/4.4);
    } else {
        return ([self screenWidth]/4);
    }
}

+ (CGFloat)joinEmailViewCellText {
    if([self screenWidth] == IPHONE_SMALL){
        return 190.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 245.0f;
    } else {
        return 284.0f;
    }
}

+ (CGFloat)entryTypeViewColOne {
    if([self screenWidth] == IPHONE_SMALL){
        return 30.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 57.5f;
    } else {
        return 77.0f;
    }
}
+ (CGFloat)entryTypeViewColTwo {
    if([self screenWidth] == IPHONE_SMALL){
        return 120.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 147.5f;
    } else {
        return 167.0f;
    }
}
+ (CGFloat)entryTypeViewColThree {
    if([self screenWidth] == IPHONE_SMALL){
        return 210.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 237.5f;
    } else {
        return 257.0f;
    }
}
+ (CGFloat)entryTypeViewJobText {
    if([self screenWidth] == IPHONE_SMALL){
        return 55.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 69.5f;
    } else {
        return 80.0f;
    }
}
+ (CGFloat)entryTypeViewCourseText {
    if([self screenWidth] == IPHONE_SMALL){
        return 119.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 146.5f;
    } else {
        return 166.0f;
    }
}
+ (CGFloat)entryTypeViewVolunteerText {
    if([self screenWidth] == IPHONE_SMALL){
        return 220.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 247.5f;
    } else {
        return 267.0f;
    }
}
+ (CGFloat)entryTypeViewClubsText {
    if([self screenWidth] == IPHONE_SMALL){
        return 50.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 77.5f;
    } else {
        return 97.0f;
    }
}
+ (CGFloat)entryTypeViewHobbiesText {
    if([self screenWidth] == IPHONE_SMALL){
        return 129.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 156.5f;
    } else {
        return 176.0f;
    }
}
+ (CGFloat)entryTypeViewMiscText {
    if([self screenWidth] == IPHONE_SMALL){
        return 230.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 257.5f;
    } else {
        return 277.0f;
    }
}

+ (CGFloat)entryTypeViewHidePlus {
    if([self screenWidth] == IPHONE_SMALL){
        return ([PFSize screenWidth]/2.15);
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return [PFSize screenWidth]/2.1;
    } else {
        return [PFSize screenWidth]/2.1;
    }
}

+ (CGFloat)networkVCMessageButton {
    if([self screenWidth] == IPHONE_SMALL){
        return 2.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 29.5f;
    } else {
        return 49.0f;
    }
}
+ (CGFloat)networkVCFacebookButton {
    if([self screenWidth] == IPHONE_SMALL){
        return 109.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 136.5f;
    } else {
        return 156.0f;
    }
}
+ (CGFloat)networkVCTwitterButton {
    if([self screenWidth] == IPHONE_SMALL){
        return 216.0f;
    } else if ([self screenWidth] == IPHONE_MEDIUM) {
        return 243.5f;
    } else {
        return 263.0f;
    }    
}
@end
