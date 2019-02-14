//
//  PFUploadViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 1/7/15.
//  Copyright (c) 2015 Portfolium. All rights reserved.
//

#import "PFUploadViewCell.h"
#import "PFConstraints.h"
#import "PFEntryView.h"
#import "UIColor+PFEntensions.h"
#import "PFColor.h"
#import "PFSize.h"

static const CGFloat kPreferredHeight = 70.0f;

@interface PFUploadViewCell ()

@end

@implementation PFUploadViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFUploadViewCell";
}

+ (CGFloat)preferredHeight; {
    
    return kPreferredHeight;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectZero];
        [image setTranslatesAutoresizingMaskIntoConstraints:NO];
        [image setContentMode:UIViewContentModeScaleAspectFit];
        [image setClipsToBounds:YES];
        [[self contentView] addSubview:image];
        [self setImage:image];
        
        UIProgressView *progressView = [[UIProgressView alloc]
                                        initWithProgressViewStyle:UIProgressViewStyleDefault];
        
        [progressView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [progressView setProgressTintColor:[PFColor blueColorOpaque]];
        [progressView setClipsToBounds:YES];
        [progressView setTrackTintColor:[UIColor clearColor]];
        [[self contentView] addSubview:progressView];
        [self setProgressView:progressView];
        
        [[progressView layer] setCornerRadius:10.0f];
        [[progressView layer] setBorderWidth:2.0f];
        [[progressView layer] setMasksToBounds:TRUE];
        [[progressView layer] setBorderColor:[PFColor separatorColor].CGColor];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self image]
                                                                 toHeight:kPreferredHeight - 20],
                                             
                                             [PFConstraints constrainView:[self image]
                                                                  toWidth:kPreferredHeight - 20],
                                             
                                             [PFConstraints leftAlignView:[self image]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:8.0f],
                                             
                                             [PFConstraints verticallyCenterView:[self image]
                                                                     inSuperview:[self contentView]],
                                             
                                             [PFConstraints constrainView:[self progressView]
                                                                 toHeight:20],
                                             
                                             [PFConstraints constrainView:[self progressView]
                                                                  toWidth:[PFSize screenWidth] - 114],
                                             
                                             [PFConstraints leftAlignView:[self progressView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:kPreferredHeight - 8],
                                             
                                             [PFConstraints verticallyCenterView:[self progressView]
                                                                     inSuperview:[self contentView]],
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self image] setBackgroundColor:[UIColor colorWithHexString:[PFEntryView palateForView]]];
}

@end
