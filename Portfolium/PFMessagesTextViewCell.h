//
//  PFMessagesTextViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 10/3/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFTableViewCell.h"

@class GCPlaceholderTextView;

@interface PFMessagesTextViewCell : UITableViewCell<PFTableViewCell, UITextViewDelegate>

@property(nonatomic, strong) GCPlaceholderTextView *textView;

- (void)setPlaceholder:(NSString *)placeholder
              animated:(BOOL)animated;

@end