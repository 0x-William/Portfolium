//
//  PFProfileSectionSlugView.h
//  Portfolium
//
//  Created by John Eisberg on 12/2/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFProfileSectionHeaderDelegate.h"

@interface PFProfileSectionSlugView : UICollectionViewCell

@property(nonatomic, weak) id<PFProfileSectionHeaderDelegate> delegate;
@property(nonatomic, strong) UIView *border1;

- (id)initWithFrame:(CGRect)frame;

@end
