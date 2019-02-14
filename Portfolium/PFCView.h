//
//  PFCView.h
//  Portfolium
//
//  Created by John Eisberg on 11/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PFCView : UIView

@property(nonatomic, assign) CGFloat contentOffset;

- (void)setContentView:(UIView *)contentView;

- (void)shake;

@end
