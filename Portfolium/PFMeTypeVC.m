//
//  PFMeTypeVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMeTypeVC.h"
#import "PFMeVC.h"
#import "PFPagedDatasource.h"
#import "PFApi.h"
#import "UIImageView+PFImageLoader.h"
#import "TTTAttributedLabel.h"
#import "PFNetworkViewItem.h"
#import "PFContentView.h"
#import "CSStickyHeaderFlowLayout.h"
#import "PFProfileSectionHeaderView.h"
#import "PFProfileHeaderView.h"
#import "PFActivityIndicatorView.h"
#import "PFProfileVC.h"
#import "PFCommentsVC.h"
#import "PFMVVModel.h"
#import "PFColor.h"
#import "PFEntryViewProvider.h"
#import "PFEntryViewItem.h"
#import "PFAuthenticationProvider.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFDetailVC.h"
#import "PFFooterBufferView.h"
#import "PFAboutViewItem.h"
#import "PFFontAwesome.h"
#import "PFImage.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFErrorHandler.h"
#import "PFProfile+PFExtensions.h"
#import "UIButton+PFExtensions.h"
#import "PFFont.h"
#import "PFSize.h"
#import "FAKFontAwesome.h"

static NSString *kHeaderReuseIdentifier = @"PFProfileTypeVCHeader";
static NSString *kSectionHeaderReuseIdentifier = @"PFProfileTypeVCSectionHeader";
static NSString *kEmptyCellIdentifier = @"EmptyCell";

typedef CGSize (^PFSizeForItemAtIndexPath)(UICollectionView *collectionView,
                                           UICollectionViewLayout *layout,
                                           NSIndexPath *indexPath);

typedef UICollectionViewCell* (^PFCellForItemAtIndexPath)(UICollectionView *collectionView,
                                                          NSIndexPath *indexPath);

typedef void (^PFViewDidAppear)();
typedef void (^PFSetSelected)(PFProfileSectionHeaderView *section);

@interface PFMeTypeVC ()

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) PFSizeForItemAtIndexPath sizeForItemAtIndexPath;
@property(nonatomic, strong) PFCellForItemAtIndexPath cellForItemAtIndexPath;
@property(nonatomic, strong) PFViewDidAppear viewDidAppear;
@property(nonatomic, strong) PFSetSelected setSelected;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, assign) BOOL isEntry;
@end

@implementation PFMeTypeVC

@synthesize isEntry;

+ (PFMeTypeVC *)_entries:(PFMeVC *)delegate; {
    
    PFMeTypeVC *vc = [[PFMeTypeVC alloc] initWithNibName:nil bundle:nil];
    
    vc.isEntry = YES;
    [vc setDelegate:delegate];
    [vc setPadding:0.0f];
    [vc setUserId:[[PFAuthenticationProvider shared] userId]];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] userEntriesById:[vc userId] pageNumber:pageNumber
                                                                                               success:^(NSArray *data) {
                                                                                                   successBlock(data);
                                                                                               }
                                                                                               failure:^NSError *(NSError *error) {
                                                                                                   return error;
                                                                                               }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    @weakify(vc)
    
    [vc setViewDidAppear:^() {
        
        @strongify(vc)
        
        [[vc sectionHeader] setEntriesSelected];
    }];
    
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
        (item, indexPath, dataSource, vc);
    
        return item;
    }];
    
    [vc setSetSelected:^(PFProfileSectionHeaderView *section) {
        
        [section setEntriesSelected];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(entryAdded:)
                                                 name:kEntryAdded
                                               object:nil];
    
    return vc;
}

+ (PFMeTypeVC *)_about:(PFMeVC *)delegate; {
    
    PFMeTypeVC *vc = [[PFMeTypeVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setDelegate:delegate];
    [vc setUserId:[[PFAuthenticationProvider shared] userId]];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] about:[vc userId]
                                                                                     success:^(PFAbout *about) {
                                                                                         successBlock(@[about]);
                                                                                     }
                                                                                     failure:^NSError *(NSError *error) {
                                                                                         return error;
                                                                                     }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    @weakify(vc)
    
    [vc setViewDidAppear:^() {
        
        @strongify(vc)
        
        [[vc sectionHeader] setAboutSelected];
    }];
    
    [vc setSizeForItemAtIndexPath:^(UICollectionView *collectionView,
                                    UICollectionViewLayout *layout,
                                    NSIndexPath *indexPath) {
        
        return CGSizeMake(320, 1000);
    }];
    
    [vc setCellForItemAtIndexPath:^(UICollectionView *collectionView,
                                    NSIndexPath *indexPath) {
        
        PFAboutViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                 [PFAboutViewItem preferredReuseIdentifier] forIndexPath:indexPath];
        
        return item;
    }];
    
    [vc setSetSelected:^(PFProfileSectionHeaderView *section) {
        
        [section setAboutSelected];
    }];
    
    return vc;
}

+ (PFMeTypeVC *)_connections:(PFMeVC *)delegate; {
    
    PFMeTypeVC *vc = [[PFMeTypeVC alloc] initWithNibName:nil bundle:nil];
    
    vc.isEntry = NO;
    [vc setDelegate:delegate];
    [vc setPadding:0.0f];
    [vc setUserId:[[PFAuthenticationProvider shared] userId]];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] userConnectionsById:[vc userId]
                                                                                                pageNumber:pageNumber
                                                                                                   success:^(NSArray *data) {
                                                                                                       successBlock(data);
                                                                                                   }
                                                                                                   failure:^NSError *(NSError *error) {
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
    
    [vc setViewDidAppear:^() {
        
        @strongify(vc)
        
        [[vc sectionHeader] setConnectionsSelected];
    }];
    
    [vc setCellForItemAtIndexPath:^(UICollectionView *collectionView,
                                    NSIndexPath *indexPath) {
        
        @strongify(vc)
        
        PFNetworkViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                   [PFNetworkViewItem preferredReuseIdentifier] forIndexPath:indexPath];
        
        PFProfile *profile = [[vc dataSource] itemAtIndex:[indexPath row]];
        
        [item setDelegate:vc];
        [item setIndex:[indexPath row]];
        
        PFFilename *avatar = [[PFFilename alloc] init];
        [avatar setDynamic:[[PFMVVModel shared] generateAvatarUrl:profile]];
        
        [[item imageView] setImageWithUrl:[avatar croppedToSize:[PFProfileHeaderView preferredAvatarSize]]
                      postProcessingBlock:nil
                         placeholderImage:nil];
        
        NSString *username = [[PFMVVModel shared] generateUsername:profile];
        
        [item setName:[[PFMVVModel shared] generateName:profile]];
        [[item usernameLabel] setText:[NSString stringWithFormat:@"@%@", username]];
        
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
        
        return item;
    }];
    
    [vc setSetSelected:^(PFProfileSectionHeaderView *section) {
        
        [section setConnectionsSelected];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(userConnected:)
                                                 name:kUserConnected
                                               object:nil];
    return vc;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nil bundle:nil];
    
    if(self) {
        
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
    
    return self;
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [self viewDidAppear]();
    
    [self titleViewDidLoad];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.pageState == PFPagedDataSourceStateEmpty) {
        UICollectionViewCell *emptyCell = [collectionView dequeueReusableCellWithReuseIdentifier:
                                           kEmptyCellIdentifier forIndexPath:indexPath];
        if (emptyCell == nil) {
            emptyCell = [[UICollectionViewCell alloc] init];
        }
        emptyCell.backgroundColor = [UIColor whiteColor];
        
        UILabel *topLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, [PFSize screenWidth], 30)];
        topLabel1.font = [PFFont fontOfLargeSize];
        topLabel1.textAlignment = NSTextAlignmentCenter;
        topLabel1.textColor = [PFColor grayColor];
        [emptyCell addSubview:topLabel1];
        
        UILabel *topLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, [PFSize screenWidth], 30)];
        topLabel2.font = [PFFont fontOfLargeSize];
        topLabel2.textAlignment = NSTextAlignmentCenter;
        topLabel2.text = @"will show up here";
        topLabel2.textColor = [PFColor grayColor];
        [emptyCell addSubview:topLabel2];

        
        UILabel *bottomLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, emptyCell.bounds.size.height - 65, [PFSize screenWidth], 30)];
        bottomLabel1.font = [PFFont fontOfLargeSize];
        bottomLabel1.textAlignment = NSTextAlignmentCenter;
        bottomLabel1.textColor = [PFColor grayColor];
        [emptyCell addSubview:bottomLabel1];
        
        float x;
        if (isEntry) {
            x = [PFSize screenWidth] / 2;
            topLabel1.text = @"Your portfolio entries";
            bottomLabel1.text = @"Tap the \"plus\" to add your first entry";
        }
        else
        {
            x = [PFSize screenWidth] / 10 * 7;
            topLabel1.text = @"Your connections";
            bottomLabel1.text = @"Tap the \"airplane\" to add connections";
        }
        
        FAKFontAwesome *downArrow = [FAKFontAwesome arrowDownIconWithSize:15];
        [downArrow addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        UILabel *down = [[UILabel alloc] initWithFrame:CGRectZero];
        down.attributedText = [downArrow attributedString];
        [down sizeToFit];
        down.center = CGPointMake(x, emptyCell.bounds.size.height - 15);
        
        [emptyCell addSubview:down];
        
        return emptyCell;
    }

    return [self cellForItemAtIndexPath](collectionView, indexPath);
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.pageState == PFPagedDataSourceStateEmpty) {
        return CGSizeMake([PFSize screenWidth], [PFSize screenHeight] - [PFFooterBufferView size].height - [PFProfileSectionHeaderView preferredSize].height - 100);
    }

    return [self sizeForItemAtIndexPath](collectionView, collectionViewLayout, indexPath);
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
    
    [[self collectionView] reloadData];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        PFProfileSectionHeaderView *view =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kSectionHeaderReuseIdentifier
                                                  forIndexPath:indexPath];
        [view setDelegate:[self delegate]];
        [self setSectionHeader:view];
        
        [self setSelected](view);
        
        return view;
        
    } else if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
        
        UICollectionReusableView *view =
        [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                           withReuseIdentifier:kHeaderReuseIdentifier
                                                  forIndexPath:indexPath];
        [view addSubview:[self headerView]];
        
        return view;
        
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
    
    BOOL found = NO;
    
    for(int i = 0; i < [[[self dataSource] data] count]; i++) {
        
        p = [[[self dataSource] data] objectAtIndex:i];
        
        if([[p userId] integerValue] == [[profile userId] integerValue]
           && [p isKindOfClass:[PFProfile class]]) {
            
            found = YES;
            
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
    
    if(!found) {
        
        [[self dataSource] refresh];
    }
}

- (void)pushEntryDetail:(NSNumber *)entryId index:(NSInteger)index; {
    
    PFEntry *entry = [[[self dataSource] data] objectAtIndex:index];
    
    [[(id)[self delegate] navigationController] pushViewController:[PFDetailVC _new:[entry entryId]
                                                                           delegate:self]
                                                                            animated:YES];
}

- (void)titleViewDidLoad; {
    
    if([self contentOffsetY] > 250) {
        
        [self setCurrentNavigationBarAlpha:([self contentOffsetY] - 250)/50];
        [[[(id)[self delegate] navigationController] navigationBar] setAlpha:[self currentNavigationBarAlpha]];
        
    } else {
        
        [self setCurrentNavigationBarAlpha:0];
        [[[(id)[self delegate] navigationController] navigationBar] setAlpha:0.01];
    }
}

- (void)entryAdded:(NSNotification *)notification; {
    
    if([(PFMeVC *)[self delegate] state] != PFViewControllerLaunching) {
        
        [[self dataSource] refresh];
    }
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
