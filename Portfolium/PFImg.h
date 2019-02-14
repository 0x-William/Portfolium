//
//  PFImg.h
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFModel.h"

@interface PFImg : NSObject<PFModel>

@property(nonatomic, strong) NSString *cropped;
@property(nonatomic, strong) NSString *croppedHttps;
@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *urlHttps;

@end
