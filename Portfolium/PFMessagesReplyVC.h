//
//  PFMessageReplyVC.h
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PFMessagesReplyVC : UIViewController<UITableViewDataSource,
                                                UITableViewDelegate,
                                                UITextFieldDelegate,
                                                UITextViewDelegate>

+ (PFMessagesReplyVC *)_new:(NSNumber *)threadId
                       name:(NSString *)name;

@end
