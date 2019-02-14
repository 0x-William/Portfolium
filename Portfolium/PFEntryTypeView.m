//
//  PFEntryTypeView.m
//  Portfolium
//
//  Created by John Eisberg on 8/26/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFEntryTypeView.h"
#import "PFAppDelegate.h"
#import "PFTapGesture.h"
#import "PFConstraints.h"
#import "PFFont.h"
#import "PFHomeVC.h"
#import "ReactiveCocoa/RACEXTScope.h"
#import "PFColor.h"
#import "PFImage.h"
#import "UIControl+BlocksKit.h"
#import "PFSize.h"
#import "FAKFontAwesome.h"

static CGFloat kCanvasHeight = 260;

@interface PFEntryTypeView ()

@property(nonatomic, assign) BOOL showing;
@property(nonatomic, strong) PFTapGesture *tap;
@property(nonatomic, strong) UIView *canvasView;

@end

@implementation PFEntryTypeView

+ (PFEntryTypeView *)shared; {
    
    static PFEntryTypeView *_shared = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _shared = [[self alloc] initWithFrame:CGRectZero];
    });
    
    return _shared;
}

- (id)initWithFrame:(CGRect)frame; {
    
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    
    if (self) {
        
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0f]];
        
        @weakify(self)
        
        [self setTap:[[PFTapGesture alloc] init:self
                                          block:^(UITapGestureRecognizer *recognizer) {
                                              
                                              @strongify(self)
                                              
                                              [self dismiss];
                                          }]];
        
        UIView *canvasView = [[UIView alloc] initWithFrame:CGRectMake(0,[PFSize screenHeight],
                                                                      [PFSize screenWidth],
                                                                      kCanvasHeight)];
        
        UIView *hidePlusView = [[UIView alloc] initWithFrame:CGRectMake([PFSize entryTypeViewHidePlus], 225, 20, 20)];
        
        [canvasView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7f]];
        
        [hidePlusView setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:1.0f]];

        [self addSubview:canvasView];
        [self setCanvasView:canvasView];
        
        [[self canvasView] addSubview:hidePlusView];
        
        UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button1 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button1 setFrame:CGRectZero];
        [button1 setBackgroundColor:[UIColor clearColor]];
        [button1 setImage:[PFImage entryJob]
                 forState:UIControlStateNormal];
        
        [button1 bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [[PFHomeVC shared] launchAddEntry:PFEntryTypeJob];
            [self dismiss];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self canvasView] addSubview:button1];
        
        UILabel *button1Label = [[UILabel alloc] initWithFrame:CGRectZero];
        [button1Label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button1Label setTextColor:[UIColor whiteColor]];
        [button1Label setBackgroundColor:[PFColor blackColorMoreOpaque]];
        [button1Label setTextAlignment:NSTextAlignmentCenter];
        [button1Label setFont:[PFFont fontOfSmallSize]];
        [button1Label setText:NSLocalizedString(@"Job", nil)];
        [button1Label setBackgroundColor:[UIColor clearColor]];
        [[self canvasView] addSubview:button1Label];
        
        [[self canvasView] addConstraints:@[[PFConstraints constrainView:button1
                                                                toHeight:80.0f],
                                            
                                            [PFConstraints constrainView:button1
                                                                 toWidth:80.0f],
                                            
                                            [PFConstraints topAlignView:button1
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints leftAlignView:button1
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewColOne]],
                                            
                                            [PFConstraints constrainView:button1Label
                                                                toHeight:20.0f],
                                            
                                            [PFConstraints constrainView:button1Label
                                                                 toWidth:[PFSize entryTypeViewColOne]],
                                            
                                            [PFConstraints topAlignView:button1Label
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:88.0f],
                                            
                                            [PFConstraints leftAlignView:button1Label
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewJobText]]
                                            ]];
        
        UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button2 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button2 setFrame:CGRectZero];
        [button2 setBackgroundColor:[UIColor clearColor]];
        [button2 setImage:[PFImage entryCourseWork]
                 forState:UIControlStateNormal];
        
        [button2 bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [[PFHomeVC shared] launchAddEntry:PFEntryTypeCourseWork];
            [self dismiss];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self canvasView] addSubview:button2];
        
        UILabel *button2Label = [[UILabel alloc] initWithFrame:CGRectZero];
        [button2Label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button2Label setTextColor:[UIColor whiteColor]];
        [button2Label setBackgroundColor:[PFColor blackColorMoreOpaque]];
        [button2Label setTextAlignment:NSTextAlignmentCenter];
        [button2Label setFont:[PFFont fontOfSmallSize]];
        [button2Label setText:NSLocalizedString(@"Course Work", nil)];
        [button2Label setBackgroundColor:[UIColor clearColor]];
        [[self canvasView] addSubview:button2Label];
        
        [[self canvasView] addConstraints:@[[PFConstraints constrainView:button2
                                                                toHeight:80.0f],
                                            
                                            [PFConstraints constrainView:button2
                                                                 toWidth:80.0f],
                                            
                                            [PFConstraints topAlignView:button2
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints leftAlignView:button2
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewColTwo]],
                                            
                                            [PFConstraints constrainView:button2Label
                                                                toHeight:20.0f],
                                            
                                            [PFConstraints constrainView:button2Label
                                                                 toWidth:82.0f],
                                            
                                            [PFConstraints topAlignView:button2Label
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:88.0f],
                                            
                                            [PFConstraints leftAlignView:button2Label
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewCourseText]]
                                            ]];
        
        UIButton *button3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button3 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button3 setFrame:CGRectZero];
        [button3 setBackgroundColor:[UIColor clearColor]];
        [button3 setImage:[PFImage entryVoluteer]
                 forState:UIControlStateNormal];
        
        [button3 bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [[PFHomeVC shared] launchAddEntry:PFEntryTypeVolunteer];
            [self dismiss];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self canvasView] addSubview:button3];
        
        UILabel *button3Label = [[UILabel alloc] initWithFrame:CGRectZero];
        [button3Label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button3Label setTextColor:[UIColor whiteColor]];
        [button3Label setBackgroundColor:[PFColor blackColorMoreOpaque]];
        [button3Label setTextAlignment:NSTextAlignmentCenter];
        [button3Label setFont:[PFFont fontOfSmallSize]];
        [button3Label setText:NSLocalizedString(@"Volunteer", nil)];
        [button3Label setBackgroundColor:[UIColor clearColor]];
        [[self canvasView] addSubview:button3Label];
        
        [[self canvasView] addConstraints:@[[PFConstraints constrainView:button3
                                                                toHeight:80.0f],
                                            
                                            [PFConstraints constrainView:button3
                                                                 toWidth:80.0f],
                                            
                                            [PFConstraints topAlignView:button3
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:12.0f],
                                            
                                            [PFConstraints leftAlignView:button3
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewColThree]],
                                            
                                            [PFConstraints constrainView:button3Label
                                                                toHeight:20.0f],
                                            
                                            [PFConstraints constrainView:button3Label
                                                                 toWidth:60.0f],
                                            
                                            [PFConstraints topAlignView:button3Label
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:88.0f],
                                            
                                            [PFConstraints leftAlignView:button3Label
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewVolunteerText]]
                                            ]];
        
        UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button4 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button4 setFrame:CGRectZero];
        [button4 setBackgroundColor:[UIColor clearColor]];
        [button4 setImage:[PFImage entryClubs]
                 forState:UIControlStateNormal];
        
        [button4 bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [[PFHomeVC shared] launchAddEntry:PFEntryTypeClubs];
            [self dismiss];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self canvasView] addSubview:button4];
        
        UILabel *button4Label = [[UILabel alloc] initWithFrame:CGRectZero];
        [button4Label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button4Label setTextColor:[UIColor whiteColor]];
        [button4Label setBackgroundColor:[PFColor blackColorMoreOpaque]];
        [button4Label setTextAlignment:NSTextAlignmentCenter];
        [button4Label setFont:[PFFont fontOfSmallSize]];
        [button4Label setText:NSLocalizedString(@"Clubs", nil)];
        [button4Label setBackgroundColor:[UIColor clearColor]];
        [[self canvasView] addSubview:button4Label];
        
        [[self canvasView] addConstraints:@[[PFConstraints constrainView:button4
                                                                toHeight:80.0f],
                                            
                                            [PFConstraints constrainView:button4
                                                                 toWidth:80.0f],
                                            
                                            [PFConstraints topAlignView:button4
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:108.0f],
                                            
                                            [PFConstraints leftAlignView:button4
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewColOne]],
                                            
                                            [PFConstraints constrainView:button4Label
                                                                toHeight:20.0f],
                                            
                                            [PFConstraints constrainView:button4Label
                                                                 toWidth:40.0f],
                                            
                                            [PFConstraints topAlignView:button4Label
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:184.0f],
                                            
                                            [PFConstraints leftAlignView:button4Label
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewClubsText]]
                                            ]];
        
        UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button5 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button5 setFrame:CGRectZero];
        [button5 setBackgroundColor:[UIColor clearColor]];
        [button5 setImage:[PFImage entryHobbies]
                 forState:UIControlStateNormal];
        
        [button5 bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [[PFHomeVC shared] launchAddEntry:PFEntryTypeHobbies];
            [self dismiss];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self canvasView] addSubview:button5];
        
        UILabel *button5Label = [[UILabel alloc] initWithFrame:CGRectZero];
        [button5Label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button5Label setTextColor:[UIColor whiteColor]];
        [button5Label setBackgroundColor:[PFColor blackColorMoreOpaque]];
        [button5Label setTextAlignment:NSTextAlignmentCenter];
        [button5Label setFont:[PFFont fontOfSmallSize]];
        [button5Label setText:NSLocalizedString(@"Hobbies", nil)];
        [button5Label setBackgroundColor:[UIColor clearColor]];
        [[self canvasView] addSubview:button5Label];
        
        [[self canvasView] addConstraints:@[[PFConstraints constrainView:button5
                                                                toHeight:80.0f],
                                            
                                            [PFConstraints constrainView:button5
                                                                 toWidth:80.0f],
                                            
                                            [PFConstraints topAlignView:button5
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:108.0f],
                                            
                                            [PFConstraints leftAlignView:button5
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewColTwo]],
                                            
                                            [PFConstraints constrainView:button5Label
                                                                toHeight:20.0f],
                                            
                                            [PFConstraints constrainView:button5Label
                                                                 toWidth:62.0f],
                                            
                                            [PFConstraints topAlignView:button5Label
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:184.0f],
                                            
                                            [PFConstraints leftAlignView:button5Label
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewHobbiesText]]
                                            ]];
        
        UIButton *button6 = [UIButton buttonWithType:UIButtonTypeCustom];
        [button6 setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button6 setFrame:CGRectZero];
        [button6 setBackgroundColor:[UIColor clearColor]];
        [button6 setImage:[PFImage entryMisc]
                 forState:UIControlStateNormal];
        
        [button6 bk_addEventHandler:^(id sender) {
            
            @strongify(self)
            
            [[PFHomeVC shared] launchAddEntry:PFEntryTypeMisc];
            [self dismiss];
            
        } forControlEvents:UIControlEventTouchUpInside];
        
        [[self canvasView] addSubview:button6];
        
        UILabel *button6Label = [[UILabel alloc] initWithFrame:CGRectZero];
        [button6Label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [button6Label setTextColor:[UIColor whiteColor]];
        [button6Label setBackgroundColor:[PFColor blackColorMoreOpaque]];
        [button6Label setTextAlignment:NSTextAlignmentCenter];
        [button6Label setFont:[PFFont fontOfSmallSize]];
        [button6Label setText:NSLocalizedString(@"Misc", nil)];
        [button6Label setBackgroundColor:[UIColor clearColor]];
        [[self canvasView] addSubview:button6Label];
        
        [[self canvasView] addConstraints:@[[PFConstraints constrainView:button6
                                                                toHeight:80.0f],
                                            
                                            [PFConstraints constrainView:button6
                                                                 toWidth:80.0f],
                                            
                                            [PFConstraints topAlignView:button6
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:108.0f],
                                            
                                            [PFConstraints leftAlignView:button6
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewColThree]],
                                            
                                            [PFConstraints constrainView:button6Label
                                                                toHeight:20.0f],
                                            
                                            [PFConstraints constrainView:button6Label
                                                                 toWidth:40.0f],
                                            
                                            [PFConstraints topAlignView:button6Label
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:184.0f],
                                            
                                            [PFConstraints leftAlignView:button6Label
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewMiscText]]
                                            ]];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [cancelButton setUserInteractionEnabled:NO];
        [cancelButton setFrame:CGRectZero];
        
        FAKFontAwesome *cancelIcon = [FAKFontAwesome timesCircleIconWithSize:36];
        [cancelIcon addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor]];
        
        [cancelButton setAttributedTitle:[cancelIcon attributedString] forState:UIControlStateNormal];
        [[self canvasView] addSubview:cancelButton];
        
        [[self canvasView] addConstraints:@[[PFConstraints constrainView:cancelButton
                                                                toHeight:40.0f],
                                            
                                            [PFConstraints constrainView:cancelButton
                                                                 toWidth:40.0f],
                                            
                                            [PFConstraints topAlignView:cancelButton
                                                    relativeToSuperView:[self canvasView]
                                                   withDistanceFromEdge:215.0f],
                                            
                                            [PFConstraints leftAlignView:cancelButton
                                                     relativeToSuperView:[self canvasView]
                                                    withDistanceFromEdge:[PFSize entryTypeViewColTwo]+20],
                                            ]];
    }
    
    return self;
}

- (void)launch; {
    
    [self pop];
    
    PFAppDelegate* app = [PFAppDelegate shared];
    [app.window addSubview:self];
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.2f]];
        
        CGRect frame = [self canvasView].frame;
        frame.origin.y = [PFSize screenHeight] - kCanvasHeight;
        [self canvasView].frame = frame;
        
    }];
    
    [self setShowing:YES];
}

- (BOOL)isShowing; {
    
    return [self showing];
}

- (void)pop; {
    
    [UIView animateWithDuration:0.2 animations:^{
    }];
}

- (void)dismiss; {
    
    [UIView animateWithDuration:0.4 animations:^{
        
        [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.0f]];
        
        CGRect frame = [self canvasView].frame;
        frame.origin.y = [PFSize screenHeight];
        [self canvasView].frame = frame;
        
    } completion:^(BOOL finished) {
        
        if(finished) {
            
            [self removeFromSuperview];
            [self setShowing:NO];
        }
    }];
}

@end
