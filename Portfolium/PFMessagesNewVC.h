//
//  PFMessagesNewVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFMessagesNewVC : UIViewController<UITableViewDataSource,
                                              UITableViewDelegate,
                                              UITextFieldDelegate,
                                              UITextViewDelegate>

+ (PFMessagesNewVC *)_new;

+ (PFMessagesNewVC *)_new:(NSNumber *)userId
                 username:(NSString *)username;

@end
