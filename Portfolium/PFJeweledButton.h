//
//  PFJeweledButton.h
//  Portfolium
//
//  Created by John Eisberg on 12/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFJewelView.h"

@interface PFJeweledButton : UIButton

@property(nonatomic, strong) PFJewelView *jewel;

+ (PFJeweledButton *)_mail:(void (^)(id sender))handler;
+ (PFJeweledButton *)_bell:(void (^)(id sender))handler;

- (void)setCount:(NSNumber *)count;

@end
