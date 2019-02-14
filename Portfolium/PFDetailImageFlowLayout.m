//
//  PFDetailImageFlowLayout.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailImageFlowLayout.h"
#import "PFSize.h"

@implementation PFDetailImageFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset
                                 withScrollingVelocity:(CGPoint)velocity; {
    
    CGFloat rawPageValue = self.collectionView.contentOffset.x / [PFSize screenWidth];
    CGFloat currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    
    if (pannedLessThanAPage && flicked) {
        
        proposedContentOffset.x = nextPage * [PFSize screenWidth];
    
    } else {
        
        proposedContentOffset.x = round(rawPageValue) * [PFSize screenWidth];
    }
    
    return proposedContentOffset;
}

- (CGFloat)flickVelocity {
    
    return 0.3;
}

@end
