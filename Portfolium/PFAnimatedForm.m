//
//  PFAnimatedForm.m
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAnimatedForm.h"
#import "PFOBBasicsImageViewCell.h"
#import "PFJoinEmailViewCell.h"
#import "PFOBEducationViewCell.h"
#import "PFSettingsSwitchViewCell.h"
#import "PFAddEntryViewCell.h"
#import "PFOBBasicsTextViewCell.h"

@interface PFAnimatedForm ()

@end

@implementation PFAnimatedForm

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setLoaded:[NSMutableArray arrayWithArray:
                         @[@0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0, @0]]];
    }
    
    return self;
}

- (void)animatePFOBBasicsImageViewCell:(PFOBBasicsImageViewCell *)cell
                                  text:(NSString *)text
                                 index:(NSInteger)index; {
    
    BOOL loaded = [[[self loaded] objectAtIndex:index] boolValue];
    [cell setLabelText:text animated:!loaded];
    [[self loaded] replaceObjectAtIndex:index withObject:@1];
}

- (void)animatePFJoinEmailViewCell:(PFJoinEmailViewCell *)cell
                              text:(NSString *)text
                             index:(NSInteger)index; {
    
    BOOL loaded = [[[self loaded] objectAtIndex:index] boolValue];
    [cell setLabelText:text animated:!loaded];
    [[self loaded] replaceObjectAtIndex:index withObject:@1];
}

- (void)animatePFOBEducationViewCell:(PFOBEducationViewCell *)cell
                                text:(NSString *)text
                               index:(NSInteger)index; {
    
    BOOL loaded = [[[self loaded] objectAtIndex:index] boolValue];
    [cell setLabelText:text animated:!loaded];
    [[self loaded] replaceObjectAtIndex:index withObject:@1];
}

- (void)animatePFSettingsSwitchViewCell:(PFSettingsSwitchViewCell *)cell
                                   text:(NSString *)text
                                  index:(NSInteger)index; {
    
    BOOL loaded = [[[self loaded] objectAtIndex:index] boolValue];
    [cell setLabelText:text animated:!loaded];
    [[self loaded] replaceObjectAtIndex:index withObject:@1];
}

- (void)animatePFAddEntryViewCell:(PFAddEntryViewCell *)cell
                             text:(NSString *)text
                            index:(NSInteger)index; {
    
    BOOL loaded = [[[self loaded] objectAtIndex:index] boolValue];
    [cell setPlaceholderText:text animated:!loaded];
    [[self loaded] replaceObjectAtIndex:index withObject:@1];
}

- (void)animatePFOBBasicsTextViewCell:(PFOBBasicsTextViewCell *)cell
                                 text:(NSString *)text
                                index:(NSInteger)index; {
    
    BOOL loaded = [[[self loaded] objectAtIndex:index] boolValue];
    [cell setPlaceholderText:text animated:!loaded];
    [[self loaded] replaceObjectAtIndex:index withObject:@1];
}

@end
