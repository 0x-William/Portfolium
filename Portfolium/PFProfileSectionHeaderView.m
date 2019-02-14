//
//  PFProfileSectionHeaderView.m
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfileSectionHeaderView.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFSize.h"

static const CGFloat kPreferredHeight = 52.0f;

@interface PFProfileSectionHeaderView ()

@property(nonatomic, strong) UIButton *entryButton;
@property(nonatomic, strong) UIButton *aboutButton;
@property(nonatomic, strong) UIButton *connectionsButton;

@property(nonatomic, strong) UIView *border2;
@property(nonatomic, strong) UIView *border3;

@end

@implementation PFProfileSectionHeaderView

+ (CGSize)preferredSize; {
    
    return CGSizeMake([PFSize screenWidth], kPreferredHeight);
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
 
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        
        UIButton *entriesButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [entriesButton setFrame:CGRectMake(0, 0, [PFSize screenWidth] / 2,
                                           [PFProfileSectionHeaderView preferredSize].height)];
        
        [entriesButton setTitle:@"Entries" forState:UIControlStateNormal];
        [[entriesButton titleLabel] setFont:[PFFont systemFontOfMediumSize]];
        [entriesButton setTitleColor:[PFColor darkGrayColor] forState:UIControlStateNormal];
        [entriesButton setTitleColor:[PFColor blueColor] forState:UIControlStateHighlighted];
        [entriesButton setTitleColor:[PFColor blueColor] forState:UIControlStateSelected];
        [entriesButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_default"] forState:UIControlStateNormal];
        [entriesButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_active"] forState:UIControlStateSelected];
        [entriesButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_active"] forState:UIControlStateHighlighted];
        
        [entriesButton setSelected:YES];
        [self addSubview:entriesButton];
        [self setEntryButton:entriesButton];
        
        
        [entriesButton addTarget:[self delegate]
                          action:@selector(entriesButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
        
        
        UIButton *connectionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [connectionsButton setFrame:CGRectMake([PFSize screenWidth] / 2, 0, [PFSize screenWidth] / 2,
                                               [PFProfileSectionHeaderView preferredSize].height)];
        
        [connectionsButton setTitle:@"Connections" forState:UIControlStateNormal];
        [[connectionsButton titleLabel] setFont:[PFFont systemFontOfMediumSize]];
        [connectionsButton setTitleColor:[PFColor darkGrayColor] forState:UIControlStateNormal];
        [connectionsButton setTitleColor:[PFColor blueColor] forState:UIControlStateHighlighted];
        [connectionsButton setTitleColor:[PFColor blueColor] forState:UIControlStateSelected];
        [connectionsButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_default"] forState:UIControlStateNormal];
        [connectionsButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_active"] forState:UIControlStateSelected];
        [connectionsButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_active"] forState:UIControlStateHighlighted];

        [self addSubview:connectionsButton];
        [self setConnectionsButton:connectionsButton];
        
        [connectionsButton addTarget:[self delegate]
                              action:@selector(connectionsButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake([PFSize screenWidth] / 2, 0, 0.5f,
                                                                     [PFProfileSectionHeaderView preferredSize].height)];
        separator.backgroundColor = [PFColor separatorColor];
        [self addSubview:separator];
        
#pragma clang diagnostic pop
        
    }
    
    return self;
}

- (void)setEntriesSelected; {
    
    [[self entryButton] setSelected:YES];
    [[self aboutButton] setSelected:NO];
    [[self connectionsButton] setSelected:NO];
    
    [[self border1] setHidden:NO];
    [[self border2] setHidden:YES];
    [[self border3] setHidden:YES];
}

- (void)setAboutSelected; {
    
    [[self entryButton] setSelected:NO];
    [[self aboutButton] setSelected:YES];
    [[self connectionsButton] setSelected:NO];
    
    [[self border1] setHidden:YES];
    [[self border2] setHidden:NO];
    [[self border3] setHidden:YES];
}

- (void)setConnectionsSelected; {
    
    [[self entryButton] setSelected:NO];
    [[self aboutButton] setSelected:NO];
    [[self connectionsButton] setSelected:YES];
    
    [[self border1] setHidden:YES];
    [[self border2] setHidden:YES];
    [[self border3] setHidden:NO];
}

@end
