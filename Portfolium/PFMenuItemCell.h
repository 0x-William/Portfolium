//
//  PFMenuItemCell.h
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFCellDescriptor.h"

@interface PFMenuItemCell : UICollectionViewCell<PFCellDescriptor>

+ (NSDictionary *)cellDescriptorWithTitle:(NSString *)title
                                   action:(SEL)action;

@end
