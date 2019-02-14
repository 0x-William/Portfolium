//
//  PFDetailVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDetailVC.h"
#import "PFContentView.h"
#import "PFDetailsImageViewCell.h"
#import "PFDetailsSocialViewCell.h"
#import "PFProfileVC.h"
#import "PFDetailsUserViewCell.h"
#import "PFApi.h"
#import "PFProfile.h"
#import "TTTAttributedLabel.h"
#import "UIImageView+PFImageLoader.h"
#import "PFDetailsTagViewCell.h"
#import "PFDetailsDescriptionViewCell.h"
#import "PFAvatar.h"
#import "PFMVVModel.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFMedia.h"
#import "PFFilename.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "PFActivityIndicatorView.h"
#import "NSString+PFExtensions.h"
#import "PFDetailsLikersViewCell.h"
#import "UIControl+BlocksKit.h"
#import "UIView+BlocksKit.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFAuthenticationProvider.h"
#import "PFMVVModel.h"
#import "PFNavigationController.h"
#import "PFSize.h"
#import "PFImage.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFErrorHandler.h"
#import "PFCommentsVC.h"
#import "PFTagsVC.h"
#import "PFShim.h"
#import "PFCategoryFeedVC.h"
#import "PFSystemCategory.h"
#import "PFStatus.h"
#import "PFGoogleAnalytics.h"
#import "ATConnect.h"
#import "PFDetailImageViewItem.h"
#import "PFDetailImageFlowLayout.h"
#import "PFImageFlickView.h"
#import "PFEntryView.h"
#import "UIColor+PFEntensions.h"
#import "FAKFontAwesome.h"
#import "PFFontAwesome.h"
#import "PFProfile+PFExtensions.h"
#import "UIButton+PFExtensions.h"
#import "UIView+PFExtensions.h"
#import "PFSize.h"
#import "PFNetworkViewItem.h"
#import "PFFont.h"


static NSString *kApptentiveUploadHandle = @"entry_upload";

static NSInteger kImageCollectionViewTag = 0;
static NSInteger kCollaboratorsCollectionViewTag = 1;

static CGFloat kCollaboratorsHeaderHeight = 30.0f;
static CGFloat kCollaboratorsFooterHeight = 20.0f;

@interface PFDetailVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, weak) UILabel *likersTitleLabel;
@property(nonatomic, weak) NSMutableArray *likersImageViews;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, weak) UILabel *starViewLabel;
@property(nonatomic, strong) UIButton *starButton;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, weak) PFProfile *profile;
@property(nonatomic, assign) BOOL fromUpload;
@property(nonatomic, assign) NSInteger currentIndex;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) PFImageFlickView *flick;
@property(nonatomic, assign) NSInteger imageIndex;
@property(nonatomic, strong) UIView *emptyView;
@property(nonatomic, strong) UIView *footerView;
@property(nonatomic, strong) UICollectionView *collaborators;
@property(nonatomic, strong) UILabel *collaboratorsLabel;


@end

@implementation PFDetailVC

@synthesize shimmed = _shimmed, emptyView;

+ (PFDetailVC *)_new:(NSNumber *)entryId
            delegate:(id<PFEntryViewDelegate>)delegate; {
    
    PFDetailVC *vc = [[PFDetailVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setEntryId:entryId];
    [vc setDelegate:delegate];
    
    [vc setImages:[[NSMutableDictionary alloc] init]];
    
    return vc;
}

+ (PFDetailVC *)_upload:(NSNumber *)entryId
               delegate:(id<PFEntryViewDelegate>)delegate; {
    
    PFDetailVC *vc = [[PFDetailVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setEntryId:entryId];
    [vc setDelegate:delegate];
    [vc setFromUpload:YES];
    
    [vc setImages:[[NSMutableDictionary alloc] init]];
    
    return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFDetailsImageViewCell class]
      forCellReuseIdentifier:[PFDetailsImageViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setAlpha:0];

    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
    
    @weakify(self)
    
    [self setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(self)
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderOpaque];
        return error;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(entryLiked:)
                                                 name:kEntryLiked
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userConnected:)
                                                 name:kUserConnected
                                               object:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButtonForShim];
    [self setShim:[PFShim blackOpaqueFor:self]];
    
    UIButton *starButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [starButton setFrame:CGRectMake(0, 0, 60, 30)];
    [starButton setBackgroundColor:[UIColor clearColor]];
    [starButton addTarget:self
                   action:@selector(likeButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    [self setStarButton:starButton];
    
    
    UIBarButtonItem *starItem = [[UIBarButtonItem alloc] initWithCustomView:starButton];

    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                target:nil action:nil];
    [fixedSpaceBarButtonItem setWidth:0];
    
    UIButton *commentButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [commentButton setFrame:CGRectMake(0, 0, 30, 30)];
    [commentButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *commentIcon = [FAKFontAwesome commentsIconWithSize:14];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *selectedCommentIcon = [FAKFontAwesome commentsIconWithSize:14];
    [selectedCommentIcon addAttribute:NSForegroundColorAttributeName value:[PFColor blueColor]];
    
    [commentButton setAttributedTitle:[commentIcon attributedString]
                          forState:UIControlStateNormal];
    [commentButton setAttributedTitle:[selectedCommentIcon attributedString]
                          forState:UIControlStateSelected];
    [commentButton setAttributedTitle:[selectedCommentIcon attributedString]
                          forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [commentButton addTarget:self
                   action:@selector(commentButtonAction:)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *commentItem = [[UIBarButtonItem alloc] initWithCustomView:commentButton];
    
    UIButton *shareButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [shareButton setFrame:CGRectMake(0, 0, 30, 30)];
    [shareButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *shareIcon = [FAKFontAwesome shareIconWithSize:14];
    [shareIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *selectedShareIcon = [FAKFontAwesome shareIconWithSize:14];
    [selectedShareIcon addAttribute:NSForegroundColorAttributeName value:[PFColor blueColor]];
    
    [shareButton setAttributedTitle:[shareIcon attributedString]
                           forState:UIControlStateNormal];
    [shareButton setAttributedTitle:[selectedShareIcon attributedString]
                           forState:UIControlStateSelected];
    [shareButton setAttributedTitle:[selectedShareIcon attributedString]
                           forState:UIControlStateSelected | UIControlStateHighlighted];
    
    [shareButton addTarget:self
                      action:@selector(shareButtonAction:)
            forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];

    //Private Message Content
    emptyView = [[UIView alloc] initWithFrame:self.view.bounds];
    [[self contentView] addSubview:emptyView];
    [emptyView setHidden:YES];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, [PFSize screenWidth], 30)];
    label1.font = [PFFont fontOfLargeSize];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.text = @"This is a private entry";
    label1.textColor = [PFColor grayColor];
    [emptyView addSubview:label1];
    
    FAKFontAwesome *userIcon = [FAKFontAwesome lockIconWithSize:150];
    [userIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UILabel *user = [[UILabel alloc] initWithFrame:CGRectZero];
    user.attributedText = [userIcon attributedString];
    [user sizeToFit];
    user.center = CGPointMake([PFSize screenWidth] / 2, 230);
    user.textColor = [PFColor lightGrayColor];
    
    [emptyView addSubview:user];
    
    
    @weakify(self)
    
    [[[self contentView] spinner] startAnimating];
    
    [[PFApi shared] entryByEntryId:[self entryId]
                           success:^(PFEntry *entry) {
                               
                               @strongify(self)
                               
                               [self setEntry:entry];
                               
                               dispatch_async(dispatch_get_main_queue(),^ {
                                   
                                   [[[self contentView] spinner] stopAnimating];
                                   
                                   if([[entry liked] integerValue] == 0) {

                                       [[self starButton] toLikeStateWithCount:
                                        [NSString stringWithFormat:@"%@", [entry likes]]];
                                   }
                                   else {
                                       
                                       [[self starButton] toLikedStateWithCount:
                                        [NSString stringWithFormat:@"%@", [entry likes]]];
                                   }
                                   
                                   [[self tableView] reloadData];
                                   [[self collectionView] reloadData];
                                   
                                   if([[entry media] count] > 1) {
                                       
                                       NSInteger count = [[entry media] count];
                                       PFImageFlickView *flick = [PFImageFlickView _new:count];
                                       
                                       [[self headerView] addSubview:flick];
                                       [self setFlick:flick];
                                   }
                                   
                                   [UIView animateWithDuration:0.3 animations:^{
                                       [[self tableView] setAlpha:1];
                                   }];
                                   
                                   [[self delegate] entryViewed:[self entryId]];
                                   
                                   [self buildCollaborators];
                                   self.navigationItem.rightBarButtonItems = @[shareItem,
                                                                               fixedSpaceBarButtonItem,
                                                                               commentItem,
                                                                               fixedSpaceBarButtonItem,
                                                                               starItem];


                               });
                               
                           } failure:^NSError *(NSError *error, NSInteger code) {
                               
                               [[[self contentView] spinner] stopAnimating];
                        
                               if (code != 403) {
                        
                                   self.navigationItem.rightBarButtonItems = @[shareItem,
                                                                               fixedSpaceBarButtonItem,
                                                                               commentItem,
                                                                               fixedSpaceBarButtonItem,
                                                                               starItem];
                                   
                               }
                               else {
                                   [emptyView setHidden:NO];
                               }
                               
                               return error;
                           }];
    
    if([self fromUpload]) {
        
        [[ATConnect sharedConnection] engage:kApptentiveUploadHandle
                          fromViewController:self];
    }
    
    UIView *headerView = [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0, [PFSize screenWidth],
                                     [PFSize preferredDetailSize].height)];
    
    [headerView setUserInteractionEnabled:YES];
    
    UIView *border = [[UIView alloc] initWithFrame:
                      CGRectMake(0, 203, [PFSize screenWidth], 0.5f)];
    [border setBackgroundColor:[PFColor separatorColor]];
    [headerView addSubview:border];
    
    PFDetailImageFlowLayout *layout = [[PFDetailImageFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    [layout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:
                                        CGRectMake(0, 0, [PFSize screenWidth],
                                                   [PFSize preferredDetailSize].height)
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setAllowsMultipleSelection:NO];
    [collectionView registerClass:[PFDetailImageViewItem class]
       forCellWithReuseIdentifier:[PFDetailImageViewItem preferredReuseIdentifier]];
    [collectionView setBackgroundColor:[UIColor colorWithHexString:[PFEntryView palateForView]]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setTag:kImageCollectionViewTag];
    [self setCollectionView:collectionView];
    [headerView addSubview:collectionView];
    
    collectionView.scrollsToTop = NO;
    self.tableView.scrollsToTop = YES;

    [self tableView].tableHeaderView = headerView;
    [self setHeaderView:headerView];
}


- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[[self navigationController] navigationBar] setAlpha:1.0f];
    
    [[self shim] setHidden:YES];
    
    [[PFGoogleAnalytics shared] track:kDetailPage
                       withIdentifier:[self entryId]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    if (section == 0) {
        return 2;
    }
    
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return nil;
    }
    
    PFDetailsUserViewCell *cell = [PFDetailsUserViewCell build:tableView];

    PFProfile *profile = [[self entry] profile];
    
    @weakify(self)
    @weakify(cell)
    
    [RACObserve([PFMVVModel shared], avatarUrl) subscribeNext:^(NSString *avatarUrl) {
        
        @strongify(self)
        @strongify(cell)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[[self entry] userId]]) {
            
            PFFilename *filename = [[PFFilename alloc] init];
            [filename setDynamic:avatarUrl];
            
            [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFDetailsUserViewCell preferredAvatarSize]]
                           postProcessingBlock:nil
                                 progressBlock:nil
                              placeholderImage:nil
                                        fadeIn:YES];
        }
    }];
    
    PFFilename *filename = [[PFFilename alloc] init];
    [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:profile]];
    
    [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFDetailsUserViewCell preferredAvatarSize]]
                   postProcessingBlock:nil
                         progressBlock:nil
                      placeholderImage:nil
                                fadeIn:YES];
    
    [RACObserve([PFMVVModel shared], fullname) subscribeNext:^(NSString *fullname){
        
        @strongify(self)
        @strongify(cell)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[[self entry] userId]]) {
            
            [[cell usernameLabel] setText:[[PFMVVModel shared] generateName:profile]];
        }
    }];
    
    [[cell usernameLabel] setText:[[PFMVVModel shared] generateName:profile]];
    
    if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[profile userId]]) {
        
        [[cell statusButton] setHidden:YES];
        
    } else {
        
        if([profile isConnected]) {
            
            [[cell statusButton] toConnectedState];
            
        } else {
            
            if([profile isPending]) {
                
                [[cell statusButton] toPendingState];
                
            } else if([profile isAwaitingAccept]) {
                
                [[cell statusButton] toAcceptState];
                
            } else {
                
                [[cell statusButton] toConnectState];
            }
        }
        
        @weakify(self);
        
        [[cell statusButton] bk_addEventHandler:^(id sender) {
            
            [[cell statusButton] setSelected:YES];
            
            NSDictionary *userInfo = @{ @"profile" : [self profile] };
            
            [[PFApi shared] connect:[[self profile] userId] success:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kUserConnected
                                                                                object:self
                                                                              userInfo:userInfo];
            } failure:^NSError *(NSError *error) {
                
                @strongify(self);
                
                [[cell statusButton] setSelected:NO];
                
                return [self errorBlock](error);
            }];
            
        } forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setProfile:profile];
    [self setStatusButton:[cell statusButton]];
    [cell setDelegate:self];
    [cell setUserId:[[self entry] userId]];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return [PFDetailsUserViewCell getHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            
            case 0:
            {
                PFDetailsSocialViewCell *cell = [PFDetailsSocialViewCell build:tableView];
                
                [[cell titleLabel] setText:[[self entry] title]];
                [[cell categoryLabel] setUserInteractionEnabled:NO];
                
                [[cell starViewLabel] setText:[NSString stringWithFormat:@"%@", [[self entry] likes]]];
                
                [[cell bubbleViewLabel] setText:[NSString stringWithFormat:@"%lu", (unsigned long)
                                                 [[[self entry] comments] count]]];
                
                [[cell eyeViewLabel] setText:[NSString stringWithFormat:@"%@", [[self entry] views]]];
                
                [self setStarViewLabel:[cell starViewLabel]];
                [self setLikeCount:[[self entry] likes]];
                
                @weakify(self)
                @weakify(cell)
                
                if([[self entry] categoryId] != nil) {
                    
                    [[PFApi shared] categoryById:[[self entry] categoryId]
                                         success:^(PFSystemCategory *category) {
                                             
                                             @strongify(self)
                                             @strongify(cell)
                                             
                                             [self setCategory:category];
                                             
                                             [[cell categoryLabel] setText:[category name]];
                                             [[cell categoryLabel] setUserInteractionEnabled:YES];
                                             
                                             [[cell categoryLabel] bk_whenTapped:^{
                                                 
                                                 [[self rootNavigationController]
                                                  pushViewController:[PFCategoryFeedVC _category:category]
                                                  animated:YES
                                                  shim:self];
                                             }];
                                             
                                         } failure:^NSError *(NSError *error) {
                                             
                                             return error;
                                         }];
                }
                
                return cell;
            }
            
            case 1:
            {
                PFDetailsTagViewCell *cell = [PFDetailsTagViewCell build:tableView];
                
                [[cell tagsLabel] setDelegate:self];
                [cell setTags:[[self entry] tags]];
                
                return cell;
            }
                
            default:
                return nil;
        }
    }
    
    switch ([indexPath row]) {
        
        case 0: {
            
            PFDetailsDescriptionViewCell *cell = [PFDetailsDescriptionViewCell build:tableView];
            
            [cell setCaption:[[self entry] caption]];
            
            return cell;
        }
            
        case 1: {
            
            PFDetailsLikersViewCell *cell = [PFDetailsLikersViewCell build:tableView];
            
            [[cell titleLabel] setText:NSLocalizedString(@"Likers", nil)];
            [self setLikersTitleLabel:[cell titleLabel]];
            [self setLikersImageViews:[cell likersImageViews]];
            
            return cell;
        }
        
        default: {
            break;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (indexPath.section == 0) {
        
        switch ([indexPath row]) {
            case 0:
                return [PFDetailsSocialViewCell getHeight:[[self entry] title]];
            case 1:
                if([[[self entry] tags] count] == 0) {
                    
                    return 0;
                    
                } else {
                    
                    return [PFDetailsTagViewCell heightForRowAtTags:[[self entry] tags]];
                }
            default:
                return 0;
        }
    }
    
    switch ([indexPath row]) {
        
        case 0: {
            
            if([NSString isNullOrEmpty:[[self entry] caption]]) {
                
                return 0;
                
            } else {
                
                return [PFDetailsDescriptionViewCell heightForRowAtCaption:[[self entry] caption]];
            }
        }
            
        case 1: {
            
            if([[[self entry] likers] count] == 0) {
                
                return 0;
                
            } else {
                
                return [PFDetailsLikersViewCell getHeight];
            }
        }
            
        default: {
            break;
        }
    }
    
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([[[self entry] likers] count] == 0) {
        
        [[self likersTitleLabel] setHidden:YES];
        
        for(int i = 0; i < 7; i++) {
            
            UIImageView *imageView = [[self likersImageViews] objectAtIndex:i];
            
            [imageView setHidden:YES];
        }
        
    } else {
        
        for(int i = 0; i < 7; i++) {
            
            UIImageView *imageView = [[self likersImageViews] objectAtIndex:i];
            
            [imageView setHidden:NO];
            [[self likersTitleLabel] setHidden:NO];
            
            if(i < [[[self entry] likers] count]) {
                
                PFProfile *profile = [[[self entry] likers] objectAtIndex:i];
                
                PFFilename *filename = [[PFFilename alloc] init];
                [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:profile]];
                
                [imageView setImageWithUrl:[filename croppedToSize:[PFDetailsLikersViewCell preferredAvatarSize]]
                       postProcessingBlock:nil
                             progressBlock:nil
                          placeholderImage:nil
                                    fadeIn:YES];
                
                NSArray *gestures = imageView.gestureRecognizers;
                for(UIGestureRecognizer *gesture in gestures) {
                    if([gesture isKindOfClass: [UITapGestureRecognizer class]]) {
                        [imageView removeGestureRecognizer:gesture];
                    }
                }
                
                @weakify(self)

                [imageView bk_whenTapped:^{
                    
                    @strongify(self)
                    
                    [self pushUserProfile:[profile userId]];
                }];
                
            } else {
                
                [imageView setHidden:YES];
            }
        }
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if([collectionView tag] == kImageCollectionViewTag) {
        
        return [[[self entry] media] count];
        
    } else {
        
        return [[[self entry] collaborators] count];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView tag] == kImageCollectionViewTag) {
    
        PFDetailImageViewItem *item = (PFDetailImageViewItem *)
        [collectionView dequeueReusableCellWithReuseIdentifier:[PFDetailImageViewItem preferredReuseIdentifier]
                                                  forIndexPath:indexPath];
        
        [[item palateView] setBackgroundColor:[UIColor colorWithHexString:
                                               [PFEntryView palateForView]]];
        
        PFMedia *media = [[[self entry] media] objectAtIndex:[indexPath row]];
        [[item mediaView] setAlpha:0.0f];
        
        [[item mediaView] setImageWithUrl:[[media filename] url]
                      postProcessingBlock:nil
                            progressBlock:nil
                         placeholderImage:nil
                                      tag:[indexPath row]
                                 callback:^(UIImage *image, NSInteger tag) {
                                     [UIView animateWithDuration:0.2 animations:^{
                                         
                                         [[item mediaView] setAlpha:1.0f];
                                         
                                         NSNumber *tagNumber = [NSNumber numberWithInt:(int)tag];
                                         [[self images] setObject:image forKey:tagNumber];
                                     }];
                                   }];
        return item;
    
    } else {
        
        PFNetworkViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                   [PFNetworkViewItem preferredReuseIdentifier] forIndexPath:indexPath];
        
        PFProfile *profile = [[[self entry] collaborators] objectAtIndex:[indexPath row]];
        
        [item setDelegate:self];
        [item setIndex:[indexPath row]];
        
        [[item imageView] setImageWithUrl:[[PFMVVModel shared] generateAvatarUrl:profile]
                      postProcessingBlock:[PFImageLoader centerAndCropToSize:CGSizeMake(45, 45)]
                            progressBlock:nil
                         placeholderImage:nil
                                   fadeIn:YES];
        
        PFFilename *filename = [[PFFilename alloc] init];
        [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:profile]];
        
        [[item imageView] setImageWithUrl:[filename croppedToSize:[PFNetworkViewItem preferredAvatarSize]]
                      postProcessingBlock:nil
                            progressBlock:nil
                         placeholderImage:nil
                                   fadeIn:YES];
        
        NSString *username = [[PFMVVModel shared] generateUsername:profile];
        
        [item setName:[[PFMVVModel shared] generateName:profile]];
        [[item usernameLabel] setText:[NSString stringWithFormat:@"@%@", username]];
        
        if(![[PFAuthenticationProvider shared] userIdIsLoggedInUser:[profile userId]]) {
        
            if([profile isConnected]) {
                
                [[item statusButton] toConnectedState];
                [[item tapButton] setUserInteractionEnabled:NO];
                
            } else {
                
                if([profile isPending]) {
                    
                    [[item statusButton] toPendingState];
                    [[item tapButton] setUserInteractionEnabled:NO];
                    
                } else if([profile isAwaitingAccept]) {
                    
                    [[item statusButton] toAcceptState];
                    [[item tapButton] setUserInteractionEnabled:YES];
                    
                } else {
                    
                    [[item statusButton] toConnectState];
                }
            }
        
        } else {
           
            [[item statusButton] setHidden:YES];
            [[item tapButton] setUserInteractionEnabled:NO];
        }
        
        return item;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([collectionView tag] == kImageCollectionViewTag) {
        
        return CGSizeMake([PFSize screenWidth], [PFSize preferredDetailSize].height);
        
    } else {
        
        return [PFNetworkViewItem size];
    }
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self shim] setHidden:NO];
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url; {
    
    PFTagsVC *vc = [PFTagsVC _new:[NSString stringWithFormat:@"%@", url]];
    
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)commentButtonAction:(UIButton *)button; {
    
    PFCommentsVC *vc = [PFCommentsVC _new:[[self entry] entryId]];
    
    [[self navigationController] pushViewController:vc animated:YES];
}

- (void)shareButtonAction:(UIButton *)button; {
    
    NSString *url = [PFEntry endPointForWebEntry:[self entryId]];
    
    [self shareText:[[self entry] title]
           andImage:[[self images] objectForKey:[NSNumber numberWithInt:(int)[self imageIndex]]]
             andUrl:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:
                                          NSUTF8StringEncoding]]
    ];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url; {
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if(text)    { [sharingItems addObject:text];    }
    if(image)   { [sharingItems addObject:image];   }
    if(url)     { [sharingItems addObject:url];     }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                    initWithActivityItems:sharingItems applicationActivities:nil];
    
    [[PFGoogleAnalytics shared] shareEntry];
    
    [self presentViewController:activityController
                       animated:YES
                     completion:nil];
}

- (void)likeButtonAction:(NSInteger)index; {
    
    [[self starButton] toLikedStateWithCount:[NSString stringWithFormat:@"%@", [self likeCount]]];
    
    [[PFApi shared] postLike:[[self entry] entryId]
                     success:^(PFComment *comment) {
                         
                         NSDictionary *userInfo = @{ @"entryId" : [[self entry] entryId] };
                         
                         [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kEntryLiked
                                                                                         object:self
                                                                                       userInfo:userInfo];
                         [[PFGoogleAnalytics shared] likedEntryFromDetail];
                     
                     } failure:^NSError *(NSError *error) {
                         
                         [[PFErrorHandler shared] showInErrorBar:error
                                                        delegate:nil
                                                          inView:[self view]
                                                          header:PFHeaderShowing];
                         return error;
                     }];
}

- (void)entryLiked:(NSNotification *)notification; {
    
    NSNumber *entryId = [[notification userInfo] objectForKey:@"entryId"];
    
    if([[self entryId] integerValue] == [entryId integerValue]) {
        
        NSNumber *likeCount = [self likeCount];
        int likeCountAsInt = [likeCount intValue];
        likeCount = [NSNumber numberWithInt:likeCountAsInt + 1];
        
        [self setLikeCount:likeCount];
        [[self starButton] toLikedStateWithCount:[NSString stringWithFormat:@"%@", likeCount]];
        
        [[[self entry] likers] insertObject:[[PFAuthenticationProvider shared] providerToProfile]
                                    atIndex:0];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:1 inSection:0];
        
        [[self tableView] beginUpdates];
        
        [[self tableView] reloadRowsAtIndexPaths:@[indexPath]
                                withRowAnimation:UITableViewRowAnimationNone];
        
        [[self tableView] endUpdates];
    }
}

- (void)userConnected:(NSNotification *)notification; {
    
    PFProfile *profile = [[notification userInfo] objectForKey:@"profile"];
    
    if([[[self entry] userId] integerValue] == [[profile userId] integerValue]) {
        
        if([[profile status] token] == nil) {
            
            [[self statusButton] toPendingState];
            
            PFStatus *status = [[PFStatus alloc] init];
            [status setStatus:kPending];
            [profile setStatus:status];
            
        } else {
            
            [[PFApi shared] accept:[[profile status] token]
                           success:^(PFUzer *user) {
                               
                               [[self statusButton] toConnectedState];
                               
                               PFStatus *status = [[PFStatus alloc] init];
                               [status setStatus:kConnected];
                               
                               [profile setStatus:status];
                               [profile setConnected:@1];
                               
                           } failure:^NSError *(NSError *error) {
                               
                               [[self statusButton] setUserInteractionEnabled:YES];
                               
                               return [self errorBlock](error);
                           }];
        }
    }
    
    PFProfile *p;
    
    for(int i = 0; i < [[[self entry] collaborators] count]; i++) {
        
        p = [[[self entry] collaborators] objectAtIndex:i];
        
        if([[p userId] integerValue] == [[profile userId] integerValue]) {
            
            PFNetworkViewItem *item = (PFNetworkViewItem *)[[self collaborators] cellForItemAtIndexPath:
                                                            [NSIndexPath indexPathForItem:i inSection:0]];
            if([[profile status] token] == nil) {
                
                [[item statusButton] toPendingState];
                
                PFStatus *status = [[PFStatus alloc] init];
                [status setStatus:kPending];
                [profile setStatus:status];
                
            } else {
                
                [[item tapButton] setUserInteractionEnabled:NO];
                
                [[PFApi shared] accept:[[profile status] token]
                               success:^(PFUzer *user) {
                                   
                                   [[item statusButton] toConnectedState];
                                   
                                   PFStatus *status = [[PFStatus alloc] init];
                                   [status setStatus:kConnected];
                                   
                                   [p setStatus:status];
                                   [p setConnected:@1];
                                   
                               } failure:^NSError *(NSError *error) {
                                   
                                   [[item tapButton] setUserInteractionEnabled:YES];
                                   
                                   return [self errorBlock](error);
                               }];
            }
            
            break;
        }
    }
}

- (void)showShim; {
    
    [[self shim] setHidden:NO];
}

- (void)hideShim; {
    
    [[self shim] setHidden:YES];
}

- (BOOL)shimmed; {
    
    return _shimmed;
}

- (void)setShimmed:(BOOL)shimmed; {
    
    _shimmed = shimmed;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView; {

    if([self flick] != nil && scrollView.contentOffset.x > 0) {
        
        [[self flick] setSelectedAtIndex:
            (scrollView.contentOffset.x / [PFSize screenWidth])];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if(scrollView.contentOffset.x > 0) {
    
        for (UICollectionViewCell *cell in [[self collectionView] visibleCells]) {
            
            NSIndexPath *indexPath = [[self collectionView] indexPathForCell:cell];
            
            [self setImageIndex:[indexPath row]];
        }
    }
}

- (void)buildCollaborators; {
    
    CGFloat height = [[[self entry] collaborators] count] * [PFNetworkViewItem size].height;
    
    UIView *footerView = [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0, [PFSize screenWidth],
                                     height + kCollaboratorsHeaderHeight + kCollaboratorsFooterHeight)];
    
    [footerView setBackgroundColor:[UIColor whiteColor]];
    [self setFooterView:footerView];
    
    [self tableView].tableFooterView = footerView;
    
    UILabel *collaboratorsLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
    [collaboratorsLabel setBackgroundColor:[UIColor whiteColor]];
    [collaboratorsLabel setNumberOfLines:1];
    [collaboratorsLabel setFont:[PFFont fontOfMediumSize]];
    [collaboratorsLabel setText:NSLocalizedString(@"Collaborators", nil)];
    [footerView addSubview:collaboratorsLabel];
    [self setCollaboratorsLabel:collaboratorsLabel];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:[PFNetworkViewItem size]];
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    [layout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    
    UICollectionView *collaborators = [[UICollectionView alloc] initWithFrame:
                                       CGRectMake(0, kCollaboratorsHeaderHeight, [PFSize screenWidth],
                                                  [[[self entry] collaborators] count] *
                                                  [PFNetworkViewItem size].height)
                                                          collectionViewLayout:layout];
    [collaborators setDelegate:self];
    [collaborators setDataSource:self];
    [collaborators registerClass:[PFNetworkViewItem class]
       forCellWithReuseIdentifier:[PFNetworkViewItem preferredReuseIdentifier]];
    [collaborators setAllowsMultipleSelection:YES];
    [collaborators setBackgroundColor:[UIColor whiteColor]];
    [collaborators setAlwaysBounceVertical:YES];
    [collaborators setTag:kCollaboratorsCollectionViewTag];
    [self setCollaborators:collaborators];
    
    [footerView addSubview:collaborators];
    
    if([[[self entry] collaborators] count] == 0) {
        [[self collaboratorsLabel] setHidden:YES];
    }
    
    [footerView disableScrollsToTopPropertyOnAllSubviews];
    
    [collaborators reloadData];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedPushAtIndex:(NSInteger)index; {
    
    PFProfile *profile = [[[self entry] collaborators] objectAtIndex:index];
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:[profile userId]]
                                               animated:YES
                                                   shim:self];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedToggleAtIndex:(NSInteger)index; {
    
    if(![[item tapButton] isSelected]) {
        
        [item pop:^{
            
            @weakify(self);
            
            [[item statusButton] setSelected:YES];
            
            PFProfile *profile = [[[self entry] collaborators] objectAtIndex:index];
            
            [[PFApi shared] connect:[profile userId] success:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kUserConnected
                                                                                object:self
                                                                              userInfo:@{ @"profile" : profile }];
                
            } failure:^NSError *(NSError *error) {
                
                @strongify(self);
                
                return [self errorBlock](error);
            }];
        }];
        
    } else {
        
        [item pop:^{
        }];
    }
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
