//
//  PFEditProfileVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFAnimatedForm.h"
#import <AviarySDK/AviarySDK.h>
#import "IBActionSheet.h"

@class PFUzer;

@interface PFEditProfileVC : PFAnimatedForm<UITableViewDataSource,
                                            UITableViewDelegate,
                                            UITextViewDelegate,
                                            UITextFieldDelegate,
                                            IBActionSheetDelegate,
                                            AFPhotoEditorControllerDelegate,
                                            UINavigationControllerDelegate,
                                            UIImagePickerControllerDelegate>

+ (PFEditProfileVC *) _new:(PFUzer *)user;

@end