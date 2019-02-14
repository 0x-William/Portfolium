//
//  PFTwitterProvider.m
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTwitterProvider.h"
#import "PFTwitterUtils+NativeTwitter.h"
#import "FHSTwitterEngine.h"
#import "PFTwitter.h"

@implementation PFTwitterProvider

+ (PFTwitterProvider *)shared; {
    
    static dispatch_once_t once;
    static PFTwitterProvider *shared;
    
    dispatch_once(&once, ^{
        
        shared = [[PFTwitterProvider alloc] init];
        
        [shared setTwitterButtonBlock:^(id<PFTwitterProviderDelegate> delegate) {
            
            __weak id<PFTwitterProviderDelegate> weakDelegate = delegate;
            
            [PFTwitterUtils getTwitterAccounts:^(BOOL accountsWereFound,
                                                 NSArray *twitterAccounts) {
                
                [weakDelegate handleTwitterAccounts:twitterAccounts];
            }];
        }];
        
        [shared setHandleTwitterAccountsBlock:^(id<PFTwitterProviderDelegate> delegate, NSArray *twitterAccounts) {
            
            switch ([twitterAccounts count]) {
                    
                case 0: {
                    
                    [[FHSTwitterEngine sharedEngine] permanentlySetConsumerKey:kTwitterConsumerKey
                                                                     andSecret:kTwitterConsumerSecret];
                    
                    UIViewController *loginController = [[FHSTwitterEngine sharedEngine]
                                                         loginControllerWithCompletionHandler:^(BOOL success) {
                        if (success) {
                            [PFTwitter loginUserWithTwitterEngine:delegate];
                        }
                    }];
                    
                    [(id)delegate presentViewController:loginController
                                               animated:YES
                                             completion:nil];
                } break;
                    
                case 1:
                    
                    [delegate onUserTwitterAccountSelection:twitterAccounts[0]]; break;
                    
                default:
                    
                    [delegate setTwitterAccounts:twitterAccounts];
                    [delegate displayTwitterAccounts:twitterAccounts];
                    
                    break;
            }
        }];
        
        [shared setDisplayTwitterAccountsBlock:^(id<PFTwitterProviderDelegate, UIActionSheetDelegate> delegate,
                                                 NSArray *twitterAccounts) {
            
            __block UIActionSheet *selectTwitterAccountsActionSheet =
            
            [[UIActionSheet alloc] initWithTitle:NSLocalizedString(@"Select Twitter Account", nil)
                                        delegate:delegate
                               cancelButtonTitle:nil
                          destructiveButtonTitle:nil
                               otherButtonTitles:nil];
            
            [twitterAccounts enumerateObjectsUsingBlock:^(id twitterAccount,
                                                          NSUInteger idx,
                                                          BOOL *stop) {
                
                [selectTwitterAccountsActionSheet addButtonWithTitle:[twitterAccount username]];
            }];
            
            [selectTwitterAccountsActionSheet setCancelButtonIndex:
                [selectTwitterAccountsActionSheet addButtonWithTitle:
                    NSLocalizedString(@"Cancel", nil)]];
            
            [selectTwitterAccountsActionSheet showInView:[(id)delegate view]];
        }];
        
        [shared setClickedButtonAtIndexBlock:^(id<PFTwitterProviderDelegate> delegate,
                                               UIActionSheet *actionSheet,
                                               NSInteger buttonIndex) {
            
            if (buttonIndex != actionSheet.cancelButtonIndex) {
                [delegate onUserTwitterAccountSelection:delegate.getTwitterAccounts[buttonIndex]];
            }
        }];
    });
    
    return shared;
}

@end