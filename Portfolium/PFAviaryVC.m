//
//  PFAviaryVC.m
//  Portfolium
//
//  Created by John Eisberg on 11/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAviaryVC.h"

@interface PFAviaryVC ()

@end

@implementation PFAviaryVC

+ (PFAviaryVC *) _new:(PFImageType)imageType
                image:(UIImage *)image; {
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        [AFPhotoEditorController setAPIKey:@"534f284b0be48eae"
                                    secret:@"f1686490ba3869d8"];
    });
    
    NSArray * toolOrder = @[kAFEnhance, kAFEffects, kAFCrop, kAFFrames, kAFAdjustments, kAFOrientation, kAFFocus, kAFText, kAFRedeye];
    [AFPhotoEditorCustomization setToolOrder:toolOrder];
    
    AFPhotoEditorController *editorController = [[AFPhotoEditorController alloc] initWithImage:image];
    
    return (PFAviaryVC *)editorController;
}

+ (void)launchImagePickerForView:(UIView *)view {
    
    
}

@end
