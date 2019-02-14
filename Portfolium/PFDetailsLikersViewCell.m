//
//  PFDetailsLikersViewCell.m
//  Portfolium
//
//  Created by John Eisberg on 11/22/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailsLikersViewCell.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFTag.h"
#import "NSString+PFExtensions.h"
#import "TTTAttributedLabel.h"
#import "PFColor.h"

static CGFloat kLikesImageViewWidth = 39.0f;

static NSInteger kMaxLikes = 7;

@interface PFDetailsLikersViewCell ()

@end

@implementation PFDetailsLikersViewCell

+ (NSString *)preferredReuseIdentifier; {
    
    return @"PFDetailsLikersViewCell";
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kLikesImageViewWidth, kLikesImageViewWidth);
}

+ (PFDetailsLikersViewCell *)build:(UITableView *)tableView; {
    
    PFDetailsLikersViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                  [PFDetailsLikersViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFDetailsLikersViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:[PFDetailsLikersViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

+ (CGFloat)getHeight; {
    
    return 74.0f;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier; {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [titleLabel setBackgroundColor:[UIColor whiteColor]];
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [titleLabel setNumberOfLines:1];
        [titleLabel setFont:[PFFont fontOfMediumSize]];
        [[self contentView] addSubview:titleLabel];
        [self setTitleLabel:titleLabel];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self titleLabel]
                                                                 toHeight:22.0f],
                                             
                                             [PFConstraints constrainView:[self titleLabel]
                                                                  toWidth:50.0f],
                                             
                                             [PFConstraints leftAlignView:[self titleLabel]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:10.0f],
                                             
                                             [PFConstraints topAlignView:[self titleLabel]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:4.0f],
                                             ]];
        
        NSMutableArray *likersImageViews = [[NSMutableArray alloc] initWithCapacity:kMaxLikes];
        
        for(int i = 0; i < kMaxLikes; i++) {
            
            CGFloat xCoord = 10;
            
            if(i > 0) { xCoord = 10 + (i * 43); }
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                      CGRectMake(xCoord, 28,
                                                 kLikesImageViewWidth, kLikesImageViewWidth)];
            
            [imageView setBackgroundColor:[UIColor whiteColor]];
            [imageView setContentMode:UIViewContentModeScaleAspectFill];
            [imageView setClipsToBounds:YES];
            [imageView setUserInteractionEnabled:YES];
            [[self contentView] addSubview:imageView];
            [likersImageViews addObject:imageView];
        }
        
        [self setLikersImageViews:likersImageViews];
    }
    
    return self;
}

@end