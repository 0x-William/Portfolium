//
//  PFIntercom.m
//  Portfolium
//
//  Created by John Eisberg on 12/6/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFIntercom.h"
#import "PFAuthenticationProvider.h"
#import "NSString+PFExtensions.h"
#import "Intercom.h"
#import "PFMVVModel.h"
#import "PFClassification.h"
#import "NSDate+PFExtensions.h"

@implementation PFIntercom

+ (void)init:(PFAuthenticationProvider *)provider
        mvvm:(PFMVVModel *)mvvm; {
    
    [Intercom beginSessionForUserWithUserId:[[provider userId] stringValue]
                                completion:^(NSError *error) {
                                    
                                    if (!error) {
                                        
                                        NSString *gender = [NSString empty];
                                        NSString *phone = [NSString empty];
                                        NSString *birthday = [NSString empty];
                                        NSString *school = [NSString empty];
                                        NSString *major = [NSString empty];
                                        NSString *type = @"unknown";
                                        NSNumber *avatar = @NO;
                                        NSNumber *cover = @YES;
                                        
                                        if(![NSString isNullOrEmpty:[provider gender]]) {
                                            gender = [provider gender];
                                        }
                                        
                                        if(![NSString isNullOrEmpty:[provider phone]]) {
                                            phone = [provider phone];
                                        }
                                        
                                        if([provider birthday] != nil) {
                                            birthday = [[provider birthday] toString];
                                        }
                                        
                                        if(![NSString isNullOrEmpty:[provider school]]) {
                                            school = [provider school];
                                        }
                                        
                                        if(![NSString isNullOrEmpty:[provider major]]) {
                                            major = [provider major];
                                        }
                                        
                                        if([provider type] != nil) {
                                            type = [PFClassification mapType:[PFClassification mapReadable:[provider type]]];
                                        }
                                        
                                        if(![NSString isNullOrEmpty:[provider avatarUrl]]) {
                                            avatar = @YES;
                                        }

                                        if(![NSString isNullOrEmpty:[provider coverUrl]]) {
                                            cover = @YES;
                                        }
                                        
                                        NSNumber *stamp = [NSNumber numberWithLong:
                                                           [[provider createdAt] timeIntervalSince1970]];
                                        
                                        NSDictionary *data = @{ @"email": [provider emailAddress],
                                                                @"user_id": [provider userId],
                                                                @"name": [[PFMVVModel shared] fullname],
                                                                @"created_at": stamp,
                                                                @"custom_attributes": @{
                                                                    @"username": [[PFMVVModel shared] username],
                                                                    @"gender": gender,
                                                                    @"phone": phone,
                                                                    @"birthday": birthday,
                                                                    @"school": school ,
                                                                    @"major": major,
                                                                    @"type": type,
                                                                    @"avatar": avatar,
                                                                    @"cover": cover
                                                                }};
                                        
                                        [Intercom updateUserWithAttributes:data
                                                                completion:^(NSError *error) {
                                                                }];
                                    } else {
                                    }
                                }];
}

@end
