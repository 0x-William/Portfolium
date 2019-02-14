//
//  PFAppDelegate.h
//  Portfolium
//
//  Created by John Eisberg on 6/8/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PFAuthenticationProvider.h"

@interface PFAppDelegate : UIResponder <UIApplicationDelegate,
                                        PFAuthenticationProviderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSNumber *notifications;
@property (strong, nonatomic) NSNumber *messages;

+ (PFAppDelegate *)shared;

- (void)resetNotifications;

- (void)messageRead;

@end
