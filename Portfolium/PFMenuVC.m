//
//  PFMenuVC.m
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMenuVC.h"
#import "PFMenuItemsVC.h"
#import "PFAppContainerVC.h"

NSString *const kPFMenuCellDescriptorSize = @"kPFMenuCellDescriptorSize";
NSString *const kPFMenuCellDescriptorAction = @"kPFMenuCellDescriptorAction";
NSString *const kPFMenuCellDescriptorActionBlock = @"kPFMenuCellDescriptorActionBlock";
NSString *const kPFMenuCellDescriptorReuseIdentifier = @"kPFMenuCellDescriptorReuseIdentifier";

CGFloat const kPFMenuPaneWidth = 250.0f;

@interface PFMenuVC ()

@end

@implementation PFMenuVC

+ (PFMenuVC *)shared; {
    
    static PFMenuVC *_shared;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _shared = [[self alloc] initWithNibName:nil bundle:nil];
    });
    
    return _shared;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    
    return self;
}

- (void)loadView; {
    
    [self setView:[[UIView alloc] initWithFrame:CGRectZero]];
    [self setMenuItemsVC:[PFMenuItemsVC menuItemsVCWithDelegate:self]];
    
    [self addChildViewController:[self menuItemsVC]];
    [[self view] setBackgroundColor:[UIColor purpleColor]];
    
    [[self view] addSubview:[[self menuItemsVC] view]];
    [[self view] setAutoresizesSubviews:YES];
    [[[self menuItemsVC] view] setFrame:CGRectZero];
    
    [[self view] setClipsToBounds:YES];
}

- (void)menu1:(id)sender; {
    
    [[PFAppContainerVC shared] closeMenuAnimated:YES];
}

- (void)menu2:(id)sender; {
    
    [[PFAppContainerVC shared] closeMenuAnimated:YES];
}

- (void)menu3:(id)sender; {
    
    [[PFAppContainerVC shared] closeMenuAnimated:YES];
}

- (void)menu4:(id)sender; {
    
    [[PFAppContainerVC shared] closeMenuAnimated:YES];
}

@end
