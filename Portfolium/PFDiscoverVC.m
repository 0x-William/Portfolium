//
//  PFDiscoverVC.m
//  Portfolium
//
//  Created by John Eisberg on 6/15/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFDiscoverVC.h"
#import "PFContentView.h"
#import "PFDiscoverViewItem.h"
#import "PFSystemCategory.h"
#import "UIImageView+PFImageLoader.h"
#import "PFImg.h"
#import "PFImage.h"
#import "PFFont.h"
#import "PFConstraints.h"
#import "PFSearchResultsVC.h"
#import "NSString+PFExtensions.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFStatusBar.h"
#import "PFColor.h"
#import "UIControl+BlocksKit.h"
#import "UITextField+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFCategoryFeedVC.h"
#import "PFNavigationControllerDelegate.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"
#import "PFSize.h"
#import "UIViewController+PFExtensions.h"

static const NSInteger kMaxCharsDefault = 100;

@interface PFDiscoverVC ()

@property(nonatomic, strong) UIView *searchView;
@property(nonatomic, strong) UITextField *searchBar;
@property(nonatomic, strong) UIButton *cancelButton;

@end

@implementation PFDiscoverVC

+ (PFDiscoverVC *)_new; {
    
    PFDiscoverVC *vc = [[PFDiscoverVC alloc] initWithNibName:nil bundle:nil];
    return vc;
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [[self shim] setBackgroundColor:[UIColor whiteColor]];
    [[self shim] setAlpha:0.9];
    
    UIView *border = [[UIView alloc] initWithFrame:
                      CGRectMake(0, [self applicationFrameOffset], [PFSize screenWidth], 0.5)];
    
    [border setBackgroundColor:[PFColor grayColor]];
    [[self shim] addSubview:border];
    
    UIView *searchView = [[UIView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f, [PFSize screenWidth] - [self applicationFrameOffset], 44.0f)];
    
    [searchView setBackgroundColor:[UIColor clearColor]];
    [self setSearchView:searchView];
    
    FAKFontAwesome *searchIcon = [FAKFontAwesome searchIconWithSize:16];
    [searchIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    UIImage *searchIconImage = [searchIcon imageWithSize:CGSizeMake(20, 20)];
    UIImageView *glass = [[UIImageView alloc] initWithFrame:CGRectZero];
   
    [glass setTranslatesAutoresizingMaskIntoConstraints:NO];
    [glass setBackgroundColor:[UIColor clearColor]];
    [glass setContentMode:UIViewContentModeCenter];
    [glass setImage:searchIconImage];
    [[self searchView] addSubview:glass];

    UITextField *searchBar = [[UITextField alloc] initWithFrame:
                              CGRectMake(34.0f, 0.0f, [PFSize screenWidth] - [self applicationFrameOffset], 40.0f)];
    
    [searchBar setBackgroundColor:[UIColor clearColor]];
    [searchBar setDelegate:self];
    [searchBar setAutocorrectionType:UITextAutocorrectionTypeNo];
    [searchBar setSpellCheckingType:UITextSpellCheckingTypeNo];
    [searchBar setFont:[PFFont fontOfMediumSize]];
    [searchBar setTextColor:[PFColor darkGrayColor]];
    [searchBar setBorderStyle:UITextBorderStyleNone];
    [searchBar setTextAlignment:NSTextAlignmentLeft];
    [searchBar setClearButtonMode:UITextFieldViewModeNever];
    [searchBar setReturnKeyType:UIReturnKeySearch];
    [searchBar setTintColor:[UIColor grayColor]];
    [[self searchView] addSubview:searchBar];
    [self setSearchBar:searchBar];
    
    if ([[self searchBar] respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        
        [self searchBar].attributedPlaceholder =
        [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Search Portfolium ... ", nil)
                                        attributes:@{NSForegroundColorAttributeName: [PFColor darkGrayColor]}];
    }
    
    [[self searchView] addConstraints:@[[PFConstraints constrainView:glass
                                                             toWidth:20.0f],
                                        
                                        [PFConstraints constrainView:glass
                                                            toHeight:16.0f],
                                        
                                        [PFConstraints topAlignView:glass
                                                relativeToSuperView:[self searchView]
                                               withDistanceFromEdge:12.0f],
                                        
                                        [PFConstraints leftAlignView:glass
                                                 relativeToSuperView:[self searchView]
                                                withDistanceFromEdge:8.0f],
                                        ]];
    
    [[self navigationItem] setTitleView:[self searchView]];
    
    UIButton *cancelButton =  [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setFrame:CGRectMake(0, 0, 40, 40)];
    [cancelButton setBackgroundColor:[UIColor clearColor]];
    
    FAKFontAwesome *cancelIcon = [FAKFontAwesome timesCircleOIconWithSize:18];
    [cancelIcon addAttribute:NSForegroundColorAttributeName value:[PFColor grayColor]];
    
    [cancelButton setAttributedTitle:[cancelIcon attributedString] forState:UIControlStateNormal];
    [cancelButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 5, 0)];
    
    @weakify(self)
    
    [cancelButton bk_addEventHandler:^(id sender) {
        
        @strongify(self) [self exitSearchMode];
        
    } forControlEvents:UIControlEventTouchUpInside];
    
    [cancelButton setAlpha:0.0f];
    
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    [[self navigationItem] setRightBarButtonItem:cancelItem];
    [self setCancelButton:cancelButton];
}

- (void)viewWillAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [self exitSearchMode];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewDidAppear:animated];
    
    [self exitSearchMode];
    
    [[PFGoogleAnalytics shared] track:kSearchPage];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFSystemCategory *category = [[self dataSource] objectAtIndex:[indexPath row]];
    
    [[self navigationController] pushViewController:(id)[PFCategoryFeedVC _category:category]
                                           animated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string; {
    
    if([string isEqualToString:@"\n"]) {
        
        [self searchBarSearchButtonClicked:textField]; return NO;
        
    } else {
        
        NSInteger thisLength = [textField.text length] + [string length] - range.length;
        
        return (thisLength > kMaxCharsDefault) ? NO : YES;
    }
}

- (void)searchBarSearchButtonClicked:(UITextField *)textField {
    
    NSString *finalText = [[textField text] stringByTrimmingCharactersInSet:
                           [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if([finalText length] > 0) {
        
        [[self searchBar] resignFirstResponder];
        
        PFSearchResultsVC *vc = [PFSearchResultsVC _new:[textField text]];
        [[self navigationController] pushViewController:vc animated:YES];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField; {
    
    [[self cancelButton] setAlpha:1.0f];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self searchBarSearchButtonClicked:textField];
    
    return NO;
}

- (void)exitSearchMode; {
    
    [[self cancelButton] setAlpha:0.0f];
    
    [[self searchBar] setText:[NSString empty]];
    [[self searchBar] resignFirstResponder];
}

@end
