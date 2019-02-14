//
//  PFImage.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFImage.h"
#import "FAKFontAwesome.h"
#import "PFSize.h"

@implementation PFImage

+ (UIImage *)intro1; {
    if ([PFSize screenHeight] == IPHONE_4_HEIGHT)
        return [UIImage imageNamed:@"onboard1_4"];
    return [UIImage imageNamed:@"onboard1"];
}

+ (UIImage *)intro2; {
    if ([PFSize screenHeight] == IPHONE_4_HEIGHT)
        return [UIImage imageNamed:@"onboard2_4"];
    return [UIImage imageNamed:@"onboard2"];
}

+ (UIImage *)intro3; {
    if ([PFSize screenHeight] == IPHONE_4_HEIGHT)
        return [UIImage imageNamed:@"onboard3_4"];
    return [UIImage imageNamed:@"onboard3"];
}

+ (UIImage *)intro4; {
    if ([PFSize screenHeight] == IPHONE_4_HEIGHT)
        return [UIImage imageNamed:@"onboard4_4"];
    return [UIImage imageNamed:@"onboard4"];
}

+ (UIImage *)forgotPassword; {
    
    return [UIImage imageNamed:@"forgotpass"];
}

+ (UIImage *)join; {
    
    return [UIImage imageNamed:@"join"];
}

+ (UIImage *)education; {
    
    return [UIImage imageNamed:@"education"];
}

+ (UIImage *)chevron; {
    
  
    FAKFontAwesome *ico_chevronBlueRight = [FAKFontAwesome chevronRightIconWithSize:18];
    [ico_chevronBlueRight addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor]];
    UIImage * chevron_blue_right = [ico_chevronBlueRight imageWithSize:CGSizeMake(18,18)];
    return chevron_blue_right;

}

+ (UIImage *)avatar; {
    
    return [UIImage imageNamed:@"default_avatar.jpg"];
}

+ (UIImage *)cover; {
    
    return [UIImage imageNamed:@"default-cover.jpg"];
}

+ (UIImage *)facebookButtonBackground; {
    
    return [[UIImage imageNamed:@"btn_facebook"] resizableImageWithCapInsets:
            UIEdgeInsetsMake(10, 10, 10, 10)];
}

+ (UIImage *)linkedInButtonBackground; {
    
    return [[UIImage imageNamed:@"btn_linkedin"] resizableImageWithCapInsets:
            UIEdgeInsetsMake(10, 10, 10, 10)];
}

+ (UIImage *)chevronBack; {
    
    FAKFontAwesome *ico_chevron_back = [FAKFontAwesome chevronLeftIconWithSize:18];
    [ico_chevron_back addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage * chevron_back = [ico_chevron_back imageWithSize:CGSizeMake(18, 18)];
    return [chevron_back resizableImageWithCapInsets: UIEdgeInsetsMake(20, 20, 20, 20)];
}

+ (UIImage *)chevronDown; {
    
    FAKFontAwesome *ico_chevron_down = [FAKFontAwesome chevronDownIconWithSize:12];
    [ico_chevron_down addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage * chevron_down = [ico_chevron_down imageWithSize:CGSizeMake(12, 12)];
    return [chevron_down resizableImageWithCapInsets: UIEdgeInsetsMake(20, 20, 20, 20)];
}

+ (UIImage *)logo; {
    
    return [UIImage imageNamed:@"logo"];
}

+ (UIImage *)error; {
    
    FAKFontAwesome *ico_error = [FAKFontAwesome warningIconWithSize:18];
    [ico_error addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage * error = [ico_error imageWithSize:CGSizeMake(18, 18)];
    return error;
}

+ (UIImage *)mailWhite; {
    
    FAKFontAwesome *ico_main = [FAKFontAwesome envelopeIconWithSize:18];
    [ico_main addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage * main = [ico_main imageWithSize:CGSizeMake(18, 18)];
    return main;
}

+ (UIImage *)like; {
    
    UIImage *background = [UIImage imageNamed:@"btn_like2"];
    UIImage *stretchableBackground = [background resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                resizingMode:UIImageResizingModeStretch];
    
    return stretchableBackground;
}

+ (UIImage *)liked; {
    
    UIImage *background = [UIImage imageNamed:@"btn_like_active2"];
    UIImage *stretchableBackground = [background resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)
                                                                resizingMode:UIImageResizingModeStretch];
    
    return stretchableBackground;
}

+ (UIImage *)chevronBackBlack; {
    
    FAKFontAwesome *ico_chevron_black_back = [FAKFontAwesome chevronLeftIconWithSize:18];
    [ico_chevron_black_back addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UIImage * chevron_black_back = [ico_chevron_black_back imageWithSize:CGSizeMake(18, 18)];
    return chevron_black_back;
}

+ (UIImage *)icon; {
    
    return [UIImage imageNamed:@"logo_gradient"];
}

+ (UIImage *)entryJob; {
 
    return [UIImage imageNamed:@"ico_EntryJob"];
}

+ (UIImage *)entryCourseWork; {
    
    return [UIImage imageNamed:@"ico_EntryProject"];
}

+ (UIImage *)entryVoluteer; {
    
    return [UIImage imageNamed:@"ico_EntryVolunteer"];
}

+ (UIImage *)entryClubs; {
    
    return [UIImage imageNamed:@"ico_EntryClubs"];
}

+ (UIImage *)entryHobbies; {
    
    return [UIImage imageNamed:@"ico_EntryHobbies"];
}

+ (UIImage *)entryMisc; {
    
    return [UIImage imageNamed:@"ico_EntryMisc"];
}

+ (UIImage *)imageAddSelected; {
    
    FAKFontAwesome *icon_ImgSelected = [FAKFontAwesome checkCircleIconWithSize:18];
    [icon_ImgSelected addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage * imgSelectedIcon = [icon_ImgSelected imageWithSize:CGSizeMake(18, 18)];
    return imgSelectedIcon;

}

+ (UIImage *)imageAddLarge; {
    
    return [UIImage imageNamed:@"ico_btn_NewImgLarge"];
}

+ (UIImage *)tutorialGrid; {
    
    FAKFontAwesome *icon_tut_grid_white = [FAKFontAwesome thLargeIconWithSize:18];
    [icon_tut_grid_white addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    UIImage * gridIcon = [icon_tut_grid_white imageWithSize:CGSizeMake(18, 18)];
    return gridIcon;
    
}

+ (UIImage *)pullDownIcon; {
    
    return [UIImage imageNamed:@"ico_logoPulldown"];
}

+ (UIImage *)addGuide; {
    
    return [UIImage imageNamed:@"add-guide"];
}

+ (UIImage *)interestGuide; {
    
    return [UIImage imageNamed:@"interests-guide"];
}

+ (UIImage *)accept; {
    
    return [UIImage imageNamed:@"btn_sm_green2"];
}

+ (UIImage *)connected; {
    
    return [UIImage imageNamed:@"btn_sm_lightblue2"];
}

@end
