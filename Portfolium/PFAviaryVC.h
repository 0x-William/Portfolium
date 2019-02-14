//
//  PFAviaryVC.h
//  Portfolium
//
//  Created by John Eisberg on 11/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AviarySDK/AviarySDK.h>

typedef enum {
    
    PFImageTypeAvatar,
    PFImageTypeCover,
    PFImageTypeEntry
    
} PFImageType;

@interface PFAviaryVC : AFPhotoEditorController

@property(nonatomic, assign) PFImageType imageType;

+ (PFAviaryVC *) _new:(PFImageType)imageType
                image:(UIImage *)image;

@end
