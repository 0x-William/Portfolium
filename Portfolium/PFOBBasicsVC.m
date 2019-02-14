//
//  PFBasicsVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/31/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOBBasicsVC.h"
#import "PFColor.h"
#import "PFOnboardingVC.h"
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
#import "UIViewController+PFExtensions.h"
#import "PFAppDelegate.h"
#import "PFAppContainerVC.h"
#import "PFHomeVC.h"
#import "PFErrorHandler.h"
#import "UITableView+PFExtensions.h"
#import "PFLocationProvider.h"
#import "UITextField+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "BSImagePickerController.h"
#import "PFAviaryVC.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import "UIImageView+PFImageLoader.h"
#import "PFMVVModel.h"
#import "PFProgressHud.h"
#import "PFSize.h"
#import "PFGoogleAnalytics.h"
#import "IBActionSheet.h"
#import "PFMVVModel.h"
#import "NSDate+PFExtensions.h"

static const NSInteger kAvatarIndex = 0;
static const NSInteger kCoverIndex = 1;
static const NSInteger kInformationIndex = 2;
static const NSInteger kGenderIndex = 3;
static const NSInteger kBirthdayIndex = 4;
static const NSInteger kLocationIndex = 5;
static const NSInteger kTaglineIndex = 6;
static const NSInteger kTextViewIndex = 7;

static const NSInteger kCamera = 0;
static const NSInteger kGallery = 1;

static const NSInteger kMaxCharsDefault = 100;
static const NSInteger kMaxCharsLocation = 255;
static const NSInteger kMaxCharsTagline = 120;

@interface PFOBBasicsVC ()

@property(nonatomic, weak) UIImageView *avatarImageView;
@property(nonatomic, weak) UIImageView *coverImageView;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *genders;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIDatePicker *datePicker;

@property(nonatomic, weak) UITextField *genderTextField;
@property(nonatomic, weak) UITextField *birthdayTextField;
@property(nonatomic, weak) UITextField *locationTextField;
@property(nonatomic, weak) UITextView *taglineTextView;

@property(nonatomic, strong) UIView *rightBarButtonContainer;
@property(nonatomic, strong) NSMutableArray *loaded;
@property(nonatomic, assign) CGFloat currentYOffset;
@property(nonatomic, strong) BSImagePickerController *picker;
@property(nonatomic, strong) NSArray *assets;

@end

@implementation PFOBBasicsVC

+ (PFOBBasicsVC *) _new; {
    
    return [[PFOBBasicsVC alloc] initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setGenders:@[NSLocalizedString(@"male", nil),
                           NSLocalizedString(@"female", nil)]];
        
        BSImagePickerController *picker = [[BSImagePickerController alloc] init];
        [self setPicker:picker];
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Basics", nil)];
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, 0, [PFSize screenWidth], [PFSize screenHeight])];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setBackgroundColor:[PFColor lightGrayColor]];
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
    [[self view] addSubview:tableView];
    [self setTableView:tableView];
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer done:^(id sender) {
    
        @strongify(self)
        
        [self prepareForApi];
        
        [[PFOnboarding shared] setLocation:[[self locationTextField] text]];
        [[PFOnboarding shared] setTagline:[[self taglineTextView] text]];
        
        [[PFApi shared] postUserProfile:[[PFAuthenticationProvider shared] firstname]
                               lastname:[[PFAuthenticationProvider shared] lastname]
                               username:[[PFAuthenticationProvider shared] username]
                               location:[[PFOnboarding shared] location]
                                tagline:[[PFOnboarding shared] tagline]
                                 gender:[[PFOnboarding shared] gender]
                              birthdate:[[PFOnboarding shared] birthdate]
                                success:^() {
                                    
                                    [self returnFromApi];
                                    
                                    [[PFGoogleAnalytics shared] updatedProfileFromOnboarding];
                                    
                                    [[PFAppContainerVC shared] setRootViewController:[PFHomeVC _new]
                                                                           animation:PFAppContainerAnimationSlideLeft];
                                    
                                    [[PFAuthenticationProvider shared] setOnboarded:YES];
                                    [[PFOnboarding shared] clear];
                                }
                                failure:^NSError *(NSError *error) {
                                    
                                    [self returnFromApi];
                                    
                                    [[PFErrorHandler shared] showInErrorBar:error
                                                                   delegate:nil
                                                                     inView:[self view]
                                                                     header:PFHeaderOpaque];
                                    return error;
                                }];
    }];
    
    [self setRightBarButtonContainer:rightBarButtonContainer];
    [[self rightBarButtonContainer] setAlpha:0.0f];
    [[self navigationItem] setRightBarButtonItem:[[UIBarButtonItem alloc]
                                                  initWithCustomView:[self rightBarButtonContainer]]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[PFLocationProvider shared] alert];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [[[PFAppDelegate shared] window] setBackgroundColor:[PFColor lightGrayColor]];
    
    [[PFOnboardingVC shared] buildTabbarButton:2];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kOnboardingProfilePage];
}

- (void)viewDidLayoutSubviews; {
    
    [super viewDidLayoutSubviews];
    
    [[self tableView] setSeparatorInsetZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 8;
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
            
            if([[PFMVVModel shared] avatarUrl] != nil) {
                
                PFFilename *filename = [[PFFilename alloc] init];
                [filename setDynamic:[[PFMVVModel shared] avatarUrl]];
                
                [[cell avatar] setImageWithUrl:[filename croppedToSize:CGSizeMake(50, 50)]
                           postProcessingBlock:nil
                              placeholderImage:nil];
            } else {
                
                [[cell avatar] setImage:[PFImage avatar]];
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
            
            if([[PFMVVModel shared] coverUrl] != nil) {
                
                [[cell avatar] setImageWithUrl:[[PFMVVModel shared] coverUrl]
                           postProcessingBlock:nil
                              placeholderImage:nil];
            } else {
                
                [[cell avatar] setImage:[PFImage cover]];
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
            
        case kGenderIndex: {
            
            PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFOBEducationViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
                
                if(![NSString isNullOrEmpty:[[PFOnboarding shared] gender]]) {
                    [[cell textField] setText:[[PFOnboarding shared] gender]];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFJoinEmailViewCell:cell
                                        text:NSLocalizedString(@"Gender", nil)
                                       index:kGenderIndex];
            
            [[cell textField] setDelegate:self];
            [self setGenderTextField:[cell textField]];
            
            return cell;
        }
            
        case kBirthdayIndex: {
            
            PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                           [PFJoinEmailViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
                
                if([[PFOnboarding shared] birthdate] != nil) {
                    
                    [[cell textField] setText:[[[PFOnboarding shared] birthdate]
                                               apiDateFormatToReadableString]];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFJoinEmailViewCell:cell
                                        text:NSLocalizedString(@"Birthday", nil)
                                       index:kBirthdayIndex];
            
            [[cell textField] setDelegate:self];
            [self setBirthdayTextField:[cell textField]];
            
            return cell;
        }
            
        case kLocationIndex: {
            
            PFJoinEmailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                         [PFJoinEmailViewCell preferredReuseIdentifier]];
            
            if (cell == nil) {
                
                cell = [[PFJoinEmailViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                  reuseIdentifier:[PFJoinEmailViewCell preferredReuseIdentifier]];
                
                if(![NSString isNullOrEmpty:[[PFOnboarding shared] location]]) {
                    
                    [[cell textField] setText:[[PFOnboarding shared] location]];
                    
                } else {
                    
                    @weakify(cell)
                    
                    [[PFLocationProvider shared] startUpdatingLocation:^(NSString *location) {
                        
                        @strongify(cell) [[cell textField] setText:location];
                    }];
                }
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsZero];
            }
            
            [self animatePFJoinEmailViewCell:cell
                                        text:NSLocalizedString(@"Location", nil)
                                       index:kLocationIndex];
            
            [[cell textField] setDelegate:self];
            [[cell textField] setReturnKeyType:UIReturnKeyDone];
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
                
                if(![NSString isNullOrEmpty:[[PFOnboarding shared] tagline]]) {
                    [[cell textView] setText:[[PFOnboarding shared] tagline]];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
    replacementString:(NSString *)string; {
    
    NSInteger thisLength = [textField.text length] + [string length] - range.length;
    
    NSInteger maxChars = kMaxCharsDefault;
    
    if(textField == [self locationTextField]) {
        maxChars = kMaxCharsLocation;
    }
    
    return (thisLength > maxChars) ? NO : YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
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

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if(textField == [self genderTextField]) {
        
        UIPickerView* pickerView = [[UIPickerView alloc] init];
        [pickerView sizeToFit];
        [pickerView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [pickerView setDelegate:self];
        [pickerView setDataSource:self];
        [pickerView setShowsSelectionIndicator:YES];
        [self setPickerView:pickerView];
        
        [textField setInputView:pickerView];
        
        UIToolbar* keyboardDoneButtonView = [self getDoneButtonAccessory];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(genderDoneClicked:)];
        
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        [textField setInputAccessoryView:keyboardDoneButtonView];
        
        if(![NSString isNullOrEmpty:[[PFOnboarding shared] gender]] &&
           [[self genders] containsObject:[[PFOnboarding shared] gender]]) {
            
            NSUInteger currentIndex = [[self genders] indexOfObject:[[PFOnboarding shared] gender]];
            
            [pickerView selectRow:currentIndex
                      inComponent:0
                         animated:YES];
            
        }
    }
    
    if(textField == [self birthdayTextField]) {
        
        UIDatePicker *datePicker = [[UIDatePicker alloc] init];
        [datePicker setDatePickerMode:UIDatePickerModeDate];
        [datePicker sizeToFit];
        [datePicker setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
        [self setDatePicker:datePicker];

        [textField setInputView:datePicker];
        
        UIToolbar* keyboardDoneButtonView = [self getDoneButtonAccessory];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(dateDoneClicked:)];
        
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        [textField setInputAccessoryView:keyboardDoneButtonView];
        
        if([[PFOnboarding shared] birthdate] != nil) {
            [datePicker setDate:[[PFOnboarding shared] birthdate]];
        }
    }
}

- (UIToolbar *)getDoneButtonAccessory; {
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView setBarStyle:UIBarStyleBlack];
    [keyboardDoneButtonView setTranslucent:YES];
    [keyboardDoneButtonView setTintColor:nil];
    [keyboardDoneButtonView sizeToFit];
    
    return keyboardDoneButtonView;
}

- (void)genderDoneClicked:(id)sender {
    
    NSUInteger selectedRow = [[self pickerView] selectedRowInComponent:0];
    NSString *gender = [[self genders] objectAtIndex:selectedRow];
    
    [[PFOnboarding shared] setGender:gender];
    
    [[self genderTextField] setText:gender];
    [[self genderTextField] resignFirstResponder];
}

- (void)dateDoneClicked:(id)sender {
    
    [[PFOnboarding shared] setBirthdate:[[self datePicker] date]];
    
    [[self birthdayTextField] setText:[[[self datePicker] date] apiDateFormatToReadableString]];
    [[self birthdayTextField] resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)pickerView; {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component; {
    
    return [[self genders] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component; {
    
    return [[self genders] objectAtIndex:row];
}

- (void)tellKeyboardToResign; {
    
    [[self genderTextField] resignFirstResponder];
    [[self birthdayTextField] resignFirstResponder];
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
    
    [actionSheet showInView:[[self tabBarController] view]];
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
                                 
                                 [[PFGoogleAnalytics shared] uploadedAvatarFromOnboarding];
                                 
                                 dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     [[self avatarImageView] setUserInteractionEnabled:YES];
                                     
                                     [[self avatarImageView] setImageWithUrl:[avatar url]
                                                         postProcessingBlock:nil
                                                            placeholderImage:nil];
                                     
                                     [[PFAuthenticationProvider shared] userUpdatedAvatarUrl:[avatar url]];
                                     [[PFMVVModel shared] signalAvatar:[avatar url]];
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
                                
                                [[PFGoogleAnalytics shared] uploadedCoverFromOnboarding];
                                
                                dispatch_async(dispatch_get_main_queue(), ^{
                                     
                                     [[self coverImageView] setUserInteractionEnabled:YES];
                                     
                                     [[self coverImageView] setImageWithUrl:[cover url]
                                                        postProcessingBlock:nil
                                                           placeholderImage:nil];
                                    
                                    [[PFAuthenticationProvider shared] userUpdatedCoverUrl:[cover url]];
                                    [[PFMVVModel shared] signalCover:[cover url]];
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
    
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [PFProgressHud hideForView:[self view]];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
