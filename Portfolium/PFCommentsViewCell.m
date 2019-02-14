//
//  PFCommentsViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCommentsViewCell.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFComment.h"
#import "PFTapGesture.h"
#import "PFCommentsVC.h"
#import "PFColor.h"
#import "PFSize.h"
#import "PFEntryView.h"

static const CGFloat kAvatarHeight = 54.0f;

@interface PFCommentsViewCell ()

@property(nonatomic, strong) TTTAttributedLabel *commentLabel;
@property(nonatomic, strong) PFTapGesture *avatarViewTap;
@property(nonatomic, strong) PFTapGesture *usernameTap;

@end

@implementation PFCommentsViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFCommentsViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (CGFloat)heightForCommentLabel:(PFComment *)comment; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfSmallSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [[comment comment] boundingRectWithSize:CGSizeMake([PFSize screenWidth] - 94, MAXFLOAT)
                                                  options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                               attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForRowAtComment:(PFComment *)comment; {
    
    CGFloat height = [PFCommentsViewCell heightForCommentLabel:comment];
    
    return height + 58.0f;
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
        
        __weak typeof(self) weakView = self;
        
        [self setAvatarViewTap:[[PFTapGesture alloc] init:avatarView
                                                    block:^(UITapGestureRecognizer *recognizer) {
                                                        [[weakView delegate] pushUserProfile:[self userId]];
                                                    }]];
        
        TTTAttributedLabel *usernameLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [usernameLabel setBackgroundColor:[UIColor whiteColor]];
        [usernameLabel setTextAlignment:NSTextAlignmentLeft];
        [usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [usernameLabel setFont:[PFFont fontOfMediumSize]];
        [usernameLabel setTextColor:[PFColor blueColor]];
        [[self contentView] addSubview:usernameLabel];
        [self setUsernameLabel:usernameLabel];
        
        [self setUsernameTap:[[PFTapGesture alloc] init:usernameLabel
                                                  block:^(UITapGestureRecognizer *recognizer) {
                                                      [[weakView delegate] pushUserProfile:[self userId]];
                                                  }]];
        
        TTTAttributedLabel *dateLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [dateLabel setBackgroundColor:[UIColor whiteColor]];
        [dateLabel setTextAlignment:NSTextAlignmentLeft];
        [dateLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [dateLabel setFont:[PFFont fontOfSmallSize]];
        [dateLabel setTextColor:[PFColor darkGrayColor]];
        [[self contentView] addSubview:dateLabel];
        [self setDateLabel:dateLabel];
        
        TTTAttributedLabel *commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [commentLabel setBackgroundColor:[UIColor whiteColor]];
        [commentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [commentLabel setNumberOfLines:0];
        [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [commentLabel setFont:[PFFont fontOfSmallSize]];
        [commentLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:commentLabel];
        [self setCommentLabel:commentLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self avatarView]
                                                                 toHeight:[PFCommentsViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                  toWidth:[PFCommentsViewCell preferredAvatarSize].width],
                                             
                                             [PFConstraints leftAlignView:[self avatarView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:14.0f],
                                             
                                             [PFConstraints topAlignView:[self avatarView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints constrainView:[self usernameLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints leftAlignView:[self usernameLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:62.0f],
                                             
                                             [PFConstraints topAlignView:[self usernameLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints constrainView:[self dateLabel]
                                                                 toHeight:16.0f],
                                             
                                             [PFConstraints constrainView:[self dateLabel]
                                                                  toWidth:227.0f],
                                             
                                             [PFConstraints leftAlignView:[self dateLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:62.0f],
                                             
                                             [PFConstraints positionView:[self dateLabel]
                                                               belowView:[self usernameLabel]
                                                              withMargin:-2.0f],
                                             
                                             [PFConstraints constrainView:[self commentLabel]
                                                                  toWidth:[PFSize screenWidth] - 94],
                                             
                                             [PFConstraints leftAlignView:[self commentLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:62.0f],
                                             
                                             [PFConstraints positionView:[self commentLabel]
                                                               belowView:[self dateLabel]
                                                              withMargin:0.0f],
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self commentLabel] setText:[self comment]];
    
    CGRect frame = [self usernameLabel].frame;
    frame.size.width = [PFEntryView widthForUserLabel:[[self usernameLabel] text]] + 2;
    [self usernameLabel].frame = frame;
}

@end
