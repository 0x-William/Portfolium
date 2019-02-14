//
//  PFProfileSectionHeaderView.h
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFProfileSectionHeaderDelegate.h"

@interface PFProfileSectionHeaderView : UICollectionViewCell

@property(nonatomic, weak) id<PFProfileSectionHeaderDelegate> delegate;
@property(nonatomic, strong) UIView *border1;

+ (CGSize)preferredSize;

- (id)initWithFrame:(CGRect)frame;

- (void)setEntriesSelected;
- (void)setAboutSelected;
- (void)setConnectionsSelected;

@end
