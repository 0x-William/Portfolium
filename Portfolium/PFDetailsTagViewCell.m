//
//  PFDetailsTagViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailsTagViewCell.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFTag.h"
#import "NSString+PFExtensions.h"
#import "TTTAttributedLabel.h"
#import "PFColor.h"

@interface PFDetailsTagViewCell ()

@end

@implementation PFDetailsTagViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFDetailsTagViewCell";
}

+ (NSString *)buildTagString:(NSArray *)tags; {
    
    NSString *tagString = [NSString empty];
    PFTag *tag;
    
    for(int i = 0; i < [tags count]; i++) {
        
        tag = [tags objectAtIndex:i];
        tagString = [NSString stringWithFormat:@"%@ #%@", tagString, [tag tag]];
    }
    
    return [tagString trim];
}


+ (CGFloat)heightForRowAtTags:(NSArray *)tags; {
    
    NSString *tagString = [PFDetailsTagViewCell buildTagString:tags];
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [tagString boundingRectWithSize:CGSizeMake(300.0f, MAXFLOAT)
                                          options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                       attributes:stringAttributes context:nil].size;
    return size.height + 20.0f;
}

+ (PFDetailsTagViewCell *)build:(UITableView *)tableView; {
    
    PFDetailsTagViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  [PFDetailsTagViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFDetailsTagViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:[PFDetailsTagViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

+ (CGFloat)getHeight; {
    
    return 0.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        TTTAttributedLabel *tagsLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [tagsLabel setBackgroundColor:[UIColor whiteColor]];
        [tagsLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [tagsLabel setNumberOfLines:0];
        [tagsLabel setFont:[PFFont fontOfMediumSize]];
        [tagsLabel setTextColor:[PFColor blueColor]];
        [tagsLabel setUserInteractionEnabled:YES];
        [[self contentView] addSubview:tagsLabel];
        [self setTagsLabel:tagsLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints leftAlignView:[self tagsLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:12.0f],
                                             
                                             [PFConstraints topAlignView:[self tagsLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints constrainView:[self tagsLabel]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:12.0f],
                                             
                                             [PFConstraints constrainView:[self tagsLabel]
                                                       toHeightOfSuperView:[self contentView]
                                                              withPadding:0.0f]
         
                                             ]];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    [self buildTagString:[self tags]];
}

- (void)buildTagString:(NSArray *)tags; {
    
    NSArray *keys = [[NSArray alloc] initWithObjects:
                     (id)kCTForegroundColorAttributeName,
                     (id)kCTUnderlineStyleAttributeName, nil];
    
    NSArray *objects = [[NSArray alloc] initWithObjects:[PFColor blueColor],
                        [NSNumber numberWithInt:kCTUnderlineStyleNone], nil];
    
    NSDictionary *linkAttributes = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    
    [self tagsLabel].linkAttributes = linkAttributes;
    [self tagsLabel].activeLinkAttributes = nil;
    
    NSString *tagString = [NSString empty];
    PFTag *tag;
    
    for(int i = 0; i < [[self tags] count]; i++) {
        
        tag = [[self tags] objectAtIndex:i];
        tagString = [NSString stringWithFormat:@"%@ #%@", tagString, [tag tag]];
    }
    
    tagString = [tagString trim];
    
    [[self tagsLabel] setText:tagString];
    
    for(int i = 0; i < [[self tags] count]; i++) {
        
        tag = [[self tags] objectAtIndex:i];
        NSString *hashedTag = [NSString stringWithFormat:@"#%@", [tag tag]];
        
        NSRange r = [tagString rangeOfString:hashedTag];
        
        [[self tagsLabel] addLinkToURL:[NSURL URLWithString:[tag tag]]
                             withRange:r];
    }
}

@end
