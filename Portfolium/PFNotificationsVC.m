//
//  PFNotificationsVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFNotificationsVC.h"
#import "PFContentView.h"
#import "PFPagedDatasource.h"
#import "PFNotificationsViewCell.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "PFProfileVC.h"
#import "PFNotification.h"
#import "PFMVVModel.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "UIImageView+PFImageLoader.h"
#import "PFAvatar.h"
#import "PFImage.h"
#import "PFColor.h"
#import "PFFont.h"
#import "PFNavigationController.h"
#import "PFHomeVC.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFAuthenticationProvider.h"
#import "PFMVVModel.h"
#import "PFSize.h"
#import "PFShim.h"
#import "PFGoogleAnalytics.h"
#import "PFAppDelegate.h"
#import "PFRootViewController.h"
#import "PFDetailVC.h"
#import "PFHomeFeedVC.h"
#import "FAKFontAwesome.h"
#import "PFCommentsVC.h"
#import "UITableView+PFExtensions.h"

static NSString *kEmptyCellIdentifier = @"EmptyCell";

@interface PFNotificationsVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PFPagedDataSource *dataSource;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, readwrite) PFViewControllerState state;
@property(nonatomic, assign) PFPagedDataSourceState pageState;

@end

@implementation PFNotificationsVC

@synthesize shimmed = _shimmed, pageState;

+ (PFNotificationsVC *)_new; {
    
    PFNotificationsVC *vc = [[PFNotificationsVC alloc] initWithNibName:nil bundle:nil];
    
    vc.pageState = PFPagedDataSourceStateLoading;
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] notifications:pageNumber
                                                                                             success:^(NSArray *data) {
                                                                                                 successBlock(data);
                                                                                             } failure:^NSError *(NSError *error) {
                                                                                                 return error;
                                                                                             }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFNotificationsViewCell class]
      forCellReuseIdentifier:[PFNotificationsViewCell preferredReuseIdentifier]];
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:kEmptyCellIdentifier];
    [tableView setBackgroundColor:[PFColor lightGrayColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setTableFooterView:[UIView new]];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Notifications", nil)];
    
    [self setUpImageBackButtonForShim];
    [self setShim:[PFShim blackOpaqueFor:self]];
    
    [[[self contentView] spinner] startAnimating];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    if([self state] == PFViewControllerLaunching) {
        
        [[self dataSource] load]; [self setState:PFViewControllerReady];
        
    } else {
        
        [[self tableView] reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kNotificationsPage];
    
    [[PFAppDelegate shared] resetNotifications];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        return 1;
    }
    return [[self dataSource] numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellIdentifier];
        
        if (emptyCell == nil) {
            emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEmptyCellIdentifier];
        }
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [PFSize screenWidth], 30)];
        label1.font = [PFFont fontOfLargeSize];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"You have no notifications";
        label1.textColor = [PFColor grayColor];
        [emptyCell addSubview:label1];
        
        FAKFontAwesome *commentIcon = [FAKFontAwesome bellIconWithSize:100];
        [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectZero];
        comment.attributedText = [commentIcon attributedString];
        [comment sizeToFit];
        comment.center = CGPointMake([PFSize screenWidth]/2, 130);
        comment.textColor = [PFColor lightGrayColor];
        
        [emptyCell addSubview:comment];
        
        return emptyCell;

    }
    
    PFNotificationsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                     [PFNotificationsViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFNotificationsViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:[PFNotificationsViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    PFNotification *notification = [[self dataSource] itemAtIndex:[indexPath row]];
    
    [cell setDelegate:self];
    [cell setUserId:[notification userId]];
    
    switch([[notification type] integerValue]) {
        
        case PFNotificationTypeReferral: {
        }
            
        case PFNotificationTypeFacebook: {
        }
            
        case PFNotificationTypeConnectionRequest: {
        }
            
        case PFNotificationTypeConnectionAccept: {
            
            PFAvatar *avatar = [[notification user] avatar];
            
            PFFilename *filename = [[PFFilename alloc] init];
            [filename setDynamic:[avatar dynamic]];
            
            [[cell avatarView]  setImageWithUrl:[filename croppedToSize:[PFNotificationsViewCell preferredAvatarSize]]
                            postProcessingBlock:nil
                                  progressBlock:nil
                               placeholderImage:nil
                                         fadeIn:YES];
            break;
        }
            
        case PFNotificationTypeCommentBack: {
        }
            
        case PFNotificationTypeView: {
        }
            
        case PFNotificationTypeComment: {
        }
            
        case PFNotificationTypeLike: {
        }
            
        case PFNotificationTypeCollaborator: {
            
            PFMedia *media = [[[notification entry] media] objectAtIndex:0];
            
            [[cell avatarView]  setImageWithUrl:[[media filename] croppedToSize:[PFNotificationsViewCell preferredAvatarSize]]
                            postProcessingBlock:nil
                                  progressBlock:nil
                               placeholderImage:nil
                                         fadeIn:YES];
            break;
        }
            
        case PFNotificationTypeJoin: {
            
            [[cell avatarView] setImage:[PFImage icon]];
            
            break;
        }
            
        default: {
            
            break;
        }
    }
    
    [cell setNotification:[notification notification]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
        forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
        
        return;
    }
    
    PFNotification *notification = [[self dataSource] itemAtIndex:[indexPath row]];
    
    if([[notification seen] integerValue] > 0) {
     
        [[cell contentView] setBackgroundColor:[UIColor whiteColor]];
     
    } else {
     
        [[cell contentView] setBackgroundColor:[PFColor blueHighlight]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        return;
    }
    
    PFNotification *notification = [[self dataSource] itemAtIndex:[indexPath row]];
    
    [[PFGoogleAnalytics shared] openedNotification];
    
    if([[notification seen] integerValue] < 1) {
        
        [notification setSeen:@1];
        
        [[PFApi shared] notificationSeen:[notification notificationId]
                                 success:^{
                                     
                                     [notification setSeen:@1];
                                     
                                 } failure:^NSError *(NSError *error) {
                                    
                                     return error;
                                 }];
    }
    
    switch([[notification type] integerValue]) {
            
        case PFNotificationTypeReferral: {
        }
            
        case PFNotificationTypeFacebook: {
        }
            
        case PFNotificationTypeConnectionRequest: {
        }
            
        case PFNotificationTypeConnectionAccept: {
            
            [[self rootNavigationController] pushViewController:[PFProfileVC _new:[[notification user] userId]]
                                                       animated:YES
                                                           shim:self];
            break;
        }
            
        case PFNotificationTypeCommentBack: {
        }
            
        case PFNotificationTypeComment: {
            
            [[self rootNavigationController] pushViewController:[PFCommentsVC _new:[[notification entry] entryId]]
                                                       animated:YES
                                                           shim:self];
            break;
        }
            
        case PFNotificationTypeView: {
        }
            
        case PFNotificationTypeLike: {
        }
            
        case PFNotificationTypeCollaborator: {
            
            PFHomeFeedVC *delegate = (PFHomeFeedVC *)[[PFHomeVC shared] viewControllerAtIndex:0];
            PFDetailVC *vc = [PFDetailVC _new:[[notification entry] entryId] delegate:delegate
                              ];
            
            [[self rootNavigationController] pushViewController:vc
                                                       animated:YES];
            break;
        }
            
        case PFNotificationTypeJoin: {
            
            [[PFHomeVC shared] plusButtonAction];
            
            break;
        }
            
        default: {
            
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        return [PFSize screenHeight] - 100;
    }
    
    PFNotification *notification = [[[self dataSource] data] objectAtIndex:[indexPath row]];
    
    return [PFNotificationsViewCell heightForRowAtNotification:notification];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    
    return [[UIView alloc] init];
}

#pragma mark - ADPagedDataSourceDelegate

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didLoadAdditionalItems:(NSInteger)items; {
    
    [[[self contentView] spinner] stopAnimating];
    
    [[self tableView] setSeparatorColor:[PFColor separatorColor]];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:items];
    NSInteger numberOfItems = [dataSource numberOfItems];
    
    for (int i = (int)numberOfItems - (int)items; i < numberOfItems; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [UIView setAnimationsEnabled:NO];
    [[self tableView] beginUpdates];
    
    [[self tableView] insertRowsAtIndexPaths:indexPaths
                            withRowAnimation:UITableViewRowAnimationNone];
    
    [[self tableView] endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
    
    [[self tableView] reloadData];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    
    pageState = toState;
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        [self tableView].userInteractionEnabled = NO;
        [[[self contentView] spinner] stopAnimating];
        [[self tableView] reloadData];
    }
    else
        [self tableView].userInteractionEnabled = YES;
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

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
