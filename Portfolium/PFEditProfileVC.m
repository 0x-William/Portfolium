//
//  PFEditProfileVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/27/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEditProfileVC.h"
#import "PFColor.h"
#import "PFOnboarding.h"
#import "PFOBBasicsImageViewCell.h"
#import "UIImageView+PFImageLoader.h"
#import "PFImage.h"
#import "PFOBBasicsTitleViewCell.h"
#import "PFOBEducationViewCell.h"
#import "PFJoinEmailViewCell.h"
#import "PFOBBasicsTextViewCell.h"
#import "GCPlaceholderTextView.h"
#import "NSString+PFExtensions.h"
#import "PFBarButtonContainer.h"
#import "PFApi.h"
#import "PFAuthenticationProvider.h"
#import "PFUzer.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "UIViewController+PFExtensions.h"
#import "UITableView+PFExtensions.h"
#import "PFErrorHandler.h"
#import "PFMVVModel.h"
#import "PFAuthenticationProvider.h"
#import "BSImagePickerController.h"
#import "PFAviaryVC.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "UIImageView+PFImageLoader.h"
#import "PFProgressHud.h"
#import "PFGoogleAnalytics.h"
#import "IBActionSheet.h"
#import "PFCView.h"
#import "NSDate+PFExtensions.h"
#import "PFSize.h"
#import "UIView+PFExtensions.h"

static const NSInteger kAvatarIndex = 0;
static const NSInteger kCoverIndex = 1;
static const NSInteger kInformationIndex = 2;
static const NSInteger kFirstnameIndex = 3;
static const NSInteger kLastnameIndex = 4;
static const NSInteger kUsernameIndex = 5;
static const NSInteger kLocationIndex = 6;
static const NSInteger kTaglineIndex = 7;
static const NSInteger kTextViewIndex = 8;

static const NSInteger kCamera = 0;
static const NSInteger kGallery = 1;

static const NSInteger kMaxCharsDefault = 100;
static const NSInteger kMaxCharsLocation = 255;
static const NSInteger kMaxCharsTagline = 120;

@interface PFEditProfileVC ()

@property(nonatomic, strong) PFUzer *user;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) UITextField *firstnameTextField;
@property(nonatomic, weak) UITextField *lastnameTextField;
@property(nonatomic, weak) UITextField *usernameTextField;
@property(nonatomic, weak) UITextField *locationTextField;
@property(nonatomic, weak) UITextView *taglineTextView;
@property(nonatomic, strong) UIView *rightBarButtonContainer;
@property(nonatomic, assign) CGFloat currentYOffset;
@property(nonatomic, strong) PFErrorHandlerBlock errorBlock;
@property(nonatomic, weak) UIImageView *avatarImageView;
@property(nonatomic, weak) UIImageView *coverImageView;
@property(nonatomic, strong) BSImagePickerController *picker;
@property(nonatomic, strong) NSArray *assets;
@property(nonatomic, strong) NSString *avatarUrl;

@end

@implementation PFEditProfileVC

+ (PFEditProfileVC *) _new:(PFUzer *)user; {
    
    PFEditProfileVC *vc =  [[PFEditProfileVC alloc] initWithNibName:nil bundle:nil];
    [vc setUser:nil];
    
    BSImagePickerController *picker = [[BSImagePickerController alloc] init];
    [vc setPicker:picker];
    
    return vc;
}

- (void)loadView; {
    
    PFCView *view = [[PFCView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    [view setContentOffset:-[self applicationFrameOffset]];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Edit Profile", nil)];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFOBBasicsImageViewCell class]
      forCellReuseIdentifier:[PFOBBasicsImageViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFOBBasicsTitleViewCell class]
      forCellReuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFOBBasicsTitleViewCell class]
      forCellReuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFJoinEmailViewCell class]
      forCellReuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
    [tableView registerClass:[PFOBBasicsTextViewCell class]
      forCellReuseIdentifier:[PFOBBasicsTextViewCell preferredReuseIdentifier]];
    [tableView setBackgroundColor:[PFColor lightGrayColor]];
    [tableView setSeparatorColor:[PFColor separatorColor]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setAllowsMultipleSelection:NO];
    tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Edit Profile", nil)];
    
    @weakify(self)
    
    [self setErrorBlock:^NSError *(NSError *error) {
        
        @strongify(self)
        
        [[PFErrorHandler shared] showInErrorBar:error
                                       delegate:nil
                                         inView:[self view]
                                         header:PFHeaderShowing];
        return error;
    }];
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer save:^(id sender) {
    
        @strongify(self)
        
        [self prepareForApi];
        
        [[PFOnboarding shared] init:[PFAuthenticationProvider shared]];
        
        NSString *firstname = [NSString empty];
        if([NSString isNullOrEmpty:[[self firstnameTextField] text]]) {
            firstname = [[self user] firstname];
        } else {
            firstname = [[self firstnameTextField] text];
        }
        
        [[PFOnboarding shared] setFirstname:firstname];
        
        NSString *lastname = [NSString empty];
        if([NSString isNullOrEmpty:[[self lastnameTextField] text]]) {
            lastname = [[self user] lastname];
        } else {
            lastname = [[self lastnameTextField] text];
        }
        
        [[PFOnboarding shared] setLastname:lastname];
        
        NSString *username = [NSString empty];
        if([NSString isNullOrEmpty:[[self usernameTextField] text]]) {
            username = [[self user] username];
        } else {
            username = [[self usernameTextField] text];
        }
        
        [[PFOnboarding shared] setUsername:username];
        
        NSString *gender = [NSString empty];
        if([[self user] gender] != nil) {
            gender = [[self user] gender];
        }
        
        [[PFOnboarding shared] setGender:gender];
        
        [[PFOnboarding shared] setLocation:[[self locationTextField] text]];
        [[PFOnboarding shared] setTagline:[[self taglineTextView] text]];
        
        [[PFApi shared] postUserProfile:firstname
                               lastname:lastname
                               username:username
                               location:[[self locationTextField] text]
                                tagline:[[self taglineTextView] text]
                                 gender:gender
                              birthdate:[[self user] birthday]
                                success:^(){
                                    
                                    [self returnFromApi];
                                    
                                    [[PFGoogleAnalytics shared] updatedProfileFromSettings];
                                    
                                    NSString *firstname = [[self firstnameTextField] text];
                                    NSString *lastname = [[self lastnameTextField] text];
                                    NSString *username = [[self usernameTextField] text];
                                    NSString *location = [[self locationTextField] text];
                                    
                                    [[PFMVVModel shared] signalFullname:firstname
                                                               lastname:lastname];
                                    
                                    [[PFMVVModel shared] signalLocation:location];
                                    [[PFMVVModel shared] signalUsername:username];
                                    [[PFOnboarding shared] clear];
                                    
                                    [[PFAuthenticationProvider shared] userUpdatedProfile:firstname
                                                                                 lastname:lastname
                                                                                 username:username
                                                                                 location:location];
                                    [self tellKeyboardToResign];
                                    
                                    [[self navigationController] popViewControllerAnimated:YES];
                                }
                                failure:^NSError *(NSError *error) {
                                    
                                    [self returnFromApi];
                                    
                                    return [self errorBlock](error);
                                }];
    }];
    
    [[PFApi shared] me:^(PFUzer *user) {
    
        @strongify(self)
        
        [self setUser:user];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [[self firstnameTextField] setText:[user firstname]];
            [[self lastnameTextField] setText:[user lastname]];
            [[self usernameTextField] setText:[user username]];
            [[self locationTextField] setText:[user location]];
            [[self taglineTextView] setText:[user tagline]];
            
            PFFilename *filename = [[PFFilename alloc] init];
            [filename setDynamic:[[PFAuthenticationProvider shared] avatarUrl]];
            
            [[self avatarImageView] setImageWithUrl:[filename croppedToSize:CGSizeMake(54, 54)]
                           postProcessingBlock:nil
                              placeholderImage:nil];
            
            [[self coverImageView] setImageWithUrl:[[user cover] url]
                               postProcessingBlock:nil
                                  placeholderImage:nil];
        });
    
    } failure:^NSError *(NSError *error) {
        
        return [self errorBlock](error);
    }];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    [[self rightBarButtonContainer] setAlpha:0.0f];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:[self rightBarButtonContainer]]];
    
    UIView *shim = [[UIView alloc] initWithFrame:CGRectMake(0, -64, [PFSize screenWidth], 64)];
    [shim setBackgroundColor:[UIColor blackColor]];
    [shim setHidden:NO];
    [[self view] addSubview:shim];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kEditProfilePage];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
    
    [[self view] disableScrollsToTopPropertyOnAllSubviews];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    switch ([indexPath row]) {
            
        case kAvatarIndex: {
            
            PFOBBasicsImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                             [PFOBBasicsImageViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFOBBasicsImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:[PFOBBasicsImageViewCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFOBBasicsImageViewCell:cell
                                            text:NSLocalizedString(@"Profile Photo ", nil)
                                           index:kAvatarIndex];
            
            [self setAvatarImageView:[cell avatar]];
            
            return cell;
        }
            
        case kCoverIndex: {
            
            PFOBBasicsImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                             [PFOBBasicsImageViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFOBBasicsImageViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:[PFOBBasicsImageViewCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFOBBasicsImageViewCell:cell
                                            text:NSLocalizedString(@"Cover Photo ", nil)
                                           index:kCoverIndex];
            
            [self setCoverImageView:[cell avatar]];
            
            return cell;
        }
            
        case kInformationIndex: {
            
            PFOBBasicsTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                             [PFOBBasicsTitleViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFOBBasicsTitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [[cell label] setText:NSLocalizedString(@"Information", nil)]; return cell;
        }
            
        case kFirstnameIndex: {
            
            PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFJoinEmailViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
                
                if(![NSString isNullOrEmpty:[[self user] firstname]]) {
                    [[cell textField] setText:[[self user] firstname]];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFJoinEmailViewCell:cell
                                        text:NSLocalizedString(@"first name", nil)
                                       index:kFirstnameIndex];
            
            [[cell textField] setDelegate:self];
            [[cell textField] setReturnKeyType:UIReturnKeyDone];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            [self setFirstnameTextField:[cell textField]];
            
            return cell;
        }
            
        case kLastnameIndex: {
            
            PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFJoinEmailViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
                
                if(![NSString isNullOrEmpty:[[self user] firstname]]) {
                    [[cell textField] setText:[[self user] lastname]];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFJoinEmailViewCell:cell
                                        text:NSLocalizedString(@"last name", nil)
                                       index:kLastnameIndex];
            
            [[cell textField] setDelegate:self];
            [[cell textField] setReturnKeyType:UIReturnKeyDone];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            [self setLastnameTextField:[cell textField]];
            
            return cell;
        }
            
        case kUsernameIndex: {
            
            PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFJoinEmailViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
                
                if(![NSString isNullOrEmpty:[[self user] username]]) {
                    [[cell textField] setText:[[self user] username]];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFJoinEmailViewCell:cell
                                        text:NSLocalizedString(@"username", nil)
                                       index:kUsernameIndex];
            
            [[cell textField] setDelegate:self];
            [[cell textField] setReturnKeyType:UIReturnKeyDone];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            [self setUsernameTextField:[cell textField]];
            
            return cell;
        }
            
        case kLocationIndex: {
            
            PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFJoinEmailViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
                
                if(![NSString isNullOrEmpty:[[self user] firstname]]) {
                    [[cell textField] setText:[[self user] location]];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFJoinEmailViewCell:cell
                                        text:NSLocalizedString(@"location", nil)
                                       index:kLocationIndex];
            
            [[cell textField] setDelegate:self];
            [[cell textField] setReturnKeyType:UIReturnKeyDone];
            [[cell textField] setAutocorrectionType:UITextAutocorrectionTypeNo];
            [[cell textField] setAutocapitalizationType:UITextAutocapitalizationTypeNone];
            
            [self setLocationTextField:[cell textField]];
            
            return cell;
        }
            
        case kTaglineIndex: {
            
            PFOBBasicsTitleViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                             [PFOBBasicsTitleViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFOBBasicsTitleViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                      reuseIdentifier:[PFOBBasicsTitleViewCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [[cell label] setText:NSLocalizedString(@"Tagline", nil)]; return cell;
        }
            
        case kTextViewIndex: {
            
            PFOBBasicsTextViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                            [PFOBBasicsTextViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFOBBasicsTextViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                     reuseIdentifier:[PFOBBasicsTextViewCell preferredReuseIdentifier]];
                
                if(![NSString isNullOrEmpty:[[self user] tagline]]) {
                    [[cell textView] setText:[[self user] tagline]];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [[cell textView] setPlaceholder:
                NSLocalizedString(@"120 characters to say who you are, and what you're going to showcase", nil)];
            
            [[cell textView] setDelegate:self];
            [self setTaglineTextView:[cell textView]];
            
            return cell;
        }
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([indexPath row] == kAvatarIndex) {
        
        return 74;
    }
    
    if([indexPath row] == kCoverIndex) {
        
        return 74;
    }
    
    if([indexPath row] == kTextViewIndex) {
        
        CGRect screen = [[UIScreen mainScreen] bounds];
        CGFloat tableViewSize = (44 * 6);
        
        return screen.size.height - tableViewSize + 100;
    }
    
    return 44.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([indexPath row] == kAvatarIndex) {
        
        [self launchImagePicker];
        
    } else if([indexPath row] == kCoverIndex) {
        
        [self launchImagePicker];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification; {
    
    [self setCurrentYOffset:[[self tableView] contentOffset].y];
    
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:kLocationIndex
                                                      inSection:0];
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

- (void)doAnimateText:(int)movement; {
    
    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: 0.3];
    
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string {
    
    NSInteger length = [[textField text] length] + [string length] - range.length;
    
    NSInteger maxChars = kMaxCharsDefault;
    
    if(textField == [self locationTextField]) {
        maxChars = kMaxCharsLocation;
    }
    
    return (length > maxChars) ? NO : YES;
}

- (BOOL)textView:(UITextView *)textView
    shouldChangeTextInRange:(NSRange)range
    replacementText:(NSString *)text; {
    
    if([text isEqualToString:@"\n"]) {
        
        [[self taglineTextView] resignFirstResponder];
        [[PFOnboarding shared] setTagline:textView.text];
    }
    
    NSInteger thisLength = [textView.text length] + [text length] - range.length;
    
	return (thisLength > kMaxCharsTagline) ? NO : YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    
    [textField resignFirstResponder];
    
    if(textField == [self locationTextField]) {
        
        [[PFOnboarding shared] setLocation:[textField text]];
    }
    
    return YES;
}

- (void)tellKeyboardToResign; {
    
    [[self firstnameTextField] resignFirstResponder];
    [[self lastnameTextField] resignFirstResponder];
    [[self usernameTextField] resignFirstResponder];
    [[self locationTextField] resignFirstResponder];
    [[self taglineTextView] resignFirstResponder];
}

- (void)launchImagePicker; {
    
    [self tellKeyboardToResign];
    
    NSString *cameraButtonName = NSLocalizedString(@"Take Photo", @"");
    NSString *galleryButtonName = NSLocalizedString(@"Choose Existing", @"");
    NSString *cancel = NSLocalizedString(@"Cancel", @"");
    
    NSArray *buttons = [NSArray arrayWithObjects:cameraButtonName, galleryButtonName, nil];
    
    IBActionSheet *actionSheet = [[IBActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:cancel
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:
                                  [buttons objectAtIndex:0],
                                  [buttons objectAtIndex:1], nil];
    
    [actionSheet showInView:self.tabBarController.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex; {
    
    switch (buttonIndex) {
            
        case kCamera: {
            
#if !TARGET_IPHONE_SIMULATOR
            
            [self doCamera]; break;
#else
            int index = (int)[[[self tableView] indexPathForSelectedRow] row];
            [self presentImageCropper:index image:[PFImage avatar]];
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
                                    
                                    [self doPresentViewController:@[ asset ]];
                                }
                                cancel:^(NSArray *assets) {
                                    
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                    
                                } finish:^(NSArray *assets) {
                                    
                                    [self doPresentViewController:assets];
                                }];
}

- (void)doPresentViewController:(NSArray *)assets; {
    
    [self setAssets:assets];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        ALAsset *asset = [assets objectAtIndex:0];
        
        ALAssetRepresentation *rep = [asset defaultRepresentation];
        CGImageRef iref = [rep fullResolutionImage];
        
        UIImage *image = [UIImage imageWithCGImage:iref];
        int index = (int)[[[self tableView] indexPathForSelectedRow] row];
        
        [self presentImageCropper:index image:image];
    }];
}

- (void)presentImageCropper:(int)index image:(UIImage *)image; {
    
    PFAviaryVC *vc = [PFAviaryVC _new:index
                                image:image];
    [vc setDelegate:self];
    
    [[self navigationController] presentViewController:vc
                                              animated:YES
                                            completion:^{
                                            }];
}

- (void)photoEditor:(AFPhotoEditorController *)editor
  finishedWithImage:(UIImage *)image; {
    
    int index = (int)[[[self tableView] indexPathForSelectedRow] row];
    
    if(index == kAvatarIndex) {
        
        [self uploadAvatar:image];
        
    } else {
        
        [self uploadCover:image];
    }
}

- (void)uploadAvatar:(UIImage *)image; {
    
    [[self avatarImageView] setUserInteractionEnabled:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        @weakify(self)
        
        [self prepareForApi];
        
        [[PFApi shared] uploadAvatar:UIImageJPEGRepresentation(image, 0.85)
                                name:[image accessibilityIdentifier]
                             success:^(PFAvatar *avatar) {
                                 
                                 @strongify(self)
                                 
                                 [self returnFromApi];
                                 
                                 [[PFGoogleAnalytics shared] uploadedAvatarFromSettings];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     [[self avatarImageView] setUserInteractionEnabled:YES];
                                     
                                     [[self avatarImageView] setImageWithUrl:[avatar url]
                                                         postProcessingBlock:nil
                                                            placeholderImage:nil];
                                     
                                     [[PFMVVModel shared] signalAvatar:[avatar dynamic]];
                                     [[PFAuthenticationProvider shared] userUpdatedAvatarUrl:[avatar dynamic]];
                                 });
                                 
                             } failure:^NSError *(NSError *error) {
                                 
                                 @strongify(self)
                                 
                                 [self returnFromApi];
                                 
                                 [[self avatarImageView] setUserInteractionEnabled:YES];
                                 
                                 return error;
                             }];
    }];
}

- (void)uploadCover:(UIImage *)image; {
    
    [[self coverImageView] setUserInteractionEnabled:NO];
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        @weakify(self)
        
        [self prepareForApi];
        
        [[PFApi shared] uploadCover:UIImageJPEGRepresentation(image, 0.85)
                               name:[image accessibilityIdentifier]
                            success:^(PFCover *cover) {
                                
                                @strongify(self)
                                
                                [self returnFromApi];
                                
                                [[PFGoogleAnalytics shared] uploadedCoverFromSettings];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    
                                    [[self coverImageView] setUserInteractionEnabled:YES];
                                    
                                    [[self coverImageView] setImageWithUrl:[cover url]
                                                       postProcessingBlock:nil
                                                          placeholderImage:nil];
                                    
                                    [[PFMVVModel shared] signalCover:[cover url]];
                                    [[PFAuthenticationProvider shared] userUpdatedCoverUrl:[cover url]];
                                });
                                
                            } failure:^NSError *(NSError *error) {
                                
                                @strongify(self)
                                
                                [self returnFromApi];
                                
                                [[self coverImageView] setUserInteractionEnabled:YES];
                                
                                return error;
                            }];
    }];
}

- (void)photoEditorCanceled:(AFPhotoEditorController *)editor; {
    
    [self dismissViewControllerAnimated:YES completion:^{
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

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info; {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    int index = (int)[[[self tableView] indexPathForSelectedRow] row];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self presentImageCropper:index image:image];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker; {
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)prepareForApi; {
    
    [[[self navigationController] navigationBar] setUserInteractionEnabled:NO];
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [[[self navigationController] navigationBar] setUserInteractionEnabled:YES];
    [PFProgressHud hideForView:[self view]];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end