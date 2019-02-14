//
//  PFCollectionViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PFCollectionViewItem <NSObject>

+ (NSString *)preferredReuseIdentifier;

@end
