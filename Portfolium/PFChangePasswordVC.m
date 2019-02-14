//
//  PFChangePasswordVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFChangePasswordVC.h"
#import "PFImage.h"
#import "PFLoginViewCell.h"
#import "PFColor.h"
#import "PFFont.h"
#import "NSString+PFExtensions.h"
#import "PFApi.h"
#import "UIViewController+PFExtensions.h"
#import "UITableView+PFExtensions.h"
#import "PFErrorHandler.h"
#import "PFSize.h"
#import "PFProgressHud.h"
#import "PFSmoothAlertView.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"

static const NSInteger kMaxCharsDefault = 100;
static const NSInteger kPasswordIndex = 0;
static const NSInteger kConfirmIndex = 1;

@interface PFChangePasswordVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) UITextField *passwordTextField;
@property(nonatomic, weak) UITextField *confirmTextField;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) NSString *confirm;

@end

@implementation PFChangePasswordVC

+ (PFChangePasswordVC *)_new; {
    
    return [[PFChangePasswordVC alloc] initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setPassword:[NSString empty]];
        [self setConfirm:[NSString empty]];
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    float offset = 0.0f;
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Change Password", nil)];
    
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    if ([PFSize screenHeight] != IPHONE_4_HEIGHT)
    {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                                  CGRectMake(0, 0, [PFSize screenWidth], 140)];
        
        [imageView setImage:[PFImage forgotPassword]];
        [[self view] addSubview:imageView];
        
        offset = 140;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, offset, [PFSize screenWidth], 88)];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setScrollEnabled:NO];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView registerClass:[PFLoginViewCell class]
      forCellReuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [[self view] addSubview:tableView];
    [self setTableView:tableView];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0,
                                                            -[self applicationFrameOffset],
                                                            [PFSize screenWidth],
                                                            [self applicationFrameOffset])];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setHidden:NO];
    [[self view] addSubview:shim];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kPasswordPage];
    
    [self makePasswordFirstResponder];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kPasswordIndex) {
        
        PFLoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 [PFLoginViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFLoginViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
        }
        
        FAKFontAwesome *lockIcon = [FAKFontAwesome lockIconWithSize:18];
        [lockIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [cell setIcon:lockIcon];
        
        [cell setTextFieldPlaceholder:NSLocalizedString(@"Your new password", nil)];
        [[cell textField] setSecureTextEntry:YES];
        [[cell textField] setKeyboardType:UIKeyboardTypeEmailAddress];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[cell textField] setReturnKeyType:UIReturnKeyGo];
        [[cell textField] setDelegate:self];
        
        [self setPasswordTextField:[cell textField]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        return cell;
    
    } else {
        
        PFLoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 [PFLoginViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFLoginViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
        }
        
        FAKFontAwesome *lockIcon = [FAKFontAwesome lockIconWithSize:18];
        [lockIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [cell setIcon:lockIcon];
        
        [cell setTextFieldPlaceholder:NSLocalizedString(@"Confirm new password", nil)];
        [[cell textField] setSecureTextEntry:YES];
        [[cell textField] setKeyboardType:UIKeyboardTypeEmailAddress];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[cell textField] setReturnKeyType:UIReturnKeyGo];
        [[cell textField] setDelegate:self];
        
        [self setConfirmTextField:[cell textField]];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        return cell;
    }
    
    return nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self isValidFormSubmission]) {
        
        [self doSubmit];
        
    } else {
        
        UITextField *passwordTextField = [[self passwordCell] textField];
        
        if(textField == passwordTextField) {
            
            [self makeConfirmFirstResponder];
            
        } else {
            
            [self makePasswordFirstResponder];
        }
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    UITextField *passwordTextField = [[self passwordCell] textField];
    UITextField *confimrTextField = [[self confirmCell] textField];
    
    if(textField == passwordTextField) {
        
        [self setPassword:[[passwordTextField text]
                           stringByReplacingCharactersInRange:range withString:string]];
        
    } else {
        
        [self setConfirm:[[confimrTextField text]
                           stringByReplacingCharactersInRange:range withString:string]];
    }
    
    NSInteger thisLength = [[textField text] length] + [string length] - range.length;
    
	return (thisLength > kMaxCharsDefault) ? NO : YES;
}

- (void)makePasswordFirstResponder; {
    
    [[[self passwordCell] textField] becomeFirstResponder];
}

- (void)makeConfirmFirstResponder; {
    
    [[[self confirmCell] textField] becomeFirstResponder];
}

- (PFLoginViewCell *)passwordCell; {
    
    return (PFLoginViewCell *)[[self tableView] cellForRowAtIndexPath:
                               [NSIndexPath indexPathForItem:kPasswordIndex inSection:0]];
}

- (PFLoginViewCell *)confirmCell; {
    
    return (PFLoginViewCell *)[[self tableView] cellForRowAtIndexPath:
                               [NSIndexPath indexPathForItem:kConfirmIndex inSection:0]];
}


- (BOOL)isValidFormSubmission; {
    
    return ![NSString isNullOrEmpty:[self password]];
}

- (void)doSubmit; {
    
    [self prepareForApi];
    
    [[PFApi shared] changePassword:[self password]
                           confirm:[self confirm] success:^{
                               
                               [self returnFromApi];
                               
                               [[PFGoogleAnalytics shared] updatedPassword];
                               
                               [self tellKeyboardToResign];
                               
                               [PFSmoothAlertView changePasswordSuccess:self];
                               
                           } failure:^NSError *(NSError *error) {
                               
                               [self returnFromApi];
                               
                               [[PFErrorHandler shared] showInErrorBar:error
                                                              delegate:nil
                                                                inView:[self view]
                                                                header:PFHeaderShowing];
                               return error;
                           }];
}

- (void)tellKeyboardToResign; {
    
    [[self passwordTextField] resignFirstResponder];
    [[self confirmTextField] resignFirstResponder];
}

- (void)prepareForApi; {
    
    [[[self navigationController] navigationBar] setUserInteractionEnabled:NO];
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
    [PFProgressHud hideForView:[self view]];
}

@end