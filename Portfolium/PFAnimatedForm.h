//
//  PFAnimatedForm.h
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFOBBasicsImageViewCell;
@class PFJoinEmailViewCell;
@class PFOBEducationViewCell;
@class PFSettingsSwitchViewCell;
@class PFOBBasicsImageViewCell;
@class PFAddEntryViewCell;
@class PFOBBasicsTextViewCell;

@interface PFAnimatedForm : UIViewController

@property(nonatomic, strong) NSMutableArray *loaded;

- (void)animatePFOBBasicsImageViewCell:(PFOBBasicsImageViewCell *)cell
                                  text:(NSString *)text
                                 index:(NSInteger)index;

- (void)animatePFJoinEmailViewCell:(PFJoinEmailViewCell *)cell
                              text:(NSString *)text
                             index:(NSInteger)index;

- (void)animatePFOBEducationViewCell:(PFOBEducationViewCell *)cell
                                text:(NSString *)text
                               index:(NSInteger)index;

- (void)animatePFSettingsSwitchViewCell:(PFSettingsSwitchViewCell *)cell
                                   text:(NSString *)text
                                  index:(NSInteger)index;

- (void)animatePFAddEntryViewCell:(PFAddEntryViewCell *)cell
                             text:(NSString *)text
                            index:(NSInteger)index;

- (void)animatePFOBBasicsTextViewCell:(PFOBBasicsTextViewCell *)cell
                                 text:(NSString *)text
                                index:(NSInteger)index;

@end
