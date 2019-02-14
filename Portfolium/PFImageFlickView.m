//
//  PFImageFlickView.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFImageFlickView.h"
#import "PFSize.h"
#import "PFColor.h"

@interface PFImageFlickView ()

@property(nonatomic, strong) NSMutableArray *circles;

@end

@implementation PFImageFlickView

+ (PFImageFlickView *)_new:(NSInteger)count; {
    
    CGRect frame = CGRectMake(0, [PFSize preferredDetailSize].height - 30, 0, 14.0f);
    frame.size.width = count * 14.0f + 6.0f;
    frame.origin.x = (([PFSize screenWidth] - frame.size.width) / 2) + 3.0f;
    
    PFImageFlickView *view = [[PFImageFlickView alloc] initWithFrame:frame];
    [view setCircles:[[NSMutableArray alloc] initWithCapacity:count]];
    
    [view setBackgroundColor:[PFColor blackColorLessOpaque]];
    [[view layer] setCornerRadius:6.0f];
    [[view layer] setMasksToBounds:YES];
    
    for(int i = 0; i < count; i++) {
        
        UIView *circle = [[UIView alloc] initWithFrame:
                          CGRectMake((i * 14.0f) + 5.0f, 2.5f, 8.0f, 8.0f)];

        [[circle layer] setCornerRadius:4.0f];
        [[circle layer] setMasksToBounds:YES];
        
        if(i == 0) {
            
            [circle setBackgroundColor:[PFColor blueColor]];
            
        } else {
            
            [circle setBackgroundColor:[PFColor lightGrayColor]];
        }
        
        [view addSubview:circle];
        [[view circles] addObject:circle];
    }
    
    return view;
}

- (void)setSelectedAtIndex:(NSInteger)index; {
    
    for(int i = 0; i < [[self circles] count]; i++) {
        
        UIView *circle = [[self circles] objectAtIndex:i];
        
        if(i == index) {
            
            [circle setBackgroundColor:[PFColor blueColor]];
            
        } else {
            
            [circle setBackgroundColor:[PFColor lightGrayColor]];
        }
    }
}

@end
