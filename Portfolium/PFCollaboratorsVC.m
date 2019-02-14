//
//  PFCollaboratorsVC.m
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCollaboratorsVC.h"
#import "PFAddEntryVC.h"
#import "PFContentView.h"
#import "UIViewController+PFExtensions.h"
#import "PFColor.h"
#import "PFActivityIndicatorView.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFApi.h"
#import "PFCollaborator.h"
#import "PFAuthenticationProvider.h"
#import "PFFont.h"
#import "FAKFontAwesome.h"
#import "PFSize.h"

static NSString *kCellIdentifier = @"PFCollaboratorsVCCell";

@interface PFCollaboratorsVC ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, weak) PFAddEntryVC *delegate;
@property(nonatomic, strong) UILabel *label1;
@property(nonatomic, strong) UILabel *comment;

@end

@implementation PFCollaboratorsVC

+ (PFCollaboratorsVC *)_new:(PFAddEntryVC *)delegate; {
    
    PFCollaboratorsVC *vc = [[PFCollaboratorsVC alloc] initWithNibName:nil bundle:nil];
    [vc setDelegate:delegate];
    
    return vc;
}

- (void)loadView; {
    
    PFContentView *view = [[PFContentView alloc] initWithFrame:CGRectZero];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setSeparatorColor:[UIColor clearColor]];
    [tableView setSeparatorInset:UIEdgeInsetsMake(0, 20, 0, 20)];
    [tableView setShowsHorizontalScrollIndicator:NO];
    [tableView setShowsVerticalScrollIndicator:NO];
    [tableView setAllowsMultipleSelection:YES];
    [tableView registerClass:[UITableViewCell class]
      forCellReuseIdentifier:kCellIdentifier];
    [view setContentView:tableView];
    [self setTableView:tableView];
    
    [self setView:view];
}

- (void)viewDidLoad; {
    
    [super viewDidLoad];
    
    [self setUpImageBackButton];
    [self setTitle:NSLocalizedString(@"Collaborators", nil)];
    [[self view] setBackgroundColor:[PFColor lightGrayColor]];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, [self applicationFrameOffset] + 20,
                                                                [PFSize screenWidth], 30)];
    label1.font = [PFFont fontOfLargeSize];
    label1.textAlignment = NSTextAlignmentCenter;
    [self setLabel1:label1];
    [label1 setHidden:YES];
    
    label1.textColor = [PFColor grayColor];
    [[self contentView] addSubview:label1];
    
    [self label1].text = @"You currently have no collaborators";
    
    FAKFontAwesome *commentIcon = [FAKFontAwesome userIconWithSize:100];
    [commentIcon addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor]];
    UILabel *comment = [[UILabel alloc] initWithFrame:CGRectZero];
    comment.attributedText = [commentIcon attributedString];
    [comment sizeToFit];
    comment.center = CGPointMake([PFSize screenWidth]/2, [self applicationFrameOffset] + 100);
    comment.textColor = [PFColor lightGrayColor];
    [comment setHidden:YES];
    [self setComment:comment];
    
    [[self contentView] addSubview:comment];
    
    [[[self contentView] spinner] startAnimating];
    
    @weakify(self)
    
    [[PFApi shared] collaborators:[[PFAuthenticationProvider shared] userId]
                          success:^(NSArray *data) {
                              
                              @strongify(self)
                              
                              if([data count] > 0) {
                              
                                  [self setDataSource:data];
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [[[self contentView] spinner] stopAnimating];
                                    
                                      [[self tableView] setSeparatorColor:[PFColor separatorColor]];
                                      
                                      [self buildSections];
                                      [[self tableView] reloadData];
                                  });
                              
                              } else {
                                  
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [[[self contentView] spinner] stopAnimating];
                                      
                                      [[self label1] setHidden:NO];
                                      [[self comment] setHidden:NO];
                                  });
                              }
                              
                          } failure:^NSError *(NSError *error) {
                              
                              @strongify(self)
                              
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                  [[[self contentView] spinner] stopAnimating];
                              });
                              
                              return error;
                          }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    
    id<PFIndexable> indexable = [self indexableAtIndexPath:indexPath];
    
    NSLog(@"dafuq? %@", [indexable getIndexableName]);
    
    cell.textLabel.text = [indexable getIndexableName];
    cell.textLabel.textColor = [PFColor textFieldTextColor];
    cell.textLabel.font = [PFFont fontOfLargeSize];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFCollaborator *collaborator = (PFCollaborator *)[self indexableAtIndexPath:indexPath];
    
    [[self delegate] addCollaborator:collaborator];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFCollaborator *collaborator = (PFCollaborator *)[self indexableAtIndexPath:indexPath];
    
    [[self delegate] removeCollaborator:collaborator];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    id<PFIndexable> indexable = [self indexableAtIndexPath:indexPath];
    
    if([[self delegate] isCollaborator:(PFCollaborator *)indexable]) {
        
        [[self tableView] selectRowAtIndexPath:indexPath
                                      animated:NO
                                scrollPosition:UITableViewScrollPositionNone];
    }
}

- (PFContentView *)contentView; {
    
    return (PFContentView *)[self view];
}

@end
