//
//  PFConstraints.m
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFConstraints.h"

@implementation PFConstraints

+ (NSLayoutConstraint *)verticallyCenterView:(UIView *)view
                                 inSuperview:(UIView *)container; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeCenterY
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeCenterY
                                       multiplier:1.0f
                                         constant:0.0f];
}

+ (NSLayoutConstraint *)horizontallyCenterView:(UIView *)view
                                   inSuperview:(UIView *)container; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeCenterX
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeCenterX
                                       multiplier:1.0f
                                         constant:0.0f];
}

+ (NSArray *)horizontallyCenterViews:(NSArray *)views
                        inSuperView:(UIView *)container
                      withTopMargin:(CGFloat)topMargin
                            spacing:(CGFloat)spacing; {
    
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:[views count] * 2];
    UIView *previousView = nil;
    for (UIView *view in views) {
        [constraints addObject:[self horizontallyCenterView:view inSuperview:container]];
        if (previousView == nil) {
            [constraints addObject:[self topAlignView:view relativeToSuperView:container withDistanceFromEdge:topMargin]];
        } else {
            [constraints addObject:[self positionView:view belowView:previousView withMargin:spacing]];
        }
        
        previousView = view;
    }
    
    return [NSArray arrayWithArray:constraints];
}

+ (NSArray *)verticallyAlignViews:(NSArray *)views
                       withMargin:(CGFloat)margin; {
    
    NSMutableArray *constraints = [NSMutableArray arrayWithCapacity:[views count] * 2];
    UIView *previousView = nil;
    for (UIView *view in views) {
        if (previousView != nil) {
            [constraints addObject:[self horizontallyCenterView:view inSuperview:previousView]];
            [constraints addObject:[self positionView:view toRightOfView:previousView withMargin:margin]];
        }
        
        previousView = view;
    }
    
    return [NSArray arrayWithArray:constraints];
}

+ (NSArray *)centerView:(UIView *)view
            inSuperview:(UIView *)container; {
    
    return @[[self verticallyCenterView:view inSuperview:container],
             [self horizontallyCenterView:view inSuperview:container]];
}

+ (NSLayoutConstraint *) constrainView:(UIView *)view
                              toHeight:(CGFloat)height; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:0
                                       multiplier:0.0f
                                         constant:height];
}

+ (NSLayoutConstraint *) constrainView:(UIView *)view
                       toMinimumHeight:(CGFloat)height; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationGreaterThanOrEqual
                                           toItem:nil
                                        attribute:0
                                       multiplier:0.0f
                                         constant:height];
}

+ (NSLayoutConstraint *) constrainView:(UIView *)view
                               toWidth:(CGFloat)width; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:nil
                                        attribute:0
                                       multiplier:0.0f
                                         constant:width];
}

+ (NSArray *) constrainView:(UIView *)view toSize:(CGSize)size; {
    
    return @[[self constrainView:view toHeight:size.height],
             [self constrainView:view toWidth:size.width]];
}

+ (NSLayoutConstraint *)constrainView:(UIView *)view
                   toWidthOfSuperView:(UIView *)container
                          withPadding:(CGFloat)padding; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeWidth
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeWidth
                                       multiplier:1.0f
                                         constant:-(padding * 2)];
}

+(NSLayoutConstraint *)constrainView:(UIView *)view
                 toHeightOfSuperView:(UIView *)container
                         withPadding:(CGFloat)padding; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeHeight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeHeight
                                       multiplier:1.0f
                                         constant:-(padding * 2)];
}

+ (NSArray *)constrainView:(UIView *)view
         toSizeOfSuperView:(UIView *)container
               withPadding:(CGFloat)padding; {
    
    return @[[self constrainView:view toWidthOfSuperView:container withPadding:padding],
             [self constrainView:view toHeightOfSuperView:container withPadding:padding]
             ];
}

+ (NSLayoutConstraint *)leftAlignView:(UIView *)view
                  relativeToSuperView:(UIView *)container
                 withDistanceFromEdge:(CGFloat)distance; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeLeft
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeLeft
                                       multiplier:1.0f
                                         constant:distance];
}


+ (NSArray *) constrainView:(UIView *)view toCoverView:(UIView *)container; {
    
    return @[[NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeCenterX
                                          relatedBy:NSLayoutRelationEqual toItem:container
                                          attribute:NSLayoutAttributeCenterX
                                         multiplier:1.0f
                                           constant:0.0f],
             [NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeCenterY
                                          relatedBy:NSLayoutRelationEqual toItem:container
                                          attribute:NSLayoutAttributeCenterY
                                         multiplier:1.0f
                                           constant:0.0f],
             [NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeWidth
                                          relatedBy:NSLayoutRelationEqual toItem:container
                                          attribute:NSLayoutAttributeWidth
                                         multiplier:1.0f
                                           constant:0.0f],
             [NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeHeight
                                          relatedBy:NSLayoutRelationEqual toItem:container
                                          attribute:NSLayoutAttributeHeight
                                         multiplier:1.0f
                                           constant:0.0f]
             ];
}

+ (NSLayoutConstraint *)rightAlignView:(UIView *)view
                   relativeToSuperView:(UIView *)container
                  withDistanceFromEdge:(CGFloat)distance; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeRight
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0f
                                         constant:-distance];
}

+ (NSLayoutConstraint *)topAlignView:(UIView *)view
                 relativeToSuperView:(UIView *)container
                withDistanceFromEdge:(CGFloat)distance; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeTop
                                       multiplier:1.0f
                                         constant:distance];
}

+ (NSLayoutConstraint *)bottomAlignView:(UIView *)view
                    relativeToSuperView:(UIView *)container
                   withDistanceFromEdge:(CGFloat)distance; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:container
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0f
                                         constant:-distance];
}


+(NSLayoutConstraint *)positionView:(UIView *)view
                          belowView:(UIView *)belowView
                         withMargin:(CGFloat)margin; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeTop
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:belowView
                                        attribute:NSLayoutAttributeBottom
                                       multiplier:1.0f
                                         constant:margin];
}

+ (NSLayoutConstraint *)positionView:(UIView *)view
                       toRightOfView:(UIView *)rightView
                          withMargin:(CGFloat)margin; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeLeft
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:rightView
                                        attribute:NSLayoutAttributeRight
                                       multiplier:1.0f
                                         constant:margin];
}


+(NSLayoutConstraint *)constrainBottomOfView:(UIView *)view
                                 toTopOfView:(UIView *)peer; {
    
    return [NSLayoutConstraint constraintWithItem:view
                                        attribute:NSLayoutAttributeBottom
                                        relatedBy:NSLayoutRelationEqual
                                           toItem:peer
                                        attribute:NSLayoutAttributeTop
                                       multiplier:1.0f
                                         constant:0];
}


+ (NSArray *)constraintView:(UIView *)view
    toBePositionedVerticallyBelowView:(UIView *)above
                  aboveView:(UIView *)below; {
    
    return @[[NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeTop
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:above
                                          attribute:NSLayoutAttributeBottom
                                         multiplier:1.0f
                                           constant:0.0f],
             
             [NSLayoutConstraint constraintWithItem:view
                                          attribute:NSLayoutAttributeBottom
                                          relatedBy:NSLayoutRelationEqual
                                             toItem:below
                                          attribute:NSLayoutAttributeTop
                                         multiplier:1.0f
                                           constant:0.0f]
             ];
}

@end