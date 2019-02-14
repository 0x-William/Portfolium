//
//  PFErrorView.h
//  Portfolium
//
//  Created by John Eisberg on 9/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFErrorViewDelegate.h"

@interface PFErrorView : UIView<UITableViewDelegate, UITableViewDataSource>

+ (BOOL)hidden;

- (id)initWithErrors:(NSArray *)errors
            delegate:(id<PFErrorViewDelegate>)delegate;

- (void)show:(BOOL)animated;
- (void)removeFromSubview:(BOOL)animated;

@end
