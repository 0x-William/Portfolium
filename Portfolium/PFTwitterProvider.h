//
//  PFTwitterProvider.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

@class ACAccount;
@class PFUser;
@class FHSToken;

@protocol PFTwitterProviderDelegate <NSObject>

- (void)handleTwitterAccounts:(NSArray *)twitterAccounts;
- (void)onUserTwitterAccountSelection:(ACAccount *)twitterAccount;
- (void)setTwitterAccounts:(NSArray *)twitterAccounts;
- (void)displayTwitterAccounts:(NSArray *)twitterAccounts;
- (NSArray *)getTwitterAccounts;
- (void)onLoginUserWithTwitterEngineSuccess:(PFUser *)user token:(FHSToken *)token;
- (void)onLoginUserWithTwitterEngineError:(NSError *)error;

@end

typedef void (^PFTwitterButtonBlock)(id<PFTwitterProviderDelegate> delegate);

typedef void (^PFHandleTwitterAccountsBlock)(id<PFTwitterProviderDelegate> delegate,
                                             NSArray *twitterAccounts);

typedef void (^PFDisplayTwitterAccountsBlock)(id<PFTwitterProviderDelegate, UIActionSheetDelegate> delegate,
                                              NSArray *twitterAccounts);

typedef void (^PFClickedButtonAtIndexBlock)(id<PFTwitterProviderDelegate> delegate,
                                            UIActionSheet *actionSheet,
                                            NSInteger buttonIndex);

@interface PFTwitterProvider : NSObject

+ (PFTwitterProvider *)shared;

@property(nonatomic, strong) PFTwitterButtonBlock twitterButtonBlock;
@property(nonatomic, strong) PFHandleTwitterAccountsBlock handleTwitterAccountsBlock;
@property(nonatomic, strong) PFDisplayTwitterAccountsBlock displayTwitterAccountsBlock;
@property(nonatomic, strong) PFClickedButtonAtIndexBlock clickedButtonAtIndexBlock;

@end