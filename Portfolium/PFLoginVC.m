//
//  PFLoginVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFLoginVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFLinkedIn.h"
#import "PFApi.h"
#import "NSString+PFExtensions.h"
#import "PFFacebook.h"
#import "PFLoginViewCell.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFColor.h"
#import "TTTAttributedLabel+PFExtensions.h"
#import "PFTapGesture.h"
#import "PFImage.h"
#import "PFForgotPasswordVC.h"
#import "UIViewController+PFExtensions.h"
#import "NSString+PFExtensions.h"
#import "PFApi.h"
#import "PFAuthenticationProvider.h"
#import "PFErrorHandler.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import <Crashlytics/Crashlytics.h>
#import "UITableView+PFExtensions.h"
#import "PFSize.h"
#import "UITabBarController+PFExtensions.h"
#import "PFProgressHud.h"
#import "PFGoogleAnalytics.h"
#import "PFActivityIndicatorView.h"
#import "FAKFontAwesome.h"
#import "PFFont.h"
#import "UITextField+ELFixSecureTextFieldFont.h"

static const NSInteger kUsernameIndex = 0;
static const NSInteger kPasswordIndex = 1;

static const NSInteger kMaxChars = 100;

@interface PFLoginVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PFTapGesture *tap;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) NSString *password;
@property(nonatomic, strong) UIButton *facebookButton;
@property(nonatomic, strong) UIButton *linkedInButton;
@property(nonatomic, strong) UILabel *forgotPasswordLabel;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;

@end

@implementation PFLoginVC

+ (PFLoginVC *) _new; {
    
    return [[PFLoginVC alloc] initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setUsername:[NSString empty]];
        [self setPassword:[NSString empty]];
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];

    [self setUpImageBackButton];
    
    [self setTitle:NSLocalizedString(@"Login", nil)];
    
    [[self view] setBackgroundColor:[PFColor lighterGrayColor]];

    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setFrame:CGRectMake([PFSize loginVCFBButton], 10, 80, 44)];
    [facebookButton setBackgroundImage:[PFImage facebookButtonBackground]
                              forState:UIControlStateNormal];
    [[self view] addSubview:facebookButton];
    [self setFacebookButton:facebookButton];
    
    FAKFontAwesome *facebookIcon = [FAKFontAwesome facebookIconWithSize:22];
    [facebookIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *facebookHighlightedIcon = [FAKFontAwesome facebookIconWithSize:22];
    [facebookHighlightedIcon addAttribute:NSForegroundColorAttributeName value:[PFColor lightGrayColor]];
    
    [facebookButton setAttributedTitle:[facebookIcon attributedString]
                      forState:UIControlStateNormal];
    [facebookButton setAttributedTitle:[facebookHighlightedIcon attributedString]
                      forState:UIControlStateHighlighted];
    
    UIButton *linkedInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [linkedInButton setFrame:CGRectMake([PFSize loginVCLKButton], 10, 80, 44)];
    [linkedInButton setBackgroundImage:[PFImage linkedInButtonBackground]
                              forState:UIControlStateNormal];
    [[self view] addSubview:linkedInButton];
    [self setLinkedInButton:linkedInButton];
    
    FAKFontAwesome *linkedInIcon = [FAKFontAwesome linkedinIconWithSize:22];
    [linkedInIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    FAKFontAwesome *linkedInHighlightedIcon = [FAKFontAwesome linkedinIconWithSize:22];
    [linkedInHighlightedIcon addAttribute:NSForegroundColorAttributeName value:[PFColor lightGrayColor]];
    
    [linkedInButton setAttributedTitle:[linkedInIcon attributedString]
                              forState:UIControlStateNormal];
    [linkedInButton setAttributedTitle:[linkedInHighlightedIcon attributedString]
                              forState:UIControlStateHighlighted];

    CGFloat tableViewHeight = 64;
    CGFloat forgotPasswordLabelHeight = 162;
    
    // only show the OR label on iPhone 5 or bigger
    if([PFSize screenHeight] > IPHONE_4_HEIGHT) {
        UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake([PFSize loginVCORText], 64, 40, 20)];
        [orLabel setFont:[PFFont fontOfMediumSize]];
        [orLabel setTextColor:[PFColor grayColor]];
        [orLabel setBackgroundColor:[UIColor clearColor]];
        [orLabel setText:NSLocalizedString(@"OR", nil)];
        [[self view] addSubview:orLabel];
        
        tableViewHeight += 30;
        forgotPasswordLabelHeight += 30;
    }
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, tableViewHeight, [PFSize screenWidth], 88)];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setBackgroundColor:[PFColor lighterGrayColor]];
    [tableView setSeparatorColor:[PFColor lightGrayColor]];
    [tableView registerClass:[PFLoginViewCell class]
      forCellReuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
    [tableView setScrollEnabled:NO];
    [[self view] addSubview:tableView];
    [self setTableView:tableView];

    TTTAttributedLabel *forgotPasswordLabel = [[TTTAttributedLabel alloc]
                                               initWithFrame:CGRectMake([PFSize loginVCForgotPwdText], forgotPasswordLabelHeight, 206, 20)];
    
    [forgotPasswordLabel setAlpha:0.0f];
    [forgotPasswordLabel setFont:[PFFont fontOfMediumSize]];
    [forgotPasswordLabel setTextColor:[PFColor grayColor]];
    [forgotPasswordLabel setUserInteractionEnabled:YES];
    [forgotPasswordLabel setTextAlignment:NSTextAlignmentCenter];
    [forgotPasswordLabel setText:NSLocalizedString(@"Forgot your password?", nil)
                        enbolden:@"password"];
    [[self view] addSubview:forgotPasswordLabel];
    [self setForgotPasswordLabel:forgotPasswordLabel];
    
    [UIView animateWithDuration:1.0f animations:^{
        [forgotPasswordLabel setAlpha:1.0];
    }];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [PFSize screenWidth], 64)];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setHidden:NO];
    [[self view] addSubview:shim];
    
    @weakify(self)
    
    [facebookButton bk_addEventHandler:^(id sender) {
        
        @strongify(self)
        
        [self prepareForApi];
        
        [[PFFacebook shared] buttonAction:^(NSString *providerId,
                                            NSString *providerUserId,
                                            NSString *token,
                                            NSString *secret,
                                            NSString *displayName,
                                            NSString *profileUrl,
                                            NSString *email) {
            
            [[PFApi shared] getTokenWithFacebook:token
                                        referral:[NSString empty]
                                         success:^(PFUzer *user) {
                                             
                                             [self returnFromApi];
                                             
                                             [[PFGoogleAnalytics shared] loggedInWithFacebook];
                                             
                                             [[PFAuthenticationProvider shared] loginUser:user
                                                                                 provider:PFAuthenticationProviderFacebook];
                                             
                                         } failure:^NSError *(NSError *error) {
                                             
                                             return [self errorBlock](error);
                                         }];
        } cancel:^{
            
            [self returnFromApi];
            [self makeUsernameFirstResponder];
            
        } error:^(NSError *error) {
            
            [self returnFromApi];
            [self makeUsernameFirstResponder];
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [linkedInButton bk_addEventHandler:^(id sender) {
        
        @strongify(self)
        
        [self prepareForApi];
        
        [[PFLinkedIn shared] buttonAction:^(NSString *providerId,
                                            NSString *providerUserId,
                                            NSString *token,
                                            NSString *secret,
                                            NSString *displayName,
                                            NSString *profileUrl,
                                            NSString *email) {
            
            [[PFApi shared] getTokenWithLinkedIn:token
                                        referral:[NSString empty]
                                         success:^(PFUzer *user) {
                                             
                                             [self returnFromApi];
                                             
                                             [[PFGoogleAnalytics shared] loggedInWithLinkedIn];
                                             
                                             [[PFAuthenticationProvider shared] loginUser:user
                                                                                 provider:PFAuthenticationProviderLinkedIn];
                                             
                                         } failure:^NSError *(NSError *error) {
                                             
                                             return [self errorBlock](error);
                                         }];
        } cancel:^{
            
            [self returnFromApi];
            
        } error:^(NSError *error) {
            
            [self returnFromApi];
        }];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [self setTap:[[PFTapGesture alloc] init:forgotPasswordLabel
                                      block:^(UITapGestureRecognizer *recognizer) {
                                          
                                          @strongify(self)
                                          
                                          [[self navigationController] pushViewController:[PFForgotPasswordVC _new]
                                                                                 animated:YES];
                                      }]];
    
    [self setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(self)
        
        [self returnFromApi];
        [self makeUsernameFirstResponder];
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderHiding];
        return error;
    }];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [self makeUsernameFirstResponder];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kLoginPage];
    
    [[self tabBarController] setMainTabBarHidden:YES animated:YES];
    
    [[[self navigationController] navigationBar] setAlpha:1];
    
    [self makeUsernameFirstResponder];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    if(![self isPushingViewController]) {
        
        [[self tabBarController] setMainTabBarHidden:NO animated:YES];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFLoginViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                [PFLoginViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFLoginViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:[PFLoginViewCell preferredReuseIdentifier]];
    }
    
    if([indexPath row] == kUsernameIndex) {
        
        FAKFontAwesome *envelopeIcon = [FAKFontAwesome envelopeOIconWithSize:18];
        [envelopeIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [cell setIcon:envelopeIcon];
        
        [cell setTextFieldPlaceholder:NSLocalizedString(@"Username or Email", nil)];
        [[cell textField] setKeyboardType:UIKeyboardTypeEmailAddress];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[cell textField] setReturnKeyType:UIReturnKeyNext];
        [[cell textField] setDelegate:self];
        [[cell textField] setTag:kUsernameIndex];
        
    } else {
        
        FAKFontAwesome *lockIcon = [FAKFontAwesome lockIconWithSize:18];
        [lockIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        [cell setIcon:lockIcon];
        
        [cell setTextFieldPlaceholder:NSLocalizedString(@"Password", nil)];
        [[cell textField] setSecureTextEntry:YES];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[cell textField] setReturnKeyType:UIReturnKeyGo];
        [[cell textField] setDelegate:self];
        [[cell textField] fixSecureTextFieldFont];
        [[cell textField] setTag:kPasswordIndex];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    return cell;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self isValidFormSubmission]) {
        
        [self doSubmit];
        
    } else {
        
        UITextField *usernameTextField = [[self usernameCell] textField];
        
        if(textField == usernameTextField) {
            
            [self makePasswordFirstResponder];
            
        } else {
            
            [self makeUsernameFirstResponder];
        }
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
                replacementString:(NSString *)string {
    
    UITextField *usernameTextField = [[self usernameCell] textField];
    UITextField *passwordTextField = [[self passwordCell] textField];
    
    if(textField == usernameTextField) {
        
        [self setUsername:[[usernameTextField text]
                           stringByReplacingCharactersInRange:range withString:string]];
        
    } else {
        
        [self setPassword:[[passwordTextField text]
                           stringByReplacingCharactersInRange:range withString:string]];
    }
    
    NSInteger thisLength = [[textField text] length] + [string length] - range.length;
    
	return (thisLength > kMaxChars) ? NO : YES;
}

- (void)makeUsernameFirstResponder; {
    
    [[[self usernameCell] textField] becomeFirstResponder];
}

- (void)makePasswordFirstResponder; {
    
    [[[self passwordCell] textField] becomeFirstResponder];
}

- (void)makeUsernameResignFirstResponder; {
    
    [[[self usernameCell] textField] resignFirstResponder];
}

- (void)makePasswordResignFirstResponder; {
    
    [[[self passwordCell] textField] resignFirstResponder];
}

- (PFLoginViewCell *)usernameCell; {
    
    return (PFLoginViewCell *)[[self tableView] cellForRowAtIndexPath:
                               [NSIndexPath indexPathForItem:kUsernameIndex inSection:0]];
}

- (PFLoginViewCell *)passwordCell; {
    
    return (PFLoginViewCell *)[[self tableView] cellForRowAtIndexPath:
                               [NSIndexPath indexPathForItem:kPasswordIndex inSection:0]];
}

- (BOOL)isValidFormSubmission; {
    
    return ![NSString isNullOrEmpty:[self username]]
    && ![NSString isNullOrEmpty:[self password]];
}

- (void)doSubmit; {
    
    [self prepareForApi];
    
    @weakify(self)
    
    [[PFApi shared] login:[self username]
                 password:[self password]
                  success:^(PFUzer *user) {
                      
                      @strongify(self)
                      
                      [self returnFromApi];
                      
                      [[PFGoogleAnalytics shared] loggedInWithEmail];
                      
                      [[PFAuthenticationProvider shared] loginUser:user
                                                          provider:PFAuthenticationProviderPortfolium];
                      
                  } failure:^NSError *(NSError *error) {
                      
                      @strongify(self)
                      
                      return [self errorBlock](error);
                  }];
}

- (void)prepareForApi; {
    
    [self makeUsernameResignFirstResponder];
    [self makePasswordResignFirstResponder];
    
    [[self facebookButton] setEnabled:NO];
    [[self linkedInButton] setEnabled:NO];
    [[self forgotPasswordLabel] setUserInteractionEnabled:NO];
    [[[self navigationController] navigationBar] setUserInteractionEnabled:NO];
    
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [[self facebookButton] setEnabled:YES];
    [[self linkedInButton] setEnabled:YES];
    [[self forgotPasswordLabel] setUserInteractionEnabled:YES];
    [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
    
    [PFProgressHud hideForView:[self view]];
}

@end
