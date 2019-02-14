//
//  PFUsersViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFUsersViewCell.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFColor.h"
#import "NSString+PFExtensions.h"
#import "PFSize.h"

static const CGFloat kAvatarHeight = 36.0f;

@interface PFUsersViewCell ()

@property(nonatomic, strong) NSLayoutConstraint *usernameYOrigin;
@property(nonatomic, strong) NSLayoutConstraint *usernameYOriginEmptySchool;
@property(nonatomic, strong) NSLayoutConstraint *usernameYOriginHasSchool;

@end

@implementation PFUsersViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFUsersViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
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
        [usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [usernameLabel setBackgroundColor:[UIColor clearColor]];
        [usernameLabel setTextAlignment:NSTextAlignmentLeft];
        [usernameLabel setFont:[PFFont fontOfMediumSize]];
        [usernameLabel setTextColor:[PFColor blueColor]];
        [[self contentView] addSubview:usernameLabel];
        [self setUsernameLabel:usernameLabel];
        
        TTTAttributedLabel *schoolLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [schoolLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [schoolLabel setBackgroundColor:[UIColor clearColor]];
        [schoolLabel setTextAlignment:NSTextAlignmentLeft];
        [schoolLabel setFont:[PFFont fontOfSmallSize]];
        [schoolLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:schoolLabel];
        [self setSchoolLabel:schoolLabel];
        
        NSLayoutConstraint *usernameYOrigin = [PFConstraints topAlignView:[self usernameLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f];
        
        [self setUsernameYOrigin:usernameYOrigin];
        
        NSLayoutConstraint *usernameYOriginEmptySchool = [PFConstraints topAlignView:[self usernameLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:16.0f];
        
        [self setUsernameYOriginEmptySchool:usernameYOriginEmptySchool];
        
        NSLayoutConstraint *usernameYOriginHasSchool = [PFConstraints topAlignView:[self usernameLabel]
                                                                 relativeToSuperView:[self contentView]
                                                                withDistanceFromEdge:8.0f];
        
        [self setUsernameYOriginHasSchool:usernameYOriginHasSchool];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self avatarView]
                                                                 toHeight:[PFUsersViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints constrainView:[self avatarView]
                                                                  toWidth:[PFUsersViewCell preferredAvatarSize].height],
                                             
                                             [PFConstraints leftAlignView:[self avatarView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self avatarView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:7.0f],
                                             
                                             [PFConstraints constrainView:[self usernameLabel]
                                                                 toHeight:16.0f],
                                             
                                             [PFConstraints constrainView:[self usernameLabel]
                                                                  toWidth:[PFSize screenWidth] - 72],
                                             
                                             [PFConstraints leftAlignView:[self usernameLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:42.0f],
                                             
                                             [self usernameYOrigin],
                                             
                                             [PFConstraints constrainView:[self schoolLabel]
                                                                 toHeight:20.0f],
                                             
                                             [PFConstraints constrainView:[self schoolLabel]
                                                                  toWidth:[PFSize screenWidth] - 72],
                                             
                                             [PFConstraints leftAlignView:[self schoolLabel]
                                                      relativeToSuperView:[self avatarView]
                                                     withDistanceFromEdge:42.0f],
                                             
                                             [PFConstraints positionView:[self schoolLabel]
                                                               belowView:[self usernameLabel]
                                                              withMargin:0.3]
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    if([NSString isNullOrEmpty:[[self schoolLabel] text]]) {
        
        [[self contentView] removeConstraint:[self usernameYOrigin]];
        [[self contentView] addConstraint:[self usernameYOriginEmptySchool]];
        
        [[self schoolLabel] setHidden:YES];
        
    } else {
        
        [[self contentView] removeConstraint:[self usernameYOrigin]];
        [[self contentView] addConstraint:[self usernameYOriginHasSchool]];
    }
}

@end
