//
//  PFDetailsSocialViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailsSocialViewCell.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "TTTAttributedLabel.h"
#import "PFColor.h"
#import "PFEntryView.h"
#import "PFImage.h"
#import "FAKFontAwesome.h"
#import "PFSize.h"

@implementation PFDetailsSocialViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFDetailsSocialViewCell";
}

+ (PFDetailsSocialViewCell *)build:(UITableView *)tableView; {
    
    PFDetailsSocialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     [PFDetailsSocialViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFDetailsSocialViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:[PFDetailsSocialViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

+ (CGFloat)heightForTitleLabel:(NSString *)title; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfLargeSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake([PFSize screenWidth] - 20.0f, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                   attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)getHeight:(NSString *)title; {
    
    CGFloat titleHeight = [PFDetailsSocialViewCell heightForTitleLabel:title];
    
    return titleHeight + 32;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        TTTAttributedLabel *titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [titleLabel setBackgroundColor:[UIColor whiteColor]];
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [titleLabel setNumberOfLines:0];
        [titleLabel setFont:[PFFont fontOfLargeSize]];
        [titleLabel setTextColor:[UIColor blackColor]];
        [[self contentView] addSubview:titleLabel];
        [self setTitleLabel:titleLabel];
        
        UILabel *categoryLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [categoryLabel setBackgroundColor:[UIColor whiteColor]];
        [categoryLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [categoryLabel setNumberOfLines:1];
        [categoryLabel setFont:[PFFont fontOfCategorySize]];
        [categoryLabel setTextColor:[PFColor darkGrayColor]];
        [[self contentView] addSubview:categoryLabel];
        [self setCategoryLabel:categoryLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self titleLabel]
                                                                  toWidth:[PFSize screenWidth] - 20.0f],
                                             
                                             [PFConstraints leftAlignView:[self titleLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self titleLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:6.0f],
                                             
                                             [PFConstraints constrainView:[self categoryLabel]
                                                                 toHeight:22.0f],
                                             
                                             [PFConstraints constrainView:[self categoryLabel]
                                                                  toWidth:[PFSize screenWidth] / 2],
                                             
                                             [PFConstraints leftAlignView:[self categoryLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints positionView:[self categoryLabel]
                                                               belowView:[self titleLabel]
                                                              withMargin:1.0f],
                                             ]];
        
        
        /*
        UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [starLabel setBackgroundColor:[UIColor whiteColor]];
        
        FAKFontAwesome *starIcon = [FAKFontAwesome heartIconWithSize:12];
        [starIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [starLabel setAttributedText:[starIcon attributedString]];
        
        [starLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:starLabel];
        
        TTTAttributedLabel *starViewLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [starViewLabel setBackgroundColor:[UIColor whiteColor]];
        [starViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [starViewLabel setFont:[PFFont fontOfSmallSize]];
        [starViewLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:starViewLabel];
        [self setStarViewLabel:starViewLabel];
        
        UILabel *bubbleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [bubbleLabel setBackgroundColor:[UIColor whiteColor]];
        
        FAKFontAwesome *bubbleIcon = [FAKFontAwesome commentsIconWithSize:12];
        [bubbleIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [bubbleLabel setAttributedText:[bubbleIcon attributedString]];
        
        [bubbleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:bubbleLabel];
        
        TTTAttributedLabel *bubbleViewLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [bubbleViewLabel setBackgroundColor:[UIColor whiteColor]];
        [bubbleViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [bubbleViewLabel setFont:[PFFont fontOfSmallSize]];
        [bubbleViewLabel setTextColor:[PFColor grayColor]];
        [[self contentView] addSubview:bubbleViewLabel];
        [self setBubbleViewLabel:bubbleViewLabel];
        
        UILabel *eyeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [eyeLabel setBackgroundColor:[UIColor whiteColor]];
        
        FAKFontAwesome *eyeIcon = [FAKFontAwesome eyeIconWithSize:12];
        [eyeIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [eyeLabel setAttributedText:[eyeIcon attributedString]];
        
        [eyeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:eyeLabel];
        
        TTTAttributedLabel *eyeViewLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [eyeViewLabel setBackgroundColor:[UIColor whiteColor]];
        [eyeViewLabel setFont:[PFFont fontOfSmallSize]];
        [eyeViewLabel setTextColor:[PFColor grayColor]];
        [eyeViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:eyeViewLabel];
        [self setEyeViewLabel:eyeViewLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:starLabel
                                                                 toHeight:14.0f],
                                             
                                             [PFConstraints constrainView:starLabel
                                                                  toWidth:14.0f],
                                             
                                             [PFConstraints rightAlignView:starLabel
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:132.0f],
                                             
                                             [PFConstraints positionView:starLabel
                                                               belowView:[self titleLabel]
                                                              withMargin:6.0f],
                                             
                                             [PFConstraints constrainView:[self starViewLabel]
                                                                 toHeight:14.0f],
                                             
                                             [PFConstraints constrainView:[self starViewLabel]
                                                                  toWidth:24.0f],
                                             
                                             [PFConstraints positionView:[self starViewLabel]
                                                           toRightOfView:starLabel
                                                              withMargin:2.0f],
                                             
                                             [PFConstraints positionView:[self starViewLabel]
                                                               belowView:[self titleLabel]
                                                              withMargin:6.0f],
                                             
                                             [PFConstraints constrainView:bubbleLabel
                                                                 toHeight:14.0f],
                                             
                                             [PFConstraints constrainView:bubbleLabel
                                                                  toWidth:14.0f],
                                             
                                             [PFConstraints positionView:bubbleLabel
                                                           toRightOfView:[self starViewLabel]
                                                              withMargin:6.0f],
                                             
                                             [PFConstraints positionView:bubbleLabel
                                                               belowView:[self titleLabel]
                                                              withMargin:5.5f],
                                             
                                             [PFConstraints constrainView:[self bubbleViewLabel]
                                                                 toHeight:14.0f],
                                             
                                             [PFConstraints constrainView:[self bubbleViewLabel]
                                                                  toWidth:24.0f],
                                             
                                             [PFConstraints positionView:[self bubbleViewLabel]
                                                           toRightOfView:bubbleLabel
                                                              withMargin:2.0f],
                                             
                                             [PFConstraints positionView:[self bubbleViewLabel]
                                                               belowView:[self titleLabel]
                                                              withMargin:5.5f],
                                             
                                             [PFConstraints constrainView:eyeLabel
                                                                 toHeight:14.0f],
                                             
                                             [PFConstraints constrainView:eyeLabel
                                                                  toWidth:14.0f],
                                             
                                             [PFConstraints positionView:eyeLabel
                                                           toRightOfView:[self bubbleViewLabel]
                                                              withMargin:6.0f],
                                             
                                             [PFConstraints positionView:eyeLabel
                                                               belowView:[self titleLabel]
                                                              withMargin:6.0f],
                                             
                                             [PFConstraints constrainView:[self eyeViewLabel]
                                                                 toHeight:14.0f],
                                             
                                             [PFConstraints constrainView:[self eyeViewLabel]
                                                                  toWidth:24.0f],
                                             
                                             [PFConstraints positionView:[self eyeViewLabel]
                                                           toRightOfView:eyeLabel
                                                              withMargin:2.0f],
                                             
                                             [PFConstraints positionView:[self eyeViewLabel]
                                                               belowView:[self titleLabel]
                                                              withMargin:6.0f],
                                             ]];
        */
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
}

@end
