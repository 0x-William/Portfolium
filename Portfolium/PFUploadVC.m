//
//  PFUploadVC.m
//  Portfolium
//
//  Created by John Eisberg on 1/7/15.
//  Copyright (c) 2015 Portfolium. All rights reserved.
//

#import "PFUploadVC.h"
#import "PFSize.h"
#import "PFUploadViewCell.h"
#import "UIImageView+PFImageLoader.h"
#import "PFAddEntryVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "PFEntry.h"
#import "PFApi.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "NSString+PFExtensions.h"
#import "UITableView+PFExtensions.h"

#import "PFEntryView.h"

typedef void (^PFCallbackBlock)();

static const CGFloat kPreferredHeight = 70.0f;

@interface PFUploadVC ()

@property(nonatomic, strong) NSArray *assets;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PFEntry *entry;
@property(nonatomic, strong) NSMutableDictionary *imageCache;
@property(nonatomic, assign) NSInteger barrier;
@property(nonatomic, strong) PFCallbackBlock callback;
@property(nonatomic, assign) NSInteger defaultIndex;

@end

@implementation PFUploadVC

+ (PFUploadVC *)_new:(NSArray *)assets
               entry:(PFEntry *)entry
        defaultIndex:(NSInteger)defaultIndex
               cache:(NSMutableDictionary *)cache; {
    
    PFUploadVC *vc = [[PFUploadVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setAssets:assets];
    [vc setEntry:entry];
    [vc setImageCache:cache];
    [vc setBarrier:[[vc assets] count]];
    [vc setDefaultIndex:defaultIndex];
    
    return vc;
}

- (void)loadView; {
    
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [view setBackgroundColor:[PFColor blackColorLessOpaque]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(20, 0, [PFSize screenWidth] - 40,
                                         [[self assets] count] * kPreferredHeight)];
    
    tableView.center = [view center];
    
    [[tableView layer] setBorderColor:[[PFColor darkestGrayColor] CGColor]];
    [[tableView layer] setBorderWidth:1.0f];
    [[tableView layer] setCornerRadius:5.0f];
    [[tableView layer] setMasksToBounds:YES];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setSeparatorColor:[PFColor darkestGrayColor]];
    [tableView registerClass:[PFUploadViewCell class]
      forCellReuseIdentifier:[PFUploadViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[UIColor whiteColor]];
    [view addSubview:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return [[self assets] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFUploadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                [PFUploadViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFUploadViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:[PFUploadViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    
    id object = [[self assets] objectAtIndex:[indexPath row]];
    
    if([object isKindOfClass:[ALAsset class]]) {
        
        ALAsset *asset = (ALAsset *)object;
        
        UIImage *image = [[self imageCache] objectForKey:
                            [NSString stringWithFormat:@"%d", [asset hash]]];
        
        if(!image) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                
                @autoreleasepool {
                    
                    ALAssetRepresentation* rep = [asset defaultRepresentation];
                    CGImageRef iref = [rep fullScreenImage];
                    UIImage* image = [UIImage imageWithCGImage:iref
                                                         scale:[rep scale]
                                                   orientation:UIImageOrientationUp];
                    
                    dispatch_async(dispatch_get_main_queue(), ^(void) {
                        
                        [[self imageCache] setObject:image forKey:
                            [NSString stringWithFormat:@"%d", [asset hash]]];
                        
                        [[cell image] setImage:image
                               postProcessingBlock:[PFImageLoader scaleAndRotateImageBlock]];
                    });
                }
            });
            
        } else {
            
            [[cell image] setImage:image
                   postProcessingBlock:[PFImageLoader scaleAndRotateImageBlock]];
        }
        
    } else {
        
        UIImage *image = (UIImage *)object;
        
        [[cell image] setImage:image
               postProcessingBlock:[PFImageLoader scaleAndRotateImageBlock]];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    return kPreferredHeight;
}

- (void)startUpload:(void(^)())callback; {
    
    [self setCallback:callback];
    
    for(int i = 0; i < [[self assets] count]; i++) {
        
        id object = [[self assets] objectAtIndex:i];
        
        if([object isKindOfClass:[ALAsset class]]) {
            
            ALAsset *asset = (ALAsset *)object;
            
            UIImage *image = [[self imageCache] objectForKey:
                                [NSString stringWithFormat:@"%d", [asset hash]]];
            
            if(!image) {
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    
                    @autoreleasepool {
                        
                        ALAssetRepresentation* rep = [asset defaultRepresentation];
                        CGImageRef iref = [rep fullScreenImage];
                        UIImage* image = [UIImage imageWithCGImage:iref
                                                             scale:[rep scale]
                                                       orientation:UIImageOrientationUp];
                        
                        dispatch_async(dispatch_get_main_queue(), ^(void) {
                            
                            [[self imageCache] setObject:image forKey:
                                [NSString stringWithFormat:@"%d", [asset hash]]];
                            
                            [self doUploadForTag:i image:image];
                        });
                    }
                });
                
            } else {
                
                [self doUploadForTag:i image:image];
            }
            
        } else {
            
            UIImage *image = (UIImage *)object;
            
            [self doUploadForTag:i image:image];
        }
    }
}

- (void)doUploadForTag:(NSInteger)tag image:(UIImage *)image; {
    
    [[PFApi shared] uploadImage:[[self entry] entryId]
                          bytes:UIImageJPEGRepresentation(image, 0.85)
                           name:[NSString empty]
                         dfault:([self defaultIndex] == tag)
                            tag:tag
                       progress:^(NSUInteger bytesWritten,
                                  long long totalBytesWritten,
                                  long long totalBytesExpectedToWrite,
                                  NSInteger tag) {
                           
                           [self handleProgress:totalBytesWritten
                                       expected:totalBytesExpectedToWrite
                                            tag:tag];
                       }
                        success:^(PFMedia *media) {
                            
                            [[[self entry] media] addObject:media];
                            
                            [self notifyBarrier];
                        }
                        failure:^NSError *(NSError *error, NSInteger tag) {
                            
                            [self handleFailure:tag];
                            
                            [self notifyBarrier];
                            
                            return error;
                        }];
}

- (void)handleProgress:(long long)totalBytesWritten
              expected:(long long)totalBytesExpectedToWrite
                   tag:(NSInteger)tag; {
    
    float progress = ((float)totalBytesWritten / totalBytesExpectedToWrite);
    
    PFUploadViewCell *cell = (PFUploadViewCell *)[[self tableView] cellForRowAtIndexPath:
                                                  [NSIndexPath indexPathForRow:tag inSection:0]];
    
    [[cell progressView] setProgress:progress animated:YES];
}

- (void)handleFailure:(NSInteger)tag; {
    
    PFUploadViewCell *cell = (PFUploadViewCell *)[[self tableView] cellForRowAtIndexPath:
                                                  [NSIndexPath indexPathForRow:tag inSection:0]];
    
    [[cell progressView] setProgressTintColor:[PFColor redColorOpaque]];
}

- (void)notifyBarrier; {
    
    [self setBarrier:([self barrier] - 1)];
    
    if([self barrier] == 0) {
        [self callback]();
    }
}

@end
