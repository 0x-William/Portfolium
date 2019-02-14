//
//  PFApiTypes.h
//  Portfolium
//
//  Created by John Eisberg on 6/12/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFUzer.h"
#import "PFEntry.h"
#import "PFThread.h"
#import "PFComment.h"
#import "PFAvatar.h"
#import "PFAbout.h"
#import "PFSystemCategory.h"
#import "PFCount.h"

typedef void (^PFApiEmptySuccessBlock)();
typedef void (^PFApiUserSuccessBlock)(PFUzer *user);
typedef void (^PFApiEntrySuccessBlock)(PFEntry *entry);
typedef void (^PFApiThreadSuccessBlock)(PFThread *thread);
typedef void (^PFApiMessageSuccessBlock)(PFMessage *message);
typedef void (^PFApiCommentSuccessBlock)(PFComment *message);
typedef void (^PFApiFeedSuccessBlock)(NSArray *data);
typedef void (^PFApiAvatarUploadSuccessBlock)(PFAvatar *avatar);
typedef void (^PFApiCoverUploadSuccessBlock)(PFCover *cover);
typedef void (^PFApiMediaUploadSuccessBlock)(PFMedia *media);
typedef void (^PFApiAboutSuccessBlock)(PFAbout *about);
typedef void (^PFApiSystemCategorySuccessBlock)(PFSystemCategory *category);
typedef void (^PFApiCountsSuccessBlock)(PFCount *count);
typedef void (^PFApiProgressBlock)(NSUInteger bytesWritten,
                                   long long totalBytesWritten,
                                   long long totalBytesExpectedToWrite,
                                   NSInteger tag);
typedef NSError* (^PFApiErrorHandlerBlock)(NSError *error);
typedef NSError* (^PFApiTaggedErrorHandlerBlock)(NSError *error, NSInteger tag);
typedef NSError* (^PFApiResponseBlock)(NSError *error, NSInteger code);