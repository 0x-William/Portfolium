//
//  PFTermsViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTermsViewCell.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFConstraints.h"
#import "TTTAttributedLabel.h"
#import "TTTAttributedLabel+PFExtensions.h"

@interface PFTermsViewCell ()

@property(nonatomic, strong) TTTAttributedLabel *termsLabel;

@end

@implementation PFTermsViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFTermsViewCell.h";
}

+ (CGFloat)heightForTermsLabel:(NSString *)text; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [text boundingRectWithSize:CGSizeMake(280.0f, MAXFLOAT)
                                     options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                  attributes:stringAttributes context:nil].size;
    return size.height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        TTTAttributedLabel *termsLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [termsLabel setFont:[PFFont fontOfMediumSize]];
        [termsLabel setBackgroundColor:[UIColor whiteColor]];
        [termsLabel setTextColor:[PFColor grayColor]];
        [termsLabel setTextAlignment:NSTextAlignmentLeft];
        [termsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [termsLabel setNumberOfLines:0];
        [[self contentView] addSubview:termsLabel];
        [self setTermsLabel:termsLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self termsLabel]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:20.0f],
                                             
                                             [PFConstraints leftAlignView:[self termsLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:20.0f],
                                             
                                             [PFConstraints topAlignView:[self termsLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:20.0f],
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [[self termsLabel] setText:[self terms] enbolden:[self header]];
}

@end
