//
//  PFMenuItemCell.m
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMenuItemCell.h"
#import "PFConstraints.h"
#import "PFMenuFoundations.h"

static const NSString *kPFMenuItemCellTitle = @"kPFMenuItemCellTitle";

@interface PFMenuItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation PFMenuItemCell

+ (NSDictionary *)cellDescriptorWithTitle:(NSString *)title
                                   action:(SEL)action; {
    
    return @{ kPFMenuItemCellTitle: NSLocalizedString(title, nil),
              kPFMenuCellDescriptorAction: NSStringFromSelector(action) };
}

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFMenuItemCell";
}

- (id)initWithFrame:(CGRect)frame; {
    
    if ((self = [super initWithFrame:CGRectZero]) != nil) {
        
        [self setTitleLabel:[[UILabel alloc] initWithFrame:CGRectZero]];
        [[self titleLabel] setBackgroundColor:[UIColor clearColor]];
        [[self titleLabel] setTextColor:[UIColor whiteColor]];
        
        NSArray *subViews = @[_titleLabel];
        
        for (UIView *view in subViews) {
            
            [[self contentView] addSubview:view];
            [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        }
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-13-[_titleLabel]-|"
                                                                     options:NSLayoutFormatAlignAllCenterY
                                                                     metrics:nil
                                                                       views:NSDictionaryOfVariableBindings(_titleLabel)]];
        for (UIView *view in subViews) {
            
            [[self contentView] addConstraint:
             [PFConstraints verticallyCenterView:view inSuperview:[self contentView]]];
        }
    }
    
    return self;
}

-(void)prepareForReuse {
    
    [super prepareForReuse];
    [self setHighlighted:NO];
}

-(void) setStateFromDescriptor:(NSDictionary *)descriptor; {
    
    [[self titleLabel] setText:[descriptor objectForKey:kPFMenuItemCellTitle]];
}

@end
