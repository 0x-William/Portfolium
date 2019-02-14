//
//  PFTermsVC.h
//  Portfolium
//
//  Created by John Eisberg on 10/4/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    PFTermsTypeTerms,
    PFTermsTypePrivacy
    
}   PFTermsType;

@interface PFTermsVC : UIViewController<UITableViewDataSource, UITableViewDelegate>

+ (PFTermsVC *)_new:(PFTermsType)type;

@end
