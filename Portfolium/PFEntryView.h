//
//  PFEntityView.h
//  Portfolium
//
//  Created by John Eisberg on 10/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFEntryViewDelegate.h"
#import "TTTAttributedLabel.h"

@interface PFEntryView : UIScrollView<UITableViewDataSource,
                                      UITableViewDelegate,
                                      UITextViewDelegate>

@property(nonatomic, strong) UIImageView *imageView;
@property(nonatomic, strong) UIView *palateView;
@property(nonatomic, strong) UIView *socialView;
@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) TTTAttributedLabel *titleLabel;
@property(nonatomic, strong) TTTAttributedLabel *userLabel;
@property(nonatomic, strong) TTTAttributedLabel *starViewLabel;
@property(nonatomic, strong) TTTAttributedLabel *bubbleViewLabel;
@property(nonatomic, strong) TTTAttributedLabel *eyeViewLabel;
@property(nonatomic, strong) TTTAttributedLabel *captionViewLabel;
@property(nonatomic, strong) NSMutableArray *comments;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, weak) id<PFEntryViewDelegate> entryDelegate;
@property(nonatomic, strong) UIView *commentView;
@property(nonatomic, strong) UITextView *commentTextView;
@property(nonatomic, strong) NSNumber *entryId;
@property(nonatomic, strong) NSNumber *likeCount;
@property(nonatomic, strong) NSNumber *commentCount;
@property(nonatomic, strong) UIButton *likeButton;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSNumber *viewCount;

+ (CGSize)preferredImageSize;

+ (CGSize)preferredImageCrop;

+ (CGSize)preferredAvatarSize;

+ (CGSize)boundingRectWithSize:(CGSize)size
                         title:(NSString *)title
                       caption:(NSString *)caption
                      comments:(NSArray *)comments;

+ (CGFloat)heightForTitleLabel:(NSString *)title;

+ (CGFloat)heightForCaptionViewBuffer:(NSString *)text;

+ (CGFloat)heightForCaptionLabel:(NSString *)text;

+ (CGFloat)widthForUserLabel:(NSString *)userName;

+ (NSString *)palateForView;

- (void)prepareForReuse;
- (void)resetCommentView;

@end
