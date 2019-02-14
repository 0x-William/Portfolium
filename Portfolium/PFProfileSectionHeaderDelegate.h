//
//  PFProfileSectionHeaderDelegate.h
//  Portfolium
//
//  Created by John Eisberg on 8/20/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PFProfileSectionHeaderDelegate <NSObject>

- (void)entriesButtonAction:(UIButton *)button;

- (void)aboutButtonAction:(UIButton *)button;

- (void)connectionsButtonAction:(UIButton *)button;

@end
