//
//  PFBasicsVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFAnimatedForm.h"
#import <AviarySDK/AviarySDK.h>
#import "IBActionSheet.h"

@interface PFOBBasicsVC : PFAnimatedForm<UITableViewDataSource,
                                         UITableViewDelegate,
                                         UITextViewDelegate,
                                         UITextFieldDelegate,
                                         UIPickerViewDelegate,
                                         UIPickerViewDataSource,
                                         IBActionSheetDelegate,
                                         AFPhotoEditorControllerDelegate,
                                         UINavigationControllerDelegate,
                                         UIImagePickerControllerDelegate>
+ (PFOBBasicsVC *) _new;

@end
