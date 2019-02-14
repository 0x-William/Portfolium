//
//  PFUsersVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFUsersVC.h"
#import "PFRootViewController.h"
#import "PFContentView.h"
#import "PFUsersViewCell.h"
#import "PFUzer.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "PFProfile.h"
#import "PFAvatar.h"
#import "PFProfileVC.h"
#import "UIImageView+PFImageLoader.h"
#import "PFMVVModel.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "UITableView+PFExtensions.h"
#import "PFNavigationController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFAuthenticationProvider.h"
#import "PFGoogleAnalytics.h"
#import "PFSize.h"
#import "UIViewController+PFExtensions.h"
#import "PFNetworkViewItem.h"
#import "UIButton+PFExtensions.h"
#import "PFProfile+PFExtensions.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFErrorHandler.h"

@interface PFUsersVC ()

@property(nonatomic, strong) NSNumber *threadId;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *dataSource;
@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;

@end

@implementation PFUsersVC

@synthesize shimmed = _shimmed;

+ (PFUsersVC *)_new:(NSNumber *)threadId; {
    
    PFUsersVC *vc = [[PFUsersVC alloc] initWithNibName:nil bundle:nil];
    [vc setThreadId:threadId];
    
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
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView registerClass:[PFNetworkViewItem class]
       forCellWithReuseIdentifier:[PFNetworkViewItem preferredReuseIdentifier]];
    [collectionView setAllowsMultipleSelection:YES];
    [collectionView setBackgroundColor:[PFColor lighterGrayColor]];
    [collectionView setAlwaysBounceVertical:YES];
    [view setContentView:collectionView];
    [self setCollectionView:collectionView];
    
    [self setView:view];
    
    UIView *shim = [[UIView alloc] initWithFrame:
                    CGRectMake(0, 0, [PFSize screenWidth], [self applicationFrameOffset])];
    
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setAlpha:0.8];
    [[self view] addSubview:shim];
    [self setShim:shim];
    
    [shim setHidden:YES];
    
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
                                             selector:@selector(userConnected:)
                                                 name:kUserConnected
                                               object:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"People on Thread", nil)];
    [self setUpImageBackButton];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self state] == PFViewControllerLaunching) {
        
        [[[self contentView] spinner] startAnimating];
        
        [[PFApi shared] getUsersForThread:[self threadId]
                                  success:^(NSArray *data) {
                                      
                                      [self setDataSource:data];
                                      [[[self contentView] spinner] stopAnimating];
                                      
                                      [[self collectionView] reloadData];
                                      [self setState:PFViewControllerReady];
                                      
                                  } failure:^NSError *(NSError *error) {
                                      
                                      [[[self contentView] spinner] stopAnimating];
                                      [self setState:PFViewControllerReady];
                                      
                                      return error;
                                      
                                  }];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kMessageThreadUsersPage
                       withIdentifier:[self threadId]];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section; {
    
    return [[self dataSource] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFNetworkViewItem *item = [[self collectionView] dequeueReusableCellWithReuseIdentifier:
                               [PFNetworkViewItem preferredReuseIdentifier] forIndexPath:indexPath];
    
    PFProfile *profile = [[self dataSource] objectAtIndex:[indexPath row]];
    
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
    
    if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[profile userId]]) {
        
        [[item statusButton] setHidden:YES];
        [[item tapButton] setUserInteractionEnabled:NO];
        
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
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedPushAtIndex:(NSInteger)index; {
    
    PFProfile *profile = [[self dataSource] objectAtIndex:index];
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:[profile userId]]
                                               animated:YES
                                                   shim:self];
}

- (void)networkViewItem:(PFNetworkViewItem *)item requestedToggleAtIndex:(NSInteger)index; {
    
    if(![[item tapButton] isSelected]) {
        
        [item pop:^{
            
            @weakify(self);
            
            [[item statusButton] setSelected:YES];
            
            PFProfile *profile = [[self dataSource] objectAtIndex:index];
            
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
    
    for(int i = 0; i < [[self dataSource] count]; i++) {
        
        p = [[self dataSource] objectAtIndex:i];
        
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
