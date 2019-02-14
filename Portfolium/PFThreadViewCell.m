//
//  PFThreadViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFThreadViewCell.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFComment.h"
#import "PFTapGesture.h"
#import "PFCommentsVC.h"
#import "PFThread.h"
#import "PFThreadVC.h"
#import "PFMessage.h"
#import "PFColor.h"
#import "PFEntryView.h"
#import "PFSize.h"
#import "PFEntryView.h"
#import "UIColor+PFEntensions.h"

static const CGFloat kAvatarHeight = 56.0f;

@interface PFThreadViewCell ()

@property(nonatomic, strong) TTTAttributedLabel *messageLabel;
@property(nonatomic, strong) PFTapGesture *avatarViewTap;
@property(nonatomic, strong) PFTapGesture *usernameTap;

@end

@implementation PFThreadViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFThreadViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (CGFloat)heightForThreadLabel:(PFMessage *)message; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfSmallSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [[message body] boundingRectWithSize:CGSizeMake([PFSize screenWidth] - 90, MAXFLOAT)
                                                  options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                               attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForRowAtThread:(PFMessage *)message; {
    
    CGFloat height = [PFThreadViewCell heightForThreadLabel:message];
    
    return height + 64.0f;
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
        
        __weak typeof(self) weakView = self;
        [self setAvatarViewTap:[[PFTapGesture alloc] init:avatarView
                                                    block:^(UITapGestureRecognizer *recognizer) {
                                                        [[weakView vc] pushUserProfile:[self userId]];
                                                    }]];
        
        TTTAttributedLabel *nameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [nameLabel setBackgroundColor:[UIColor whiteColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [nameLabel setFont:[PFFont fontOfMediumSize]];
        [nameLabel setTextColor:[PFColor blueColor]];
        [[self contentView] addSubview:nameLabel];
        [self setNameLabel:nameLabel];
        
        [self setUsernameTap:[[PFTapGesture alloc] init:nameLabel
                                                  block:^(UITapGestureRecognizer *recognizer) {
                                                      [[weakView vc] pushUserProfile:[self userId]];
                                                  }]];
        
        TTTAttributedLabel *messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [messageLabel setBackgroundColor:[UIColor whiteColor]];
        [messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [messageLabel setNumberOfLines:0];
        [messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [messageLabel setFont:[PFFont fontOfSmallSize]];
        [messageLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:messageLabel];
        [self setMessageLabel:messageLabel];
        
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [dateLabel setBackgroundColor:[UIColor clearColor]];
        [dateLabel setTextAlignment:NSTextAlignmentLeft];
        [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [dateLabel setFont:[PFFont boldFontOfSmallSize]];
        [dateLabel setTextColor:[PFColor lightGrayColor]];
        [[self contentView] addSubview:dateLabel];
        [self setDateLabel:dateLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self avatarView]
                                                                 toHeight:[PFThreadViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                  toWidth:[PFThreadViewCell preferredAvatarSize].width],
                                             
                                             [PFConstraints leftAlignView:[self avatarView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints topAlignView:[self avatarView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints constrainView:[self nameLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints leftAlignView:[self nameLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:64.0f],
                                             
                                             [PFConstraints topAlignView:[self nameLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints constrainView:[self messageLabel]
                                                                  toWidth:[PFSize screenWidth] - 90],
                                             
                                             [PFConstraints leftAlignView:[self messageLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:64.0f],
                                             
                                             [PFConstraints topAlignView:[self messageLabel]
                                                     relativeToSuperView:[self nameLabel]
                                                    withDistanceFromEdge:22.0f],
                                             
                                             [PFConstraints constrainView:[self dateLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self dateLabel]
                                                                  toWidth:237.0f],
                                             
                                             [PFConstraints leftAlignView:[self dateLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:64.0f],
                                             
                                             [PFConstraints bottomAlignView:[self dateLabel]
                                                        relativeToSuperView:[self contentView]
                                                       withDistanceFromEdge:8.0f],
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self messageLabel] setText:[self message]];
    
    CGRect frame = [self dateLabel].frame;
    frame.origin.y = [self messageLabel].frame.origin.y + [self messageLabel].frame.size.height;
    [self dateLabel].frame = frame;
    
    frame = [self nameLabel].frame;
    frame.size.width = [PFEntryView widthForUserLabel:[[self nameLabel] text]] + 2;
    [self nameLabel].frame = frame;
}

@end