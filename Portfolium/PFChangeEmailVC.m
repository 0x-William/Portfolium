//
//  PFChangeEmailVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFChangeEmailVC.h"
#import "PFImage.h"
#import "PFLoginViewCell.h"
#import "PFColor.h"
#import "PFFont.h"
#import "NSString+PFExtensions.h"
#import "PFApi.h"
#import "UITableView+PFExtensions.h"
#import "UIViewController+PFExtensions.h"
#import "PFErrorHandler.h"
#import "PFSize.h"
#import "PFProgressHud.h"
#import "PFAuthenticationProvider.h"
#import "PFSmoothAlertView.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"

static const NSInteger kMaxCharsDefault = 100;

@interface PFChangeEmailVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITextField *emailTextField;
@property(nonatomic, strong) NSString *email;

@end

@implementation PFChangeEmailVC

+ (PFChangeEmailVC *)_new; {
    
    return [[PFChangeEmailVC alloc] initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Change Email", nil)];
    
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 0, [PFSize screenWidth], 140)];
    
    [imageView setImage:[PFImage forgotPassword]];
    [[self view] addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, 140, [PFSize screenWidth], 44)];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView registerClass:[PFLoginViewCell class]
      forCellReuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [[self view] addSubview:tableView];
    [self setTableView:tableView];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 200, 200, 40)];
    [instructionsLabel setFont:[PFFont fontOfMediumSize]];
    [instructionsLabel setTextColor:[PFColor grayColor]];
    [instructionsLabel setNumberOfLines:2];
    [instructionsLabel setTextAlignment:NSTextAlignmentCenter];
    [instructionsLabel setText:NSLocalizedString(@"Change your email, goon. Now! Or I'll crash the app ...", nil)];
    [[self view] addSubview:instructionsLabel];
    [instructionsLabel setHidden:YES];
    
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
    
    [[PFGoogleAnalytics shared] track:kEmailPage];
    
    [self makeEmailFirstResponder];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFLoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             [PFLoginViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFLoginViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
    }
    
    FAKFontAwesome *envelopeIcon = [FAKFontAwesome envelopeOIconWithSize:18];
    [envelopeIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    [cell setIcon:envelopeIcon];
    
    [cell setTextFieldPlaceholder:NSLocalizedString(@"Your new email address", nil)];
    [[cell textField] setKeyboardType:UIKeyboardTypeEmailAddress];
    [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
    [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [[cell textField] setReturnKeyType:UIReturnKeyGo];
    [[cell textField] setDelegate:self];
    
    [self setEmailTextField:[cell textField]];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self isValidFormSubmission]) {
        [self doSubmit];
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    UITextField *emailTextField = [[self emailCell] textField];
    
    [self setEmail:[[emailTextField text]
                    stringByReplacingCharactersInRange:range withString:string]];
    
    if([self isValidFormSubmission]) {
        
        [emailTextField setReturnKeyType:UIReturnKeyGo];
        
    } else {
        
        [emailTextField setReturnKeyType:UIReturnKeyDefault];
    }
    
    [emailTextField reloadInputViews];
    
    NSInteger thisLength = [[textField text] length] + [string length] - range.length;
    
	return (thisLength > kMaxCharsDefault) ? NO : YES;
}

- (void)makeEmailFirstResponder; {
    
    [[[self emailCell] textField] becomeFirstResponder];
}

- (PFLoginViewCell *)emailCell; {
    
    return (PFLoginViewCell *)[[self tableView] cellForRowAtIndexPath:
                               [NSIndexPath indexPathForItem:0 inSection:0]];
}

- (BOOL)isValidFormSubmission; {
    
    return ![NSString isNullOrEmpty:[self email]];
}

- (void)doSubmit; {
    
    [self prepareForApi];
    
    [[PFApi shared] changeEmail:[self email]
                        success:^{
                            
                            [self returnFromApi];
                            
                            [[PFGoogleAnalytics shared] updatedEmail];
                            
                            [[PFAuthenticationProvider shared] userUpdatedEmail:[self email]];
                            [[self emailTextField] resignFirstResponder];
                            
                            [PFSmoothAlertView changeEmailSuccess:self];
                            
                        } failure:^NSError *(NSError *error) {
                            
                            [self returnFromApi];
                            
                            [[PFErrorHandler shared] showInErrorBar:error
                                                           delegate:nil
                                                             inView:[self view]
                                                             header:PFHeaderShowing];
                            return error;
                        }];
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