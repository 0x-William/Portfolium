//
//  PFMessagesViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/10/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMessagesViewCell.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFComment.h"
#import "PFTapGesture.h"
#import "PFCommentsVC.h"
#import "PFThread.h"
#import "PFMessagesVC.h"
#import "PFColor.h"
#import "PFSize.h"
#import "PFEntryView.h"
#import "UIColor+PFEntensions.h"

static const CGFloat kAvatarHeight = 56.0f;

@interface PFMessagesViewCell ()

@property(nonatomic, strong) TTTAttributedLabel *messageLabel;
@property(nonatomic, strong) PFTapGesture *avatarViewTap;
@property(nonatomic, strong) PFTapGesture *usernameTap;

@end

@implementation PFMessagesViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFMessagesViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (CGFloat)heightForThreadLabel:(PFThread *)thread; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfSmallSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [[thread lastBody] boundingRectWithSize:CGSizeMake([PFSize screenWidth] - 98, MAXFLOAT)
                                                  options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                               attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForRowAtThread:(PFThread *)thread; {
    
    CGFloat height = [PFMessagesViewCell heightForThreadLabel:thread];
    
    return height + 64.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [avatarView setBackgroundColor:[UIColor clearColor]];
        [avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [avatarView setClipsToBounds:YES];
        [avatarView setUserInteractionEnabled:YES];
        [[self contentView] addSubview:avatarView];
        [self setAvatarView:avatarView];
        
        TTTAttributedLabel *usernameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [usernameLabel setBackgroundColor:[UIColor clearColor]];
        [usernameLabel setTextAlignment:NSTextAlignmentLeft];
        [usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [usernameLabel setFont:[PFFont fontOfMediumSize]];
        [usernameLabel setTextColor:[PFColor blueColor]];
        [[self contentView] addSubview:usernameLabel];
        [self setUsernameLabel:usernameLabel];
        
        UILabel *subjectLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [subjectLabel setBackgroundColor:[UIColor clearColor]];
        [subjectLabel setTextAlignment:NSTextAlignmentLeft];
        [subjectLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [subjectLabel setFont:[PFFont boldFontOfSmallSize]];
        [subjectLabel setTextColor:[PFColor darkGrayColor]];
        [[self contentView] addSubview:subjectLabel];
        [self setSubjectLabel:subjectLabel];
        
        TTTAttributedLabel *messageLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [messageLabel setBackgroundColor:[UIColor clearColor]];
        [messageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [messageLabel setNumberOfLines:0];
        [messageLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [messageLabel setFont:[PFFont fontOfSmallSize]];
        [messageLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:messageLabel];
        [self setMessageLabel:messageLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self avatarView]
                                                                 toHeight:[PFMessagesViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                  toWidth:[PFMessagesViewCell preferredAvatarSize].width],
                                             
                                             [PFConstraints leftAlignView:[self avatarView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints topAlignView:[self avatarView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints constrainView:[self usernameLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self usernameLabel]
                                                                  toWidth:[PFSize screenWidth] - 98],
                                             
                                             [PFConstraints leftAlignView:[self usernameLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:64.0f],
                                             
                                             [PFConstraints topAlignView:[self usernameLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints constrainView:[self subjectLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self subjectLabel]
                                                                  toWidth:[PFSize screenWidth] - 98],
                                             
                                             [PFConstraints leftAlignView:[self subjectLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:64.0f],
                                             
                                             [PFConstraints topAlignView:[self subjectLabel]
                                                     relativeToSuperView:[self usernameLabel]
                                                    withDistanceFromEdge:17.0f],
                                             
                                             [PFConstraints constrainView:[self messageLabel]
                                                                  toWidth:[PFSize screenWidth] - 98],
                                             
                                             [PFConstraints leftAlignView:[self messageLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:64.0f],
                                             
                                             [PFConstraints topAlignView:[self messageLabel]
                                                     relativeToSuperView:[self subjectLabel]
                                                    withDistanceFromEdge:22.0f],
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self messageLabel] setText:[self message]];
}

@end
