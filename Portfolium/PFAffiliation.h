//
//  PFAffiliation.h
//  Portfolium
//
//  Created by John Eisberg on 11/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFAccomplishment.h"

@interface PFAffiliation : PFAccomplishment

@property(nonatomic, strong) NSDate *startDate;
@property(nonatomic, strong) NSDate *endDate;

@end
