//
//  PFAddEntryVC.m
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAddEntryVC.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "PFSize.h"
#import "PFAddEntryViewCell.h"
#import "PFBarButtonContainer.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFEntry.h"
#import "PFOBBasicsTextViewCell.h"
#import "GCPlaceholderTextView.h"
#import "PFOBEducationViewCell.h"
#import "PFFont.h"
#import "PFSubCategoriesVC.h"
#import "PFCollaboratorsVC.h"
#import "PFCollaborator.h"
#import "NSString+PFExtensions.h"
#import "PFImage.h"
#import "PFApi.h"
#import "PFSystemCategory.h"
#import "PFErrorHandler.h"
#import "UITextView+PFExtensions.h"
#import "NSString+PFExtensions.h"
#import "PFRootViewController.h"
#import "PFGoogleAnalytics.h"
#import "PFSize.h"
#import "BSImagePickerController.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "PFProgressHud.h"
#import "UIView+BlocksKit.h"
#import "PFAddEntryViewItem.h"
#import "PFDetailVC.h"
#import "PFHomeVC.h"
#import "ALAsset+PFExtensions.h"
#import "PFCView.h"
#import "FAKFontAwesome.h"
#import "NSNotificationCenter+MainThread.h"
#import "PFUploadVC.h"
#import "UIImageView+PFImageLoader.h"
#import "PFImageLoader.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UITableView+PFExtensions.h"

#define ACCEPTABLE_CHARACTERS @" ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-"

static const NSInteger kTitleIndex = 0;
static const NSInteger kDescriptionIndex = 2;
static const NSInteger kCategoryIndex = 1;
static const NSInteger kTagsIndex = 3;
static const NSInteger kCollaboratorsIndex = 4;

static const NSInteger kCamera = 0;
static const NSInteger kGallery = 1;

static const NSInteger kMaxImages = 5;

static NSString *kAddReuseIdentifier = @"kAddReuseIdentifier";

static const NSInteger kMaxCharsDefault = 50;
static const NSInteger kMaxCharsDescription = 64000;
static const NSInteger kMaxCharsTags = 100;

@interface PFAddEntryVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *rightBarButtonContainer;
@property(nonatomic, assign) PFEntryType entryType;
@property(nonatomic, weak) UITextField *titleTextField;
@property(nonatomic, weak) GCPlaceholderTextView *informationTextView;
@property(nonatomic, weak) UILabel *subCategoryLabel;
@property(nonatomic, weak) UITextField *tagsTextField;
@property(nonatomic, weak) UILabel *collaboratorsLabel;
@property(nonatomic, strong) NSMutableArray *collaborators;
@property(nonatomic, strong) NSNumber *categoryId;
@property(nonatomic, assign) PFViewControllerState state;
@property(nonatomic, strong) BSImagePickerController *picker;
@property(nonatomic, strong) NSMutableArray *assets;
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) UIView *headerView;
@property(nonatomic, strong) UIImageView *addImagesImageView;
@property(nonatomic, assign) CGFloat currentYOffset;
@property(nonatomic, strong) NSCharacterSet *blockedCharacters;
@property(nonatomic, assign) NSInteger selectedImageIndex;
@property(nonatomic, strong) NSMutableDictionary *imageCache;

@end

@implementation PFAddEntryVC

+ (PFAddEntryVC *) _new:(PFEntryType)entryType; {
    
    PFAddEntryVC *vc = [[PFAddEntryVC alloc] initWithNibName:nil bundle:nil];
    
    [vc setEntryType:entryType];
    [vc setCollaborators:[[NSMutableArray alloc] init]];
    
    return vc;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        BSImagePickerController *picker = [[BSImagePickerController alloc] init];
        [self setPicker:picker];
        
        NSMutableArray *assets = [[NSMutableArray alloc] init];
        [self setAssets:assets];
        
        NSMutableDictionary *imageCache = [[NSMutableDictionary alloc] init];
        [self setImageCache:imageCache];
        
        [self setBlockedCharacters:[[NSCharacterSet characterSetWithCharactersInString:
                                     ACCEPTABLE_CHARACTERS] invertedSet]];
    }
    
    return self;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setBackgroundColor:[PFColor lightGrayColor]];
    [tableView registerClass:[PFAddEntryViewCell class]
      forCellReuseIdentifier:[PFAddEntryViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFOBBasicsTextViewCell class]
      forCellReuseIdentifier:[PFOBBasicsTextViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFOBEducationViewCell class]
      forCellReuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:
                                 CGRectMake(0, 0, [PFSize screenWidth], 220)];
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
                   action:@selector(dismissCurrentViewController)
         forControlEvents:UIControlEventTouchUpInside];
    
    [[self navigationItem] setLeftBarButtonItem:barBackButtonItem];
    [[self navigationItem] setHidesBackButton:YES];
    
    [self setTitle:NSLocalizedString(@"Add Entry", nil)];
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer save:^(id sender) {
        
        @strongify(self)
        
        if([self isValidFormSubmission]) {
            
            [self tellKeyboardToResign];
            [self prepareForApi];
            
            [[PFApi shared] postEntry:[PFEntry entryTypeToString:[self entryType]]
                                title:[[self titleTextField] text]
                           categoryId:[self categoryId]
                          description:[[self informationTextView] text]
                                 tags:[[[self tagsTextField] text] commaDelimit]
                        collaborators:[self buildCollaboratorIdString]
                              fileUrl:@""
                                 file:@""
                        facebookShare:YES
                              success:^(PFEntry *entry) {
                                  
                                  [self returnFromApi];
                                  
                                  [[PFGoogleAnalytics shared] addedEntry:[self entryType]];
                                  
                                  if([[self assets] count] == 0) {
    
                                      [self returnFromApi];
                                      
                                      [self uploadComplete:entry];
                                  
                                  } else {
                                      
                                      [self startImageUpload:entry];
                                  }
                                  
                              } failure:^NSError *(NSError *error) {
                                  
                                  [self returnFromApi];
                                  
                                  [[PFErrorHandler shared] showInErrorBar:error
                                                                 delegate:nil
                                                                   inView:[self view]
                                                                   header:PFHeaderOpaque];
                                  return error;
                              }];
        }
    }];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    [[self rightBarButtonContainer] setAlpha:0.0f];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:[self rightBarButtonContainer]]];
    
    [[self rightBarButtonContainer] setAlpha:0];
    [[self rightBarButtonContainer] setHidden:YES];
    
    UIView *headerView = [[UIView alloc] initWithFrame:
                          CGRectMake(0, 0, [PFSize screenWidth], 110)];
    
    [headerView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *addImagesImageView = [[UIImageView alloc] initWithFrame:
                                       CGRectMake(5, 5, [PFSize screenWidth] - 10, 100)];
    
    [addImagesImageView setContentMode:UIViewContentModeScaleAspectFit];
    [addImagesImageView setBackgroundColor:[UIColor whiteColor]];
    [addImagesImageView setImage:[PFImage imageAddLarge]];
    [addImagesImageView setAlpha:0.0f];
    [addImagesImageView setUserInteractionEnabled:YES];
    
    [addImagesImageView bk_whenTapped:^{
        
        @strongify(self)
        
        [self launchImagePicker];
    }];
    
    [headerView addSubview:addImagesImageView];
    [self setAddImagesImageView:addImagesImageView];
    
    UIView *border = [[UIView alloc] initWithFrame:
                      CGRectMake(0, 109, [PFSize screenWidth], 1.0f)];
    [border setBackgroundColor:[PFColor separatorColor]];
    [headerView addSubview:border];
    
    [self tableView].tableHeaderView = headerView;
    
    [UIView animateWithDuration:1.0 animations:^{
        [addImagesImageView setAlpha:1.0f];
    }];
    
    [self setHeaderView:headerView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    [layout setMinimumInteritemSpacing:10.0f];
    [layout setMinimumLineSpacing:10.0f];
    [layout setSectionInset:UIEdgeInsetsMake(10.0f, 10.0f, 10.0f, 10.0f)];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:
                                        CGRectMake(0, 0, [PFSize screenWidth], 109)
                                                          collectionViewLayout:layout];
    [collectionView setDelegate:self];
    [collectionView setDataSource:self];
    [collectionView setAllowsMultipleSelection:NO];
    [collectionView registerClass:[PFAddEntryViewItem class]
       forCellWithReuseIdentifier:[PFAddEntryViewItem preferredReuseIdentifier]];
    [collectionView registerClass:[UICollectionViewCell class]
       forCellWithReuseIdentifier:kAddReuseIdentifier];
    [collectionView setBackgroundColor:[UIColor whiteColor]];
    [collectionView setShowsHorizontalScrollIndicator:NO];
    [collectionView setShowsVerticalScrollIndicator:NO];
    [collectionView setHidden:YES];
    [self setCollectionView:collectionView];
    
    [[self headerView] addSubview:collectionView];
    
    [RACObserve(self, assets) subscribeNext:^(id _) {
        
        @strongify(self)
        
        if([[self assets] count] == 0) {
            
            [[self collectionView] setHidden:YES];
            
        } else {
            
            [[self collectionView] setHidden:NO];
            [[self collectionView] reloadData];
        }
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [self doIsValidFormSubmission];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kUploadPage];
    
    if([self state] == PFViewControllerLaunching) {
        
        [self setState:PFViewControllerReady];
    }
}

- (void)viewWillDisappear:(BOOL)animated; {
    
    [self tellKeyboardToResign];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setContentInset:UIEdgeInsetsMake([self applicationFrameOffset], 0, 0, 0)];
    
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kTitleIndex) {
        
        PFAddEntryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                    [PFAddEntryViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFAddEntryViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:[PFAddEntryViewCell preferredReuseIdentifier]];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFAddEntryViewCell:cell
                                   text:NSLocalizedString(@"Title", nil)
                                  index:kTitleIndex];
        
        [self setTitleTextField:[cell textField]];
        
        [[cell textField] setReturnKeyType:UIReturnKeyDone];
        [[cell textField] setDelegate:self];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        
        return cell;
        
    } else if([indexPath row] == kDescriptionIndex) {
        
        PFOBBasicsTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                        [PFOBBasicsTextViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFOBBasicsTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                 reuseIdentifier:[PFOBBasicsTextViewCell preferredReuseIdentifier]];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFOBBasicsTextViewCell:cell
                                       text:NSLocalizedString(@"Description", nil)
                                      index:kDescriptionIndex];
        
        [self setInformationTextView:[cell textView]];
        
        [[cell textView] setFont:[PFFont fontOfLargeSize]];
        
        [[cell textView] setReturnKeyType:UIReturnKeyDone];
        [[cell textView] setDelegate:self];
        
        return cell;
        
    } else if([indexPath row] == kCategoryIndex) {
        
        PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                       [PFOBEducationViewCell preferredReuseIdentifier]];
        if (cell == nil) {
            
            cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [[cell label] setTextColor:[UIColor lightGrayColor]];
        
        [cell setLabelText:NSLocalizedString(@"Category", nil) animated:YES];
        [self setSubCategoryLabel:[cell label]];
        
        return cell;
        
    } else if([indexPath row] == kTagsIndex) {
        
        PFAddEntryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                    [PFAddEntryViewCell preferredReuseIdentifier]];
        
        if (cell == nil) {
            
            cell = [[PFAddEntryViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:[PFAddEntryViewCell preferredReuseIdentifier]];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [self animatePFAddEntryViewCell:cell
                                   text:NSLocalizedString(@"Tags", nil)
                                  index:kTagsIndex];
        
        [self setTagsTextField:[cell textField]];
        
        [[cell textField] setReturnKeyType:UIReturnKeyDone];
        [[cell textField] setDelegate:self];
        [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
        [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        
        return cell;
        
    } else if([indexPath row] == kCollaboratorsIndex) {
        
        PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                       [PFOBEducationViewCell preferredReuseIdentifier]];
        if (cell == nil) {
            
            cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
        }
        
        [cell setBackgroundColor:[UIColor whiteColor]];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        
        [[cell label] setTextColor:[UIColor lightGrayColor]];
        
        [cell setLabelText:NSLocalizedString(@"Collaborators", nil) animated:YES];
        [self setCollaboratorsLabel:[cell label]];
        
        return cell;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row] == kDescriptionIndex) {
        
        return 88.0f;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kCategoryIndex) {
        
        [[self navigationController] pushViewController:[PFSubCategoriesVC _new:self]
                                               animated:YES];
        
    } else if([indexPath row] == kCollaboratorsIndex) {
        
        [[self navigationController] pushViewController:[PFCollaboratorsVC _new:self]
                                               animated:YES];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    
    return [[UIView alloc] init];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if([[self assets] count] < kMaxImages) {
        return [[self assets] count] + 1;
    } else {
        return kMaxImages;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row] < [[self assets] count]) {
        
        PFAddEntryViewItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                    [PFAddEntryViewItem preferredReuseIdentifier] forIndexPath:indexPath];
        
        [item setBackgroundColor:[UIColor whiteColor]];
        [item setDelegate:self];
        [item setIndex:[indexPath row]];
        
        id object = [[self assets] objectAtIndex:[indexPath row]];
        
        if([object isKindOfClass:[ALAsset class]]) {
        
            ALAsset *asset = (ALAsset *)object;
            
            UIImage *image = [[self imageCache] objectForKey:
                                [NSString stringWithFormat:@"%lu", (unsigned long)[asset hash]]];
            
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
                                [NSString stringWithFormat:@"%lu", (unsigned long)[asset hash]]];
                            
                            [[item imageView] setImage:image
                                   postProcessingBlock:[PFImageLoader scaleAndRotateImageBlock]];
                        });
                    }
                });
            
            } else {
                
                [[item imageView] setImage:image
                       postProcessingBlock:[PFImageLoader scaleAndRotateImageBlock]];
            }
        
        } else {
            
            UIImage *image = (UIImage *)object;
            
            [[item imageView] setImage:image
                   postProcessingBlock:[PFImageLoader scaleAndRotateImageBlock]];
        }
        
        [item setUserInteractionEnabled:YES];
        
        if([[self assets] count] == 1) {
            
            [item setSelected:YES];
            [item setUserInteractionEnabled:NO];
            [[self collectionView] selectItemAtIndexPath:indexPath
                                                animated:NO
                                          scrollPosition:UICollectionViewScrollPositionNone];
            
            [self setSelectedImageIndex:0];
             
        } else {
            
            if([indexPath row] == [self selectedImageIndex]) {
                
                [item setSelected:YES];
                [[self collectionView] selectItemAtIndexPath:indexPath
                                                    animated:NO
                                              scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        
        return item;
        
    } else {
        
        UICollectionViewCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:
                                      kAddReuseIdentifier forIndexPath:indexPath];
        
        UIButton *add = [UIButton buttonWithType:UIButtonTypeCustom];
        [add setFrame:CGRectMake(20, 10, 40, 40)];
        
        FAKFontAwesome *addIcon = [FAKFontAwesome plusCircleIconWithSize:40];
        [addIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
        
        [add setAttributedTitle:[addIcon attributedString] forState:UIControlStateNormal];
        
        @weakify(self)
        
        [add bk_whenTapped:^{
            
            @strongify(self) [self launchImagePicker];
        }];
        
        [item addSubview:add];
        
        return item;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row] < [[self assets] count]) {
        return CGSizeMake(120, 80);
    } else {
        return CGSizeMake(120, 60);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return NO;
}

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {
    
    NSInteger length = [[textField text] length] + [string length] - range.length;
    
    if(textField == [self tagsTextField]) {
        
        BOOL goodChar = [string rangeOfCharacterFromSet:[self blockedCharacters]].location == NSNotFound;
        BOOL goodLength = (length > kMaxCharsTags) ? NO : YES;
        
        return goodChar && goodLength;
    }
    
    [self doIsValidFormSubmission];
    
    return (length > kMaxCharsDefault) ? NO : YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text; {
    
    if([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
    }
    
    [self doIsValidFormSubmission];
    
    NSInteger thisLength = [textView.text length] + [text length] - range.length;
    
    return (thisLength > kMaxCharsDescription) ? NO : YES;
}

- (void)addCollaborator:(PFCollaborator *)collaborator; {
    
    [[self collaborators] addObject:collaborator];
    
    [[self collaboratorsLabel] setTextColor:[PFColor textFieldTextColor]];
    [[self collaboratorsLabel] setText:[self buildCollaboratorString]];
}

- (void)removeCollaborator:(PFCollaborator *)collaborator; {
    
    [[self collaborators] removeObject:collaborator];
    [[self collaboratorsLabel] setText:[self buildCollaboratorString]];
}

- (BOOL)isCollaborator:(PFCollaborator *)collaborator; {
    
    return [[self collaborators] containsObject:collaborator];
}

- (void)setSubCategory:(PFSystemCategory *)subCategory; {
    
    [[self subCategoryLabel] setTextColor:[PFColor textFieldTextColor]];
    [[self subCategoryLabel] setText:[subCategory name]];
    
    [self setCategoryId:[subCategory categoryId]];
    
    [self doIsValidFormSubmission];
}

- (NSString *)buildCollaboratorString; {
    
    if([[self collaborators] count] == 0) {
        return NSLocalizedString(@"Collaborators", nil);
    }
    
    PFCollaborator *collaborator;
    NSString *collaboratorString = @"";
    NSString *delimiter = @"";
    
    for(int i = (int)[[self collaborators] count] - 1; i >= 0; i--) {
        
        collaborator = [[self collaborators] objectAtIndex:i];
        collaboratorString = [NSString stringWithFormat:@"%@%@ %@",
                              collaboratorString, delimiter, [collaborator name]];
        delimiter = @",";
    }
    
    return [collaboratorString trim];
}

- (NSString *)buildCollaboratorIdString; {
    
    PFCollaborator *collaborator;
    NSString *collaboratorIdString = @"";
    NSString *delimiter = @"";
    
    for(int i = (int)[[self collaborators] count] - 1; i >= 0; i--) {
        
        collaborator = [[self collaborators] objectAtIndex:i];
        collaboratorIdString = [NSString stringWithFormat:@"%@%@%@",
                              collaboratorIdString, delimiter, [collaborator collaboratorId]];
        delimiter = @",";
    }
    
    return [collaboratorIdString trim];
}

- (void)dismissCurrentViewController; {
    
    [self tellKeyboardToResign];
    
    [[self navigationController] dismissViewControllerAnimated:YES completion:^{}];
}

- (void)tellKeyboardToResign; {
    
    [[self titleTextField] resignFirstResponder];
    [[self informationTextView] resignFirstResponder];
    [[self tagsTextField] resignFirstResponder];
}

- (void)doIsValidFormSubmission; {
    
    if([self isValidFormSubmission]) {
        
        [self showDoneButton];
        
    } else {
        
        [self hideDoneButton];
    }
}

- (BOOL)isValidFormSubmission; {
    
    return ![NSString isNullOrEmpty:[[self titleTextField] text]]
    && [[[self informationTextView] text] length] > 0
    && [[self categoryId] integerValue] > 0;
}

- (void)showDoneButton; {
    
    [[self rightBarButtonContainer] setHidden:NO];
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self rightBarButtonContainer] setAlpha:1];
    }];
}

- (void)hideDoneButton; {
    
    [UIView animateWithDuration:0.3 animations:^{
        [[self rightBarButtonContainer] setAlpha:0];
    }];
    
    [[self rightBarButtonContainer] setHidden:YES];
}

- (void)launchImagePicker; {
    
    NSString *cameraButtonName = NSLocalizedString(@"Take Photo", @"");
    NSString *galleryButtonName = NSLocalizedString(@"Choose Existing", @"");
    NSString *cancel = NSLocalizedString(@"Cancel", @"");
    
    NSArray *buttons = [NSArray arrayWithObjects:cameraButtonName, galleryButtonName, nil];
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:cancel
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  [buttons objectAtIndex:0],
                                  [buttons objectAtIndex:1], nil];
    
    [actionSheet showInView:[self view]];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex; {
    
    switch (buttonIndex) {
            
        case kCamera: {
            
#if !TARGET_IPHONE_SIMULATOR
           
            [self doCamera]; break;
#else
#endif
            
        }
            
        case kGallery: {
            
            [self doGallery]; break;
        }
            
        default: {
            break;
        }
    }
}

- (void)doGallery; {
    
    [self presentImagePickerController:[self picker]
                              animated:YES
                            completion:nil
                                toggle:^(ALAsset *asset, BOOL select) {
                                    
                                    if(select) {
                                        
                                        NSMutableArray *kvc = [self mutableArrayValueForKey:@"assets"];
                                        [kvc addObject:asset];
                                        
                                    } else {
                                        
                                        NSMutableArray *kvc = [self mutableArrayValueForKey:@"assets"];
                                        [kvc removeObject:asset];
                                    }
                                    
                                    if([[self assets] count] >= kMaxImages) {
                                        [self dismissViewControllerAnimated:YES completion:nil];
                                    }
                                }
                                cancel:^(NSArray *assets) {
                                    
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                    
                                } finish:^(NSArray *assets) {
                                    
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                }];
}

- (void)doCamera; {
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    [imagePickerController setDelegate:self];
    [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
    
    [self presentViewController:imagePickerController
                       animated:YES
                     completion:^{
                     }];
}

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info; {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSMutableArray *kvc = [self mutableArrayValueForKey:@"assets"];
    [kvc addObject:image];
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)addEntryViewItem:(PFAddEntryViewItem *)item
  requestedToggleAtIndex:(NSInteger)index; {
    
    if(![[item tapButton] isSelected]) {
        
        [item pop:^{
            
            [item setSelected:YES];
            
            [self setSelectedImageIndex:index];
            
            [[self collectionView] selectItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]
                                                animated:NO
                                          scrollPosition:UICollectionViewScrollPositionNone];
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification; {
    
    [self setCurrentYOffset:[[self tableView] contentOffset].y];
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:kTitleIndex inSection:0];
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [[self tableView] scrollToRowAtIndexPath:scrollIndexPath
                                                 atScrollPosition:UITableViewScrollPositionTop
                                                         animated:NO];
                         
                     } completion:^(BOOL finished) {
                     }];
}

- (void)keyboardWillHide:(NSNotification *)notification; {
    
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         [[self tableView] setContentOffset:CGPointMake(0, [self currentYOffset])
                                                   animated:NO];
                         
                     } completion:^(BOOL finished) {
                     }];
}

- (void)prepareForApi; {
    
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [PFProgressHud hideForView:[self view]];
}

- (void)uploadComplete:(PFEntry *)entry; {
    
    NSDictionary *userInfo = @{ @"entry" : entry };
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kEntryAdded
                                                                    object:self
                                                                  userInfo:userInfo];
    [[PFHomeVC shared] launchAddedEntry:[entry entryId]];
    
    [[self navigationController] dismissViewControllerAnimated:YES
                                                    completion:nil];
}

- (void)startImageUpload:(PFEntry *)entry; {
    
    [[entry media] removeAllObjects];
    
    PFUploadVC *vc = [PFUploadVC _new:[self assets]
                                entry:entry
                         defaultIndex:[self selectedImageIndex]
                                cache:[self imageCache]];
    
    [[self cView] addSubview:[vc view]];
    
    [vc startUpload:^{
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [[vc view] setAlpha:0.0f];
            
        } completion:^(BOOL finished) {
            
            if(finished) {
                
                [[vc view] removeFromSuperview];
                [self uploadComplete:entry];
            }
        }];
    }];
}

- (PFCView *)cView; {
    
    return (PFCView *)[self view];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
