//
//  PFOBEducationVC.h
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFOBEducationVC : UIViewController<UITableViewDelegate,
                                              UITableViewDataSource,
                                              UITextFieldDelegate,
                                              UIPickerViewDelegate,
                                              UIPickerViewDataSource>
+ (PFOBEducationVC *)_new;

- (void)didChooseWhoIAm:(NSString *)whoIAm;
- (void)didChooseSchool:(NSString *)school;
- (void)didChooseFieldOfStudy:(NSString *)fieldOfStudy;
- (void)didChooseYear:(NSString *)year;

@end
