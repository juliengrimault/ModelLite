//
//  MLRelationshipMapping.m
//  ModelLite
//
//  Created by Julien on 14/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

@import ObjectiveC.runtime;
#import "MLRelationshipMapping.h"
#import "MLRelationshipMappingManyToMany.h"
#import "MLRelationshipMappingOneToMany.h"

@implementation MLRelationshipMapping

+ (id<MLRelationshipMapping>)mappingWithRelationshipName:(NSString *)relationshipName dictionary:(NSDictionary *)relationshipDict
{
    if (relationshipDict[@"lookupTable"] != nil) {
        return [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:relationshipName dictionary:relationshipDict];
    } else {
        return [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:relationshipName dictionary:relationshipDict];
    }
}

@end
