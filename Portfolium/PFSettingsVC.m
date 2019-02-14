//
//  PFSettingsVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFSettingsVC.h"
#import "PFCView.h"
#import "PFOBBasicsTitleViewCell.h"
#import "PFOBEducationViewCell.h"
#import "PFSettingsSwitchViewCell.h"
#import "PFUzer.h"
#import "PFApi.h"
#import "PFChangePasswordVC.h"
#import "PFChangeEmailVC.h"
#import "PFAuthenticationProvider.h"
#import "UIViewController+PFExtensions.h"
#import "UITableView+PFExtensions.h"
#import "PFColor.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFErrorHandler.h"
#import "PFSize.h"
#import "PFGoogleAnalytics.h"

static const NSInteger kSecurityIndex = 0;
static const NSInteger kChangePasswordIndex = 1;
static const NSInteger kChangeEmailIndex = 2;
static const NSInteger kPrivacyIndex = 3;
static const NSInteger kEmail1Index = 4;
static const NSInteger kEmail2Index = 5;
static const NSInteger kEmail3Index = 6;
static const NSInteger kEmail4Index = 7;
static const NSInteger kEmail5Index = 8;
static const NSInteger kMoreIndex = 9;
static const NSInteger kAboutIndex = 10;

@interface PFSettingsVC ()

@property(nonatomic, strong) PFUzer *user;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *types;
@property(nonatomic, weak) UISwitch *email1Switch;
@property(nonatomic, weak) UISwitch *email2Switch;
@property(nonatomic, weak) UISwitch *email3Switch;
@property(nonatomic, weak) UISwitch *email4Switch;
@property(nonatomic, weak) UISwitch *email5Switch;
@property(nonatomic, weak) UISwitch *email6Switch;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;

@end

@implementation PFSettingsVC

+ (PFSettingsVC *)_new:(PFUzer *)user; {
    
    PFSettingsVC *vc = [[PFSettingsVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setTypes:@[@"comment", @"like", @"tag", @"message", @"network"]];
    [vc setUser:user];
    
    return vc;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentOffset:-[self applicationFrameOffset]];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Settings", nil)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFOBBasicsTitleViewCell class]
      forCellReuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFOBEducationViewCell class]
      forCellReuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFSettingsSwitchViewCell class]
      forCellReuseIdentifier:[PFSettingsSwitchViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[PFColor lightGrayColor]];
    [tableView setSeparatorColor:[PFColor separatorColor]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, -[self applicationFrameOffset],
                                                            [PFSize screenWidth],
                                                            [self applicationFrameOffset])];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setHidden:NO];
    [[self view] addSubview:shim];
    
    @weakify(self)
    
    [self setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(self)
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderShowing];
        return error;
    }];
    
    [[PFApi shared] me:^(PFUzer *user) {
        
        @strongify(self)
        
        [self setUser:user];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self setToggles];
        });
        
    } failure:^NSError *(NSError *error) {
        
        return [self errorBlock](error);
    }];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kSettingsPage];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kSecurityIndex) {
    
        PFOBBasicsTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFOBBasicsTitleViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFOBBasicsTitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [[cell label] setText:NSLocalizedString(@"Account", nil)];
        
        return cell;
    }
    
    if([indexPath row] == kChangePasswordIndex) {
        
        PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                            [PFOBEducationViewCell preferredReuseIdentifier]];
        if (cell == nil) {
            
            cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFOBEducationViewCell:cell
                                      text:NSLocalizedString(@"Change Password", nil)
                                     index:kChangePasswordIndex];
        
        return cell;
    }
    
    if([indexPath row] == kChangeEmailIndex) {
        
        PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFOBEducationViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFOBEducationViewCell:cell
                                      text:NSLocalizedString(@"Change Email", nil)
                                     index:kChangeEmailIndex];
        
        return cell;
    }
    
    if([indexPath row] == kPrivacyIndex) {
        
        PFOBBasicsTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFOBBasicsTitleViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFOBBasicsTitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [[cell label] setText:NSLocalizedString(@"Send me an email when someone:", nil)];
        
        return cell;
    }
    
    if([indexPath row] == kEmail1Index) {
        
        PFSettingsSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFSettingsSwitchViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFSettingsSwitchViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFSettingsSwitchViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFSettingsSwitchViewCell:cell
                                         text:NSLocalizedString(@"Comments on an entry of mine", nil)
                                        index:kEmail1Index];
        
        [self setEmail1Switch:[cell swtch]];
        [[cell swtch] setSelected:[[self user] emailComment]];
        [[cell swtch] setTag:0];
        [[cell swtch] addTarget:self
                         action:@selector(notificationSwitchChanged:)
               forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    if([indexPath row] == kEmail2Index) {
        
        PFSettingsSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                          [PFSettingsSwitchViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFSettingsSwitchViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:[PFSettingsSwitchViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFSettingsSwitchViewCell:cell
                                         text:NSLocalizedString(@"Likes a portfolio entry of mine", nil)
                                        index:kEmail2Index];
        
        [self setEmail2Switch:[cell swtch]];
        [[cell swtch] setOn:[[self user] emailLike]];
        [[cell swtch] setTag:1];
        [[cell swtch] addTarget:self
                         action:@selector(notificationSwitchChanged:)
                 forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    if([indexPath row] == kEmail3Index) {
        
        PFSettingsSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                          [PFSettingsSwitchViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFSettingsSwitchViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:[PFSettingsSwitchViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFSettingsSwitchViewCell:cell
                                         text:NSLocalizedString(@"Tags me in their portfolio entry", nil)
                                        index:kEmail3Index];
        
        [self setEmail3Switch:[cell swtch]];
        [[cell swtch] setOn:[[self user] emailTag]];
        [[cell swtch] setTag:2];
        [[cell swtch] addTarget:self
                         action:@selector(notificationSwitchChanged:)
               forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    if([indexPath row] == kEmail4Index) {
        
        PFSettingsSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                          [PFSettingsSwitchViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFSettingsSwitchViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:[PFSettingsSwitchViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFSettingsSwitchViewCell:cell
                                         text:NSLocalizedString(@"Sends me a message", nil)
                                        index:kEmail4Index];
        
        [self setEmail4Switch:[cell swtch]];
        [[cell swtch] setOn:[[self user] emailMessage]];
        [[cell swtch] setTag:3];
        [[cell swtch] addTarget:self
                         action:@selector(notificationSwitchChanged:)
               forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    if([indexPath row] == kEmail5Index) {
        
        PFSettingsSwitchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                          [PFSettingsSwitchViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFSettingsSwitchViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                   reuseIdentifier:[PFSettingsSwitchViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFSettingsSwitchViewCell:cell
                                         text:NSLocalizedString(@"Requests to connect with me", nil)
                                        index:kEmail5Index];
        
        [self setEmail5Switch:[cell swtch]];
        [[cell swtch] setOn:[[self user] emailNetwork]];
        [[cell swtch] setTag:4];
        [[cell swtch] addTarget:self
                         action:@selector(notificationSwitchChanged:)
               forControlEvents:UIControlEventValueChanged];
        
        return cell;
    }
    
    if([indexPath row] == kMoreIndex) {
        
        PFOBBasicsTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFOBBasicsTitleViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFOBBasicsTitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [[cell label] setText:NSLocalizedString(@"More", nil)];
        
        return cell;
    }
    
    if([indexPath row] == kAboutIndex) {
        
        PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                            [PFOBEducationViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
    
        [self animatePFOBEducationViewCell:cell
                                      text:NSLocalizedString(@"Logout", nil)
                                     index:kAboutIndex];
        
        return cell;
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kChangePasswordIndex) {
        
        PFChangePasswordVC *vc = [PFChangePasswordVC _new];
        [[self navigationController] pushViewController:vc animated:YES];
    
    } else if([indexPath row] == kChangeEmailIndex) {
        
        PFChangeEmailVC *vc = [PFChangeEmailVC _new];
        [[self navigationController] pushViewController:vc animated:YES];
    
    } else if([indexPath row] == kAboutIndex) {
        
        [[PFAuthenticationProvider shared] logout];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    
    return [[UIView alloc] init];
}

- (void)notificationSwitchChanged:(UISwitch *)swtch; {
    
    [[PFApi shared] postEmailNotification:[[self types] objectAtIndex:[swtch tag]]
                                    value:[swtch isOn] ? @"true" : @"false"
                                  success:^{
                                      [[PFGoogleAnalytics shared] changedEmailNotificationSetting];
                                  } failure:^NSError *(NSError *error) {
                                      
                                      return [self errorBlock](error);
                                  }];
}

- (void)setToggles; {
    
    [[self email1Switch] setOn:[[[self user] emailComment] boolValue]
                      animated:YES];
    
    [[self email2Switch] setOn:[[[self user] emailLike] boolValue]
                      animated:YES];
    
    [[self email3Switch] setOn:[[[self user] emailTag] boolValue]
                      animated:YES];
    
    [[self email4Switch] setOn:[[[self user] emailMessage] boolValue]
                      animated:YES];
    
    [[self email5Switch] setOn:[[[self user] emailNetwork] boolValue]
                      animated:YES];
    
    [[self email6Switch] setOn:[[[self user] emailEmployer] boolValue]
                      animated:YES];
}

@end
