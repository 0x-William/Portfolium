//
//  PFMenuItems.m
//  Portfolium
//
//  Created by John Eisberg on 6/21/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFMenuItemsVC.h"
#import "PFMenuItemCell.h"
#import "PFMenuVC.h"
#import "PFColor.h"
#import "PFAuthenticationProvider.h"
#import "PFMenuItemCell.h"
#import "PFConstraints.h"
#import "PFMenuFoundations.h"

typedef void (^PFMenuActionBlock)();

@interface PFMenuItemsVC ()

@property (nonatomic, assign) CGSize defaultCellSize;
@property (nonatomic, strong) NSArray *cellDescriptors;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@end

@implementation PFMenuItemsVC

+ (PFMenuItemsVC *)menuItemsVCWithDelegate:(PFMenuVC *)delegate; {
    
    PFMenuItemsVC *top = [[PFMenuItemsVC alloc] initWithNibName:nil bundle:nil];
    [top setDelegate:delegate];
    [top setCellDescriptors:[self topLevelCellDescriptors]];
    
    return top;
}

+ (NSArray *) topLevelCellDescriptors; {
    
    static NSArray *sharedDescriptors;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        sharedDescriptors= @[
                             @[
                                 [PFMenuItemCell cellDescriptorWithTitle:@"Menu 1"
                                                                  action:@selector(menu1:)],
                                 
                                 [PFMenuItemCell cellDescriptorWithTitle:@"Menu 2"
                                                                  action:@selector(menu2:)],
                                 
                                 [PFMenuItemCell cellDescriptorWithTitle:@"Menu 3"
                                                                  action:@selector(menu3:)],
                                 
                                 [PFMenuItemCell cellDescriptorWithTitle:@"Menu 4"
                                                                  action:@selector(menu4:)],
                                 ]
                             ];
#pragma clang diagnostic pop
    });
    
    return sharedDescriptors;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
    }
    
    return self;
}

- (void)loadView; {
    
    [self setView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self setLayout:[[UICollectionViewFlowLayout alloc] init]];
    [[self layout] setScrollDirection:UICollectionViewScrollDirectionVertical];
    [[self layout] setSectionInset:UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
    [[self layout] setMinimumLineSpacing:1.0f];
    
    [self setDefaultCellSize:CGSizeMake(kPFMenuPaneWidth, 45.0f)];
    [self setCollectionView:[[UICollectionView alloc] initWithFrame:CGRectZero
                                               collectionViewLayout:[self layout]]];
    
    [[self collectionView] registerClass:[PFMenuItemCell class]
              forCellWithReuseIdentifier:[PFMenuItemCell preferredReuseIdentifier]];
    
    [[self collectionView] setAlwaysBounceVertical:YES];
    [[self collectionView] setDelegate:self];
    [[self collectionView] setDataSource:self];
    [[self collectionView] setBackgroundColor:[UIColor grayColor]];
    [[self collectionView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [[self collectionView] setScrollsToTop:NO];
    [[self view] addSubview:[self collectionView]];
    
    [[self view] addConstraint:[PFConstraints constrainView:[self collectionView]
                                         toWidthOfSuperView:[self view]
                                                withPadding:0.0f]];
    
    [[self view] addConstraint:[PFConstraints constrainView:[self collectionView]
                                        toHeightOfSuperView:[self view]
                                                withPadding:0.0f]];
    
    [[self view] addConstraint:[PFConstraints bottomAlignView:[self collectionView]
                                          relativeToSuperView:[self view]
                                         withDistanceFromEdge:0.0f]];
    
    [[self view] addConstraint:[PFConstraints horizontallyCenterView:[self collectionView]
                                                         inSuperview:[self view]]];
}

-(NSArray *)cellDescriptors; {
    
    return _cellDescriptors;
}

-(NSDictionary *)cellDescriptorForIndexPath:(NSIndexPath *)indexPath; {
    
    return [[[self cellDescriptors] objectAtIndex:[indexPath section]] objectAtIndex:[indexPath row]];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return [[[self cellDescriptors] objectAtIndex:section] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *descriptor = [self cellDescriptorForIndexPath:indexPath];
    UICollectionViewCell<PFCellDescriptor> *cell = [collectionView dequeueReusableCellWithReuseIdentifier:
                                                    [PFMenuItemCell preferredReuseIdentifier] forIndexPath:indexPath];
    [cell setStateFromDescriptor:descriptor];
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [[self cellDescriptors] count];
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *descriptor = [self cellDescriptorForIndexPath:indexPath];
    NSString *selectorAsString = [descriptor objectForKey:kPFMenuCellDescriptorAction];
    
    if(selectorAsString) {
        
        SEL selector = NSSelectorFromString(selectorAsString);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [[self delegate] performSelector:selector withObject:[self delegate]];
#pragma clang diagnostic pop
    }
    
    PFMenuActionBlock actionBlock = [descriptor objectForKey:kPFMenuCellDescriptorActionBlock];
    
    if(actionBlock) {
        actionBlock();
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath; {
    
    return [self defaultCellSize];
}

@end
