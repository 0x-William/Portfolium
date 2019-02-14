//
//  PFCollaboratorsVC.h
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFIndexedListVC.h"

@class PFAddEntryVC;

@interface PFCollaboratorsVC : PFIndexedListVC

+ (PFCollaboratorsVC *)_new:(PFAddEntryVC *)delegate;

@end
