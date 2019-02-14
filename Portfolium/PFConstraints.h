//
//  PFConstraints.h
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PFConstraints : NSObject

+ (NSLayoutConstraint *)verticallyCenterView:(UIView *)view
                                 inSuperview:(UIView *)container;

+ (NSLayoutConstraint *)horizontallyCenterView:(UIView *)view
                                   inSuperview:(UIView *)container;

+ (NSArray *)horizontallyCenterViews:(NSArray *)views
                         inSuperView:(UIView *)container
                       withTopMargin:(CGFloat)topMargin
                             spacing:(CGFloat)spacing;

+ (NSArray *)verticallyAlignViews:(NSArray *)views
                       withMargin:(CGFloat)margin;

+ (NSArray *)centerView:(UIView *)view
            inSuperview:(UIView *)container;

+ (NSLayoutConstraint *)constrainView:(UIView *)view
                             toHeight:(CGFloat)height;

+ (NSLayoutConstraint *)constrainView:(UIView *)view
                      toMinimumHeight:(CGFloat)height;

+ (NSLayoutConstraint *)constrainView:(UIView *)view
                              toWidth:(CGFloat)width;

+ (NSArray *)constrainView:(UIView *)view
                    toSize:(CGSize)size;

+ (NSLayoutConstraint *)constrainView:(UIView *)view
                   toWidthOfSuperView:(UIView *)container
                          withPadding:(CGFloat)padding;

+ (NSLayoutConstraint *)constrainView:(UIView *)view
                  toHeightOfSuperView:(UIView *)container
                          withPadding:(CGFloat)padding;

+ (NSArray *)constrainView:(UIView *)view
         toSizeOfSuperView:(UIView *)container
               withPadding:(CGFloat)padding;

+ (NSLayoutConstraint *)leftAlignView:(UIView *)view
                  relativeToSuperView:(UIView *)container
                 withDistanceFromEdge:(CGFloat)distance1;

+ (NSArray *)constrainView:(UIView *)view
               toCoverView:(UIView *)container;

+ (NSLayoutConstraint *)rightAlignView:(UIView *)view
                   relativeToSuperView:(UIView *)container
                  withDistanceFromEdge:(CGFloat)distance;

+ (NSLayoutConstraint *)topAlignView:(UIView *)view
                 relativeToSuperView:(UIView *)container
                withDistanceFromEdge:(CGFloat)distance;

+ (NSLayoutConstraint *)bottomAlignView:(UIView *)view
                    relativeToSuperView:(UIView *)container
                   withDistanceFromEdge:(CGFloat)distance;

+ (NSLayoutConstraint *)positionView:(UIView *)view
                           belowView:(UIView *)belowView
                          withMargin:(CGFloat)margin;

+ (NSLayoutConstraint *)positionView:(UIView *)view
                       toRightOfView:(UIView *)rightView
                          withMargin:(CGFloat)margin;

+ (NSLayoutConstraint *)constrainBottomOfView:(UIView *)view
                                  toTopOfView:(UIView *)peer;

+ (NSArray *)constraintView:(UIView *)view
    toBePositionedVerticallyBelowView:(UIView *)above
                  aboveView:(UIView *)below;

@end

