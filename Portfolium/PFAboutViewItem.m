//
//  PFAboutViewItem.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAboutViewItem.h"
#import "PFColor.h"
#import "PFEducationViewCell.h"
#import "PFAbout.h"
#import "PFConstraints.h"
#import "PFFont.h"

@interface PFAboutViewItem ();

@property(nonatomic, strong) UIView *canvasView;
@property(nonatomic, strong) UILabel *taglineLabel;
@property(nonatomic, strong) UILabel *tagline;

@end

@implementation PFAboutViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFAboutViewItem";
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[PFColor blueGray]];
        
        UIView *canvasView = [[UIView alloc] initWithFrame:CGRectZero];
        [canvasView setBackgroundColor:[UIColor whiteColor]];
        [canvasView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:canvasView];
        [self setCanvasView:canvasView];
        
        [[canvasView layer] setBorderColor:[[PFColor grayColor] CGColor]];
        [[canvasView layer] setBorderWidth:1.0f];
        [[canvasView layer] setCornerRadius:5.0f];
        [[canvasView layer] setMasksToBounds:YES];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self canvasView]
                                                                 toHeight:500.0f],
                                             
                                             [PFConstraints constrainView:[self canvasView]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:8.0f],
                                             
                                             [PFConstraints leftAlignView:[self canvasView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:8.0f],
                                             
                                             [PFConstraints topAlignView:[self canvasView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:8.0f],
                                             ]];
    }
    
    return self;
}

@end
