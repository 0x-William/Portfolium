//
//  PFCollaborator.m
//  Portfolium
//
//  Created by John Eisberg on 11/16/14.
//  Copyright (c) 2014 Portfolium. All rights reserved.
//

#import "PFCollaborator.h"
#import "RKObjectMapping.h"

@implementation PFCollaborator

+ (NSString *)endPoint; {
    
    return @"";
}

+ (NSString *)endPointUser; {
    
    return @"/connections/list/:id";
}

+ (RKObjectMapping *) getMapping; {
    
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[self class]];
    
    [mapping addAttributeMappingsFromDictionary:@{ @"id"   : @"collaboratorId",
                                                   @"name" : @"name" }];
    
    return mapping;
}

- (NSString *)getIndexableName; {
    
    return [self name];
}

- (NSString *)endPointUserPath; {
    
    if([self collaboratorId] == nil) {
        [self setCollaboratorId:@0];
    }
    
    return [[PFCollaborator endPointUser] stringByReplacingOccurrencesOfString:@":id"
                                                                    withString:[[self collaboratorId] stringValue]];
}

- (BOOL)isEqual:(id)other {
    
    if ([[other collaboratorId] integerValue] ==
        [[self collaboratorId] integerValue]) {
        
        return YES;
    }
    
    return NO;
}

@end
