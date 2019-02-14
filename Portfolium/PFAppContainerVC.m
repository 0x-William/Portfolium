//
//  PFAppContainerVC.m
//  Portfolium
//
//  Created by John Eisberg on 6/19/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFAppContainerVC.h"
#import "PFAuthenticationProvider.h"
#import "PFHomeVC.h"
#import "PFMenuVC.h"
#import "PFMenuItemsVC.h"
#import "PFMenuFoundations.h"

typedef NS_ENUM(NSInteger, PFMenuState) {
    
    PFMenuStateOpen,
    PFMenuStateClosed,
    PFMenuStateAnimatingOpen,
    PFMenuStateAnimatingClosed,
};

static const CGFloat kPFMenuSlideAnimationDuration = 0.25f;

static CGFloat defaultMenuVelocity() {
    return kPFMenuPaneWidth / kPFMenuSlideAnimationDuration;
}

@interface PFAppContainerVC()

@property (nonatomic, assign) PFMenuState menuState;
@property (nonatomic, strong) UIView *appContainer;
@property (nonatomic, strong) UIView *mainPane;
@property (nonatomic, strong) UIView *menuPane;
@property (nonatomic, strong) UIPanGestureRecognizer *dragRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) NSNumber *lastChangeVelocity;
@property (nonatomic, assign) BOOL menuEnabled;
@property (nonatomic, strong) UINavigationController *navigationController;

@end

@implementation PFAppContainerVC

+ (PFAppContainerVC *)shared; {
    
    static dispatch_once_t once;
    static PFAppContainerVC *shared;
    
    dispatch_once(&once, ^{
        
        shared = [[PFAppContainerVC alloc] initWithNibName:nil bundle:nil]; [shared view];
    });
    
    return shared;
}

-(void)loadView; {
    
    [self setMenuState:PFMenuStateClosed];
    [self setAppContainer:[[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];
    
    [self setMainPane:[[UIView alloc] initWithFrame:[[self appContainer] bounds]]];
    [self setMenuPane:[[PFMenuVC shared] view]];
    
    CGRect menuFrame = CGRectMake(-kPFMenuPaneWidth, 0.0f, kPFMenuPaneWidth, CGRectGetHeight([[self mainPane] frame]));
    [[self menuPane] setFrame:menuFrame];
    
    [[[[PFMenuVC shared] menuItemsVC] view] setFrame:[[self menuPane] bounds]];
    
    [self setDragRecognizer:[[UIPanGestureRecognizer alloc]
                             initWithTarget:self
                             action:@selector(mainViewWasDragged:)]];
    
    [self setTapRecognizer:[[UITapGestureRecognizer alloc]
                            initWithTarget:self
                            action:@selector(mainViewWasTapped:)]];
    
    [[self dragRecognizer] setDelegate:self];
    [[self tapRecognizer] setDelegate:self];
    
    [[self mainPane] addGestureRecognizer:[self dragRecognizer]];
    [[self mainPane] addGestureRecognizer:[self tapRecognizer]];
    
    [[self appContainer] addSubview:[self mainPane]];
    [[self appContainer] addSubview:[self menuPane]];
    
    [self setView:[self appContainer]];
}

- (void)mainViewWasTapped:(UITapGestureRecognizer *)sender; {
    
    [self closeMenuAnimated:YES];
}

- (void)closeMenuAnimated:(bool)animate; {
    
    [self closeMenuAnimated:animate velocity:defaultMenuVelocity()];
}

- (void)closeMenuAnimated:(bool)animate velocity:(CGFloat)velocity; {
    
    CGFloat remaining = [self currentMenuShift];
    NSTimeInterval time = remaining / velocity;
    time = MAX(time, kPFMenuSlideAnimationDuration * 0.5);
    
    void (^steps)() = ^{
        
        [[self mainPane] setTransform:CGAffineTransformIdentity];
        [[self menuPane] setTransform:CGAffineTransformIdentity];
        [self menuDidClose];
    };
    
    void (^completion)(BOOL finished) = ^(BOOL finished){
        
        [self setMenuState:PFMenuStateClosed];
    };
    
    [self setMenuState:PFMenuStateAnimatingClosed];
    
    if(animate) {
        
        [UIView animateWithDuration:time delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:steps
                         completion:completion];
    } else {
        
        steps();
        completion(YES);
    }
}

- (void)menuDidClose; {
    
    [[[self navigationController] view] setUserInteractionEnabled:YES];
}

-(void)mainViewWasDragged:(UIPanGestureRecognizer *)sender; {
    
    CGFloat translation = [[self dragRecognizer] translationInView:[self mainPane]].x;
    CGFloat velocity = [[self dragRecognizer] velocityInView:[self mainPane]].x;
    
    if ([sender state] == UIGestureRecognizerStateEnded) {
        
        if(ABS(velocity) < defaultMenuVelocity()) {
            if(velocity < 0.0f) {
                velocity = -defaultMenuVelocity();
            } else {
                velocity = defaultMenuVelocity();
            }
        }
        
        BOOL overThreshold = (ABS([self currentMenuShift]) / kPFMenuPaneWidth) > .40
        || [[self lastChangeVelocity] integerValue] > 50;
        
        if(velocity >= 0.0f) {
            if(overThreshold) {
                [self openMenuAnimated:YES velocity:velocity];
            } else {
                [self closeMenuAnimated:YES  velocity:velocity];
            }
        } else {
            [self closeMenuAnimated:YES velocity:velocity];
        }
        
    } else if([sender state] == UIGestureRecognizerStateBegan) {
        
        if([self menuState] == PFMenuStateOpen) {
            if(velocity >= 0.0f) {
                return;
            }
            [self setMenuState:PFMenuStateAnimatingClosed];
        } else if([self menuState] == PFMenuStateClosed) {
            if(velocity <= 0.0f) {
                return;
            }
            [self setMenuState:PFMenuStateAnimatingOpen];
        }
        
    } else if ([sender state] == UIGestureRecognizerStateChanged) {
        
        [self setLastChangeVelocity:@(ABS(velocity))];
        
        if(!([self menuState] == PFMenuStateAnimatingOpen ||
             [self menuState] == PFMenuStateAnimatingClosed)) {
            return;
        }
        
        CGFloat shiftBase = 0.0f;
        if([self menuState] == PFMenuStateAnimatingClosed) {
            shiftBase = kPFMenuPaneWidth;
        }
        
        CGFloat shift = shiftBase + translation;
        if(shift < 0.0f) {
            shift = 0.0f;
        }
        
        if(shift > kPFMenuPaneWidth) {
            shift = kPFMenuPaneWidth;
        }
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(shift, 0.0f);
        [[self menuPane] setTransform:translate];
        [[self mainPane] setTransform:translate];
    }
}

-(void)openMenuAnimated:(bool)animate; {
    
    [self openMenuAnimated:animate velocity:defaultMenuVelocity()];
}

-(void)openMenuAnimated:(bool)animate velocity:(CGFloat)velocity; {
    
    CGFloat remaining = kPFMenuPaneWidth - [self currentMenuShift];
    NSTimeInterval time = remaining / velocity;
    time = MAX(time, kPFMenuSlideAnimationDuration * 0.5);
    
    void (^steps)() = ^{
        
        CGAffineTransform shift = CGAffineTransformMakeTranslation(kPFMenuPaneWidth, 0.0f);
        [[self menuPane] setTransform:shift];
        [[self mainPane] setTransform:shift];
        [self menuDidOpen];
    };
    
    void (^completion)(BOOL finished) = ^(BOOL finished){
        
        [self setMenuState:PFMenuStateOpen];
    };
    
    [self setMenuState:PFMenuStateAnimatingOpen];
    
    if(animate) {
        
        [UIView animateWithDuration:time delay:0.0f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:steps
                         completion:completion];
    } else {
        
        steps();
        completion(YES);
    }
}

-(void)menuDidOpen; {
    
    [[[self navigationController] view] setUserInteractionEnabled:NO];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer; {
    
    if(![self menuEnabled]) return NO;
    
    if(gestureRecognizer == [self tapRecognizer]) {

        return ([self menuState] == PFMenuStateOpen);
    
    } else {
        
        return ([self menuState] == PFMenuStateOpen || [self menuState] == PFMenuStateClosed);
    }
}

-(CGFloat)currentMenuShift; {
    
    CGPoint shifted = CGPointApplyAffineTransform(CGPointZero, [[self menuPane] transform]);
    return shifted.x;
}

- (void)popVCAction; {
    
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)setRootViewController:(UIViewController *)root
                    animation:(PFAppContainerAnimation)animation; {
    
    UIViewController *previous = [self navigationController];
    if(!previous) {
        animation = PFAppContainerAnimationNone;
    }
    
    UINavigationController *newRootWrapped = [self wrapViewController:root];
    [self setNavigationController:newRootWrapped];
    [self addChildViewController:newRootWrapped];
    
    CGRect bounds = [[self mainPane] bounds];
    [[newRootWrapped view] setFrame:bounds];
    
    CGAffineTransform newRootStartTransform, previousRootEndTransform;
    switch (animation) {
        
        case PFAppContainerAnimationSlideUp:
            
            newRootStartTransform = CGAffineTransformMakeTranslation(0.0f, bounds.size.height);
            previousRootEndTransform = CGAffineTransformIdentity;
            break;
        
        case PFAppContainerAnimationSlideDown:
            
            newRootStartTransform = CGAffineTransformMakeTranslation(0.0f, -bounds.size.height);
            previousRootEndTransform = CGAffineTransformMakeTranslation(0.0f, bounds.size.height);
            break;
        
        case PFAppContainerAnimationSlideLeft:
            
            newRootStartTransform = CGAffineTransformMakeTranslation(bounds.size.width, 0.0f);
            previousRootEndTransform = CGAffineTransformIdentity;
            break;
        
        default:
            
            newRootStartTransform = previousRootEndTransform = CGAffineTransformIdentity;
            break;
    }
    
    [[newRootWrapped view] setTransform:newRootStartTransform];
    
    void (^steps)() = ^{
        
        [[newRootWrapped view] setTransform:CGAffineTransformIdentity];
        [[previous view] setTransform:previousRootEndTransform];
    };
    
    void (^onCompletion)(BOOL) = ^(BOOL finished) {
        
        if(finished) {
            [previous removeFromParentViewController];
        } else {
        }
    };
    
    if (animation != PFAppContainerAnimationNone) {
        
        [self transitionFromViewController:previous
                          toViewController:newRootWrapped
                                  duration:0.25f
                                   options:UIViewAnimationOptionTransitionNone
                                animations:steps
                                completion:onCompletion];
    } else {
        
        [[self mainPane] addSubview:[newRootWrapped view]];
    }
}

- (void)openMenuAction; {
    
    if ([self menuState] == PFMenuStateOpen) {
        [self closeMenuAnimated:YES];
    } else {
        [self openMenuAnimated:YES];
    }
}

- (void)setRootViewController:(UIViewController *)root; {
    
    [self setRootViewController:root animation:PFAppContainerAnimationNone];
}

- (void)setDefaultRootViewControllerWithAnimation:(PFAppContainerAnimation)animation; {
    
    PFHomeVC *vc = [PFHomeVC _new];
    [self setRootViewController:vc animation:animation];
}

- (void)setDefaultRootViewController; {
    
    [self setDefaultRootViewControllerWithAnimation:PFAppContainerAnimationNone];
}

- (UINavigationController *) wrapViewController:(UIViewController *)vc; {
    
    UINavigationController *nav = [[UINavigationController alloc]
                                   initWithRootViewController:vc];
    return nav;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)vc
                    animated:(BOOL)animated; {
}

@end