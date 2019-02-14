//
//  PFIndexedListVC.m
//  Portfolium
//
//  Created by John Eisberg on 9/3/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFIndexedListVC.h"
#import "PFIndexable.h"
#import "PFColor.h"
#import "PFFont.h"

static NSString *kCellIdentifier = @"indexable";

@interface PFIndexedListVC ()

@end

@implementation PFIndexedListVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        
        [self setSections:[[NSMutableDictionary alloc] init]];
        [self setFiltered:[[NSMutableArray alloc] init]];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return [[[self sections] allKeys] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return [[[self sections] valueForKey:[[[[self sections] allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]] count];
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section; {
    
    return [[[[self sections] allKeys] sortedArrayUsingSelector:
             @selector(localizedCaseInsensitiveCompare:)]
            objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView; {
    
    return [[[self sections] allKeys] sortedArrayUsingSelector:
            @selector(localizedCaseInsensitiveCompare:)];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:kCellIdentifier];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    id<PFIndexable> indexable = [self indexableAtIndexPath:indexPath];
    
    cell.textLabel.text = [indexable getIndexableName];
    cell.textLabel.textColor = [PFColor textFieldTextColor];
    cell.textLabel.font = [PFFont fontOfLargeSize];
    
    return cell;
}

- (id<PFIndexable>)indexableAtIndexPath:(NSIndexPath *)indexPath; {
    
    id<PFIndexable> indexable = [[[self sections] valueForKey:
                                  [[[[self sections] allKeys] sortedArrayUsingSelector:
                                    @selector(localizedCaseInsensitiveCompare:)] objectAtIndex:[indexPath section]]]
                                 objectAtIndex:[indexPath row]];
    return indexable;
}

- (void)buildSections; {
    
    BOOL found;
    
    [[self sections] removeAllObjects];
    NSArray *target = [self dataSource];
    
    if([self isFiltered]) {
        target = [self filtered];
    }
    
    for (id<PFIndexable> indexable in target) {
        NSString *c = [[indexable getIndexableName] substringToIndex:1]; found = NO;
        for (NSString *str in [[self sections] allKeys]) {
            if ([str isEqualToString:c]) {
                found = YES;
            }
        }
        if (!found) {
            [[self sections] setValue:[[NSMutableArray alloc] init] forKey:c];
        }
    }
    for (id<PFIndexable> indexable in target) {
        [[[self sections] objectForKey:[[indexable getIndexableName] substringToIndex:1]]
         addObject:indexable];
    }
    for (NSString *key in [[self sections] allKeys]) {
        
        [[[self sections] objectForKey:key] sortUsingDescriptors:
         [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                ascending:YES]]];
    }
}

- (void)doFilter:(NSString *)searchText; {
    
    [self setIsFiltering:YES];
    
    if (searchText.length == 0) {
        
        [self setIsFiltered:NO];
        
    } else {
        
        [self setIsFiltered:YES];
        
        [[self filtered] removeAllObjects];
        
        for (id<PFIndexable> indexable in [self dataSource]) {
            
            if ([[[indexable getIndexableName] uppercaseString]
                 hasPrefix:[searchText uppercaseString]]) {
                
                [[self filtered] addObject:indexable];
            }
        }
    }
    
    [self buildSections];
    
    [[self tableView] reloadData];
    
    [self setIsFiltering:NO];
}

@end
