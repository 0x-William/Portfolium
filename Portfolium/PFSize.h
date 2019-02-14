//
//  PFSize.h
//  Portfolium
//
//  Created by John Eisberg on 11/13/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#pragma mark - Screen Sizes
#define IPHONE_SMALL    320
#define IPHONE_MEDIUM   375
#define IPHONE_LARGE    414

#pragma mark - Screen Heights
#define IPHONE_4_HEIGHT        480
#define IPHONE_5_HEIGHT        568
#define IPHONE_6_HEIGHT        667
#define IPHONE_6_PLUS_HEIGHT   736

#import <Foundation/Foundation.h>

@interface PFSize : NSObject

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

+ (CGSize)preferredHeaderSize;
+ (CGSize)preferredDetailSize;
+ (CGSize)preferredImageCrop;

+ (CGSize)adjustedImageSize:(CGSize)size;


/******************************************************
 
                    Screen Alignment
 
 *****************************************************/
 
/* 
 * Used in PFJoinVC.m
 */
+ (CGFloat)joinVCPFLogo;
+ (CGFloat)joinVCFBLKButton;
+ (CGFloat)joinVCEmailText;


/*
 * Used in PFLoginVC.m
 */
+ (CGFloat)loginVCFBButton;
+ (CGFloat)loginVCLKButton;
+ (CGFloat)loginVCORText;
+ (CGFloat)loginVCForgotPwdText;

/*
 * Used in PFJoinEmailViewCell.m
 */
+ (CGFloat)joinEmailViewCellText;

/*
 * Used in PFEntryTypeView.m
 */

+ (CGFloat)entryTypeViewColOne;
+ (CGFloat)entryTypeViewColTwo;
+ (CGFloat)entryTypeViewColThree;
+ (CGFloat)entryTypeViewJobText;
+ (CGFloat)entryTypeViewCourseText;
+ (CGFloat)entryTypeViewVolunteerText;
+ (CGFloat)entryTypeViewClubsText;
+ (CGFloat)entryTypeViewHobbiesText;
+ (CGFloat)entryTypeViewMiscText;
+ (CGFloat)entryTypeViewHidePlus;



/*
 * Used in PFNetworkVC.m
 */

+ (CGFloat)networkVCMessageButton;
+ (CGFloat)networkVCFacebookButton;
+ (CGFloat)networkVCTwitterButton;

@end
