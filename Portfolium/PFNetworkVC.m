//
//  PFNetworkVC.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFNetworkVC.h"
#import "PFContentView.h"
#import "PFNetworkViewItem.h"
#import "PFPagedDatasource.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "UIImageView+PFImageLoader.h"
#import "PFImage.h"
#import "UIViewController+PFExtensions.h"
#import "PFProfileVC.h"
#import "PFMVVModel.h"
#import "PFStatusBar.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFStatus.h"
#import "NSNotificationCenter+MainThread.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFErrorHandler.h"
#import "UIControl+BlocksKit.h"
#import "PFNavigationController.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"
#import "PFMessagesVC.h"
#import "PFNotificationsVC.h"
#import "NSAttributedString+CCLFormat.h"
#import "PFSize.h"
#import "PFFontAwesome.h"
#import "PFProfile+PFExtensions.h"
#import "UIButton+PFExtensions.h"
#import "PFJeweledButton.h"
#import "PFAppDelegate.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFConstraints.h"
#import "UIView+BlocksKit.h"

static NSString *kHeaderReuseIdentifier = @"PFNetworkVCHeader";
static const CGFloat kHeaderHeight = 128.0f;

@interface PFNetworkVC ()

@property(nonatomic, readwrite) PFViewControllerState state;
@property(nonatomic, strong) PFPagedDataSource *dataSource;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, assign) ABAddressBookRef addressBook;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, strong) UIView *header;
@property(nonatomic, assign) BOOL headerDidLoad;
@property(nonatomic, strong) PFJeweledButton *bellButton;
@property(nonatomic, strong) PFJeweledButton *mailButton;

@end

@implementation PFNetworkVC

@synthesize shimmed = _shimmed;

+ (PFNetworkVC *)_new; {
    
    PFNetworkVC *vc = [[PFNetworkVC alloc] initWithNibName:nil bundle:nil];
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] suggestedUsers:pageNumber
                                                                                              success:^(NSArray *data) {
                                                                                                  successBlock(data);
                                                                                              }
                                                                                              failure:^NSError *(NSError *error) {
                                                                                                  return error;
                                                                                              }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentOffset:0.0f];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setItemSize:[PFNetworkViewItem size]];
    [layout setMinimumInteritemSpacing:0.0f];
    [layout setMinimumLineSpacing:0.0f];
    [layout setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [layout setHeaderReferenceSize:CGSizeMake(0, kHeaderHeight)];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFNetworkViewItem class]
       forCellWithReuseIdentifier:[PFNetworkViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:kHeaderReuseIdentifier];
    [collectionView setAllowsMultipleSelection:YES];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [collectionView setAlwaysBounceVertical:YES];
    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userConnected:)
                                                 name:kUserConnected
                                               object:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], 64)];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [[self view] addSubview:shim];
    [self setShim:shim];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [titleLabel setFont:[PFFont systemFontOfLargeSize]];
    [titleLabel setTextAlignment:NSTextAlignmentCenter];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [titleLabel setText:NSLocalizedString(@"Invite & Connect", nil)];
    [[self navigationItem] setTitleView:titleLabel];
    [self setTitleLabel:titleLabel];
    
    PFJeweledButton *mailButton = [PFJeweledButton _mail:^(id sender) {
        [self mailButtonAction:sender];
    }];
    
    UIBarButtonItem *mailItem = [[UIBarButtonItem alloc] initWithCustomView:mailButton];
    [self setMailButton:mailButton];
    
    UIBarButtonItem *fixedSpaceBarButtonItem = [[UIBarButtonItem alloc]
                                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                target:nil action:nil];
    [fixedSpaceBarButtonItem setWidth:0];
    
    PFJeweledButton *bellButton = [PFJeweledButton _bell:^(id sender) {
        [self bellButtonAction:sender];
    }];
    
    UIBarButtonItem *bellItem = [[UIBarButtonItem alloc] initWithCustomView:bellButton];
    [self setBellButton:bellButton];
    
    self.navigationItem.rightBarButtonItems = @[bellItem, fixedSpaceBarButtonItem,  mailItem];
    
    @weakify(self)
    
    [RACObserve([PFAppDelegate shared], notifications) subscribeNext:^(NSNumber *notifications) {
        
        @strongify(self)
        
        [[self bellButton] setCount:notifications];
    }];
    
    [RACObserve([PFAppDelegate shared], messages) subscribeNext:^(NSNumber *messages) {
        
        @strongify(self)
        
        [[self mailButton] setCount:messages];
    }];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [PFStatusBar statusBarWhite];
    
    if([self state] == PFViewControllerLaunching ||
       [self state] == PFViewControllerEmpty ||
       [[[self dataSource] data] count] == 0) {
        
        [self setState:PFViewControllerLoading];
        [[[self contentView] spinner] startAnimating];
        [[self dataSource] load];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kInvitePage];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    
    return [[self dataSource] numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PFNetworkViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                               [PFNetworkViewItem preferredReuseIdentifier] forIndexPath:indexPath];
    
    PFProfile *profile = [[self dataSource] itemAtIndex:[indexPath row]];
    
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
}

#pragma mark - ADPagedDataSourceDelegate

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didLoadAdditionalItems:(NSInteger)items; {
    
    [[[self contentView] spinner] stopAnimating];
    
    [UIView animateWithDuration:0.2f animations:^{
        [[self header] setAlpha:1];
    }];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:items];
    NSInteger numberOfItems = [dataSource numberOfItems];
    
    for (int i = (int)numberOfItems - (int)items; i < numberOfItems; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [[self collectionView] performBatchUpdates:^{
        [[self collectionView] insertItemsAtIndexPaths:indexPaths];
    } completion:nil];
    
    [self setState:PFViewControllerReady];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    
    if (toState == PFPagedDataSourceStateEmpty) {
        [self setState:PFViewControllerEmpty];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionReusableView *reusableview = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView *reusableview =
        [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                           withReuseIdentifier:kHeaderReuseIdentifier
                                                  forIndexPath:indexPath];
        if (reusableview == nil) {
            
            reusableview = [[UICollectionReusableView alloc] initWithFrame:
                            CGRectMake(0, 0, [PFSize screenWidth], kHeaderHeight)];
        }
        
        [reusableview setBackgroundColor:[UIColor whiteColor]];
        
        UIView *top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], kHeaderHeight - 40)];
        [top setBackgroundColor:[UIColor whiteColor]];
        [reusableview addSubview:top];
        
        UIView *blueBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, kHeaderHeight - 40)];
        [blueBar setBackgroundColor:[PFColor blueColor]];
        [top addSubview:blueBar];
        
        UIView *blueBall = [[UIView alloc] initWithFrame:CGRectMake(16, 10, 62, 62)];
        [blueBall setBackgroundColor:[PFColor blueColor]];
        [top addSubview:blueBall];
        
        UILabel *icon = [[UILabel alloc] initWithFrame:blueBall.frame];
        [icon setTextAlignment:NSTextAlignmentCenter];
        [icon setBackgroundColor:[UIColor clearColor]];
        [top addSubview:icon];
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome paperPlaneIconWithSize:30];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        [icon setAttributedText:[normalIcon attributedString]];
        
        [[blueBall layer] setCornerRadius:31.0f];
        [[blueBall layer] setMasksToBounds:YES];
        
        TTTAttributedLabel *text = [[TTTAttributedLabel alloc] initWithFrame:CGRectZero];
        [text setBackgroundColor:[UIColor whiteColor]];
        [text setTranslatesAutoresizingMaskIntoConstraints:NO];
        [text setNumberOfLines:0];
        [text setLineBreakMode:NSLineBreakByWordWrapping];
        [text setFont:[PFFont fontOfMediumSize]];
        [text setTextColor:[PFColor blueColor]];
        [text setText:NSLocalizedString(@"Tap to send your friends an invitation to join you on Portfolium", nil)];
        [top addSubview:text];
        
        [top addConstraints:@[[PFConstraints constrainView:text
                                                  toHeight:50],
                              
                              [PFConstraints constrainView:text
                                                   toWidth:[PFSize screenWidth] - 120],
                              
                              [PFConstraints leftAlignView:text
                                       relativeToSuperView:top
                                      withDistanceFromEdge:90.0f],
                              
                              [PFConstraints verticallyCenterView:text
                                                      inSuperview:top],
                              ]];
        
        UIView *labelView = [[UIView alloc] initWithFrame:CGRectMake(0, 84, [PFSize screenWidth], 40)];
        [labelView setBackgroundColor:[PFColor lightGrayColor]];
        [reusableview addSubview:labelView];
        
        UILabel *peopleLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 0, 200, 40)];
        [peopleLabel setBackgroundColor:[UIColor clearColor]];
        [peopleLabel setFont:[PFFont fontOfMediumSize]];
        [peopleLabel setTextColor:[PFColor darkerGrayColor]];
        [peopleLabel setText:NSLocalizedString(@"People to connect with", nil)];
        [labelView addSubview:peopleLabel];
        
        [self setHeader:reusableview];
        
        if(![self headerDidLoad]) {
            
            [[self header] setAlpha:0];
            [self setHeaderDidLoad:YES];
        }
        
        @weakify(self)
        
        [top bk_whenTapped:^{
            
            @strongify(self)
            
            [self shareText:NSLocalizedString(@"sms", nil)
                   andImage:nil
                     andUrl:nil];
        }];
        
        return reusableview;
    
    }
    
    return reusableview;
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedPushAtIndex:(NSInteger)index; {
    
    PFProfile *profile = [[[self dataSource] data] objectAtIndex:index];
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:[profile userId]]
                                               animated:YES
                                                   shim:self];
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
        
        if([[p userId] integerValue] == [[profile userId] integerValue]) {
            
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

- (void)launchSms; {
    
    if(![MFMessageComposeViewController canSendText]) {
    } else {
     
        NSString *message = [NSString stringWithFormat:NSLocalizedString(@"sms", nil)];
        
        MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        messageController.messageComposeDelegate = self;
        
        [messageController setBody:message];
        
        [self presentViewController:messageController animated:YES completion:nil];
    }
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result; {
    
    switch (result) {
            
        case MessageComposeResultCancelled:
        case MessageComposeResultFailed:
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)shareText:(NSString *)text andImage:(UIImage *)image andUrl:(NSURL *)url; {
    
    NSMutableArray *sharingItems = [NSMutableArray new];
    
    if(text)    { [sharingItems addObject:text];    }
    if(image)   { [sharingItems addObject:image];   }
    if(url)     { [sharingItems addObject:url];     }
    
    UIActivityViewController *activityController = [[UIActivityViewController alloc]
                                                    initWithActivityItems:sharingItems applicationActivities:nil];
    
    [[PFGoogleAnalytics shared] shareApp];
    
    [self presentViewController:activityController
                       animated:YES
                     completion:nil];
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

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
