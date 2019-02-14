//
//  PFJoinEmailVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/28/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFJoinEmailVC.h"
#import "PFColor.h"
#import "PFJoinEmailViewCell.h"
#import "NSString+PFExtensions.h"
#import "PFFont.h"
#import "TTTAttributedLabel+PFExtensions.h"
#import "PFApi.h"
#import "PFAuthenticationProvider.h"
#import "UIViewController+PFExtensions.h"
#import "PFErrorHandler.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "UITableView+PFExtensions.h"
#import "PFTermsVC.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFGoogleAnalytics.h"
#import "PFProgressHud.h"
#import "PFSize.h"
#import "UITextField+ELFixSecureTextFieldFont.h"

static NSString *kTos = @"kTos";
static NSString *kPp = @"kPp";

static const NSInteger kMaxChars = 100;
static const NSInteger kMaxCharsUsername = 32;

static const NSInteger kFirstnameIndex = 0;
static const NSInteger kLastnameIndex = 1;
static const NSInteger kUsernameIndex = 2;
static const NSInteger kEmailIndex = 3;
static const NSInteger kPasswordIndex = 4;

@interface PFJoinEmailVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *values;
@property(nonatomic, assign) NSInteger index;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;

@property(nonatomic, weak) UITextField *firstnameTextField;
@property(nonatomic, weak) UITextField *lastnameTextField;
@property(nonatomic, weak) UITextField *usernameTextField;
@property(nonatomic, weak) UITextField *emailTextField;
@property(nonatomic, weak) UITextField *passwordTextField;

@end

@implementation PFJoinEmailVC

+ (PFJoinEmailVC *)_new; {
    
    return [[PFJoinEmailVC alloc] initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setIndex:0];
        [self setValues:[[NSMutableArray alloc] initWithCapacity:kPasswordIndex + 1]];
        
        for(int i = 0; i <= kPasswordIndex; i++) {
            [[self values] insertObject:[NSString empty] atIndex:i];
        }
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Join", nil)];
   
    
    [[self view] setBackgroundColor:[PFColor lighterGrayColor]];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], [PFSize screenHeight] - 250)];
    scrollView.contentSize = CGSizeMake([PFSize screenWidth], (44*(kPasswordIndex + 1)) + 48);
    
    UITableView *tableView = [[UITableView alloc]
                              initWithFrame:CGRectMake(0, 0,
                                                       [PFSize screenWidth],
                                                       44*(kPasswordIndex +1))];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setScrollEnabled:NO];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setSeparatorColor:[PFColor lightGrayColor]];
    [tableView registerClass:[PFJoinEmailViewCell class]
      forCellReuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];

    [scrollView addSubview:tableView];
    [self setTableView:tableView];
    
    TTTAttributedLabel *policyLabel = [[TTTAttributedLabel alloc]
                                       initWithFrame:CGRectMake([PFSize joinVCFBLKButton],
                                                                (44*(kPasswordIndex + 1)) + 18, 260, 30)];
    [policyLabel setAlpha:0.0f];
    [policyLabel setFont:[PFFont fontOfMediumSize]];
    [policyLabel setTextColor:[PFColor grayColor]];
    [policyLabel setUserInteractionEnabled:YES];
    [policyLabel setTextAlignment:NSTextAlignmentCenter];
    [policyLabel setDelegate:self];
    [policyLabel setText:NSLocalizedString(@"terms of service and privacy policy", nil)];
    [policyLabel link:@"terms of service" to:kTos];
    [policyLabel link:@"privacy policy" to:kPp];
    
    [scrollView addSubview:policyLabel];
    [[self view] addSubview:scrollView];
    
    [UIView animateWithDuration:1.0f animations:^{
        [policyLabel setAlpha:1.0];
    }];
    
    @weakify(self)
    
    [self setErrorBlock:^NSError *(NSError *error) {

        @strongify(self)
        
        [self returnFromApi];
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderShowing];
        return error;
    }];
    

    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [PFSize screenWidth], 64)];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setHidden:NO];
    [[self view] addSubview:shim];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kJoinWithEmailPage];
    
    PFJoinEmailViewCell *cell = (PFJoinEmailViewCell *)[[self tableView] cellForRowAtIndexPath:
                                                        [NSIndexPath indexPathForItem:0 inSection:0]];
    
    [[cell textField] becomeFirstResponder];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];

    [[self tableView] setSeparatorInsetZero];
    
    [[self tableView] setContentInset:
        UIEdgeInsetsMake(0, 0, 0, 0)];
    
    [self setExtendedLayoutIncludesOpaqueBars:NO];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return kPasswordIndex + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                 [PFJoinEmailViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    switch ([indexPath row]) {
        
        case kFirstnameIndex:
            
            [cell setLabelText:NSLocalizedString(@"first name", nil) animated:YES];
            [[cell textField] setTag:kFirstnameIndex];
            [self setFirstnameTextField:[cell textField]];
            [[cell textField] setReturnKeyType:UIReturnKeyNext];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            
            break;
            
        case kLastnameIndex:
            
            [cell setLabelText:NSLocalizedString(@"last name", nil) animated:YES];
            [[cell textField] setTag:kLastnameIndex];
            [self setLastnameTextField:[cell textField]];
            [[cell textField] setReturnKeyType:UIReturnKeyNext];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
            
            break;
            
        case kUsernameIndex:
            
            [cell setLabelText:NSLocalizedString(@"username", nil) animated:YES];
            [[cell textField] setTag:kUsernameIndex];
            [self setUsernameTextField:[cell textField]];
            [[cell textField] setReturnKeyType:UIReturnKeyNext];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            break;
            
        case kEmailIndex:
            
            [cell setLabelText:NSLocalizedString(@"email", nil) animated:YES];
            [[cell textField] setKeyboardType:UIKeyboardTypeEmailAddress];
            [[cell textField] setTag:kEmailIndex];
            [self setEmailTextField:[cell textField]];
            [[cell textField] setReturnKeyType:UIReturnKeyNext];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            break;
            
        case kPasswordIndex:
            
            [cell setLabelText:NSLocalizedString(@"password", nil) animated:YES];
            [[cell textField] setTag:kPasswordIndex];
            [[cell textField] setSecureTextEntry:YES];
            [self setPasswordTextField:[cell textField]];
            [[cell textField] setReturnKeyType:UIReturnKeyJoin];
            [[cell textField] fixSecureTextFieldFont];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            break;
            
        default: break;
    }
    
    [[cell textField] setDelegate:self];
    
    return cell;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
    
    UITextField *target;
    int i = 0;
    
    for(i = 0; i <= kPasswordIndex; i++) {
        
        target = [[self cellAtIndex:i] textField];
        
        if(textField == target) {
            
            NSString *value = [[target text]
                               stringByReplacingCharactersInRange:range withString:string];
            
            [[self values] replaceObjectAtIndex:i withObject:value]; break;
        }
    }
    
    if([self isValidFormSubmission]) {
    } else {
    }
    
    [self makeTextboxFirstResponderAtIndex:i];
    
    NSInteger maxChars = kMaxChars;
    
    if(textField == [self usernameTextField]) {
        
        maxChars = kMaxCharsUsername;
    }
    
    return ([[textField text] length] + [string length] -
            range.length > maxChars) ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self isValidFormSubmission]) {
        [self doSubmit];
    } else {
        if([self index] < kPasswordIndex) {
            [self setIndex:[self index] + 1];
        } else {
            [self setIndex:0];
        } [self makeTextboxFirstResponderAtIndex:[self index]];
    }
    
    return NO;
}

- (void)makeTextboxFirstResponderAtIndex:(NSInteger)index; {
    
    [[[self cellAtIndex:index] textField] becomeFirstResponder];
}

- (PFJoinEmailViewCell *)cellAtIndex:(NSInteger)index; {
    
    return (PFJoinEmailViewCell *)[[self tableView] cellForRowAtIndexPath:
                                   [NSIndexPath indexPathForItem:index inSection:0]];
}

- (BOOL)isValidFormSubmission; {
    
    for(int i = 0; i <= kPasswordIndex; i++) {
        
        NSString *value = [[self values] objectAtIndex:i];
        if([NSString isNullOrEmpty:value]) {
            return NO;
        }
    }
    
    return YES;
}

- (void)doSubmit; {
    
    [self prepareForApi];
    
    [[PFApi shared] signUp:[[self values] objectAtIndex:kEmailIndex]
                  username:[[self values] objectAtIndex:kUsernameIndex]
                 firstname:[[self values] objectAtIndex:kFirstnameIndex]
                  lastname:[[self values] objectAtIndex:kLastnameIndex]
                  password:[[self values] objectAtIndex:kPasswordIndex]
                  referral:[NSString empty]
                   success:^(PFUzer *user) {
                       
                       [self returnFromApi];
                       
                       [[PFGoogleAnalytics shared] joinedWithEmail];
                       
                       [[PFAuthenticationProvider shared] loginUser:user
                                                           provider:PFAuthenticationProviderPortfolium];
                       
                   } failure:^NSError *(NSError *error) {
                       
                       return [self errorBlock](error);
                   }];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url; {
    
    PFTermsVC *termsVC;
    
    if([[NSString stringWithFormat:@"%@", url] isEqualToString:kTos]) {
        
        termsVC = [PFTermsVC _new:PFTermsTypeTerms];
        
    } else {
    
        termsVC = [PFTermsVC _new:PFTermsTypePrivacy];
    }
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:termsVC];
    [[nc navigationBar] restyleNavigationBarTranslucentBlack];
    
    [[self navigationController] presentViewController:nc
                                              animated:YES
                                            completion:^{
    }];
}

- (void)prepareForApi; {
    
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [PFProgressHud hideForView:[self view]];
}

@end
