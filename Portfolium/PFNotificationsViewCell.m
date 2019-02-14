//
//  PFNotificationsViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFNotificationsViewCell.h"
#import "PFTapGesture.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFNotificationsVC.h"
#import "PFNotification.h"
#import "PFColor.h"
#import "PFEntryView.h"
#import "PFSize.h"
#import "PFEntryView.h"
#import "UIColor+PFEntensions.h"

static const CGFloat kAvatarHeight = 50.0f;

@interface PFNotificationsViewCell ()

@property(nonatomic, strong) PFTapGesture *avatarViewTap;
@property(nonatomic, strong) PFTapGesture *nameTap;

@end

@implementation PFNotificationsViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFNotificationsViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (CGFloat)heightForNotificationLabel:(PFNotification *)notification; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfSmallSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [[notification notification] boundingRectWithSize:CGSizeMake(232.0f, MAXFLOAT)
                                                            options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForRowAtNotification:(PFNotification *)notification; {
    
    return kAvatarHeight + 16;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [avatarView setBackgroundColor:[UIColor clearColor]];
        [avatarView setUserInteractionEnabled:YES];
        [avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [avatarView setClipsToBounds:YES];
        [[self contentView] addSubview:avatarView];
        [self setAvatarView:avatarView];
        
        TTTAttributedLabel *notificationLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [notificationLabel setBackgroundColor:[UIColor clearColor]];
        [notificationLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [notificationLabel setNumberOfLines:0];
        [notificationLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [notificationLabel setFont:[PFFont fontOfSmallSize]];
        [notificationLabel setTextColor:[PFColor darkGrayColor]];
        [[self contentView] addSubview:notificationLabel];
        [self setNotificationLabel:notificationLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self avatarView]
                                                                 toHeight:[PFNotificationsViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                  toWidth:[PFNotificationsViewCell preferredAvatarSize].width],
                                             
                                             [PFConstraints leftAlignView:[self avatarView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints verticallyCenterView:[self avatarView]
                                                                     inSuperview:[self contentView]],
                                             
                                             [PFConstraints constrainView:[self notificationLabel]
                                                                  toWidth:[PFSize screenWidth] - 92],
                                             
                                             [PFConstraints leftAlignView:[self notificationLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:58.0f],
                                             
                                             [PFConstraints verticallyCenterView:notificationLabel
                                                                     inSuperview:[self contentView]],
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self notificationLabel] setText:[self notification]];
}

@end
