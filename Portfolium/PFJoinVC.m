//
//  PFSignupVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/25/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFJoinVC.h"
#import "PFImage.h"
#import "TTTAttributedLabel.h"
#import "PFFont.h"
#import "PFColor.h"
#import "TTTAttributedLabel+PFExtensions.h"
#import "PFTapGesture.h"
#import "PFJoinEmailVC.h"
#import "UIViewController+PFExtensions.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFFacebook.h"
#import "PFApi.h"
#import "PFLinkedIn.h"
#import "NSString+PFExtensions.h"
#import "PFAuthenticationProvider.h"
#import "PFErrorHandler.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFGoogleAnalytics.h"
#import "UINavigationBar+PFExtensions.h"
#import "UITabBarController+PFExtensions.h"
#import "PFSize.h"
#import "PFProgressHud.h"
#import "FAKFontAwesome.h"


@interface PFJoinVC ()

@property(nonatomic, strong) PFTapGesture *tap;
@property(nonatomic, strong) UIButton *backButton;
@property(nonatomic, strong) UIButton *facebookButton;
@property(nonatomic, strong) UIButton *linkedInButton;
@property(nonatomic, strong) UILabel *joinWithEmailLabel;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;

@end

@implementation PFJoinVC

+ (PFJoinVC *)_new; {
    
    return [[PFJoinVC alloc] initWithNibName:nil bundle:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [imageView setImage:[PFImage join]];
    [imageView setContentMode:UIViewContentModeTop];
    [[self view] addSubview:imageView];
    
    /*
    UIImageView *logo = [[UIImageView alloc] initWithFrame:CGRectMake([PFSize joinVCPFLogo],
                                                                      132, 160, 48)];
    [logo setContentMode:UIViewContentModeScaleAspectFit];
    [logo setImage:[PFImage logo]];
    [[self view] addSubview:logo];
    */
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(10, 34, 36, 26)];
    
    FAKFontAwesome *backIcon = [FAKFontAwesome chevronLeftIconWithSize:18];
    [backIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [backButton setAttributedTitle:[backIcon attributedString] forState:UIControlStateNormal];
    [[self view] addSubview:backButton];
    [self setBackButton:backButton];
    
    
    UIButton *facebookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [facebookButton setFrame:CGRectMake([PFSize joinVCFBLKButton],
                                        [PFSize screenHeight] - 194, 260, 50)];
    
    FAKFontAwesome *facebookIcon = [FAKFontAwesome facebookIconWithSize:24];
    [facebookIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    
    [facebookButton setBackgroundImage:[PFImage facebookButtonBackground]
                              forState:UIControlStateNormal];
    [facebookButton setAttributedTitle:[facebookIcon attributedString] forState:UIControlStateNormal];
    facebookButton.contentEdgeInsets = UIEdgeInsetsMake(8, -214.0f, 5.0f, 5.0f);
    [[self view] addSubview:facebookButton];
    
    
    
    TTTAttributedLabel *facebookLabel = [[TTTAttributedLabel alloc] initWithFrame:
                                         CGRectMake(65, -4, 160, 60)];
    [facebookLabel setFont:[PFFont fontOfMediumSize]];
    [facebookLabel setTextColor:[UIColor whiteColor]];
    [facebookLabel setBackgroundColor:[UIColor clearColor]];
    [facebookLabel setUserInteractionEnabled:NO];
    [facebookLabel setText:NSLocalizedString(@"Join with Facebook", nil)
                  enbolden:NSLocalizedString(@"Facebook", nil)];
    [facebookButton addSubview:facebookLabel];
    
    
    UIButton *linkedInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [linkedInButton setFrame:CGRectMake([PFSize joinVCFBLKButton],
                                        [PFSize screenHeight] - 138, 260, 50)];
    
    FAKFontAwesome *linkedInIcon = [FAKFontAwesome linkedinIconWithSize:24];
    [linkedInIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
    [linkedInButton setBackgroundImage:[PFImage linkedInButtonBackground]
                              forState:UIControlStateNormal];
    [linkedInButton setAttributedTitle:[linkedInIcon attributedString] forState:UIControlStateNormal];
    linkedInButton.contentEdgeInsets = UIEdgeInsetsMake(8, -204.0f, 5.0f, 5.0f);
    [[self view] addSubview:linkedInButton];
    
    TTTAttributedLabel *linkedinLabel = [[TTTAttributedLabel alloc] initWithFrame:
                                         CGRectMake(72, -4, 160, 60)];
    [linkedinLabel setFont:[PFFont fontOfMediumSize]];
    [linkedinLabel setTextColor:[UIColor whiteColor]];
    [linkedinLabel setBackgroundColor:[UIColor clearColor]];
    [linkedinLabel setUserInteractionEnabled:NO];
    [linkedinLabel setText:NSLocalizedString(@"Join with LinkedIn", nil)
                  enbolden:NSLocalizedString(@"LinkedIn", nil)];
    [linkedInButton addSubview:linkedinLabel];
    
    
    TTTAttributedLabel *joinWithEmailLabel = [[TTTAttributedLabel alloc]
                                              initWithFrame:CGRectMake([PFSize joinVCEmailText],
                                                                       [PFSize screenHeight] - 80, 200, 20)];
    [joinWithEmailLabel setAlpha:0.0f];
    [joinWithEmailLabel setTextAlignment:NSTextAlignmentCenter];
    [joinWithEmailLabel setFont:[PFFont fontOfMediumSize]];
    [joinWithEmailLabel setTextColor:[UIColor whiteColor]];
    [joinWithEmailLabel setUserInteractionEnabled:YES];
    [joinWithEmailLabel setText:NSLocalizedString(@"or join with email", nil)
                       enbolden:NSLocalizedString(@"email", nil)];
    [[self view] addSubview:joinWithEmailLabel];
    [self setJoinWithEmailLabel:joinWithEmailLabel];
    
    [UIView animateWithDuration:1.0f animations:^{
        [joinWithEmailLabel setAlpha:1.0];
    }];
    
    @weakify(self)
    
    [backButton bk_addEventHandler:^(id sender) {
        
        @strongify(self) [[self navigationController] popViewControllerAnimated:YES];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
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
                                             
                                             [[PFGoogleAnalytics shared] joinedWithFacebook];
                                             
                                             [[PFAuthenticationProvider shared] loginUser:user
                                                                                 provider:PFAuthenticationProviderFacebook];
                                             
                                         } failure:^NSError *(NSError *error) {
                                             
                                             return [self errorBlock](error);
                                         }];
        } cancel:^{
            
            [self returnFromApi];
            
        } error:^(NSError *error) {
            
            [self returnFromApi];
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
                                             
                                             [[PFGoogleAnalytics shared] joinedWithLinkedIn];
                                             
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
    
    [self setTap:[[PFTapGesture alloc] init:joinWithEmailLabel
                                      block:^(UITapGestureRecognizer *recognizer) {
                                          
                                          @strongify(self)
                                          
                                          [[self navigationController] pushViewController:[PFJoinEmailVC _new]
                                                                                 animated:YES];
                                      }]];
    
    [self setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(self)
        
        [self returnFromApi];
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderHiding];
        return error;
    }];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kJoinPage];
    
    [[self tabBarController] setMainTabBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [super viewWillDisappear:animated];
    
    if(![self isPushingViewController]) {
        
        [[self tabBarController] setMainTabBarHidden:NO animated:YES];
    }
}

- (void)prepareForApi; {
    
    [[self backButton] setEnabled:NO];
    [[self facebookButton] setEnabled:NO];
    [[self linkedInButton] setEnabled:NO];
    [[self joinWithEmailLabel] setUserInteractionEnabled:NO];
    
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [[self backButton] setEnabled:YES];
    [[self facebookButton] setEnabled:YES];
    [[self linkedInButton] setEnabled:YES];
    [[self joinWithEmailLabel] setUserInteractionEnabled:YES];
    
    [PFProgressHud hideForView:[self view]];
}

@end
