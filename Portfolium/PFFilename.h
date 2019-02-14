//
//  PFFilename.h
//  Portfolium
//
//  Created by John Eisberg on 8/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFModel.h"

@interface PFFilename : NSObject<PFModel>

@property(nonatomic, strong) NSString *dynamic;
@property(nonatomic, strong) NSString *dynamicHttps;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *urlHttps;

- (NSString *)croppedToSize:(CGSize)size;

@end
