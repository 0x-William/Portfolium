//
//  PFEntryViewItem.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntryViewItem.h"
#import "PFColor.h"
#import "PFConstraints.h"

@implementation PFEntryViewItem

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFEntryViewItem";
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        PFEntryView *entryView = [[PFEntryView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        [entryView setBackgroundColor:[PFColor lighterGrayColor]];
        [entryView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self setEntryView:entryView];
        [[self contentView] addSubview:(UIView *)[self entryView]];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self entryView]
                                                      toHeightOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints constrainView:[self entryView]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints horizontallyCenterView:[self entryView]
                                                                       inSuperview:[self contentView]],
                                             
                                             [PFConstraints verticallyCenterView:[self entryView]
                                                                     inSuperview:[self contentView]]
                                             ]];
    }
    
    return self;
}

- (PFEntryView *)containedEntryView; {
    
    return [self entryView];
}

@end
