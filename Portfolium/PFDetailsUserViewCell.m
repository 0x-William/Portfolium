//
//  PFDetailsUserViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailsUserViewCell.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFTapGesture.h"
#import "PFDetailVC.h"
#import "PFConstraints.h"
#import "PFColor.h"
#import "UIControl+BlocksKit.h"
#import "PFImage.h"
#import "FAKFontAwesome.h"
#import "NSAttributedString+CCLFormat.h"
#import "PFSize.h"
#import "PFFontAwesome.h"

static CGFloat kUserViewHeight = 47.0f;
static CGFloat kAvatarHeight = 26.0f;

@interface PFDetailsUserViewCell ()

@property(nonatomic, strong) PFTapGesture *avatarViewTap;
@property(nonatomic, strong) PFTapGesture *usernameLabelTap;

@end

@implementation PFDetailsUserViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFDetailsUserViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (PFDetailsUserViewCell *)build:(UITableView *)tableView; {
    
    PFDetailsUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                   [PFDetailsUserViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFDetailsUserViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                            reuseIdentifier:[PFDetailsUserViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

+ (CGFloat)getHeight; {
    
    return kUserViewHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIView *top = [[UIView alloc] initWithFrame:CGRectZero];
        [top setTranslatesAutoresizingMaskIntoConstraints:NO];
        [top setBackgroundColor:[PFColor separatorColor]];
        [[self contentView] addSubview:top];
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [avatarView setBackgroundColor:[UIColor whiteColor]];
        [avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
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
        
        [self setUsernameLabelTap:[[PFTapGesture alloc] init:usernameLabel
                                                    block:^(UITapGestureRecognizer *recognizer) {
                                                        [[weakView delegate] pushUserProfile:[self userId]];
                                                    }]];
        
        UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [statusButton setFrame:CGRectMake([PFSize screenWidth] - 64, 10, 50, 30)];
        [statusButton setBackgroundImage:[PFImage like]
                                       forState:UIControlStateNormal];
        
        [statusButton setAttributedTitle:[PFFontAwesome connectIcon]
                                forState:UIControlStateNormal];
        
        [[statusButton titleLabel] setFont:[PFFont systemFontOfSmallSize]];
        [statusButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 3, 3, 0)];
        [self setStatusButton:statusButton];
        [[self contentView] addSubview:statusButton];
        
        UIView *bottom = [[UIView alloc] initWithFrame:CGRectZero];
        [bottom setTranslatesAutoresizingMaskIntoConstraints:NO];
        [bottom setBackgroundColor:[PFColor separatorColor]];
        [[self contentView] addSubview:bottom];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:top
                                                                 toHeight:0.5f],
                                             
                                             [PFConstraints constrainView:top
                                                                  toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:top
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:top
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                 toHeight:[PFDetailsUserViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                  toWidth:[PFDetailsUserViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints leftAlignView:[self avatarView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self avatarView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints constrainView:[self usernameLabel]
                                                                 toHeight:18.0f],
                                             
                                             [PFConstraints constrainView:[self usernameLabel]
                                                                  toWidth:[PFSize screenWidth] * 2/3],
                                             
                                             [PFConstraints leftAlignView:[self usernameLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:42.0f],
                                             
                                             [PFConstraints verticallyCenterView:[self usernameLabel]
                                                                     inSuperview:[self contentView]],
                                             
                                             [PFConstraints constrainView:bottom
                                                                 toHeight:0.5f],
                                             
                                             [PFConstraints constrainView:bottom
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:bottom
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints bottomAlignView:bottom
                                                        relativeToSuperView:[self contentView]
                                                       withDistanceFromEdge:0.0f],
                                             ]];
    }
    
    return self;
}

@end
