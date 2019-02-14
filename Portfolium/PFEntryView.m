//
//  PFEntityView.m
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntryView.h"
#import "PFConstraints.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFEntryCommentViewCell.h"
#import "UIImageView+PFImageLoader.h"
#import "PFComment.h"
#import "PFProfile.h"
#import "PFTapGesture.h"
#import "PFCommentsVC.h"
#import "PFAvatar.h"
#import "GCPlaceholderTextView.h"
#import "NSString+PFExtensions.h"
#import "PFMVVModel.h"
#import "PFColor.h"
#import "PFImage.h"
#import "PFCommentField.h"
#import "NSNotificationCenter+MainThread.h"
#import "UIControl+BlocksKit.h"
#import "UIView+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "UITextView+PFExtensions.h"
#import "UIView+PFExtensions.h"
#import "PFProfileTypeVC.h"
#import "PFLandingVC.h"
#import "PFLandingProfileVC.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFAuthenticationProvider.h"
#import "PFLandingCategoryFeedVC.h"
#import <stdlib.h>
#import "UIColor+PFEntensions.h"
#import "FAKFontAwesome.h"
#import "PFSize.h"

static CGFloat kImageViewHeight = 220.0f;
static CGFloat kEntryMargin = 8.0f;
static CGFloat kCaptionMargin = 12.0f;
static CGFloat kCommentMargin = 10.0f;
static CGFloat kAvatarHeight = 42.0f;

@interface PFEntryView ()

@property(nonatomic, strong) PFTapGesture *avatarViewTap;
@property(nonatomic, strong) PFTapGesture *userLabelTap;
@property(nonatomic, strong) UIView *interactionView;
@property(nonatomic, strong) UIButton *commentButton;
@property(nonatomic, strong) UIButton *submitCommentButton;
@property(nonatomic, assign) CGFloat commentHeight;
@property(nonatomic, strong) UIView *captionView;
@property(nonatomic, strong) UIView *contentView;

@end

@implementation PFEntryView

+ (CGSize)preferredImageSize; {
    
    return CGSizeMake([PFSize screenWidth], kImageViewHeight);
}

+ (CGSize)preferredImageCrop; {
    
    return [PFSize preferredImageCrop];
}

+ (CGSize)preferredAvatarSize; {
    
    return CGSizeMake(kAvatarHeight, kAvatarHeight);
}

+ (NSArray *)palates; {
    
    static NSArray *_palates;
    static dispatch_once_t once;
    
    dispatch_once(&once, ^{
        
        _palates = @[@"cff09e",
                     @"a8dba8",
                     @"79bd9a",
                     @"3b8686",
                     @"0b486b"];
    });
    
    return _palates;
}

+ (NSString *)palateForView; {
    
    return [[PFEntryView palates] objectAtIndex:
            arc4random_uniform((int)[[PFEntryView palates] count])];
}

+ (CGSize)boundingRectWithSize:(CGSize)size
                         title:(NSString *)title
                       caption:(NSString *)caption
                      comments:(NSArray *)comments; {
    
    CGFloat height = [PFEntryView heightForCaptionLabel:caption] + 14;
    
    PFComment *comment;
    
    for(int i = 0; i < [comments count]; i++) {
        
        comment = [comments objectAtIndex:i];
        height = height + [PFEntryView heightForRowAtComment:comment];
    }
    
    return CGSizeMake(247.0f, kImageViewHeight
                      + (64 + [PFEntryView heightForTitleLabel:title])
                      + height + 20.0f + 32.0f
                      + [PFEntryView heightForCaptionViewBuffer:caption]);
}

+ (CGFloat)heightForTitleLabel:(NSString *)title; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [title boundingRectWithSize:CGSizeMake([PFSize screenWidth] - 90, MAXFLOAT)
                                      options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                   attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForCaptionLabel:(NSString *)text; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGFloat width = [PFSize screenWidth] - (2 * kEntryMargin) - 2 - (kCaptionMargin * 2);
    CGSize size = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                  attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForCaptionViewBuffer:(NSString *)text; {
    
    CGFloat buffer = -14.0f;
    if(![NSString isNullOrEmpty:text]) {
        buffer = 14;
    }
    
    return buffer;
}

+ (CGFloat)widthForUserLabel:(NSString *)userName; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfMediumSize]
                                                                 forKey:NSFontAttributeName];
    
    CGSize size = [userName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                         options:NSStringDrawingTruncatesLastVisibleLine|
                   NSStringDrawingUsesLineFragmentOrigin
                                      attributes:stringAttributes context:nil].size;
    return size.width;
}

+ (CGFloat)heightForCommentLabel:(PFComment *)comment; {
    
    NSDictionary *stringAttributes = [NSDictionary dictionaryWithObject:[PFFont fontOfSmallSize]
                                                                 forKey:NSFontAttributeName];
    
    NSString *commentString = [NSString stringWithFormat:@"%@ %@",
                               [[PFMVVModel shared] generateName:[comment profile]],
                               [comment comment]];
    
    CGSize size = [commentString boundingRectWithSize:CGSizeMake(([PFSize screenWidth] * 4/5) - kCommentMargin,
                                                                 MAXFLOAT)
                                              options:NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin
                                           attributes:stringAttributes context:nil].size;
    return size.height;
}

+ (CGFloat)heightForRowAtComment:(PFComment *)comment; {
    
    CGFloat height = [PFEntryView heightForCommentLabel:comment];
    
    if(height < 41.0f) {
        height = 44.0f;
    } else {
        height = height + 12.0f;
    }
    
    return height;
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [contentView setClipsToBounds:YES];
        [contentView setBackgroundColor:[PFColor lightGrayColor]];
        [self addSubview:contentView];
        [self setContentView:contentView];
        
        [[contentView layer] setBorderColor:[[PFColor lightGrayColor] CGColor]];
        [[contentView layer] setBorderWidth:1.0f];
        [[contentView layer] setCornerRadius:5.0f];
        [[contentView layer] setMasksToBounds:YES];
        
        [self addConstraints:@[[PFConstraints constrainView:[self contentView]
                                         toWidthOfSuperView:self
                                                withPadding:kEntryMargin],
                               
                               [PFConstraints leftAlignView:[self contentView]
                                        relativeToSuperView:self
                                       withDistanceFromEdge:kEntryMargin],
                               
                               [PFConstraints topAlignView:[self contentView]
                                       relativeToSuperView:self
                                      withDistanceFromEdge:kEntryMargin],
                               ]];
        
        UIView *palateView = [[UIView alloc] initWithFrame:CGRectZero];
        [palateView setBackgroundColor:[UIColor colorWithHexString:[PFEntryView palateForView]]];
        [palateView setUserInteractionEnabled:YES];
        [palateView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self contentView] addSubview:palateView];
        [self setPalateView:palateView];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self palateView]
                                                                 toHeight:kImageViewHeight - 1.0f],
                                             
                                             [PFConstraints constrainView:[self palateView]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:[self palateView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:[self palateView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setUserInteractionEnabled:YES];
        [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [[self contentView] addSubview:imageView];
        [self setImageView:imageView];
        
        @weakify(self)
        
        [imageView bk_whenTapped:^{
            
            @strongify(self)
            
            [[self entryDelegate] pushEntryDetail:[self entryId]
                                            index:[self index]];
        }];
        
        [[self contentView] addConstraints:@[[PFConstraints constrainView:[self imageView]
                                                                 toHeight:kImageViewHeight - 1.0f],
                                             
                                             [PFConstraints constrainView:[self imageView]
                                                       toWidthOfSuperView:[self contentView]
                                                              withPadding:0.0f],
                                             
                                             [PFConstraints leftAlignView:[self imageView]
                                                      relativeToSuperView:[self contentView]
                                                     withDistanceFromEdge:0.0f],
                                             
                                             [PFConstraints topAlignView:[self imageView]
                                                     relativeToSuperView:[self contentView]
                                                    withDistanceFromEdge:0.0f],
                                             ]];
        
        UIView *socialView = [[UIView alloc] initWithFrame:
                              CGRectMake(0, kImageViewHeight - 0.5,
                                         [PFSize screenWidth] - (kEntryMargin * 2), 20)];
        
        [socialView setBackgroundColor:[UIColor whiteColor]];
        [socialView setUserInteractionEnabled:YES];
        [[self contentView] addSubview:socialView];
        [self setSocialView:socialView];
        
        [socialView bk_whenTapped:^{
            
            @strongify(self)
            
            [[self entryDelegate] pushEntryDetail:[self entryId]
                                            index:[self index]];
        }];
        
        UIView *avatarBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [avatarBackgroundView setBackgroundColor:[UIColor colorWithHexString:[PFEntryView palateForView]]];
        [avatarBackgroundView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self socialView] addSubview:avatarBackgroundView];
        
        UIImageView *avatarView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [avatarView setBackgroundColor:[UIColor whiteColor]];
        [avatarView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [avatarView setContentMode:UIViewContentModeScaleAspectFill];
        [avatarView setClipsToBounds:YES];
        [avatarView setUserInteractionEnabled:YES];
        [[self socialView] addSubview:avatarView];
        [self setAvatarView:avatarView];
        
        [RACObserve([PFMVVModel shared], avatarUrl) subscribeNext:^(NSString *avatarUrl) {
            
            @strongify(self)
            
            if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[self userId]]) {
                
                PFFilename *filename = [[PFFilename alloc] init];
                [filename setDynamic:avatarUrl];
                
                [[self avatarView] setImageWithUrl:[filename croppedToSize:[PFEntryView preferredAvatarSize]]
                               postProcessingBlock:nil
                                  placeholderImage:nil];
            }
        }];
        
        [avatarView bk_whenTapped:^{
            
            @strongify(self) [[self entryDelegate] pushUserProfile:[self userId]];
        }];
        
        TTTAttributedLabel *titleLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [titleLabel setBackgroundColor:[UIColor whiteColor]];
        [titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [titleLabel setNumberOfLines:0];
        [titleLabel setFont:[PFFont fontOfMediumSize]];
        [titleLabel setTextColor:[PFColor blueColor]];
        [[self socialView] addSubview:titleLabel];
        [self setTitleLabel:titleLabel];
        
        TTTAttributedLabel *byLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [byLabel setBackgroundColor:[UIColor whiteColor]];
        [byLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [byLabel setFont:[PFFont fontOfMediumSize]];
        [byLabel setTextColor:[UIColor lightGrayColor]];
        [byLabel setText:NSLocalizedString(@"by", nil)];
        [[self socialView] addSubview:byLabel];
        
        TTTAttributedLabel *userLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [userLabel setBackgroundColor:[UIColor clearColor]];
        [userLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [userLabel setFont:[PFFont fontOfMediumSize]];
        [userLabel setTextColor:[PFColor darkerGrayColor]];
        [[self socialView] addSubview:userLabel];
        [self setUserLabel:userLabel];
        
        [RACObserve([PFMVVModel shared], fullname) subscribeNext:^(NSString *fullname){
            
            @strongify(self)
            
            if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[self userId]]) {
                
                [[self userLabel] setText:fullname];
            }
        }];
        
        [userLabel bk_whenTapped:^{
            
            @strongify(self) [[self entryDelegate] pushUserProfile:[self userId]];
        }];
        
        UILabel *starLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [starLabel setBackgroundColor:[UIColor whiteColor]];
        
        FAKFontAwesome *starIcon = [FAKFontAwesome heartIconWithSize:12];
        [starIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [starLabel setAttributedText:[starIcon attributedString]];
        
        [starLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self socialView] addSubview:starLabel];
        
        TTTAttributedLabel *starViewLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [starViewLabel setBackgroundColor:[UIColor whiteColor]];
        [starViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [starViewLabel setFont:[PFFont fontOfSmallSize]];
        [starViewLabel setTextColor:[PFColor grayColor]];
        [starViewLabel setTextAlignment:NSTextAlignmentLeft];
        [[self socialView] addSubview:starViewLabel];
        [self setStarViewLabel:starViewLabel];
        
        UILabel *bubbleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [bubbleLabel setBackgroundColor:[UIColor whiteColor]];
        
        FAKFontAwesome *bubbleIcon = [FAKFontAwesome commentsIconWithSize:12];
        [bubbleIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [bubbleLabel setAttributedText:[bubbleIcon attributedString]];
        
        [bubbleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self socialView] addSubview:bubbleLabel];
        
        TTTAttributedLabel *bubbleViewLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [bubbleViewLabel setBackgroundColor:[UIColor whiteColor]];
        [bubbleViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [bubbleViewLabel setFont:[PFFont fontOfSmallSize]];
        [bubbleViewLabel setTextColor:[PFColor grayColor]];
        [bubbleViewLabel setTextAlignment:NSTextAlignmentLeft];
        [[self socialView] addSubview:bubbleViewLabel];
        [self setBubbleViewLabel:bubbleViewLabel];
        
        UILabel *eyeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [eyeLabel setBackgroundColor:[UIColor whiteColor]];
        
        FAKFontAwesome *eyeIcon = [FAKFontAwesome eyeIconWithSize:12];
        [eyeIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [eyeLabel setAttributedText:[eyeIcon attributedString]];
        
        [eyeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[self socialView] addSubview:eyeLabel];
        
        TTTAttributedLabel *eyeViewLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [eyeViewLabel setBackgroundColor:[UIColor whiteColor]];
        [eyeViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [eyeViewLabel setFont:[PFFont fontOfSmallSize]];
        [eyeViewLabel setTextColor:[PFColor grayColor]];
        [eyeViewLabel setTextAlignment:NSTextAlignmentLeft];
        [[self socialView] addSubview:eyeViewLabel];
        [self setEyeViewLabel:eyeViewLabel];
        
        [[self socialView] addConstraints:@[[PFConstraints constrainView:avatarBackgroundView
                                                                toHeight:[PFEntryView preferredAvatarSize].height],
                                            
                                            [PFConstraints constrainView:avatarBackgroundView
                                                                 toWidth:[PFEntryView preferredAvatarSize].width],
                                            
                                            [PFConstraints leftAlignView:avatarBackgroundView
                                                     relativeToSuperView:[self socialView]
                                                    withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints topAlignView:avatarBackgroundView
                                                    relativeToSuperView:[self socialView]
                                                   withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints constrainView:[self avatarView]
                                                                toHeight:[PFEntryView preferredAvatarSize].height],
                                            
                                            [PFConstraints constrainView:[self avatarView]
                                                                 toWidth:[PFEntryView preferredAvatarSize].width],
                                            
                                            [PFConstraints leftAlignView:[self avatarView]
                                                     relativeToSuperView:[self socialView]
                                                    withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints topAlignView:[self avatarView]
                                                    relativeToSuperView:[self socialView]
                                                   withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints constrainView:[self titleLabel]
                                                                 toWidth:[PFSize screenWidth] - 90],
                                            
                                            [PFConstraints leftAlignView:[self titleLabel]
                                                     relativeToSuperView:[self socialView]
                                                    withDistanceFromEdge:60.0f],
                                            
                                            [PFConstraints topAlignView:[self titleLabel]
                                                    relativeToSuperView:[self socialView]
                                                   withDistanceFromEdge:16.0f],
                                            
                                            [PFConstraints constrainView:byLabel
                                                                toHeight:20.0f],
                                            
                                            [PFConstraints constrainView:byLabel
                                                                 toWidth:20.0f],
                                            
                                            [PFConstraints leftAlignView:byLabel
                                                     relativeToSuperView:[self socialView]
                                                    withDistanceFromEdge:60.0f],
                                            
                                            [PFConstraints positionView:byLabel
                                                              belowView:[self titleLabel]
                                                             withMargin:0.0f],
                                            
                                            [PFConstraints constrainView:[self userLabel]
                                                                toHeight:18.0f],
                                            
                                            [PFConstraints positionView:[self userLabel]
                                                          toRightOfView:byLabel
                                                             withMargin:0.0f],
                                            
                                            [PFConstraints positionView:[self userLabel]
                                                              belowView:[self titleLabel]
                                                             withMargin:1.0f],
                                            
                                            [PFConstraints constrainView:starLabel
                                                                toHeight:14.0f],
                                            
                                            [PFConstraints constrainView:starLabel
                                                                 toWidth:14.0f],
                                            
                                            [PFConstraints leftAlignView:starLabel
                                                     relativeToSuperView:[self socialView]
                                                    withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints positionView:starLabel
                                                              belowView:[self userLabel]
                                                             withMargin:10.0f],
                                            
                                            [PFConstraints constrainView:[self starViewLabel]
                                                                toHeight:14.0f],
                                            
                                            [PFConstraints constrainView:[self starViewLabel]
                                                                 toWidth:24.0f],
                                            
                                            [PFConstraints positionView:[self starViewLabel]
                                                          toRightOfView:starLabel
                                                             withMargin:4.0f],
                                            
                                            [PFConstraints positionView:[self starViewLabel]
                                                              belowView:[self userLabel]
                                                             withMargin:10.0f],
                                            
                                            [PFConstraints constrainView:bubbleLabel
                                                                toHeight:14.0f],
                                            
                                            [PFConstraints constrainView:bubbleLabel
                                                                 toWidth:14.0f],
                                            
                                            [PFConstraints positionView:bubbleLabel
                                                          toRightOfView:[self starViewLabel]
                                                             withMargin:0.0f],
                                            
                                            [PFConstraints positionView:bubbleLabel
                                                              belowView:[self userLabel]
                                                             withMargin:10.0f],
                                            
                                            [PFConstraints constrainView:[self bubbleViewLabel]
                                                                toHeight:14.0f],
                                            
                                            [PFConstraints constrainView:[self bubbleViewLabel]
                                                                 toWidth:24.0f],
                                            
                                            [PFConstraints positionView:[self bubbleViewLabel]
                                                          toRightOfView:bubbleLabel
                                                             withMargin:4.0f],
                                            
                                            [PFConstraints positionView:[self bubbleViewLabel]
                                                              belowView:[self userLabel]
                                                             withMargin:10.0f],
                                            
                                            [PFConstraints constrainView:eyeLabel
                                                                toHeight:14.0f],
                                            
                                            [PFConstraints constrainView:eyeLabel
                                                                 toWidth:14.0f],
                                            
                                            [PFConstraints positionView:eyeLabel
                                                          toRightOfView:[self bubbleViewLabel]
                                                             withMargin:0.0f],
                                            
                                            [PFConstraints positionView:eyeLabel
                                                              belowView:[self userLabel]
                                                             withMargin:10.0f],
                                            
                                            [PFConstraints constrainView:[self eyeViewLabel]
                                                                toHeight:14.0f],
                                            
                                            [PFConstraints constrainView:[self eyeViewLabel]
                                                                 toWidth:34.0f],
                                            
                                            [PFConstraints positionView:[self eyeViewLabel]
                                                          toRightOfView:eyeLabel
                                                             withMargin:4.0f],
                                            
                                            [PFConstraints positionView:[self eyeViewLabel]
                                                              belowView:[self userLabel]
                                                             withMargin:10.0f],
                                            ]];
        
        UIView *captionView = [[UIView alloc] initWithFrame:
                               CGRectMake(9, 0, [PFSize screenWidth] - (2 * kEntryMargin) - 2, 0)];
        
        [captionView setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:captionView];
        [self setCaptionView:captionView];
        
        TTTAttributedLabel *captionViewLabel = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [captionViewLabel setBackgroundColor:[UIColor whiteColor]];
        [captionViewLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [captionViewLabel setNumberOfLines:0];
        [captionViewLabel setFont:[PFFont fontOfMediumSize]];
        [captionViewLabel setTextColor:[PFColor grayColor]];
        [[self captionView] addSubview:captionViewLabel];
        [self setCaptionViewLabel:captionViewLabel];
        
        [self addConstraints:@[[PFConstraints constrainView:[self captionViewLabel]
                                         toWidthOfSuperView:[self captionView]
                                                withPadding:kCaptionMargin],
                               
                               [PFConstraints leftAlignView:[self captionViewLabel]
                                        relativeToSuperView:[self captionView]
                                       withDistanceFromEdge:kCaptionMargin],
                               
                               [PFConstraints topAlignView:[self captionViewLabel]
                                       relativeToSuperView:[self captionView]
                                      withDistanceFromEdge:0.0f]
                               ]];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView setSeparatorInset:UIEdgeInsetsZero];
        [tableView setShowsHorizontalScrollIndicator:NO];
        [tableView setShowsVerticalScrollIndicator:NO];
        [tableView registerClass:[PFEntryCommentViewCell class]
          forCellReuseIdentifier:[PFEntryCommentViewCell preferredReuseIdentifier]];
        [tableView setScrollEnabled:NO];
        [tableView setBackgroundColor:[PFColor commentGrayColor]];
        [tableView setSeparatorColor:[UIColor clearColor]];
        [[self contentView] addSubview:tableView];
        [self setTableView:tableView];
        
        UIView *interactionView = [[UIView alloc] initWithFrame:CGRectZero];
        [interactionView setBackgroundColor:[PFColor commentGrayColor]];
        [interactionView setClipsToBounds:YES];
        [[self contentView] addSubview:interactionView];
        [self setInteractionView:interactionView];
        
        UIButton *likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [likeButton setBackgroundImage:[PFImage like]
                              forState:UIControlStateNormal];
        [likeButton setBackgroundImage:[PFImage liked]
                              forState:UIControlStateSelected];
        
        FAKFontAwesome *likeStarIcon = [FAKFontAwesome heartIconWithSize:16];
        [likeStarIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        FAKFontAwesome *selectedIcon = [FAKFontAwesome heartIconWithSize:16];
        [selectedIcon addAttribute:NSForegroundColorAttributeName value:[PFColor blueColor]];
        
        [likeButton setAttributedTitle:[likeStarIcon attributedString]
                              forState:UIControlStateNormal];
        [likeButton setAttributedTitle:[selectedIcon attributedString]
                              forState:UIControlStateSelected];
        [likeButton setAttributedTitle:[selectedIcon attributedString]
                              forState:UIControlStateSelected | UIControlStateHighlighted];
        
        [likeButton bk_addEventHandler:^(id sender) {
            
            @strongify(self) [self likeButtonAction:sender];
        
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self interactionView] addSubview:likeButton];
        [self setLikeButton:likeButton];
        
        [[self interactionView] addConstraints:@[[PFConstraints constrainView:likeButton
                                                                     toHeight:30.0f],
                                                 
                                                 [PFConstraints constrainView:likeButton
                                                                      toWidth:50.0f],
                                                 
                                                 [PFConstraints leftAlignView:likeButton
                                                          relativeToSuperView:[self interactionView]
                                                         withDistanceFromEdge:10.0f],
                                                 
                                                 [PFConstraints topAlignView:likeButton
                                                         relativeToSuperView:[self interactionView]
                                                        withDistanceFromEdge:8.0f]
                                                 ]];
        
        PFCommentField *commentTextField = [[PFCommentField alloc] initWithFrame:CGRectZero];
        [commentTextField setTranslatesAutoresizingMaskIntoConstraints:NO];
        [commentTextField setFont:[PFFont fontOfSmallSize]];
        [commentTextField setTextColor:[PFColor commentGrayColor]];
        [commentTextField setBackgroundColor:[UIColor whiteColor]];
        [commentTextField setBorderStyle:UITextBorderStyleRoundedRect];
        [commentTextField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [commentTextField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [commentTextField setPlaceholder:NSLocalizedString(@"Leave positive feedback...", nil)];
        [commentTextField setUserInteractionEnabled:NO];
        [[self interactionView] addSubview:commentTextField];
        
        [[self interactionView] addConstraints:@[[PFConstraints constrainView:commentTextField
                                                                     toHeight:30.0f],
                                                 
                                                 [PFConstraints constrainView:commentTextField
                                                                      toWidth:[PFSize screenWidth] - 98],
                                                 
                                                 [PFConstraints leftAlignView:commentTextField
                                                          relativeToSuperView:[self interactionView]
                                                         withDistanceFromEdge:68.0f],
                                                 
                                                 [PFConstraints topAlignView:commentTextField
                                                         relativeToSuperView:[self interactionView]
                                                        withDistanceFromEdge:8.0f]
                                                 ]];
        
        UIButton *commentButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [commentButton setBackgroundColor:[UIColor clearColor]];
        [commentButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [commentButton setTag:[self index]];
        
        [commentButton bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [self commentButtonAction:sender];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self interactionView] addSubview:commentButton];
        [self setCommentButton:commentButton];
        
        [[self interactionView] addConstraints:@[[PFConstraints constrainView:[self commentButton]
                                                                     toHeight:30.0f],
                                                 
                                                 [PFConstraints constrainView:[self commentButton]
                                                                      toWidth:230.0f],
                                                 
                                                 [PFConstraints leftAlignView:[self commentButton]
                                                          relativeToSuperView:[self interactionView]
                                                         withDistanceFromEdge:64.0f],
                                                 
                                                 [PFConstraints topAlignView:[self commentButton]
                                                         relativeToSuperView:[self interactionView]
                                                        withDistanceFromEdge:8.0f]
                                                 ]];
        
        UIView *commentView = [[UIView alloc] initWithFrame:CGRectZero];
        [commentView setBackgroundColor:[PFColor lighterGrayColor]];
        [self addSubview:commentView];
        [self setCommentView:commentView];
        
        GCPlaceholderTextView *commentTextView = [[GCPlaceholderTextView alloc]
                                                  initWithFrame:CGRectMake(10, 10, [PFSize screenWidth] - 42, 30)];
        
        [commentTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [commentTextView setFont:[PFFont fontOfSmallSize]];
        [commentTextView setDelegate:self];
        [commentTextView setPlaceholder:NSLocalizedString(@"Add a comment ... ", nil)];
        [commentTextView setPlaceholderColor:[PFColor placeholderTextColor]];
        [commentTextView setTextColor:[PFColor textFieldTextColor]];
        [commentTextView layer].cornerRadius = 4.0f;
        [commentTextView layer].borderColor = [[PFColor separatorColor] CGColor];
        [commentTextView layer].borderWidth = 1.0f;
        [commentTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
        [commentTextView setReturnKeyType:UIReturnKeyGo];
        [self setCommentTextView:commentTextView];
        [[self commentView] addSubview:commentTextView];
        [[self commentView] setHidden:YES];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(commentPosted:)
                                                     name:kCommentPosted
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(entryLiked:)
                                                     name:kEntryLiked
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(entryViewed:)
                                                     name:kEntryViewed
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    
    return self;
}

- (void)layoutSubviews; {
    
    [super layoutSubviews];
    
    CGFloat height = [PFEntryView heightForTitleLabel:[[self titleLabel] text]];
    
    CGRect frame = [self socialView].frame;
    frame.size.height = 64 + height;
    [self socialView].frame = frame;
    CGFloat captionViewBuffer = [PFEntryView heightForCaptionViewBuffer:
                                 [[self captionViewLabel] text]];
    
    height = [PFEntryView heightForCaptionLabel:
              [[self captionViewLabel] text]] + captionViewBuffer;
    
    frame = [self captionView].frame;
    frame.origin.y = CGRectGetMaxY([self socialView].frame) + 6;
    frame.size.height = height;
    [self captionView].frame = frame;
    CGFloat tableViewY = [self captionView].frame.origin.y + height;
    
    frame = [self tableView].frame;
    frame.origin.y = tableViewY + 0.5 - 8;
    frame.size.width = [self contentView].frame.size.width;
    frame.size.height = [[self tableView] sizeThatFits:
                         CGSizeMake(frame.size.width, HUGE_VALF)].height + 2;
    
    [self tableView].frame = frame;
    
    frame = [self interactionView].frame;
    frame.size.width = [self contentView].frame.size.width;
    frame.size.height = 46.0f;
    frame.origin.y = CGRectGetMaxY([self tableView].frame);
    [self interactionView].frame = frame;
    
    frame = [self commentView].frame;
    frame.size.width = [self interactionView].frame.size.width - 4;
    frame.size.height = 46.0f;
    frame.origin.x = [self interactionView].frame.origin.x + 10;
    frame.origin.y = [self interactionView].frame.origin.y + 6;
    [self commentView].frame = frame;
    
    frame = [self contentView].frame;
    frame.size.height = CGRectGetMaxY([self interactionView].frame);
    [self contentView].frame = frame;
    
    frame = [self userLabel].frame;
    frame.size.width = [PFEntryView widthForUserLabel:[self name]] + 2;
    [self userLabel].frame = frame;
    
    [self disableScrollsToTopPropertyOnAllSubviews];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return [[self comments] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFEntryCommentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                               [PFEntryCommentViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFEntryCommentViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:[PFEntryCommentViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell setBackgroundColor:[PFColor commentGrayColor]];
    
    PFComment *comment = [[self comments] objectAtIndex:[indexPath row]];
    
    [cell setEntryDelegate:[self entryDelegate]];
    [cell setProfile:[comment profile]];
    
    [[cell avatarView] setImageWithUrl:[[PFMVVModel shared] generateAvatarUrl:[comment profile]]
                   postProcessingBlock:nil
                      placeholderImage:nil];
    
    PFFilename *avatar = [[PFFilename alloc] init];
    [avatar setDynamic:[[PFMVVModel shared] generateAvatarUrl:[comment profile]]];
    
    [[cell avatarView] setImageWithUrl:[avatar croppedToSize:[PFEntryCommentViewCell preferredAvatarSize]]
                   postProcessingBlock:nil
                      placeholderImage:nil];
    
    @weakify(comment)
    @weakify(cell)
    
    [RACObserve([PFMVVModel shared], avatarUrl) subscribeNext:^(NSString *avatarUrl){
        
        @strongify(comment)
        @strongify(cell)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[[comment profile] userId]]) {
            
            PFFilename *avatar = [[PFFilename alloc] init];
            [avatar setDynamic:avatarUrl];
            
            [[cell avatarView] setImageWithUrl:[avatar croppedToSize:[PFEntryCommentViewCell preferredAvatarSize]]
                           postProcessingBlock:nil
                              placeholderImage:nil];
        }
    }];
    
    NSString *commentString = [NSString stringWithFormat:@"%@ %@",
                               [[PFMVVModel shared] generateName:[comment profile]],
                               [comment comment]];
    
    [cell setFullname:[[PFMVVModel shared] generateName:[comment profile]]];
    [cell setComment:commentString];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFComment *comment = [[self comments] objectAtIndex:[indexPath row]];
    
    [[self entryDelegate] pushComments:[comment entryId]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFComment *comment = [[self comments] objectAtIndex:[indexPath row]];
    
    return [PFEntryView heightForRowAtComment:comment];
}

- (void)setComments:(NSMutableArray *)comments; {
    
    _comments = comments;
    
    [[self tableView] reloadData];
}

- (void)textViewDidChange:(UITextView *)textView; {
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newTextViewSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    CGRect newTextViewFrame = textView.frame;
    CGRect newContentViewFrame = textView.superview.frame;
    CGRect newButtonFrame = [self submitCommentButton].frame;
    
    newTextViewFrame.size = CGSizeMake(fmaxf(newTextViewSize.width, fixedWidth),
                                       newTextViewSize.height);
    
    if([self commentHeight] == 0) {
        [self setCommentHeight:newTextViewFrame.size.height];
    }
    
    if([self commentHeight] < newTextViewFrame.size.height) {
        
        newContentViewFrame.origin.y = newContentViewFrame.origin.y - 14.0f;
        newButtonFrame.origin.y = newButtonFrame.origin.y + 14.0f;
        newContentViewFrame.size.height = newContentViewFrame.size.height + 14.0f;
        
        [self setCommentHeight:newTextViewFrame.size.height];
        [[self entryDelegate] commentTextViewDidGrow];
    }
    
    if([self commentHeight] > newTextViewFrame.size.height) {
        
        newContentViewFrame.origin.y = newContentViewFrame.origin.y + 14.0f;
        newButtonFrame.origin.y = newButtonFrame.origin.y - 14.0f;
        newContentViewFrame.size.height = newContentViewFrame.size.height - 14.0f;
        
        [self setCommentHeight:newTextViewFrame.size.height];
        [[self entryDelegate] commentTextViewDidShrink];
    }
    
    textView.frame = newTextViewFrame;
    textView.superview.frame = newContentViewFrame;
    [self submitCommentButton].frame = newButtonFrame;
}

- (void)resetCommentView; {
    
    CGRect frame = [self commentView].frame;
    frame.size.width = [self interactionView].frame.size.width - 4;
    frame.size.height = 46.0f;
    frame.origin.x = [self interactionView].frame.origin.x + 10;
    frame.origin.y = [self interactionView].frame.origin.y + 6;
    [self commentView].frame = frame;
    
    frame = [self commentTextView].frame;
    frame.origin.y = 10.0f;
    frame.size.height = 30.0f;
    [self commentTextView].frame = frame;
    
    frame = [self submitCommentButton].frame;
    frame.origin.y = 10.0f;
    [self submitCommentButton].frame = frame;
    
    [[self commentTextView] setText:[NSString empty]];
    [self setCommentHeight:0.0f];
    
    [self resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text; {
    
    if([text isEqualToString:@"\n"]) {
        
        [[self entryDelegate] submitCommentButtonAction:[self index]
                                                comment:[[self commentTextView] text]];
        return NO;
    }
    
    NSInteger thisLength = [textView.text length] + [text length] - range.length;
    
    return (thisLength > 1000) ? NO : YES;
}

- (void)prepareForReuse; {
    
    [[self likeButton] setSelected:NO];
    [[self likeButton] setUserInteractionEnabled:YES];
}

- (void)commentPosted:(NSNotification *)notification; {
    
    NSNumber *entryId = [[notification userInfo] objectForKey:@"entryId"];
    
    if([[self entryId] integerValue] == [entryId integerValue]) {
        
        NSNumber *commentCount = [self commentCount];
        int commentCountAsInt = [commentCount intValue];
        commentCount = [NSNumber numberWithInt:commentCountAsInt + 1];
        
        [self setCommentCount:commentCount];
        [[self bubbleViewLabel] setText:[NSString stringWithFormat:@"%@", commentCount]];
        
        [[self entryDelegate] commentAtIndex:[self index]];
        
        [self layoutSubviews];
    }
}

- (void)entryLiked:(NSNotification *)notification; {
    
    NSNumber *entryId = [[notification userInfo] objectForKey:@"entryId"];
    
    if([[self entryId] integerValue] == [entryId integerValue]) {
        
        [[self likeButton] setSelected:YES];
        [[self likeButton] setUserInteractionEnabled:NO];
        
        NSNumber *likeCount = [self likeCount];
        int likeCountAsInt = [likeCount intValue];
        likeCount = [NSNumber numberWithInt:likeCountAsInt + 1];
        
        [self setLikeCount:likeCount];
        [[self starViewLabel] setText:[NSString stringWithFormat:@"%@", likeCount]];
        
        [[self entryDelegate] entryLikedAtIndex:[self index]];
    }
}

- (void)entryViewed:(NSNotification *)notification; {
    
    NSNumber *entryId = [[notification userInfo] objectForKey:@"entryId"];
    
    if([[self entryId] integerValue] == [entryId integerValue]) {
        
        NSNumber *viewCount = [self viewCount];
        int viewCountAsInt = [viewCount intValue];
        viewCount = [NSNumber numberWithInt:viewCountAsInt + 1];
        
        [self setViewCount:viewCount];
        [[self eyeViewLabel] setText:[NSString stringWithFormat:@"%@", viewCount]];
        
        [[self entryDelegate] entryViewedAtIndex:[self index]];
    }
}

- (void)commentButtonAction:(UIButton *)button; {
    
    // pure hack
    
    _PFEntryFeedVC *hack = (_PFEntryFeedVC *)[self entryDelegate];
    
    if([hack isKindOfClass:[PFProfileTypeVC class]]) {
        
        PFProfileTypeVC *type = (PFProfileTypeVC *)hack;
        
        if([[type delegate] isKindOfClass:[PFLandingProfileVC class]]) {
            
            [[PFLandingVC shared] pushJoinVC];
            return;
            
        } else {
            
            [[self commentTextView] becomeFirstResponder];
        }
    
    } else {
        
        if([hack isKindOfClass:[PFLandingProfileVC class]] ||
           [hack isKindOfClass:[PFLandingCategoryFeedVC class]]) {
            
            [[PFLandingVC shared] pushJoinVC];
            
        } else {
         
            [[self commentTextView] becomeFirstResponder];
        }
    }
}

- (void)likeButtonAction:(UIButton *)button; {
    
    [[self entryDelegate] likeButtonAction:[self index]
                                    sender:[self likeButton]];
}

- (void)keyboardWillShow:(NSNotification *)notification; {
    
    if([[self commentTextView] isFirstResponder]) {
    
        NSDictionary* keyboardInfo = [notification userInfo];
        NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
        CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
        
        [[self commentView] setHidden:NO];
        
        CGRect commentButtonRect = [[[self commentButton] superview]
                                    convertRect:[[self commentButton] bounds] toView:nil];
        
        [[self entryDelegate] commentButtonAction:commentButtonRect
                                            index:[self index]
                                    keyboardFrame:keyboardFrameBeginRect
                                       viewHeight:[self commentView].frame.size.height];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification; {
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
