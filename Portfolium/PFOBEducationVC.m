//
//  PFOBEducationVC.m
//  Portfolium
//
//  Created by John Eisberg on 7/29/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFOBEducationVC.h"
#import "PFOnboardingVC.h"
#import "PFOnboarding.h"
#import "PFColor.h"
#import "PFImage.h"
#import "PFOBEducationViewCell.h"
#import "PFIAmAVC.h"
#import "NSString+PFExtensions.h"
#import "PFSchoolsVC.h"
#import "PFBarButtonContainer.h"
#import "PFStudyVC.h"
#import "PFOBBasicsVC.h"
#import "PFOBEducationTextFieldCell.h"
#import "PFApi.h"
#import "UIViewController+PFExtensions.h"
#import "PFAppDelegate.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFErrorHandler.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFSize.h"
#import "PFGoogleAnalytics.h"
#import "PFClassification.h"

static const NSInteger kIIndex = 0;
static const NSInteger kSchoolIndex = 1;
static const NSInteger kStudyIndex = 2;
static const NSInteger kYearIndex = 3;

static const NSInteger kYearsAhead = 10;

@interface PFOBEducationVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSString *email;
@property(nonatomic, strong) UIView *rightBarButtonContainer;
@property(nonatomic, strong) NSArray *years;

@property(nonatomic, weak) UILabel *whoIAmLabel;
@property(nonatomic, weak) UILabel *schoolLabel;
@property(nonatomic, weak) UILabel *fieldOfStudyLabel;
@property(nonatomic, weak) UITextField *graduationYearTextField;

@property(nonatomic, strong) UIPickerView *pickerView;

@end

@implementation PFOBEducationVC

+ (PFOBEducationVC *)_new; {
    
    return [[PFOBEducationVC alloc] initWithNibName:nil bundle:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy"];
        
        NSInteger i2  = [[formatter stringFromDate:[NSDate date]] intValue];
        NSMutableArray *tmp = [[NSMutableArray alloc] init];

        for (int i = 1920; i <= i2 + kYearsAhead; i++) {
            [tmp addObject:[NSString stringWithFormat:@"%d", i]];
        }
        
        [self setYears:[[tmp reverseObjectEnumerator] allObjects]];
    }
    
    return self;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Education", nil)];

    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:
                              CGRectMake(0, 74, [PFSize screenWidth], 180*([PFSize screenWidth]/320))];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setImage:[PFImage education]];
    [[self view] addSubview:imageView];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:
                              CGRectMake(0, 74+180*([PFSize screenWidth]/320), [PFSize screenWidth], (44 * 4))];
    
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setScrollEnabled:NO];
    [tableView setSeparatorColor:[PFColor lightGrayColor]];
    [tableView registerClass:[PFOBEducationViewCell class]
      forCellReuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
    [[self view] addSubview:tableView];
    [self setTableView:tableView];
    
    @weakify(self)
    
    UIView *rightBarButtonContainer = [PFBarButtonContainer _continue:^(id sender) {
        
        @strongify(self)
        
        if([self canContinue]) {
            
            [[PFApi shared] postUserClassification:[[PFOnboarding shared] whoIAm]
                                            school:[[PFOnboarding shared] school]
                                             major:[[PFOnboarding shared] fieldOfStudy]
                                              year:[[PFOnboarding shared] graduationYear]
                                           success:^{
                                               [[self navigationController] pushViewController:[PFOBBasicsVC _new]
                                                                                      animated:YES];
                                           } failure:^NSError *(NSError *error) {
                                               
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
    [[self continueButton] setAlpha:0.0f];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [[[PFAppDelegate shared] window] setBackgroundColor:[PFColor lightGrayColor]];
    
    [[PFOnboardingVC shared] buildTabbarButton:1];
    
    [[self navigationController] setDelegate:(id)[[PFOnboardingVC shared]
                                                  navigationControllerDelegate]];
    
    if([self canChooseEducationInformation]) {
        [[self schoolLabel] setTextColor:[PFColor darkGrayColor]];
    } else {
        [[self schoolLabel] setTextColor:[PFColor textFieldTextColor]];
    }
    
    if([self canChooseEducationInformation]) {
        [[self fieldOfStudyLabel] setTextColor:[PFColor darkGrayColor]];
    } else {
        [[self fieldOfStudyLabel] setTextColor:[PFColor textFieldTextColor]];
    }
    
    if([self canChooseEducationInformation]) {
        [[self graduationYearTextField] setTextColor:[PFColor darkGrayColor]];
    } else {
        [[self graduationYearTextField] setTextColor:[PFColor textFieldTextColor]];
    }
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kOnboardingTypePage];
}

- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    
    if ([[self tableView] respondsToSelector:@selector(setLayoutMargins:)]) {
        [[self tableView] setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {

    switch ([indexPath row]) {
            
        case kIIndex: {
            
            PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                           [PFOBEducationViewCell preferredReuseIdentifier]];
            if (cell == nil) {
                
                cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if([cell respondsToSelector:@selector(setLayoutMargins:)]) {
                [cell setLayoutMargins:UIEdgeInsetsMake(0, 10, 0, 0)];
            }
            
            if([NSString isNullOrEmpty:[[PFOnboarding shared] whoIAm]]) {
                [cell setLabelText:NSLocalizedString(@"I am currently a(n):", nil) animated:YES];
            } else {
                [cell setLabelText:[[PFOnboarding shared] whoIAm] animated:YES];
            }
            
            [self toggleContinueButton];
            [self setWhoIAmLabel:[cell label]]; return cell;
        }
            
        case kSchoolIndex: {
            
            PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                           [PFOBEducationViewCell preferredReuseIdentifier]];
            if (cell == nil) {
                
                cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if([NSString isNullOrEmpty:[[PFOnboarding shared] school]]) {
                [cell setLabelText:NSLocalizedString(@"Select your school", nil) animated:YES];
            } else {
                [cell setLabelText:[[PFOnboarding shared] school] animated:YES];
            }
            
            if([self canChooseEducationInformation]) {
                [[cell label] setTextColor:[PFColor darkGrayColor]];
            } else {
                [[cell label] setTextColor:[PFColor grayColor]];
            }
            
            [self toggleContinueButton];
            [self setSchoolLabel:[cell label]]; return cell;
        }
            
        case kStudyIndex: {
            
            PFOBEducationViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                           [PFOBEducationViewCell preferredReuseIdentifier]];
            if (cell == nil) {
                
                cell = [[PFOBEducationViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                    reuseIdentifier:[PFOBEducationViewCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if([NSString isNullOrEmpty:[[PFOnboarding shared] fieldOfStudy]]) {
                [cell setLabelText:NSLocalizedString(@"Select your major/field of study", nil) animated:YES];
            } else {
                [cell setLabelText:[[PFOnboarding shared] fieldOfStudy] animated:YES];
            }
            
            if([self canChooseEducationInformation]) {
                [[cell label] setTextColor:[PFColor darkGrayColor]];
            } else {
                [[cell label] setTextColor:[PFColor grayColor]];
            }
            
            [self toggleContinueButton];
            [self setFieldOfStudyLabel:[cell label]]; return cell;
        }
            
        case kYearIndex: {
            
            PFOBEducationTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:
                                                [PFOBEducationTextFieldCell preferredReuseIdentifier]];
            if (cell == nil) {
                
                cell = [[PFOBEducationTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                         reuseIdentifier:
                        [PFOBEducationTextFieldCell preferredReuseIdentifier]];
            }
            
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            if([NSString isNullOrEmpty:[[PFOnboarding shared] graduationYear]]) {
                [cell setTextFieldText:NSLocalizedString(@"Select your graduation year", nil) animated:YES];
            } else {
                [cell setTextFieldText:[[PFOnboarding shared] graduationYear] animated:YES];
            }
            
            if([self canChooseEducationInformation]) {
                [[cell textField] setTextColor:[PFColor darkGrayColor]];
            } else {
                [[cell textField] setTextColor:[PFColor grayColor]];
            }
            
            [self toggleContinueButton];
            [self setGraduationYearTextField:[cell textField]];
            [[cell textField] setDelegate:self]; return cell;
        }
            
        default: break;
    }
    
    [self toggleContinueButton];
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    UIViewController *vc;
    
    switch ([indexPath row]) {
            
        case kIIndex:
            
            vc = [PFIAmAVC _new:self]; break;
            
        case kSchoolIndex:
            
            vc = [PFSchoolsVC _new:[[PFOnboarding shared] whoIAm] delegate:self]; break;
            
        case kStudyIndex:
            
            vc = [PFStudyVC _new:self]; break;
            
        case kYearIndex:
            
        default: break;
    }
    
    if(vc != nil) {
    
        [[self navigationController] setDelegate:nil];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section; {
    
    return 0.01f;
}

- (UIToolbar *)getDoneButtonAccessory; {
    
    UIToolbar *keyboardDoneButtonView = [[UIToolbar alloc] init];
    [keyboardDoneButtonView setBarStyle:UIBarStyleBlack];
    [keyboardDoneButtonView setTranslucent:YES];
    [keyboardDoneButtonView setTintColor:nil];
    [keyboardDoneButtonView sizeToFit];
    
    return keyboardDoneButtonView;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if(![self canChooseEducationInformation]) {
        
        if([indexPath row] > 0) {
            return nil;
        }
    }
    
    return indexPath;
}

- (void)didChooseWhoIAm:(NSString *)whoIAm; {
    
    [[PFOnboarding shared] setWhoIAm:whoIAm];
    [[self whoIAmLabel] setText:whoIAm];
    [self toggleContinueButton];
    
    if([whoIAm isEqualToString:kPortfoliumTypeReadable]) {
        [self resetForm];
    }
}

- (void)didChooseSchool:(NSString *)school; {

    [[PFOnboarding shared] setSchool:school];
    [[self schoolLabel] setText:school];
    [self toggleContinueButton];
}

- (void)didChooseFieldOfStudy:(NSString *)fieldOfStudy; {
    
    [[PFOnboarding shared] setFieldOfStudy:fieldOfStudy];
    [[self fieldOfStudyLabel] setText:fieldOfStudy];
    [self toggleContinueButton];
}

- (void)didChooseYear:(NSString *)year; {
    
    [[PFOnboarding shared] setGraduationYear:year];
    [[self graduationYearTextField] setText:year];
    [self toggleContinueButton];
}

- (UIButton *)continueButton; {
    
    return [[[self rightBarButtonContainer] subviews] objectAtIndex:0];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    if([self canChooseEducationInformation]) {
        
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
                                                                      action:@selector(yearDoneClicked:)];
        
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:doneButton, nil]];
        [textField setInputAccessoryView:keyboardDoneButtonView];
        
        if(![NSString isNullOrEmpty:[[PFOnboarding shared] graduationYear]] &&
           [[self years] containsObject:[[PFOnboarding shared] graduationYear]]) {
       
            NSUInteger currentIndex = [[self years] indexOfObject:[[PFOnboarding shared] graduationYear]];
            
            [pickerView selectRow:currentIndex
                      inComponent:0
                         animated:YES];
            
        } else {
         
            [pickerView selectRow:kYearsAhead inComponent:0 animated:YES];
        }
    
    } else {
      
        [textField resignFirstResponder];
    }
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView {
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component; {
    
    return [[self years] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component; {
    
    return [[self years] objectAtIndex:row];
}

- (void)yearDoneClicked:(id)sender {
    
    NSUInteger selectedRow = [[self pickerView] selectedRowInComponent:0];
    NSString *year = [[self years] objectAtIndex:selectedRow];
    
    [[PFOnboarding shared] setGraduationYear:year];
    
    [[self graduationYearTextField] setText:year];
    [[self graduationYearTextField] resignFirstResponder];
    
    [self didChooseYear:year];
}

- (BOOL)canContinue; {
    
    if([[[PFOnboarding shared] whoIAm] isEqualToString:kPortfoliumTypeReadable]) {
        return YES;
    }
    
    if(![NSString isNullOrEmpty:[[PFOnboarding shared] whoIAm]] &&
       ![NSString isNullOrEmpty:[[PFOnboarding shared] school]] &&
       ![NSString isNullOrEmpty:[[PFOnboarding shared] fieldOfStudy]] &&
       ![NSString isNullOrEmpty:[[PFOnboarding shared] graduationYear]]) {
        
        return YES;
    
    } else {
        
        return NO;
    }
}

- (void)toggleContinueButton; {
    
    CGFloat alpha = 0.0f;
    if([self canContinue]) {
        alpha = 1.0f;
    }
    
    [UIView animateWithDuration:1.0f animations:^{
        [[self rightBarButtonContainer] setAlpha:alpha];
        [[self continueButton] setAlpha:alpha];
    }];
}

- (BOOL)canChooseEducationInformation; {
    
    return ![NSString isNullOrEmpty:[[PFOnboarding shared] whoIAm]] &&
            ![[[[PFOnboarding shared] whoIAm] trim] isEqualToString:[kPortfoliumTypeReadable trim]];
}

- (void)resetForm; {
    
    [[self schoolLabel] setText:NSLocalizedString(@"Select your school", nil)];
    [[PFOnboarding shared] setSchool:[NSString empty]];
    
    [[self fieldOfStudyLabel] setText:NSLocalizedString(@"Select your major/field of study", nil)];
    [[PFOnboarding shared] setFieldOfStudy:[NSString empty]];
    
    [[self graduationYearTextField] setText:NSLocalizedString(@"Select your graduation year", nil)];
    [[PFOnboarding shared] setGraduationYear:[NSString empty]];
}

@end
