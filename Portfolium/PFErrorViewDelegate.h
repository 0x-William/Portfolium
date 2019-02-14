//
//  PFErrorViewDelegate.h
//  Portfolium
//
//  Created by John Eisberg on 9/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PFErrorViewDelegate <NSObject>

@optional

- (void)errorView:(id)errorView
  selectedAtIndex:(NSInteger)index;

@end
