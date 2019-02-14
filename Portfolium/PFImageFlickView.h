//
//  PFImageFlickView.h
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFImageFlickView : UIView

+ (PFImageFlickView *)_new:(NSInteger)count;

- (void)setSelectedAtIndex:(NSInteger)index;

@end
