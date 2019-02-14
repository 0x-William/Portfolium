//
//  UIButton+PFExtensions.h
//  Portfolium
//
//  Created by John Eisberg on 12/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIButton (PFExtentions)

- (void)toConnectState;

- (void)toPendingState;

- (void)toAcceptState;

- (void)toConnectedState;

- (void)toLikeStateWithCount : (NSString*)str ;

- (void)toLikedStateWithCount : (NSString*)str ;

@end
