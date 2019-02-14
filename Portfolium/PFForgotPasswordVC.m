//
//  PFForgotPasswordVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFForgotPasswordVC.h"
#import "PFImage.h"
#import "PFLoginViewCell.h"
#import "PFColor.h"
#import "PFFont.h"
#import "NSString+PFExtensions.h"
#import "UIViewController+PFExtensions.h"
#import "UITableView+PFExtensions.h"
#import "PFApi.h"
#import "PFErrorHandler.h"
#import "PFProgressHud.h"
#import "PFSmoothAlertView.h"
#import "FAKFontAwesome.h"
#import "PFGoogleAnalytics.h"
#import "PFSize.h"

static const NSInteger kMaxChars = 100;

@interface PFForgotPasswordVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, weak) UITextField *emailTextField;

@end

@implementation PFForgotPasswordVC

+ (PFForgotPasswordVC *)_new; {
    
    PFForgotPasswordVC *vc = [[PFForgotPasswordVC alloc] initWithNibName:nil bundle:nil];
    [vc setEmail:[NSString empty]];
    
    return vc;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Forgot Password", nil)];
    
    [[self view] setBackgroundColor:[PFColor lighterGrayColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], 140)];
    [imageView setImage:[PFImage forgotPassword]];
    [[self view] addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 140, [PFSize screenWidth], 44)];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setSeparatorColor:[PFColor lightGrayColor]];
    [tableView registerClass:[PFLoginViewCell class]
      forCellReuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
    [[self view] addSubview:tableView];
    [self setTableView:tableView];
    
    UILabel *instructionsLabel = [[UILabel alloc] initWithFrame:CGRectMake(54, 198, 200, 40)];
    [instructionsLabel setFont:[PFFont fontOfMediumSize]];
    [instructionsLabel setTextColor:[PFColor grayColor]];
    [instructionsLabel setNumberOfLines:2];
    [instructionsLabel setTextAlignment:NSTextAlignmentCenter];
    [instructionsLabel setAlpha:0.0f];
    [instructionsLabel setText:NSLocalizedString(@"Password recovery options will be sent to you", nil)];
    [instructionsLabel setHidden:YES];
    [[self view] addSubview:instructionsLabel];
    
    [UIView animateWithDuration:0.7f animations:^{
        [instructionsLabel setAlpha:1.0f];
    }];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [PFSize screenWidth], 64)];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setHidden:NO];
    [[self view] addSubview:shim];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kForgotPage];
    
    [self makeEmailFirstResponder];
}

- (void) viewDidLayoutSubviews {
    
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
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    FAKFontAwesome *envelopeIcon = [FAKFontAwesome envelopeOIconWithSize:18];
    [envelopeIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    [cell setIcon:envelopeIcon];
    
    [cell setTextFieldPlaceholder:NSLocalizedString(@"Your email address", nil)];
    [[cell textField] setKeyboardType:UIKeyboardTypeEmailAddress];
    [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
    [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [[cell textField] setReturnKeyType:UIReturnKeyGo];
    [[cell textField] setDelegate:self];
    
    [self setEmailTextField:[cell textField]];
    
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
    
    NSInteger thisLength = [[textField text] length] + [string length] - range.length;
    
	return (thisLength > kMaxChars) ? NO : YES;
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
    
    [[PFApi shared] forgotPassword:[self email]
                           success:^{
                               
                               [self returnFromApi];
                               
                               [[self emailTextField] resignFirstResponder];
                               
                               [PFSmoothAlertView forgotPasswordSuccess:self];
                               
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
