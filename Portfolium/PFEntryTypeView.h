//
//  PFEntryTypeView.h
//  Portfolium
//
//  Created by John Eisberg on 8/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFEntryTypeView : UIView

+ (PFEntryTypeView *)shared;

- (void)launch;
- (BOOL)isShowing;

@end
