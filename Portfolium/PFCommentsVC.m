//
//  PFCommentsVC.m
//  Portfolium
//
//  Created by John Eisberg on 8/9/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCommentsVC.h"
#import "PFContentView.h"
#import "PFCommentsViewCell.h"
#import "PFPagedDatasource.h"
#import "PFComment.h"
#import "PFApi.h"
#import "PFActivityIndicatorView.h"
#import "PFProfileVC.h"
#import "UIImageView+PFImageLoader.h"
#import "TTTAttributedLabel.h"
#import "PFAvatar.h"
#import "PFMVVModel.h"
#import "PFLandingCommentsVC.h"
#import "UIViewController+PFExtensions.h"
#import "TTTAttributedLabel+PFExtensions.h"
#import "PFColor.h"
#import "UITableView+PFExtensions.h"
#import "UINavigationBar+PFExtensions.h"
#import "PFNavigationController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "PFAuthenticationProvider.h"
#import "PFMVVModel.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "GCPlaceholderTextView.h"
#import "PFFont.h"
#import "PFImage.h"
#import "NSString+PFExtensions.h"
#import "PFErrorHandler.h"
#import "NSNotificationCenter+MainThread.h"
#import "UIControl+BlocksKit.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFSize.h"
#import "PFShim.h"
#import "PFProgressHud.h"
#import "PFGoogleAnalytics.h"
#import "FAKFontAwesome.h"

static const NSInteger kMaxCharsDefault = 64000;

static NSString *kEmptyCellIdentifier = @"EmptyCell";

@interface PFCommentsVC ()

@property(nonatomic, strong) NSNumber *entryId;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) PFPagedDataSource *dataSource;
@property(nonatomic, strong) UIView *shim;
@property(nonatomic, assign) BOOL shimmed;
@property(nonatomic, strong) UIView *accessoryView;
@property(nonatomic, strong) UIView *inputAccessoryContentView;
@property(nonatomic, strong) UITextView *commentTextView;
@property(nonatomic, strong) UIButton *submitCommentButton;
@property(nonatomic, assign) CGFloat footerHeight;
@property(nonatomic, assign) CGFloat commentHeight;
@property(nonatomic, assign) PFPagedDataSourceState pageState;

@end

@implementation PFCommentsVC

@synthesize shimmed = _shimmed, pageState;

+ (PFCommentsVC *)_new:(NSNumber *)entryId; {
    
    PFCommentsVC *vc = [[PFCommentsVC alloc] initWithNibName:nil bundle:nil];
    [vc setEntryId:entryId];

    __weak PFCommentsVC *weakVC = vc;
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] commentsByEntryId:[weakVC entryId]
                                                                                              pageNumber:pageNumber
                                                                                                 success:^(NSArray *data) {
                                                                                                     successBlock(data);
                                                                                                 } failure:^NSError *(NSError *error) {
                                                                                                     return error;
                                                                                                 }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    return vc;
}

+ (PFLandingCommentsVC *)_landing:(NSNumber *)entryId; {
    
    PFLandingCommentsVC *vc = [[PFLandingCommentsVC alloc] initWithNibName:nil bundle:nil];
    [vc setEntryId:entryId];
    
    __weak PFCommentsVC *weakVC = vc;
    
    PFPagedDataSource *dataSource = [PFPagedDataSource dataSourceWithPageSize:kDefaultPageSize
                                                                   dataLoader:^(NSInteger pageNumber,
                                                                                PFApiFeedSuccessBlock successBlock,
                                                                                PFApiErrorHandlerBlock failure) {
                                                                       
                                                                       [[PFApi shared] commentsByEntryId:[weakVC entryId]
                                                                                              pageNumber:pageNumber
                                                                                                 success:^(NSArray *data) {
                                                                                                     successBlock(data);
                                                                                                 } failure:^NSError *(NSError *error) {
                                                                                                     return error;
                                                                                                 }];
                                                                   }];
    [dataSource setDelegate:vc];
    [vc setDataSource:dataSource];
    
    [vc setShimmed:YES];
    
    return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    [view setBackgroundColor:[PFColor lighterGrayColor]];
    
    pageState = PFPagedDataSourceStateLoading;
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView registerClass:[PFCommentsViewCell class]
      forCellReuseIdentifier:[PFCommentsViewCell preferredReuseIdentifier]];
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kEmptyCellIdentifier];
    [tableView setBackgroundColor:[PFColor lighterGrayColor]];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setTableFooterView:[UIView new]];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
    
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:
                                  CGRectMake(10.0, 0.0, 310.0,
                                  [[self tabBarController] tabBar].frame.size.height)];
    
    [inputAccessoryView setBackgroundColor:[PFColor lightGrayColor]];
    
    UIView *inputAccessoryContentView = [[UIView alloc] initWithFrame:
                                         CGRectMake(0.0, 0.0, [PFSize screenWidth],
                                         [[self tabBarController] tabBar].frame.size.height)];
    
    [inputAccessoryContentView setBackgroundColor:[PFColor lightGrayColor]];
    [inputAccessoryContentView layer].borderColor = [[PFColor separatorColor] CGColor];
    [inputAccessoryContentView layer].borderWidth = 1.0f;
    [inputAccessoryView addSubview:inputAccessoryContentView];
    [self setInputAccessoryContentView:inputAccessoryContentView];
    
    GCPlaceholderTextView *commentTextView = [[GCPlaceholderTextView alloc]
                                              initWithFrame:CGRectMake(10, 9, [PFSize screenWidth] - 20, 30)];
    
    [commentTextView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [commentTextView setFont:[PFFont fontOfSmallSize]];
    [commentTextView setDelegate:self];
    [commentTextView setPlaceholder:NSLocalizedString(@"Leave positive feedback...", nil)];
    [commentTextView setPlaceholderColor:[PFColor placeholderTextColor]];
    [commentTextView setTextColor:[PFColor textFieldTextColor]];
    [commentTextView layer].cornerRadius = 4.0f;
    [commentTextView layer].borderColor = [[PFColor separatorColor] CGColor];
    [commentTextView layer].borderWidth = 1.0f;
    [commentTextView setAutocorrectionType:UITextAutocorrectionTypeNo];
    [commentTextView setReturnKeyType:UIReturnKeyGo];
    [self setCommentTextView:commentTextView];
    [inputAccessoryContentView addSubview:commentTextView];
    [self setAccessoryView:inputAccessoryView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(commentPosted:)
                                                 name:kCommentPosted
                                               object:nil];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setTitle:NSLocalizedString(@"Comments", nil)];
    
    [self setUpImageBackButtonForShim];
    [self setShim:[PFShim blackOpaqueFor:self]];
    
    [[[self contentView] spinner] startAnimating];
    [[self dataSource] load];
}

- (void)viewDidAppear:(BOOL)animated; {
    
    [super viewWillAppear:animated];
    
    [[PFGoogleAnalytics shared] track:kEntryCommentsPage
                       withIdentifier:[self entryId]];

    [[self view] becomeFirstResponder];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    if (pageState == PFPagedDataSourceStateEmpty) {
        return 1;
    }
    
    return [[self dataSource] numberOfItems];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    // In the future we do not need to add this data to the table - all we have to do is add
    // the views to the content view and set them to 'hidden' is the data source is not empty.
    // We should try and avoid conditionals in the table delegates as this leads to potential
    // race-conditions within the async data loader. We have also 'leaked' datasource state into the
    // controller here - which is was not designed to do.
    
    if (pageState == PFPagedDataSourceStateEmpty) {
        UITableViewCell *emptyCell = [tableView dequeueReusableCellWithIdentifier:kEmptyCellIdentifier];
        
        if (emptyCell == nil) {
            emptyCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEmptyCellIdentifier];
        }

        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, [PFSize screenWidth], 30)];
        label1.font = [PFFont fontOfLargeSize];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"Be the first to";
        label1.textColor = [PFColor grayColor];
        [emptyCell addSubview:label1];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, [PFSize screenWidth], 40)];
        label2.font = [PFFont fontOfLargeSize];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"leave positive feedback";
        label2.textColor = [PFColor grayColor];
        [emptyCell addSubview:label2];
        
        FAKFontAwesome *commentIcon = [FAKFontAwesome commentsIconWithSize:100];
        [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
        UILabel *comment = [[UILabel alloc] initWithFrame:CGRectZero];
        comment.attributedText = [commentIcon attributedString];
        [comment sizeToFit];
        comment.center = CGPointMake([PFSize screenWidth]/2, 150);
        comment.textColor = [PFColor lightGrayColor];
        
        [emptyCell addSubview:comment];
        
        return emptyCell;
    }
    
    PFCommentsViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                               [PFCommentsViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = [[PFCommentsViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:[PFCommentsViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    PFComment *comment = [[self dataSource] itemAtIndex:[indexPath row]];
    
    [cell setDelegate:self];
    [cell setUserId:[comment userId]];
    
    PFFilename *filename = [[PFFilename alloc] init];
    [filename setDynamic:[[PFMVVModel shared] generateAvatarUrl:[comment profile]]];
    
    [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFCommentsViewCell preferredAvatarSize]]
                   postProcessingBlock:nil
                         progressBlock:nil
                      placeholderImage:nil
                                fadeIn:YES];
    @weakify(cell)
    @weakify(comment)
    
    [RACObserve([PFMVVModel shared], avatarUrl) subscribeNext:^(NSString *avatarUrl){
        
        @strongify(cell)
        @strongify(comment)
        
        if([[PFAuthenticationProvider shared] userIdIsLoggedInUser:[comment userId]]) {
            
            PFFilename *filename = [[PFFilename alloc] init];
            [filename setDynamic:avatarUrl];
            
            [[cell avatarView] setImageWithUrl:[filename croppedToSize:[PFCommentsViewCell preferredAvatarSize]]
                           postProcessingBlock:nil
                                 progressBlock:nil
                              placeholderImage:nil
                                        fadeIn:YES];
        }
    }];
    
    [[cell usernameLabel] setText:[[PFMVVModel shared] generateName:[comment profile]]];
    [[cell dateLabel] setDate:[comment createdAt]];
    [cell setComment:[comment comment]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {
    if (pageState == PFPagedDataSourceStateEmpty) {
        return [PFSize screenHeight] - 100;
    }
    PFComment *comment = [[[self dataSource] data] objectAtIndex:[indexPath row]];
    
    return [PFCommentsViewCell heightForRowAtComment:comment];
}

#pragma mark - ADPagedDataSourceDelegate

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didLoadAdditionalItems:(NSInteger)items; {
    
    [[[self contentView] spinner] stopAnimating];
    
    [[self tableView] setSeparatorColor:[PFColor separatorColor]];
    
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:items];
    NSInteger numberOfItems = [dataSource numberOfItems];
    
    for (int i = (int)numberOfItems - (int)items; i < numberOfItems; ++i) {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [UIView setAnimationsEnabled:NO];
    [[self tableView] beginUpdates];
    
    [[self tableView] insertRowsAtIndexPaths:indexPaths
                            withRowAnimation:UITableViewRowAnimationNone];
    
    [[self tableView] endUpdates];
    [UIView setAnimationsEnabled:YES];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
        didRefreshItems:(NSInteger)items; {
    
    [[self tableView] reloadData];
}

- (void)pagedDataSource:(PFPagedDataSource *)dataSource
 didTransitionFromState:(PFPagedDataSourceState)fromState
                toState:(PFPagedDataSourceState)toState; {
    
    pageState = toState;
    
    if (toState == PFPagedDataSourceStateEmpty) {
        [[[self contentView] spinner] stopAnimating];
        [[self tableView] reloadData];
    }
}

- (void)pushUserProfile:(NSNumber *)userId; {
    
    [[self rootNavigationController] pushViewController:[PFProfileVC _new:userId]
                                               animated:YES
                                                   shim:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section; {
    
    return [[UIView alloc] init];
}

- (void)showShim; {
    
    [[self shim] setHidden:NO];
}

- (void)hideShim; {
    
    [[self shim] setHidden:YES];
}

- (BOOL)shimmed; {
    
    return _shimmed;
}

- (void)setShimmed:(BOOL)shimmed; {
    
    _shimmed = shimmed;
}

- (void)keyboardWillShow:(NSNotification *)notification; {
    
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    
    CGFloat keyboardHeight = keyboardFrameBeginRect.size.height +
    [[self tabBarController] tabBar].frame.size.height;
    
    CGFloat contentHeight = [self tableView].contentSize.height;
    
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    if(keyboardHeight + contentHeight > screen.size.height) {
        
        [self setFooterHeight:keyboardHeight - 46.0f - 32.0f];
        
        [[self tableView] beginUpdates];
        [[self tableView] endUpdates];
    }
}

- (void)keyboardWillHide:(NSNotification *)notification; {
}

- (BOOL)canBecomeFirstResponder; {
    
    return YES;
}

- (void)submitCommentButtonAction; {
    
    @weakify(self)
    
    [self prepareForApi];
    
    [[PFApi shared] postComment:[self entryId]
                        comment:[[self commentTextView] text]
                        success:^(PFComment *comment) {
                            
                            @strongify(self)
                            
                            [self returnFromApi];
                            
                            [[PFGoogleAnalytics shared] commentedOnEntryFromDetail];
                            
                            NSDictionary *userInfo = @{ @"entryId" : [self entryId],
                                                        @"comment" : comment };
                            
                            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kCommentPosted
                                                                                            object:self
                                                                                          userInfo:userInfo];
                        } failure:^NSError *(NSError *error) {
                            
                            [self returnFromApi];
                            
                            [[PFErrorHandler shared] showInErrorBar:error
                                                           delegate:nil
                                                             inView:[self view]
                                                             header:PFHeaderShowing];
                            return error;
                        }];
}

- (void)commentPosted:(NSNotification *)notification; {
    
    NSNumber *entryId = [[notification userInfo] objectForKey:@"entryId"];
    PFComment *comment = [[notification userInfo] objectForKey:@"comment"];
    
    if([[self entryId] integerValue] == [entryId integerValue]) {
        
        [self setPageState:PFPagedDataSourceStateReady];
        
        [[[self dataSource] data] insertObject:comment atIndex:0];
        
        [[self tableView] reloadData];
        
        [[self tableView] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        [self resetCommentView];
    }
}

- (void)textViewDidChange:(UITextView *)textView; {
    
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newTextViewSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    
    CGRect newTextViewFrame = textView.frame;
    CGRect newContentViewFrame = textView.superview.frame;
    CGRect newButtonFrame = [self submitCommentButton].frame;
    
    newTextViewFrame.size = CGSizeMake(fmaxf(newTextViewSize.width, fixedWidth),
                                       newTextViewSize.height);
    
    if([self commentHeight] == 0) {
        [self setCommentHeight:newTextViewFrame.size.height];
    }
    
    if([self commentHeight] < newTextViewFrame.size.height) {
        
        newContentViewFrame.origin.y = newContentViewFrame.origin.y - 14.0f;
        newButtonFrame.origin.y = newButtonFrame.origin.y + 14.0f;
        newContentViewFrame.size.height = newContentViewFrame.size.height + 14.0f;
        
        [self setCommentHeight:newTextViewFrame.size.height];
    }
    
    if([self commentHeight] > newTextViewFrame.size.height) {
        
        newContentViewFrame.origin.y = newContentViewFrame.origin.y + 14.0f;
        newButtonFrame.origin.y = newButtonFrame.origin.y - 14.0f;
        newContentViewFrame.size.height = newContentViewFrame.size.height - 14.0f;
        
        [self setCommentHeight:newTextViewFrame.size.height];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
       
        textView.frame = newTextViewFrame;
        textView.superview.frame = newContentViewFrame;
        [self submitCommentButton].frame = newButtonFrame;
    }];
}

- (void)resetCommentView; {
    
    CGRect frame = [self inputAccessoryView].frame;
    frame.size.height = [[self tabBarController] tabBar].frame.size.height;
    [self inputAccessoryContentView].frame = frame;
    
    frame = [self inputAccessoryContentView].frame;
    frame.size.height = [[self tabBarController] tabBar].frame.size.height;
    [self inputAccessoryContentView].frame = frame;
    
    frame = [self commentTextView].frame;
    frame.origin.y = 10.0f;
    frame.size.height = 30.0f;
    [self commentTextView].frame = frame;
    
    frame = [self submitCommentButton].frame;
    frame.origin.y = 10.0f;
    [self submitCommentButton].frame = frame;
    
    [[self commentTextView] setText:[NSString empty]];
    [self setCommentHeight:0.0f];
    
    [[self commentTextView] resignFirstResponder];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text; {
    
    if([text isEqualToString:@"\n"]) {
        
        if(![NSString isNullOrEmpty:[[self commentTextView] text]]) {
            [self submitCommentButtonAction];
        }
        
        return NO;
    }
    
    NSInteger thisLength = [textView.text length] + [text length] - range.length;
    
    return (thisLength > kMaxCharsDefault) ? NO : YES;
}

- (void)prepareForApi; {
    
    [PFProgressHud showForView:[self view]];
}

- (void)returnFromApi; {
    
    [PFProgressHud hideForView:[self view]];
}

- (UIView *)inputAccessoryView; {
    
    return [self accessoryView];
}

- (PFNavigationController *)rootNavigationController; {
    
    return (PFNavigationController *)[self navigationController];
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

- (void)dealloc; {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
