//
//  PFMessagesNewVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/11/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMessagesNewVC.h"
#import "PFCView.h"
#import "PFMessagesNewViewCell.h"
#import "PFOBBasicsTextViewCell.h"
#import "GCPlaceholderTextView.h"
#import "NSString+PFExtensions.h"
#import "PFApi.h"
#import "PFBarButtonContainer.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFThread.h"
#import "PFImage.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFMessagesTextViewCell.h"
#import "PFErrorHandler.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFProgressHud.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"
#import "UITableView+PFExtensions.h"

static const NSInteger kToIndex = 0;
static const NSInteger kSubjectIndex = 1;
static const NSInteger kMessageIndex = 2;
static const NSInteger kMaxChars = 300;

@interface PFMessagesNewVC ()

@property(nonatomic, strong) NSNumber *userId;
@property(nonatomic, strong) NSString *username;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) UITextField *toTextField;
@property(nonatomic, weak) UITextField *subjectTextField;
@property(nonatomic, weak) GCPlaceholderTextView *messageTextView;
@property(nonatomic, strong) UIView *leftBarButtonContainer;
@property(nonatomic, strong) UIView *rightBarButtonContainer;

@end

@implementation PFMessagesNewVC

+ (PFMessagesNewVC *)_new; {
    
    return [[PFMessagesNewVC alloc] initWithNibName:nil bundle:nil];
}

+ (PFMessagesNewVC *)_new:(NSNumber *)userId
                 username:(NSString *)username; {
    
    PFMessagesNewVC *vc = [[PFMessagesNewVC alloc] initWithNibName:nil bundle:nil];
    [vc setUserId:userId];
    [vc setUsername:username];
    
    return vc;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFMessagesNewViewCell class]
      forCellReuseIdentifier:[PFMessagesNewViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFMessagesTextViewCell class]
      forCellReuseIdentifier:[PFMessagesTextViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setScrollEnabled:NO];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Compose Message", nil)];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 16, 18, 26)];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 0)];
    
    FAKFontAwesome *backIcon = [FAKFontAwesome chevronLeftIconWithSize:18];
    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [backButton setAttributedTitle:[backIcon attributedString] forState:UIControlStateNormal];
    UIBarButtonItem *barBackButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:self
                   action:@selector(popCurrentViewController)
         forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setLeftBarButtonItem:barBackButtonItem];
    [[self navigationItem] setHidesBackButton:YES];
    
    [[[self navigationController] navigationBar] restyleNavigationBarTranslucentBlack];
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer done:^(id sender) {
        
        @strongify(self)
        
        if([self isValidFormSubmission]) {
            [self doSubmit];
        } else {
            [[self subjectTextField] becomeFirstResponder];
        }
    }];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:[self rightBarButtonContainer]]];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kMessageComposePage];
    
    [[self subjectTextField] becomeFirstResponder];
}

- (void) viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kToIndex) {
        
        PFMessagesNewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                       [PFMessagesNewViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFMessagesNewViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:[PFMessagesNewViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setText:[NSString stringWithFormat:@"To: %@", [self username]] animated:YES];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[cell textField] setReturnKeyType:UIReturnKeyNext];
        [[cell textField] setTag:kToIndex];
        [[cell textField] setDelegate:self];
        [[cell textField] setUserInteractionEnabled:NO];
        [[cell textField] setFont:[PFFont fontOfMediumSize]];
        [[cell textField] setTextColor:[PFColor grayColor]];
        [self setSubjectTextField:[cell textField]];
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        return cell;
        
    } else if([indexPath row] == kSubjectIndex) {
        
        PFMessagesNewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                       [PFMessagesNewViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFMessagesNewViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:[PFMessagesNewViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ([[cell textField] respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            
            UIColor *color = [PFColor grayColor];
            [cell textField].attributedPlaceholder =
            [[NSAttributedString alloc] initWithString:@"Subject"
                                            attributes:@{NSForegroundColorAttributeName: color}];
        }
        
        [cell setTextFieldPlaceholder:NSLocalizedString(@"Subject", nil)];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeWords];
        [[cell textField] setReturnKeyType:UIReturnKeyNext];
        [[cell textField] setTag:kSubjectIndex];
        [[cell textField] setDelegate:self];
        [[cell textField] setFont:[PFFont fontOfMediumSize]];
        [[cell textField] setTextColor:[PFColor grayColor]];
        [self setSubjectTextField:[cell textField]];
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
        return cell;
        
    } else if([indexPath row] == kMessageIndex) {
        
        PFMessagesTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        [PFMessagesTextViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFMessagesTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:[PFMessagesTextViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setPlaceholder:NSLocalizedString(@"Message", nil)
                    animated:NO];
        
        [[cell textView] setDelegate:self];
        [[cell textView] setReturnKeyType:UIReturnKeyDefault];
        [[cell textView] setTextColor:[PFColor grayColor]];

        [self setMessageTextView:[cell textView]];
        [[self messageTextView] setAlpha:1.0f];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    switch ([indexPath row]) {
            
        case kToIndex: {
            return 44.0f;
        }
            
        case kSubjectIndex: {
            return 44.0f;
        }
            
        case kMessageIndex: {
            
            CGRect screen = [[UIScreen mainScreen] bounds];
            return screen.size.height - 88.0f;
        }
            
        default: {
            break;
        }
    }
    
    return 0.0f;
}

- (void)keyboardWillShow:(NSNotification *)notification; {
}

- (void)keyboardWillHide:(NSNotification *)notification; {
}

- (void)textViewDidBeginEditing:(UITextField *)textField; {
    
    [self keyboardWillShow:nil];
}

- (void)textViewDidEndEditing:(UITextField *)textField; {
    
    [self keyboardWillHide:nil];
    [self toggleReturnType];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    NSInteger thisLength = [textView.text length] + [text length] - range.length;
    
    return (thisLength > kMaxChars) ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if([self isValidFormSubmission]) {
        [self doSubmit];
    } else {
        if(textField == [self toTextField]) {
            [[self subjectTextField] becomeFirstResponder];
        } else if(textField == [self subjectTextField]) {
            [[self messageTextView] becomeFirstResponder];
        }
    }
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
    
    [self toggleReturnType];
    
    NSInteger thisLength = [[textField text] length] + [string length] - range.length;
    
    return (thisLength > kMaxChars) ? NO : YES;
}

- (BOOL) isValidFormSubmission; {
    
    return ![NSString isNullOrEmpty:[[self subjectTextField] text]] &&
    ![NSString isNullOrEmpty:[[self messageTextView] text]];
}

- (void)toggleReturnType; {
    
    if([self isValidFormSubmission]) {
        [self markReturnTypeGo];
    } else {
        [self markReturnTypeNext];
    }
}

- (void)markReturnTypeNext; {
    
    [[self toTextField] setReturnKeyType:UIReturnKeyNext];
    [[self toTextField] reloadInputViews];
    
    [[self subjectTextField] setReturnKeyType:UIReturnKeyNext];
    [[self subjectTextField] reloadInputViews];
}

- (void)markReturnTypeGo; {
    
    [[self toTextField] setReturnKeyType:UIReturnKeyDefault];
    [[self toTextField] reloadInputViews];
    
    [[self subjectTextField] setReturnKeyType:UIReturnKeyNext];
    [[self subjectTextField] reloadInputViews];
}

- (void)leftBarButtonItemAction:(UIButton *)button; {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)doSubmit; {
    
    @weakify(self);
    
    [self prepareForApi];
    
    [[PFApi shared] postMessage:[self userId]
                        subject:[[self subjectTextField] text]
                        message:[[self messageTextView] text]
                        success:^(PFThread *thread) {
                            
                            @strongify(self);
                            
                            [self returnFromApi];
                            
                            [[PFGoogleAnalytics shared] composedNewMessage];
                            
                            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kThreadSent
                                                                                            object:self
                                                                                          userInfo:@
                             { @"thread" : thread }];
                            [self leftBarButtonItemAction:nil];
                            
                            dispatch_async(dispatch_get_main_queue(), ^{
                                
                                [[self subjectTextField] resignFirstResponder];
                                [[self messageTextView] resignFirstResponder];
                                
                                [self dismissViewControllerAnimated:YES completion:^{
                                }];
                            });
                            
                        } failure:^NSError *(NSError *error) {
                            
                            @strongify(self);
                            
                            [self returnFromApi];
                            
                            [[PFErrorHandler shared] showInErrorBar:error
                                                           delegate:nil
                                                             inView:[self view]
                                                             header:PFHeaderOpaque];
                            return error;
                        }];
}

- (void)popCurrentViewController; {
    
    [[self subjectTextField] resignFirstResponder];
    [[self messageTextView] resignFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)prepareForApi; {
    
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [PFProgressHud hideForView:[self view]];
}

@end
