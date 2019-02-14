//
//  PFIntercom.h
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFAuthenticationProvider;
@class PFMVVModel;

@interface PFIntercom : NSObject

+ (void)init:(PFAuthenticationProvider *)provider
        mvvm:(PFMVVModel *)mvvm;

@end
