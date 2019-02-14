//
//  PFErrorView.m
//  Portfolium
//
//  Created by John Eisberg on 9/5/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFErrorView.h"
#import "PFErrorViewCell.h"
#import "PFColor.h"
#import "PFSize.h"

static BOOL kHidden = YES;

@interface PFErrorView ()

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *errors;
@property(nonatomic, weak) id<PFErrorViewDelegate> delegate;

@end

@implementation PFErrorView

+ (BOOL)hidden; {
    
    return kHidden;
}

- (id)initWithErrors:(NSArray *)errors
            delegate:(id<PFErrorViewDelegate>)delegate; {
    
    self = [super initWithFrame:CGRectMake(0, 0, [PFSize screenWidth], 0)];
    
    if (self) {
        
        [self setErrors:errors];
        [self setDelegate:delegate];
        
        [self setBackgroundColor:[PFColor redColorOpaque]];
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:
                                  CGRectMake(0, 0, [PFSize screenWidth], 0)];
        
        [tableView setDelegate:self];
        [tableView setDataSource:self];
        [tableView registerClass:[PFErrorViewCell class]
          forCellReuseIdentifier:[PFErrorViewCell preferredReuseIdentifier]];
        [tableView setBackgroundColor:[UIColor clearColor]];
        [tableView setSeparatorColor:[UIColor clearColor]];
        [tableView setScrollEnabled:NO];
        [self setTableView:tableView];
        [self addSubview:tableView];
    }
    
    return self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
    return [[self errors] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    PFErrorViewCell *cell = [tableView dequeueReusableCellWithIdentifier:
                             [PFErrorViewCell preferredReuseIdentifier]];
    
    if (cell == nil) {
        
        cell = (PFErrorViewCell *)[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:[PFErrorViewCell preferredReuseIdentifier]];
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setError:[[self errors] objectAtIndex:[indexPath row]]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath; {

    NSString *error = [[self errors] objectAtIndex:[indexPath row]];
    
    return [PFErrorViewCell heightForRowAtError:error];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    if([self delegate] && [[self delegate] respondsToSelector:@selector(errorView:selectedAtIndex:)]) {
        
        [[self delegate] errorView:self selectedAtIndex:[indexPath row]];
    
    } else {
        
        [self removeFromSubview:YES];
    }
}

- (void)show:(BOOL)animated; {
    
    kHidden = NO;
    
    if(animated) {
    
        [UIView animateWithDuration:0.5f
                         animations:^{
                             [self doShow];
                         }];
    } else {
        
        [self doShow];
    }
    
    [NSTimer scheduledTimerWithTimeInterval:3.0
                                     target:self
                                   selector:@selector(removeFromSubview:)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)doShow; {
    
    CGRect frame = self.frame;
    frame.size.height = [[self tableView] sizeThatFits:
                         CGSizeMake(frame.size.width, HUGE_VALF)].height;
    
    self.frame = frame;
    
    frame = self.tableView.frame;
    frame.size.height = self.frame.size.height;
    
    self.tableView.frame = frame;
}

- (void)removeFromSubview:(BOOL)animated; {
    
    if(animated || YES) {

        [UIView animateWithDuration:0.5f
                         animations:^{
                             
                             CGRect frame = self.frame;
                             frame.size.height = 0.0f;
                             
                             self.frame = frame;
                             
                             frame = self.tableView.frame;
                             frame.size.height = 0.0f;
                             
                             self.tableView.frame = frame;
                             
                         } completion:^(BOOL finished) {
                             
                             [self removeFromSuperview];
                             kHidden = YES;
                         }];
    } else {
        
        [self removeFromSuperview];
        kHidden = YES;
    }
}

@end
