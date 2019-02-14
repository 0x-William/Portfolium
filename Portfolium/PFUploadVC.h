//
//  PFUploadVC.h
//  Portfolium
//
//  Created by John Eisberg on 1/7/15.
//  Copyright (c) 2015 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFEntry;

@interface PFUploadVC : UIViewController<UITableViewDataSource,
                                         UITableViewDelegate>

+ (PFUploadVC *)_new:(NSArray *)assets
               entry:(PFEntry *)entry
        defaultIndex:(NSInteger)defaultIndex
               cache:(NSMutableDictionary *)cache;

- (void)startUpload:(void(^)())callback;

@end
