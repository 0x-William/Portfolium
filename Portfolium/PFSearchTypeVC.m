//
//  PFSearchTypeVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSearchTypeVC.h"
#import "PFSearchResultsVC.h"
#import "PFContentView.h"
#import "PFNetworkViewItem.h"
#import "PFPagedDataSource.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "PFRootViewController.h"
#import "UIImageView+PFImageLoader.h"
#import "TTTAttributedLabel.h"
#import "PFAvatar.h"
#import "PFProfileVC.h"
#import "PFCommentsVC.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFMVVModel.h"
#import "PFColor.h"
#import "UITextField+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFEntryViewProvider.h"
#import "PFEntryViewItem.h"
#import "PFStatus.h"
#import "PFImage.h"
#import "PFErrorHandler.h"
#import "PFConstraints.h"
#import "PFFont.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFAuthenticationProvider.h"
#import "PFFooterBufferView.h"
#import "PFDetailVC.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"
#import "NSAttributedString+CCLFormat.h"
#import "PFSize.h"
#import "UIViewController+PFExtensions.h"
#import "PFFontAwesome.h"
#import "PFProfile+PFExtensions.h"
#import "UIButton+PFExtensions.h"
#import "PFProfileSectionHeaderView.h"

static NSString *kHeaderIdentifier = @"kHeaderIdentifier";
static NSString *kEmptyCellIdentifier = @"EmptyCell";
static CGFloat kIdentifierWidth = 86.0f;

typedef CGSize (^PFSizeForItemAtIndexPath)(UICollectionView *collectionView,
                                           UICollectionViewLayout *layout,
                                           NSIndexPath *indexPath);

typedef UICollectionViewCell* (^PFCellForItemAtIndexPath)(UICollectionView *collectionView,
                                                          NSIndexPath *indexPath);

@interface PFSearchTypeVC ()

@property(nonatomic, strong) NSString *q;
@property(nonatomic, weak) PFSearchResultsVC *delegate;
@property(nonatomic, assign) CGFloat padding;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, assign) PFPagedDataSourceState pageState;
@property(nonatomic, strong) PFSizeForItemAtIndexPath sizeForItemAtIndexPath;
@property(nonatomic, strong) PFCellForItemAtIndexPath cellForItemAtIndexPath;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, assign) CGFloat selectorOffset;
@property(nonatomic, assign) BOOL isEntry;

@end

@implementation PFSearchTypeVC
@synthesize entriesButton, connectionsButton, pageState, isEntry;

+ (PFSearchTypeVC *)_entries:(PFSearchResultsVC *)delegate q:(NSString *)q; {
    
    PFSearchTypeVC *vc = [[PFSearchTypeVC alloc] initWithNibName:nil bundle:nil];
    
    vc.isEntry = YES;
    [vc setDelegate:delegate];
    [vc setQ:q]; [vc setPadding:0.0f];
    [vc setSelectorOffset:(([PFSize screenWidth] / 2) - kIdentifierWidth) / 2];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] searchEntries:[vc q]
                                                                                          pageNumber:pageNumber
                                                                                             success:^(NSArray *data) {
                                                                                                 [[PFGoogleAnalytics shared] searchedForTerm:q];
                                                                                                 successBlock(data);
                                                                                             } failure:^NSError *(NSError *error) {
                                                                                                 return error;
                                                                                             }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    @weakify(vc)
    
    [vc setSizeForItemAtIndexPath:^(UICollectionView *collectionView,
                                    UICollectionViewLayout *layout,
                                    NSIndexPath *indexPath) {
        
        @strongify(vc)
        
        return [[PFEntryViewProvider shared] sizeForItemAtIndexPathBlock]
        (indexPath, [vc dataSource]);
    }];
    
    [vc setCellForItemAtIndexPath:^(UICollectionView *collectionView,
                                    NSIndexPath *indexPath) {
        
        @strongify(vc)
        
        PFEntryViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                 [PFEntryViewItem preferredReuseIdentifier] forIndexPath:indexPath];
        
        [[PFEntryViewProvider shared] entryForItemAtIndexPathBlock]
        (item, indexPath, [vc dataSource], vc);
        
        return item;
    }];
    
    return vc;
}

+ (PFSearchTypeVC *)_people:(PFSearchResultsVC *)delegate q:(NSString *)q; {
    
    PFSearchTypeVC *vc = [[PFSearchTypeVC alloc] initWithNibName:nil bundle:nil];
    
    vc.isEntry = NO;
    CGFloat offset = ((([PFSize screenWidth] / 2) - kIdentifierWidth) / 2) + ([PFSize screenWidth] / 2);
    
    [vc setDelegate:delegate];
    [vc setQ:q];
    [vc setPadding:0.0f];
    [vc setSelectorOffset:offset];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] searchUsers:[vc q]
                                                                                        pageNumber:pageNumber
                                                                                           success:^(NSArray *data) {
                                                                                               successBlock(data);
                                                                                           } failure:^NSError *(NSError *error) {
                                                                                               return error;
                                                                                           }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    [vc setSizeForItemAtIndexPath:^(UICollectionView *collectionView,
                                    UICollectionViewLayout *layout,
                                    NSIndexPath *indexPath) {
        return [PFNetworkViewItem size];
    }];
    
    @weakify(vc)
    
    [vc setCellForItemAtIndexPath:^(UICollectionView *collectionView,
                                    NSIndexPath *indexPath) {
        
        @strongify(vc)
        
        PFNetworkViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                   [PFNetworkViewItem preferredReuseIdentifier] forIndexPath:indexPath];
        
        PFProfile *profile = [[vc dataSource] itemAtIndex:[indexPath row]];
        
        [item setDelegate:vc];
        [item setIndex:[indexPath row]];
        
        PFFilename *filename = [[PFFilename alloc] init];
        [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:profile]];
        
        [[item imageView] setImageWithUrl:[filename croppedToSize:[PFNetworkViewItem preferredAvatarSize]]
                      postProcessingBlock:nil
                            progressBlock:nil
                         placeholderImage:nil
                                   fadeIn:YES];
        
        [item setName:[[PFMVVModel shared] generateName:profile]];
        [[item usernameLabel] setText:[NSString stringWithFormat:@"@%@",
                                       [[PFMVVModel shared] generateUsername:profile]]];
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[profile userId]]) {
            
            [[item statusButton] setHidden:YES];
            
        } else {
            
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
        }
        
        return item;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(userConnected:)
                                                 name:kUserConnected
                                               object:nil];
    return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setHeaderReferenceSize:CGSizeMake([PFSize screenWidth], [PFProfileSectionHeaderView preferredSize].height)];
    [layout setMinimumInteritemSpacing:[self padding]];
    [layout setMinimumLineSpacing:[self padding]];
    [layout setSectionInset:UIEdgeInsetsMake([self padding],
                                             [self padding],
                                             [self padding],
                                             [self padding])];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFEntryViewItem class]
       forCellWithReuseIdentifier:[PFEntryViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[PFNetworkViewItem class]
       forCellWithReuseIdentifier:[PFNetworkViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[UICollectionViewCell class]
       forCellWithReuseIdentifier:kEmptyCellIdentifier];
    
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kHeaderIdentifier];
    [collectionView registerClass:[PFFooterBufferView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:[PFFooterBufferView preferredReuseIdentifier]];

    [collectionView setAllowsMultipleSelection:NO];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentView:collectionView];
    
    [self setScrollView:collectionView];
    [self setCollectionView:collectionView];
    pageState = PFPagedDataSourceStateLoading;
    
    [self setView:view];
    
    @weakify(self)
    
    [self setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(self)
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderHiding];
        return error;
    }];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self state] == PFViewControllerLaunching) {
        
        [[[self contentView] spinner] startAnimating];
        [[self dataSource] load];
        
        [self setState:PFViewControllerReady];
    }
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self collectionView] setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (pageState == PFPagedDataSourceStateEmpty) {
        return 1;
    }
    return [[self dataSource] numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        UICollectionViewCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:
                                           kEmptyCellIdentifier forIndexPath:indexPath];
        if (emptyCell == nil) {
            emptyCell = [[UICollectionViewCell alloc] init];
        }
        
        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, [PFSize screenWidth], 40)];
        topLabel.font = [PFFont fontOfLargeSize];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.text = @"No results found...";
        topLabel.textColor = [PFColor grayColor];
        [emptyCell addSubview:topLabel];
        
        UILabel *bottomLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyCell.bounds.size.height - 95, [PFSize screenWidth], 30)];
        bottomLabel1.font = [PFFont fontOfLargeSize];
        bottomLabel1.textAlignment = NSTextAlignmentCenter;
        bottomLabel1.textColor = [PFColor grayColor];
        [emptyCell addSubview:bottomLabel1];
        
        UILabel *bottomLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyCell.bounds.size.height - 70, [PFSize screenWidth], 40)];
        bottomLabel2.font = [PFFont fontOfLargeSize];
        bottomLabel2.textAlignment = NSTextAlignmentCenter;
        bottomLabel2.text = [NSString stringWithFormat:@"\"%@\"", [self q] ];
        bottomLabel2.textColor = [PFColor grayColor];
        [emptyCell addSubview:bottomLabel2];

        float x;
        if (isEntry) {
            x = [PFSize screenWidth] / 2;
            bottomLabel1.text = @"Be the first to showcase:";
        }
        else
        {
            x = [PFSize screenWidth] / 10 * 7;
            bottomLabel1.text = @"Invite your friend:";
        }
        
        FAKFontAwesome *downArrow = [FAKFontAwesome arrowDownIconWithSize:15];
        [downArrow addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        UILabel *down = [[UILabel alloc] initWithFrame:CGRectZero];
        down.attributedText = [downArrow attributedString];
        [down sizeToFit];
        down.center = CGPointMake(x, emptyCell.bounds.size.height - 10);
        
        [emptyCell addSubview:down];

        return emptyCell;
    }
    
    return [self cellForItemAtIndexPath]
    (collectionView, indexPath);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        return CGSizeMake([PFSize screenWidth], [PFSize screenHeight] - [PFFooterBufferView size].height - [PFProfileSectionHeaderView preferredSize].height - 80);
    }
    
    return [self sizeForItemAtIndexPath]
    (collectionView, collectionViewLayout, indexPath);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
referenceSizeForFooterInSection:(NSInteger)section; {
    
    return [PFFooterBufferView size];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath; {

    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderIdentifier forIndexPath:indexPath];
        
        if (reusableview==nil) {
            reusableview=[[UICollectionReusableView alloc] initWithFrame:
                          CGRectMake(0, 0, [PFSize screenWidth], [PFProfileSectionHeaderView preferredSize].height)];
        }
        
        [reusableview setBackgroundColor:[UIColor whiteColor]];
        
        entriesButton = [UIButton buttonWithType:UIButtonTypeCustom];
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
        
        [entriesButton setSelected:[self isEntry]];
        [reusableview addSubview:entriesButton];
    
        [entriesButton addTarget:[self delegate]
                          action:@selector(entriesButtonAction:)
                forControlEvents:UIControlEventTouchUpInside];
        
        connectionsButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [connectionsButton setFrame:CGRectMake([PFSize screenWidth] / 2, 0, [PFSize screenWidth] / 2,
                                               [PFProfileSectionHeaderView preferredSize].height)];
        
        [connectionsButton setTitle:@"People" forState:UIControlStateNormal];
        [[connectionsButton titleLabel] setFont:[PFFont systemFontOfMediumSize]];
        [connectionsButton setTitleColor:[PFColor darkGrayColor] forState:UIControlStateNormal];
        [connectionsButton setTitleColor:[PFColor blueColor] forState:UIControlStateHighlighted];
        [connectionsButton setTitleColor:[PFColor blueColor] forState:UIControlStateSelected];
        [connectionsButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_default"] forState:UIControlStateNormal];
        [connectionsButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_active"] forState:UIControlStateSelected];
        [connectionsButton setBackgroundImage:[UIImage imageNamed:@"bg_tab_active"] forState:UIControlStateHighlighted];
        
        [connectionsButton setSelected:![self isEntry]];
        [reusableview addSubview:connectionsButton];
        
        [connectionsButton addTarget:[self delegate]
                              action:@selector(peopleButtonAction:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake([PFSize screenWidth] / 2, 0, 0.5f,
                                                                     [PFProfileSectionHeaderView preferredSize].height)];
        separator.backgroundColor = [PFColor separatorColor];
        [reusableview addSubview:separator];
        
        return reusableview;
        
    } else if([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        
        PFFooterBufferView *buffer = [collectionView dequeueReusableSupplementaryViewOfKind:
                                      UICollectionElementKindSectionFooter withReuseIdentifier:
                                      [PFFooterBufferView preferredReuseIdentifier]
                                                                               forIndexPath:indexPath];
        
        [buffer setBackgroundColor:[PFColor lighterGrayColor]];
        
        return buffer;
    }
    
    return nil;
}

#pragma mark - ADPagedDataSourceDelegate

- (void)pagedDataSource:(PFPagedDataSource *)dataSource didLoadAdditionalItems:(NSInteger)items; {
    
    [[[self contentView] spinner] stopAnimating];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:items];
    NSInteger numberOfItems = [dataSource numberOfItems];
    
    for (int i = (int)numberOfItems - (int)items; i < numberOfItems; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [[self collectionView] insertItemsAtIndexPaths:indexPaths];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource didRefreshItems:(NSInteger)items; {
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    pageState = toState;
    
    if (toState == PFPagedDataSourceStateEmpty) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[self contentView] spinner] stopAnimating];
            
            [[self collectionView] reloadData];
        });
    }
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self delegate] pushUserProfile:userId];
}

- (void)pushComments:(NSNumber *)entryId; {
    
    [[self delegate] pushComments:entryId];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedPushAtIndex:(NSInteger)index; {

    PFProfile *profile = [[[self dataSource] data] objectAtIndex:index];
    
    [[self delegate] pushUserProfile:[profile userId]];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedToggleAtIndex:(NSInteger)index; {
    
    if(![[item tapButton] isSelected]) {
        
        [item pop:^{
            
            @weakify(self);
            
            [[item statusButton] setSelected:YES];
            
            PFProfile *profile = [[[self dataSource] data] objectAtIndex:index];
            
            [[PFApi shared] connect:[profile userId] success:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kUserConnected
                                                                                object:self
                                                                              userInfo:@{ @"profile" : profile }];
                
            } failure:^NSError *(NSError *error) {
                
                @strongify(self);
                
                [[item statusButton] setSelected:NO];
                
                return [self errorBlock](error);
            }];
        }];
        
    } else {
        
        [item pop:^{
        }];
    }
}

- (void)userConnected:(NSNotification *)notification; {
    
    PFProfile *profile = [[notification userInfo] objectForKey:@"profile"];
    PFProfile *p;
    
    for(int i = 0; i < [[[self dataSource] data] count]; i++) {
        
        p = [[[self dataSource] data] objectAtIndex:i];
        
        if([[p userId] integerValue] == [[profile userId] integerValue]
           && [p isKindOfClass:[PFProfile class]]) {
            
            PFNetworkViewItem *item = (PFNetworkViewItem *)[[self collectionView] cellForItemAtIndexPath:
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

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [[(id)[self delegate] navigationController] pushViewController:[PFDetailVC _new:[entry entryId] delegate:self]
                                                          animated:YES];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
