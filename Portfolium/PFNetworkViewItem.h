//
//  PFNetworkViewItem.h
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCollectionViewItem.h"
#import "PFNetworkViewItemDelegate.h"

@interface PFNetworkViewItem : UICollectionViewCell<PFCollectionViewItem>

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) UILabel *usernameLabel;
@property(nonatomic, strong) UIButton *tapButton;
@property(nonatomic, strong) UIButton *statusButton;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, weak) id<PFNetworkViewItemDelegate> delegate;
@property(nonatomic, strong) NSNumber *userId;

+ (CGSize)size;

+ (CGSize)preferredAvatarSize;

- (void)pop:(void(^)(void))callback;

@end
