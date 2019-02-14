//
//  PFEntryHeaderView.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFSystemCategory;

@interface PFEntryHeaderView : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *descriptionLabel;

+ (CGSize)preferredSize;

- (void)setImageFor:(PFSystemCategory *)category
           animated:(BOOL)animated
           callback:(void (^)(id sender))callback;

- (void)headerViewDidScrollUp:(CGFloat)yOffset;
- (void)headerViewDidReturnToOrigin;
- (void)headerViewDidScrollDown:(CGFloat)yOffset;

@end
