//
//  PFEntryCommentViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntryCommentViewCell.h"
#import "PFConstraints.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFTapGesture.h"
#import "TTTAttributedLabel+PFExtensions.h"
#import "PFColor.h"
#import "PFSize.h"

static const CGFloat kAvatarHeight = 30;

@interface PFEntryCommentViewCell ()

@property(nonatomic, strong) TTTAttributedLabel *commentLabel;
@property(nonatomic, strong) PFTapGesture *avatarViewTap;

@end

@implementation PFEntryCommentViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFEntryCommentViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [avatarView setBackgroundColor:[PFColor commentGrayColor]];
        [avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [avatarView setClipsToBounds:YES];
        [avatarView setUserInteractionEnabled:YES];
        [[self contentView] addSubview:avatarView];
        [self setAvatarView:avatarView];
        
        __weak typeof(self) weakView = self;
        
        [self setAvatarViewTap:[[PFTapGesture alloc] init:avatarView
                                                    block:^(UITapGestureRecognizer *recognizer) {
                                                        [[weakView entryDelegate] pushUserProfile:
                                                         [[self profile] userId]];
                                                    }]];
        
        TTTAttributedLabel *commentLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [commentLabel setBackgroundColor:[PFColor commentGrayColor]];
        [commentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [commentLabel setNumberOfLines:0];
        [commentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [commentLabel setFont:[PFFont fontOfSmallSize]];
        [commentLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:commentLabel];
        [self setCommentLabel:commentLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self avatarView]
                                                                 toHeight:[PFEntryCommentViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                  toWidth:[PFEntryCommentViewCell preferredAvatarSize].width],
                                             
                                             [PFConstraints leftAlignView:[self avatarView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints topAlignView:[self avatarView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints constrainView:[self commentLabel]
                                                                  toWidth:([PFSize screenWidth] * 4/5) - 10],
                                             
                                             [PFConstraints leftAlignView:[self commentLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:50.0f],
                                             
                                             [PFConstraints topAlignView:[self commentLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:12.0f]
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self commentLabel] setText:[self comment]];
    [[self commentLabel] add:[self profile]];
    [[self commentLabel] setDelegate:(id)[self entryDelegate]];
}

@end
