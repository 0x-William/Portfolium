//
//  PFMessageReplyVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/18/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMessagesReplyVC.h"
#import "PFCView.h"
#import "PFMessagesNewViewCell.h"
#import "PFMessagesTextViewCell.h"
#import "GCPlaceholderTextView.h"
#import "NSString+PFExtensions.h"
#import "PFApi.h"
#import "PFBarButtonContainer.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFImage.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFFont.h"
#import "PFColor.h"
#import "PFErrorHandler.h"
#import "PFProgressHud.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"
#import "ReactiveCocoa/RACEXTScope.h"

static const NSInteger kSubjectIndex = 0;
static const NSInteger kMessageIndex = 1;

static const NSInteger kMaxCharsDefault = 255;
static const NSInteger kMaxCharsBody = 64000;

@interface PFMessagesReplyVC ()

@property(nonatomic, strong) NSNumber *threadId;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) UITextField *subjectTextField;
@property(nonatomic, weak) GCPlaceholderTextView *messageTextView;
@property(nonatomic, strong) UIView *leftBarButtonContainer;
@property(nonatomic, strong) UIView *rightBarButtonContainer;

@end

@implementation PFMessagesReplyVC

+ (PFMessagesReplyVC *)_new:(NSNumber *)threadId
                       name:(NSString *)name; {
    
    PFMessagesReplyVC *vc = [[PFMessagesReplyVC alloc] initWithNibName:nil bundle:nil];
    [vc setThreadId:threadId];
    [vc setName:name];
    
    return vc;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFMessagesNewViewCell class]
      forCellReuseIdentifier:[PFMessagesNewViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setScrollEnabled:NO];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
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
    
    [self setTitle:NSLocalizedString(@"Reply", nil)];
    
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
    
    [[PFGoogleAnalytics shared] track:kMessageReplyPage
                       withIdentifier:[self threadId]];
    
    [UIView animateWithDuration:0.4 animations:^{
        [[self messageTextView] setAlpha:1.0f];
    }];
    
    [[self messageTextView] becomeFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kSubjectIndex) {
        
        PFMessagesNewViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                       [PFMessagesNewViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFMessagesNewViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:[PFMessagesNewViewCell preferredReuseIdentifier]];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        [cell setText:[NSString stringWithFormat:@"Re: %@", [self name]] animated:YES];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [[cell textField] setReturnKeyType:UIReturnKeyNext];
        [[cell textField] setTag:kSubjectIndex];
        [[cell textField] setDelegate:self];
        [[cell textField] setUserInteractionEnabled:NO];
        [[cell textField] setFont:[PFFont fontOfMediumSize]];
        [[cell textField] setTextColor:[PFColor grayColor]];
        [cell setBackgroundColor:[PFColor lightGrayColor]];
        [self setSubjectTextField:[cell textField]];
        
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
        
        [self setMessageTextView:[cell textView]];
        [[self messageTextView] setAlpha:0.0f];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    switch ([indexPath row]) {
            
        case kSubjectIndex: {
            return 44.0f;
        }
            
        case kMessageIndex: {
            
            CGRect screen = [[UIScreen mainScreen] bounds];
            return screen.size.height - 44.0f;
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
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text; {
    
    NSInteger thisLength = [textView.text length] + [text length] - range.length;
    
    return (thisLength > kMaxCharsBody) ? NO : YES;
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
    
    NSInteger thisLength = [[textField text] length] + [string length] - range.length;
    
    return (thisLength > kMaxCharsDefault) ? NO : YES;
}

- (BOOL) isValidFormSubmission; {
    
    return ![NSString isNullOrEmpty:[[self subjectTextField] text]]
    && ![NSString isNullOrEmpty:[[self messageTextView] text]];
    
    return NO;
    
}

- (void)leftBarButtonItemAction:(UIButton *)button; {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)doSubmit; {
    
    [self prepareForApi];
    
    [[PFApi shared] postThread:[self threadId]
                       message:[[self messageTextView] text]
                       success:^(PFMessage *message) {
                           
                           [self returnFromApi];
                           
                           [[PFGoogleAnalytics shared] repliedToMessage];
                           
                           [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kMessageSent
                                                                                           object:self
                                                                                         userInfo:@
                            { @"message" : message }];
                           
                           [self leftBarButtonItemAction:nil];
                           
                       } failure:^NSError *(NSError *error) {
                           
                           [self returnFromApi];
                           
                           [[PFErrorHandler shared] showInErrorBar:error
                                                          delegate:nil
                                                            inView:[self view]
                                                            header:PFHeaderOpaque];
                           return  error;
                       }];
}

- (void)popCurrentViewController; {
    
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

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
