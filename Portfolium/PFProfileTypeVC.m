//
//  PFProfileTypeVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/7/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFProfileTypeVC.h"
#import "PFProfileVC.h"
#import "PFContentView.h"
#import "CSStickyHeaderFlowLayout.h"
#import "PFProfileSectionHeaderView.h"
#import "PFImage.h"
#import "PFProfileHeaderView.h"
#import "PFPagedDatasource.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "PFEntry.h"
#import "UIImageView+PFImageLoader.h"
#import "TTTAttributedLabel.h"
#import "PFNetworkViewItem.h"
#import "PFRootViewController.h"
#import "PFCommentsVC.h"
#import "PFMVVModel.h"
#import "PFColor.h"
#import "NSURL+PFExtensions.h"
#import "PFEntryViewProvider.h"
#import "PFEntryViewItem.h"
#import "UINavigationBar+PFExtensions.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFStatus.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFLandingProfileVC.h"
#import "PFLandingProfileTypeVC.h"
#import "PFErrorHandler.h"
#import "PFDetailVC.h"
#import "PFFooterBufferView.h"
#import "PFAuthenticationProvider.h"
#import "FAKFontAwesome.h"
#import "NSAttributedString+CCLFormat.h"
#import "PFFontAwesome.h"
#import "PFProfile+PFExtensions.h"
#import "UIButton+PFExtensions.h"
#import "PFSize.h"
#import "PFFont.h"

static NSString *kHeaderReuseIdentifier = @"PFProfileTypeVCHeader";
static NSString *kSectionHeaderReuseIdentifier = @"PFProfileTypeVCSectionHeader";
static NSString *kEmptyCellIdentifier = @"EmptyCell";

typedef CGSize (^PFSizeForItemAtIndexPath)(UICollectionView *collectionView,
                                         UICollectionViewLayout *layout,
                                         NSIndexPath *indexPath);
typedef void (^PFViewDidAppear)();
typedef void (^PFSetSelected)(PFProfileSectionHeaderView *section);

typedef UICollectionViewCell* (^PFCellForItemAtIndexPath)(UICollectionView *collectionView,
                                           NSIndexPath *indexPath);
@interface PFProfileTypeVC ()

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) UIImageView *avatarView;
@property(nonatomic, strong) PFSizeForItemAtIndexPath sizeForItemAtIndexPath;
@property(nonatomic, strong) PFCellForItemAtIndexPath cellForItemAtIndexPath;
@property(nonatomic, assign) CGFloat padding;
@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, strong) PFViewDidAppear viewDidAppear;
@property(nonatomic, strong) PFSetSelected setSelected;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, assign) BOOL isEntry;

@end

@implementation PFProfileTypeVC
@synthesize isEntry;

+ (PFProfileTypeVC *)_entries:(PFProfileVC *)delegate
                       userId:(NSNumber *)userId; {
 
    PFProfileTypeVC *vc = [[PFProfileTypeVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setDelegate:delegate];
    [vc setUserId:userId];
    [vc setPadding:0.0f];
    vc.isEntry = YES;
    
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
    
    return vc;
}

+ (PFProfileTypeVC *)_about:(PFProfileVC *)delegate
                     userId:(NSNumber *)userId; {
    
    PFProfileTypeVC *vc = [[PFProfileTypeVC alloc] initWithNibName:nil bundle:nil];
    [vc setDelegate:delegate];
    
    @weakify(vc)
    
    [vc setViewDidAppear:^() {
        
        @strongify(vc)
        
        [[vc sectionHeader] setAboutSelected];
    }];
    
    [vc setSetSelected:^(PFProfileSectionHeaderView *section) {
        
        [section setAboutSelected];
    }];
    
    return vc;
}

+ (PFProfileTypeVC *)_connections:(PFProfileVC *)delegate
                           userId:(NSNumber *)userId; {
    
    PFProfileTypeVC *vc = [[PFProfileTypeVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setDelegate:delegate];
    [vc setUserId:userId];
    [vc setPadding:0.0f];
    vc.isEntry = NO;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:vc
                                             selector:@selector(userConnected:)
                                                 name:kUserConnected
                                               object:nil];
    
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
        
        [item setUserId:[profile userId]];
        [item setDelegate:vc];
        [item setIndex:[indexPath row]];
        
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
    
    [vc setSetSelected:^(PFProfileSectionHeaderView *section) {
        
        [section setConnectionsSelected];
    }];
    
    return vc;
}

+ (PFLandingProfileTypeVC *)_landingEntries:(PFLandingProfileVC *)delegate
                                     userId:(NSNumber *)userId; {
    
    PFLandingProfileTypeVC *vc = [[PFLandingProfileTypeVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setDelegate:delegate];
    [vc setUserId:userId];
    [vc setPadding:0.0f];
    
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
    
    return vc;
}

+ (PFLandingProfileTypeVC *)_landingAbout:(PFLandingProfileVC *)delegate
                                   userId:(NSNumber *)userId; {
    
    PFLandingProfileTypeVC *vc = [[PFLandingProfileTypeVC alloc] initWithNibName:nil bundle:nil];
    [vc setDelegate:delegate];
    
    @weakify(vc)
    
    [vc setViewDidAppear:^() {
        
        @strongify(vc)
        
        [[vc sectionHeader] setAboutSelected];
    }];
    
    [vc setSetSelected:^(PFProfileSectionHeaderView *section) {
        
        [section setAboutSelected];
    }];
    
    return vc;
}

+ (PFLandingProfileTypeVC *)_landingConnections:(PFLandingProfileVC *)delegate
                                         userId:(NSNumber *)userId; {
    
    PFLandingProfileTypeVC *vc = [[PFLandingProfileTypeVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setDelegate:delegate];
    [vc setUserId:userId];
    [vc setPadding:0.0f];
    
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
    
    [vc setSetSelected:^(PFProfileSectionHeaderView *section) {
        
        [section setConnectionsSelected];
    }];
    
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

        if (isEntry) {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, [PFSize screenWidth], 30)];
            label1.font = [PFFont fontOfLargeSize];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.text = [NSString stringWithFormat:@"%@ is currently working", self.headerView.name];
            label1.textColor = [PFColor grayColor];
            [emptyCell addSubview:label1];
            
            UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 55, [PFSize screenWidth], 30)];
            label2.font = [PFFont fontOfLargeSize];
            label2.textAlignment = NSTextAlignmentCenter;
            label2.text = @"on new entries";
            label2.textColor = [PFColor grayColor];
            [emptyCell addSubview:label2];
        }
        else
        {
            UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, [PFSize screenWidth], 30)];
            label1.font = [PFFont fontOfLargeSize];
            label1.textAlignment = NSTextAlignmentCenter;
            label1.text = [NSString stringWithFormat:@"Connect with %@!", self.headerView.name];
            label1.textColor = [PFColor grayColor];
            [emptyCell addSubview:label1];

        }
        
        return emptyCell;
    }
    
    return [self cellForItemAtIndexPath](collectionView, indexPath);
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

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.pageState == PFPagedDataSourceStateEmpty) {
        return CGSizeMake([PFSize screenWidth], [PFSize screenHeight] - [PFFooterBufferView size].height - [PFProfileSectionHeaderView preferredSize].height - 80);
    }
    
    return [self sizeForItemAtIndexPath](collectionView, collectionViewLayout, indexPath);
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

- (void)titleViewDidLoad; {
    
    if([self contentOffsetY] > 250) {
        
        [self setCurrentNavigationBarAlpha:([self contentOffsetY] - 250)/50];
        [[[(id)[self delegate] navigationController] navigationBar] setAlpha:[self currentNavigationBarAlpha]];
        
    } else {
        
        [self setCurrentNavigationBarAlpha:0];
        [[[(id)[self delegate] navigationController] navigationBar] setAlpha:0.01];
    }
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
