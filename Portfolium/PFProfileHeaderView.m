//
//  PFProfileHeaderView.m
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfileHeaderView.h"
#import "PFImage.h"
#import "PFProfileVC.h"
#import "PFFont.h"
#import "PFColor.h"
#import "NSString+PFExtensions.h"
#import "UIColor+PFEntensions.h"
#import "PFEntryView.h"
#import "PFSize.h"
#import "FAKFontAwesome.h"

static const CGFloat kAvatarOffset = 95.0f;
static const CGFloat kNameOffset = 85.0f;
static const CGFloat kHeaderTextOffset = 120.0f;
static const CGFloat kAlphaMultiplier = 90.0f;
static const CGFloat kAvatarHeight = 74.0f;
static const CGFloat kGradientHeight = 120.0f;

@interface PFProfileHeaderView ()

@property(nonatomic, assign) CGFloat nameOriginY;
@property(nonatomic, assign) CGFloat schoolOriginY;

@end

@implementation PFProfileHeaderView

+ (CGSize)preferredSize; {
    
    return [PFSize preferredHeaderSize];
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (CGFloat)heightForSchoolLabel:(NSString *)school; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [school boundingRectWithSize:CGSizeMake([PFSize screenWidth] - kHeaderTextOffset, 40)
                                      options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                   attributes:stringAttributes context:nil].size;
    return size.height;
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *palateView = [[UIImageView alloc] initWithFrame:[self frame]];
        [palateView setBackgroundColor:[UIColor colorWithHexString:[PFEntryView palateForView]]];
        [palateView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:palateView];
        [self setPalateView:palateView];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:[self frame]];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
        [self setImageView:imageView];
        
        CAGradientLayer *gradient = [CAGradientLayer layer];
        [gradient setHidden:YES];
        
        gradient.frame = CGRectMake(self.frame.origin.x,
                                    self.frame.size.height - kGradientHeight,
                                    [PFSize screenWidth],
                                    kGradientHeight);
        
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor clearColor] CGColor],
                           (id)[[UIColor blackColor] CGColor], nil];
        
        [[self imageView].layer insertSublayer:gradient atIndex:0];
        [self setGradient:gradient];
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:
                                   CGRectMake(15, [PFProfileHeaderView preferredSize].height - kAvatarOffset,
                                              kAvatarHeight, kAvatarHeight)];
        
        [avatarView setBackgroundColor:[UIColor clearColor]];
        [avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [avatarView setClipsToBounds:YES];
        [[self imageView] addSubview:avatarView];
        [self setAvatarView:avatarView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(96, [PFProfileHeaderView preferredSize].height - kNameOffset,
                                         [PFSize screenWidth] - kHeaderTextOffset, 30)];
        
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setFont:[PFFont boldFontOfLargeSize]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [[self imageView] addSubview:nameLabel];
        [self setNameLabel:nameLabel];
        
        nameLabel.shadowColor = [UIColor blackColor];
        nameLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
        UILabel *schoolLabel = [[UILabel alloc] initWithFrame:
                                CGRectMake(96, [PFProfileHeaderView preferredSize].height - 55,
                                           [PFSize screenWidth] - kHeaderTextOffset, 30)];
        
        [schoolLabel setBackgroundColor:[UIColor clearColor]];
        [schoolLabel setFont:[PFFont fontOfMediumSize]];
        [schoolLabel setNumberOfLines:2];
        [schoolLabel setTextColor:[UIColor whiteColor]];
        [[self imageView] addSubview:schoolLabel];
        [self setSchoolLabel:schoolLabel];
        
        schoolLabel.shadowColor = [UIColor blackColor];
        schoolLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    CGRect frame = [self nameLabel].frame;
    frame.origin.y = [self initNameOriginY];
    [self nameLabel].frame = frame;

    if(![NSString isNullOrEmpty:[[self schoolLabel] text]]) {
        
        if([self schoolOriginY] == 0) {
        
            CGFloat height = [PFProfileHeaderView heightForSchoolLabel:[self school]];
            
            frame = [self schoolLabel].frame;
            frame.size.height = height;
            
            if(height > 17) {
                
                frame.origin.y = frame.origin.y - 6;
            }
            
            [self schoolLabel].frame = frame;
            [self setSchoolOriginY:frame.origin.y];
        }
    }
}

- (void)headerViewDidScrollUp:(CGFloat) yOffset; {
    
    CGRect frame = [self imageView].frame;
    frame.origin.y =  0 + (yOffset / 2) * -1;
    [self imageView].frame = frame;
    
    frame = [self avatarView].frame;
    frame.origin.y =  [PFProfileHeaderView preferredSize].height - kAvatarOffset + (yOffset / 2) * -1;
    [self avatarView].frame = frame;
    
    frame = [self nameLabel].frame;
    frame.origin.y =  [self nameOriginY] + (yOffset / 2) * -1;
    [self nameLabel].frame = frame;
    
    frame = [self schoolLabel].frame;
    frame.origin.y =  [self schoolOriginY] + (yOffset / 2) * -1;
    [self schoolLabel].frame = frame;
    
    [[self nameLabel] setAlpha:1];
    [[self schoolLabel] setAlpha:1];
}

- (void)headerViewDidReturnToOrigin; {
    
    CGRect frame = [self imageView].frame;
    frame.origin.y = 0;
    [self imageView].frame = frame;
    
    frame = [self imageView].frame;
    frame.size.height = [PFProfileHeaderView preferredSize].height;
    [self imageView].frame = frame;
    
    frame = [self avatarView].frame;
    frame.origin.y =  [PFProfileHeaderView preferredSize].height - kAvatarOffset;
    [self avatarView].frame = frame;
    
    frame = [self nameLabel].frame;
    frame.origin.y =  [self nameOriginY];
    [self nameLabel].frame = frame;
    
    frame = [self schoolLabel].frame;
    frame.origin.y =  [self schoolOriginY];
    [self schoolLabel].frame = frame;
    
    [[self nameLabel] setAlpha:1];
    [[self schoolLabel] setAlpha:1];
}

- (void)headerViewDidScrollDown:(CGFloat) yOffset; {
    
    CGRect frame = [self imageView].frame;
    frame.origin.y = 0;
    [self imageView].frame = frame;
    
    frame = [self avatarView].frame;
    frame.origin.y =  [PFProfileHeaderView preferredSize].height - kAvatarOffset;
    [self avatarView].frame = frame;
    
    [[self avatarView] setAlpha:(1 - ( -1 * yOffset / 90))];
    
    frame = [self nameLabel].frame;
    frame.origin.y =  [self nameOriginY];
    [self nameLabel].frame = frame;
    
    frame = [self schoolLabel].frame;
    frame.origin.y = [self schoolOriginY];
    [self schoolLabel].frame = frame;
    
    frame = [self imageView].frame;
    frame.size.height = [PFProfileHeaderView preferredSize].height - yOffset;
    [self imageView].frame = frame;
    
    [[self nameLabel] setAlpha:(1 - ( -1 * yOffset / kAlphaMultiplier))];
    [[self schoolLabel] setAlpha:(1 - ( -1 * yOffset / kAlphaMultiplier))];
    
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    
    frame = [self gradient].frame;
    frame.size.height = kGradientHeight - yOffset;
    [self gradient].frame = frame;
    
    [CATransaction commit];
}

- (CGFloat)initNameOriginY; {
    
    CGFloat yCoord = [PFProfileHeaderView preferredSize].height - kNameOffset;
    
    if([NSString isNullOrEmpty:[[self schoolLabel] text]]) {
        
        yCoord = yCoord + 10;
    
    } else {
        
        CGFloat height = [PFProfileHeaderView heightForSchoolLabel:[self school]];
        
        if(height > 17) {
            
            yCoord = yCoord - 3;
        
        } else {
            
            yCoord = yCoord + 2;
        }
    }
    
    [self setNameOriginY:yCoord];
    
    return yCoord;
}

- (void)addBorderToAvatar; {
    
    [self.avatarView.layer setBorderColor:[[UIColor whiteColor] CGColor]];
    [self.avatarView.layer setBorderWidth:2.0];
    [self.avatarView.layer setCornerRadius:2.0];
}

@end
