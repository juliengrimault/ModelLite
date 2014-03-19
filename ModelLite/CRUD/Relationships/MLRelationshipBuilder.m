//
//  MLRelationshipBuilder.m
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "MLRelationshipBuilder.h"
#import "MLRelationshipMapping.h"
#import "MLRelationshipMappingOneToMany.h"
#import "MLRelationshipMappingManyToMany.h"
#import "MLRelationshipManyToManyBuilder.h"
#import "MLRelationshipOneToManyBuilder.h"

@implementation MLRelationshipBuilder

+ (id<MLRelationshipBuilder>)builderWithRelationshipMapping:(id<MLRelationshipMapping>)mapping
                                               childMapping:(MLMapping *)childMapping
                                              instanceCache:(NSMapTable *)childInstanceCache
{
    if ([mapping isKindOfClass:[MLRelationshipMappingManyToMany class]]) {
        return [[MLRelationshipManyToManyBuilder alloc] initWithInstanceCache:childInstanceCache
                                                          relationshipMapping:(MLRelationshipMappingManyToMany *)mapping
                                                                 childMapping:childMapping];

    } else if ([mapping isKindOfClass:[MLRelationshipMappingOneToMany class]]) {
        return [[MLRelationshipOneToManyBuilder alloc] initWithInstanceCache:childInstanceCache
                                                         relationshipMapping:(MLRelationshipMappingOneToMany *)mapping
                                                                childMapping:childMapping];
    } else {
        NSAssert1(NO, @"Unknown relationship builder class for mapping of class %@", [mapping class]);
        return nil;
    }
}

@end
