//
//  PFProfileHeaderView.h
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFProfileHeaderView : UIView

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *schoolLabel;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *school;
@property(nonatomic, strong) UIView *palateView;
@property(nonatomic, strong) CAGradientLayer *gradient;

+ (CGSize)preferredSize;
+ (CGSize)preferredAvatarSize;

- (void)headerViewDidScrollUp:(CGFloat)yOffset;
- (void)headerViewDidReturnToOrigin;
- (void)headerViewDidScrollDown:(CGFloat)yOffset;

- (void)addBorderToAvatar;

@end
