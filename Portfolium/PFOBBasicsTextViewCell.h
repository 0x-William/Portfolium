//
//  PFOBBasicsTextViewCell.h
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFTableViewCell.h"

@class GCPlaceholderTextView;

@interface PFOBBasicsTextViewCell : UITableViewCell<PFTableViewCell, UITextViewDelegate>

@property(nonatomic, strong) GCPlaceholderTextView *textView;

- (void)setPlaceholder:(NSString *)placeholder
              animated:(BOOL)animated;

- (void)setPlaceholderText:(NSString *)text
                  animated:(BOOL)animated;

@end
