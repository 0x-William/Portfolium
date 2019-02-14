//
//  PFTutorialView.m
//  Portfolium
//
//  Created by John Eisberg on 12/2/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFTutorialView.h"
#import "PFAppDelegate.h"
#import "PFConstraints.h"
#import "PFImage.h"
#import "PFFont.h"
#import "PFAuthenticationProvider.h"
#import "PFSize.h"
#import "FAKFontAwesome.h"

@interface PFTutorialView ()

@property(nonatomic, strong) void (^tapAction)(void);
@property(nonatomic, assign) BOOL isUp;
@property(nonatomic, strong) UIImageView *grid;
@property(nonatomic, strong) UIImageView *interestsGuide;
@property(nonatomic, strong) UIImageView *add;
@property(nonatomic, strong) UIImageView *addGuide;

@end

@implementation PFTutorialView

+ (PFTutorialView *)tutorial; {
    
    PFTutorialView *view = [[PFTutorialView alloc] initWithFrame:CGRectZero];
    
    __weak PFTutorialView *weakView = view;
    
    [weakView setTapAction:^{
        
        [[PFAuthenticationProvider shared] setTutorialized:YES];
    }];
    
    return view;
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.8f]];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                     action:@selector(tapAction:)];
        [self addGestureRecognizer:tapGesture];
        
        UIImageView *grid = [[UIImageView alloc] initWithFrame:CGRectZero];
        [grid setTranslatesAutoresizingMaskIntoConstraints:NO];
        [grid setAlpha:0.0f];
        [grid setImage:[PFImage tutorialGrid]];
        [self addSubview:grid];
        [self setGrid:grid];
        
        [self addConstraints:@[[PFConstraints constrainView:grid
                                                   toHeight:18.0f],
                               
                               [PFConstraints constrainView:grid
                                                    toWidth:18.0f],
                               
                               [PFConstraints leftAlignView:grid
                                        relativeToSuperView:self
                                       withDistanceFromEdge:21.0f],
                               
                               [PFConstraints topAlignView:grid
                                       relativeToSuperView:self
                                      withDistanceFromEdge:34.0f],
                               ]];
        
        UIImageView *interestsGuide = [[UIImageView alloc] initWithFrame:CGRectZero];
        [interestsGuide setTranslatesAutoresizingMaskIntoConstraints:NO];
        [interestsGuide setContentMode:UIViewContentModeScaleAspectFit];
        [interestsGuide setBackgroundColor:[UIColor clearColor]];
        [interestsGuide setAlpha:0.0f];
        [interestsGuide setImage:[PFImage interestGuide]];
        [self addSubview:interestsGuide];
        [self setInterestsGuide:interestsGuide];
        
        [self addConstraints:@[[PFConstraints constrainView:interestsGuide
                                                   toHeight:200.0f],
                               
                               [PFConstraints constrainView:interestsGuide
                                                    toWidth:300.0f],
                               
                               [PFConstraints leftAlignView:interestsGuide
                                        relativeToSuperView:self
                                       withDistanceFromEdge:4.0f],
                               
                               [PFConstraints topAlignView:interestsGuide
                                       relativeToSuperView:self
                                      withDistanceFromEdge:20.0f],
                               ]];
        
        UIImageView *add = [[UIImageView alloc] initWithFrame:CGRectZero];
        [add setTranslatesAutoresizingMaskIntoConstraints:NO];
        [add setAlpha:0.0f];
        
        FAKFontAwesome *normalIcon = [FAKFontAwesome plusCircleIconWithSize:36];
        [normalIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [add setImage:[normalIcon imageWithSize:CGSizeMake(35, 35)]];
        [self addSubview:add];
        [self setAdd:add];
        
        [self addConstraints:@[[PFConstraints constrainView:add
                                                   toHeight:35.0f],
                               
                               [PFConstraints constrainView:add
                                                    toWidth:35.0f],
                               
                               [PFConstraints leftAlignView:add
                                        relativeToSuperView:self
                                       withDistanceFromEdge:(([PFSize screenWidth] - 32) / 2) - 2],
                               
                               [PFConstraints topAlignView:add
                                       relativeToSuperView:self
                                      withDistanceFromEdge:[PFSize screenHeight] - 43],
                               ]];
        
        UIImageView *addGuide = [[UIImageView alloc] initWithFrame:CGRectZero];
        [addGuide setTranslatesAutoresizingMaskIntoConstraints:NO];
        [addGuide setContentMode:UIViewContentModeScaleAspectFit];
        [addGuide setAlpha:0.0f];
        [addGuide setImage:[PFImage addGuide]];
        [self addSubview:addGuide];
        [self setAddGuide:addGuide];
        
        [self addConstraints:@[[PFConstraints constrainView:addGuide
                                                   toHeight:200.0f],
                               
                               [PFConstraints constrainView:addGuide
                                                    toWidth:300.0f],
                               
                               [PFConstraints leftAlignView:addGuide
                                        relativeToSuperView:self
                                       withDistanceFromEdge:(([PFSize screenWidth] - 300) / 2) - 6],
                               
                               [PFConstraints topAlignView:addGuide
                                       relativeToSuperView:self
                                      withDistanceFromEdge:[PFSize screenHeight] - 238.0f],
                               ]];
    }
    
    return self;
}

-(void)tapAction:(id)sender; {
    
    [UIView animateWithDuration:0.5
                     animations:^{self.alpha = 0.0;}
                     completion:^(BOOL finished){
                         
                         [self setIsUp:NO];
                         
                         [self tapAction]();
                         [self removeFromSuperview];
                     }
     ];
    
}

- (void)launch; {

    if(![self isUp]) {
    
        [self setIsUp:YES];
        
        [self performSelector:@selector(doLaunch) withObject:self afterDelay:0.5];
    }
}

- (void)doLaunch; {
    
    PFAppDelegate* app = [PFAppDelegate shared];
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/1.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceInAnimationStopped)];
    [app.window addSubview:self];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    [UIView commitAnimations];
    
    [UIView animateWithDuration:2.0f animations:^{
        
        [[self grid] setAlpha:1.0f];
        [[self interestsGuide] setAlpha:1.0f];
        [[self add] setAlpha:1.0f];
        [[self addGuide] setAlpha:1.0f];
    }];
}

- (void)bounceInAnimationStopped; {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(bounceOutAnimationStopped)];
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
    [UIView commitAnimations];
}

- (void)bounceOutAnimationStopped; {
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.3/2];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

@end
