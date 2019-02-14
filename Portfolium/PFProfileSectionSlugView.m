//
//  PFProfileSectionSlugView.m
//  Portfolium
//
//  Created by John Eisberg on 12/2/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfileSectionSlugView.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFProfileSectionHeaderView.h"

@interface PFProfileSectionSlugView ()

@property(nonatomic, strong) UIButton *entryButton;
@property(nonatomic, strong) UIButton *aboutButton;
@property(nonatomic, strong) UIButton *connectionsButton;

@end

@implementation PFProfileSectionSlugView

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor clearColor]];
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        
        UIButton *entriesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [entriesButton setFrame:CGRectMake(0, 0, 160, [PFProfileSectionHeaderView preferredSize].height)];
        [entriesButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:entriesButton];
        [self setEntryButton:entriesButton];
        
        [entriesButton addTarget:[self delegate]
                          action:@selector(entriesButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
        
        /*UIButton *aboutButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [aboutButton setFrame:CGRectMake(106, 0, 106, 34)];
        [aboutButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:aboutButton];
        [self setAboutButton:aboutButton];
        
        [aboutButton addTarget:[self delegate]
                        action:@selector(aboutButtonAction:)
              forControlEvents:UIControlEventTouchUpInside];*/
        
        UIButton *connectionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [connectionsButton setFrame:CGRectMake(160, 0, 160, [PFProfileSectionHeaderView preferredSize].height)];
        [connectionsButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:connectionsButton];
        [self setConnectionsButton:connectionsButton];
        
        [connectionsButton addTarget:[self delegate]
                              action:@selector(connectionsButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        
#pragma clang diagnostic pop
        
    }
    
    return self;
}

@end
