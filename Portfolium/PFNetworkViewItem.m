//
//  PFNetworkViewItem.m
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFNetworkViewItem.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFButton.h"
#import "PFColor.h"
#import "PFImage.h"
#import "PFSize.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFMVVModel.h"
#import "PFAuthenticationProvider.h"

static const CGFloat kAvatarHeight = 44.0f;

@interface PFNetworkViewItem ()

@property(nonatomic, strong) UIButton *profileButton;
@property(nonatomic, strong) UILabel *nameLabel;

@end

@implementation PFNetworkViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFNetworkViewItem";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (CGSize)size; {
    
    return CGSizeMake([PFSize screenWidth], 62.0f);
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[PFColor lighterGrayColor]];
        
        [[self contentView] setBackgroundColor:[UIColor whiteColor]];
        
        [self setImageView:[[UIImageView alloc] initWithFrame:CGRectZero]];
        [[self imageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self imageView] setContentMode:UIViewContentModeScaleAspectFill];
        [[self imageView] setBackgroundColor:[UIColor whiteColor]];
        [[self imageView] setClipsToBounds:YES];
        [[self imageView] setOpaque:YES];
        [[self contentView] addSubview:[self imageView]];
        
        UIButton *profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [profileButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [profileButton setBackgroundColor:[UIColor clearColor]];
        [[self contentView] addSubview:profileButton];
        [self setProfileButton:profileButton];
        [profileButton addTarget:self
                          action:@selector(push:)
                forControlEvents:UIControlEventTouchUpInside];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [nameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [nameLabel setNumberOfLines:0];
        [nameLabel setBackgroundColor:[UIColor whiteColor]];
        [nameLabel setTextAlignment:NSTextAlignmentLeft];
        [nameLabel setFont:[PFFont fontOfMediumSize]];
        [nameLabel setTextColor:[PFColor darkerGrayColor]];
        [nameLabel setOpaque:YES];
        [[self contentView] addSubview:nameLabel];
        [self setNameLabel:nameLabel];
        
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [usernameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [usernameLabel setBackgroundColor:[UIColor whiteColor]];
        [usernameLabel setTextAlignment:NSTextAlignmentLeft];
        [usernameLabel setFont:[PFFont fontOfSmallSize]];
        [usernameLabel setTextColor:[PFColor grayColor]];
        [usernameLabel setOpaque:YES];
        [[self contentView] addSubview:usernameLabel];
        [self setUsernameLabel:usernameLabel];
        
        @weakify(self)
        
        [RACObserve([PFMVVModel shared], username) subscribeNext:^(NSString *username) {
            
            @strongify(self)
            
            if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[self userId]]) {
                
                [[self usernameLabel] setText:[NSString stringWithFormat:@"@%@", username]];
            }
        }];
        
        UIButton *tapButton = [PFButton connectButton];
        [tapButton setBackgroundColor:[UIColor clearColor]];
        [tapButton setClipsToBounds:YES];
        [tapButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:tapButton];
        [self setTapButton:tapButton];
        [tapButton addTarget:self
                          action:@selector(toggled:)
                forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *statusButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [statusButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [statusButton setBackgroundImage:[PFImage like]
                                forState:UIControlStateNormal];
        [statusButton setClipsToBounds:YES];
        [[statusButton titleLabel] setFont:[PFFont systemFontOfSmallSize]];
        [statusButton setTitleColor:[UIColor whiteColor]
                           forState:UIControlStateNormal];
        [statusButton setTitleEdgeInsets:UIEdgeInsetsMake(0.1, 0, -0.1, 0)];
        [statusButton setUserInteractionEnabled:NO];
        [statusButton setOpaque:YES];
        [self setStatusButton:statusButton];
        [[self contentView] insertSubview:[self statusButton]
                             belowSubview:[self tapButton]];
        
        UIView *border = [[UIView alloc] initWithFrame:CGRectZero];
        [border setTranslatesAutoresizingMaskIntoConstraints:NO];
        [border setBackgroundColor:[PFColor lightGrayColor]];
        [border setOpaque:YES];
        [[self contentView] addSubview:border];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self imageView]
                                                          toHeight:[PFNetworkViewItem preferredAvatarSize].height],
                                      
                                      [PFConstraints constrainView:[self imageView]
                                                           toWidth:[PFNetworkViewItem preferredAvatarSize].width],
                                      
                                      [PFConstraints leftAlignView:[self imageView]
                                               relativeToSuperView:[self contentView]
                                              withDistanceFromEdge:8.0f],
                                      
                                      [PFConstraints topAlignView:[self imageView]
                                              relativeToSuperView:[self contentView]
                                             withDistanceFromEdge:8.0f],
                                      
                                      [PFConstraints constrainView:[self profileButton]
                                               toHeightOfSuperView:[self contentView]
                                                       withPadding:0.0f],
                                      
                                      [PFConstraints constrainView:[self profileButton]
                                                           toWidth:[PFSize screenWidth] - 80],
                                      
                                      [PFConstraints leftAlignView:[self profileButton]
                                               relativeToSuperView:[self contentView]
                                              withDistanceFromEdge:0.0f],
                                      
                                      [PFConstraints topAlignView:[self profileButton]
                                              relativeToSuperView:[self contentView]
                                             withDistanceFromEdge:0.0f],
                                      
                                      [PFConstraints constrainView:[self nameLabel]
                                                          toHeight:17.0f],
                                      
                                      [PFConstraints constrainView:[self nameLabel]
                                                           toWidth:120.0f],
                                      
                                      [PFConstraints leftAlignView:[self nameLabel]
                                               relativeToSuperView:[self imageView]
                                              withDistanceFromEdge:50.0f],
                                      
                                      [PFConstraints topAlignView:[self nameLabel]
                                              relativeToSuperView:[self contentView]
                                             withDistanceFromEdge:14.0f],
                                      
                                      [PFConstraints constrainView:[self usernameLabel]
                                                          toHeight:14.0f],
                                      
                                      [PFConstraints constrainView:[self usernameLabel]
                                                           toWidth:200.0f],
                                      
                                      [PFConstraints leftAlignView:[self usernameLabel]
                                               relativeToSuperView:[self imageView]
                                              withDistanceFromEdge:50.0f],
                                      
                                      [PFConstraints positionView:[self usernameLabel]
                                                        belowView:[self nameLabel]
                                                       withMargin:0.0f],
                                      
                                      [PFConstraints constrainView:[self tapButton]
                                               toHeightOfSuperView:[self contentView]
                                                       withPadding:0.0f],
                                      
                                      [PFConstraints constrainView:[self tapButton]
                                                toWidthOfSuperView:[self statusButton]
                                                       withPadding:0.0f],
                                      
                                      [PFConstraints leftAlignView:[self tapButton]
                                               relativeToSuperView:[self contentView]
                                              withDistanceFromEdge:[PFSize screenWidth] - 60],
                                      
                                      [PFConstraints topAlignView:[self tapButton]
                                              relativeToSuperView:[self contentView]
                                             withDistanceFromEdge:0.0f],
                                     
                                     [PFConstraints constrainView:[self statusButton]
                                                         toHeight:30.0f],
                                     
                                     [PFConstraints constrainView:[self statusButton]
                                                          toWidth:50.0f],
                                     
                                     [PFConstraints rightAlignView:[self statusButton]
                                               relativeToSuperView:[self contentView]
                                              withDistanceFromEdge:10.0f],
                                     
                                     [PFConstraints topAlignView:[self statusButton]
                                             relativeToSuperView:[self contentView]
                                            withDistanceFromEdge:14.0f],
                                     
                                     [PFConstraints constrainView:border
                                                         toHeight:0.5],
                                     
                                     [PFConstraints constrainView:border
                                               toWidthOfSuperView:[self contentView]
                                                      withPadding:0.0f],
                                     
                                     [PFConstraints rightAlignView:border
                                               relativeToSuperView:[self contentView]
                                              withDistanceFromEdge:0.0f],
                                     
                                     [PFConstraints topAlignView:border
                                             relativeToSuperView:[self contentView]
                                            withDistanceFromEdge:[PFNetworkViewItem size].height - 1],
                                      ]];
    }
    
    return self;
}

- (void)pop:(void(^)(void))callback; {
    
    [UIView animateWithDuration:0.3/1.5
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self contentView].transform = CGAffineTransformScale
                         (CGAffineTransformIdentity, 0.95, 0.95);
                     }
                     completion:^(BOOL finished){
                         
                         [self bounceInAnimationStopped:callback];
                     }];
}

- (void)bounceInAnimationStopped:(void(^)(void))callback; {
    
    [UIView animateWithDuration:0.3/1.5
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self contentView].transform = CGAffineTransformScale
                         (CGAffineTransformIdentity, 1.0, 1.0);
                     }
                     completion:^(BOOL finished){
                         
                         [self bounceOutAnimationStopped:callback];
                     }];
}

- (void)bounceOutAnimationStopped:(void(^)(void))callback; {
    
    [UIView animateWithDuration:0.3/1.5
                          delay:0.0f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         [self contentView].transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished){
                         
                         callback();
                     }];
}

- (void)setSelected:(BOOL)selected; {
    
    if (self.selected == selected) return;
    
    [super setSelected:selected];
    
    if(selected) {
        
        [[self tapButton] setSelected:YES];
        
    } else {
        
        [[self tapButton] setSelected:NO];
    }
}

- (void)push:(UIButton *)button; {
    
    [[self delegate] networkViewItem:self requestedPushAtIndex:[self index]];
}

- (void)toggled:(UIButton *)button; {
    
    [[self delegate] networkViewItem:self requestedToggleAtIndex:[self index]];
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self nameLabel] setText:[self name]];
}

- (void)prepareForReuse; {
    
    [super prepareForReuse];
    
    [[self statusButton] setHidden:NO];
    
    [[self statusButton] setBackgroundImage:[PFImage like]
                                   forState:UIControlStateNormal];
    
    [[self statusButton] setTitle:NSLocalizedString(@"connect", nil)
                         forState:UIControlStateNormal];
    
    [[self tapButton] setUserInteractionEnabled:YES];
}

@end
