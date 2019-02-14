//
//  PFEntryHeaderView.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntryHeaderView.h"
#import "PFImage.h"
#import "PFFont.h"
#import "PFColor.h"
#import "UIImageView+PFImageLoader.h"
#import "PFSystemCategory.h"
#import "PFGradient.h"
#import "PFSize.h"

@implementation PFEntryHeaderView

+ (CGSize)preferredSize; {
    
    return [PFSize preferredHeaderSize];
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(0, 0, [PFSize screenWidth],
                                             [PFEntryHeaderView preferredSize].height)];
        
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [self addSubview:imageView];
        [self setImageView:imageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:
                              CGRectMake(10, [PFEntryHeaderView preferredSize].height - 55,
                                         [PFSize screenWidth] - 20, 30)];
        
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [nameLabel setFont:[PFFont boldFontOfExtraLargeSize]];
        [nameLabel setTextColor:[UIColor whiteColor]];
        [[self imageView] addSubview:nameLabel];
        [self setNameLabel:nameLabel];
        
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:
                                     CGRectMake(10, [PFEntryHeaderView preferredSize].height - 30,
                                                [PFSize screenWidth] - 20, 20)];
        
        [descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [descriptionLabel setFont:[PFFont boldFontOfSmallSize]];
        [descriptionLabel setTextColor:[UIColor whiteColor]];
        [[self imageView] addSubview:descriptionLabel];
        [self setDescriptionLabel:descriptionLabel];
    }
    
    return self;
}

- (void)headerViewDidScrollUp:(CGFloat) yOffset; {
    
    CGRect frame = [self imageView].frame;
    frame.origin.y =  0 + (yOffset / 2) * -1;
    [self imageView].frame = frame;
    
    frame = [self nameLabel].frame;
    frame.origin.y =  ([PFEntryHeaderView preferredSize].height - 55) + (yOffset / 2) * -1;
    [self nameLabel].frame = frame;
    
    frame = [self descriptionLabel].frame;
    frame.origin.y =  ([PFEntryHeaderView preferredSize].height - 30) + (yOffset / 2) * -1;
    [self descriptionLabel].frame = frame;
    
    [[self nameLabel] setAlpha:(([PFEntryHeaderView preferredSize].height - 55) - yOffset) /
     ([PFEntryHeaderView preferredSize].height - 55)];
    
    [[self descriptionLabel] setAlpha:(([PFEntryHeaderView preferredSize].height - 55) - yOffset) /
     ([PFEntryHeaderView preferredSize].height - 55)];
}

- (void)headerViewDidReturnToOrigin; {
    
    CGRect frame = [self imageView].frame;
    frame.origin.y = 0;
    [self imageView].frame = frame;
    
    frame = [self imageView].frame;
    frame.size.height = [PFEntryHeaderView preferredSize].height;
    [self imageView].frame = frame;
    
    frame = [self nameLabel].frame;
    frame.origin.y =  ([PFEntryHeaderView preferredSize].height - 55);
    [self nameLabel].frame = frame;
    
    frame = [self descriptionLabel].frame;
    frame.origin.y =  ([PFEntryHeaderView preferredSize].height - 30);
    [self descriptionLabel].frame = frame;
    
    [[self nameLabel] setAlpha:1];
    [[self descriptionLabel] setAlpha:1];
}

- (void)headerViewDidScrollDown:(CGFloat) yOffset; {

    CGRect frame = [self imageView].frame;
    frame.origin.y = 0;
    [self imageView].frame = frame;
    
    frame = [self nameLabel].frame;
    frame.origin.y =  ([PFEntryHeaderView preferredSize].height - 55);
    [self nameLabel].frame = frame;
    
    frame = [self descriptionLabel].frame;
    frame.origin.y =  ([PFEntryHeaderView preferredSize].height - 30);
    [self descriptionLabel].frame = frame;
    
    frame = [self imageView].frame;
    frame.size.height = [PFEntryHeaderView preferredSize].height - yOffset;
    [self imageView].frame = frame;
    
    [[self nameLabel] setAlpha:(1 - ( -1 * yOffset / 90))];
    [[self descriptionLabel] setAlpha:(1 - ( -1 * yOffset / 90))];
}

- (void)setImageFor:(PFSystemCategory *)category
           animated:(BOOL)animated
           callback:(void (^)(id sender))callback; {
    
    [[self nameLabel] setHidden:YES];
    [[self descriptionLabel] setHidden:YES];
    
    [[self nameLabel] setText:[category name]];
    [[self descriptionLabel] setText:[category desc]];
    
    [[self imageView] setAlpha:0.0f];
    [[self nameLabel] setAlpha:0.0f];
    [[self descriptionLabel] setAlpha:0.0f];
    
    [[self imageView] setImageWithUrl:[[category gradient] url]
                        postProcessingBlock:nil
                              progressBlock:nil
                           placeholderImage:nil
                                        tag:0
                                   callback:^(UIImage *image, NSInteger tag) {
                                       
                                       if(animated) {
                                       
                                           [UIView animateWithDuration:0.5 animations:^{
                                               
                                               [[self imageView] setAlpha:1.0f];
                                               
                                           } completion:^(BOOL finished) {
                                               
                                               [[self nameLabel] setAlpha:0];
                                               [[self descriptionLabel] setAlpha:0];
                                               
                                               [[self nameLabel] setHidden:NO];
                                               [[self descriptionLabel] setHidden:NO];
                                               
                                               [UIView animateWithDuration:0.3 animations:^{
                                                   
                                                   [[self nameLabel] setAlpha:1];
                                                   [[self descriptionLabel] setAlpha:1];
                                                   
                                               } completion:^(BOOL finished) {
                                               }];
                                           }];
                                           
                                       } else {
                                           
                                           [[self imageView] setAlpha:1.0f];
                                           [[self nameLabel] setAlpha:1.0f];
                                           [[self descriptionLabel] setAlpha:1.0f];
                                           
                                           [[self imageView] setHidden:NO];
                                           [[self nameLabel] setHidden:NO];
                                           [[self descriptionLabel] setHidden:NO];
                                       }
                                       
                                       callback(self);
                                   }];
}

@end