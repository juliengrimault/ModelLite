//
//  MLRelationshipManyToManyBuilder.m
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "MLRelationshipManyToManyBuilder.h"
#import "MLMapping.h"
#import "MLRelationshipMapping.h"
#import <FMDB/FMDatabase.h>
#import "FMResultSet+ModelLite.h"
#import "MLResultSetBuilder.h"
#import "NSArray+ModelLite.h"

@interface MLRelationshipManyToManyBuilder()
@property (nonatomic, strong) MLRelationshipMappingManyToMany *relationshipMapping;
@property (nonatomic, strong) MLMapping *childMapping;
@property (nonatomic, strong) NSMapTable *instanceCache;
@end
@implementation MLRelationshipManyToManyBuilder

-(id) initWithInstanceCache:(NSMapTable *)childInstanceCache
        relationshipMapping:(MLRelationshipMappingManyToMany *)relationshipMapping
               childMapping:(MLMapping *)childMapping
{
    NSParameterAssert(childInstanceCache != nil);
    NSParameterAssert(relationshipMapping != nil);
    NSParameterAssert(childMapping != nil);
    
    self = [super init];
    if (!self) return nil;

    self.relationshipMapping = relationshipMapping;
    self.childMapping = childMapping;
    self.instanceCache = childInstanceCache;
    
    return self;
}

- (void)populateRelationshipForInstances:(NSDictionary *)instances withDB:(FMDatabase *)db
{
    FMResultSet *rs = [db executeQuery:[self lookupFetchQueryForInstanceIds:[instances allKeys]]];

    NSMutableSet *missingChildId = [NSMutableSet set];
    NSMutableDictionary *parentChildMap = [NSMutableDictionary new];

    NSMutableArray *p = [NSMutableArray array];
    NSObject<MLDatabaseObject> *parent = nil;

    // find which child instance are not in the cache
    while ([rs next]) {
        NSInteger parentId = [rs intForColumn:self.relationshipMapping.parentIdColumn];

        if (parentId != [parent.primaryKeyValue integerValue]) {
            if (parent) {
                parentChildMap[parent.primaryKeyValue] = p;
                p = [NSMutableArray new];
            }
            parent = instances[@(parentId)];
            NSAssert2(parent != nil, @"Instance with id %ld not in instances dictionary %@", parentId, instances);
        }

        id childId = [rs valueForColumnName:self.relationshipMapping.childIdColumn
                                       type:self.childMapping.primaryKeyType];

        id<MLDatabaseObject> childInstance = [self.instanceCache objectForKey:childId];
        if (childInstance == nil) {
            [missingChildId addObject:childId];
            [p addObject:childId];
        } else {
            [p addObject:childInstance];
        }
    }
    if (parent) {
        parentChildMap[parent.primaryKeyValue] = p;
    }

    // fetch missing child instances and add them to the cache
    __unused NSArray *missingChildInstances = nil; //keep a copy to make sure the fetch children put in the cache do not get cleared
    if ([missingChildId count] > 0) {
        FMResultSet *childRS = [db executeQuery:[self fetchChildInstanceQuery:missingChildId]];
        MLResultSetBuilder *resultSetBuilder = [[MLResultSetBuilder alloc] initWithInstanceCache:self.instanceCache mapping:self.childMapping];
        missingChildInstances = [resultSetBuilder buildInstancesFromResultSet:childRS];
    }

    // populate the relationship
    [parentChildMap enumerateKeysAndObjectsUsingBlock:^(id parentId, NSMutableArray *childInstances, BOOL *stop) {
        NSInteger childCount = [childInstances count];
        for (NSInteger i = 0; i < childCount; i++) {

            id object = childInstances[i];
            // if the object is not a child instance, it is the primary key of the child instance instead.
            // we need to look in the cache for the child instance and replace the PK with it.
            if (![object isKindOfClass:self.childMapping.modelClass]) {
                id<MLDatabaseObject> childInstance = [self.instanceCache objectForKey:object];
                NSAssert2(childInstance != nil, @"Unable to find child instance %@ PK=%@", self.childMapping.modelClass, object);
                [childInstances replaceObjectAtIndex:i withObject:childInstance];
            }
        }

        NSObject<MLDatabaseObject> *parentInstance = instances[parentId];
        NSAssert2(parent != nil, @"Instance with id %@ not in instances dictionary %@", parentId, instances);
        [parentInstance setValue:[childInstances copy] forKey:self.relationshipMapping.relationshipName];
    }];
}

- (NSString *)lookupFetchQueryForInstanceIds:(NSArray *)parentIds
{
    return [NSString stringWithFormat:
            @"SELECT %@ FROM %@ "
            "WHERE %@ IN (%@) "
            "ORDER BY %@ ASC, %@ ASC",
            [[self lookupTableQueriedColumns] componentsJoinedByString:@", "],
            self.relationshipMapping.lookupTable,
            self.relationshipMapping.parentIdColumn,
            [parentIds fmdbQueryParameter],
            self.relationshipMapping.parentIdColumn,
            self.relationshipMapping.indexColumn];
}

- (NSArray *)lookupTableQueriedColumns
{
    NSMutableSet *queriedColumns = [NSMutableSet set];
    [queriedColumns addObject:self.relationshipMapping.parentIdColumn];
    [queriedColumns addObject:self.relationshipMapping.childIdColumn];
    [queriedColumns addObject:self.relationshipMapping.indexColumn];
    return [queriedColumns allObjects];
}

- (NSString *)fetchChildInstanceQuery:(NSSet *)childIds
{
    return [NSString stringWithFormat:
            @"SELECT %@ FROM %@ WHERE id IN (%@)",
            [[self childTableQueriedColumns] componentsJoinedByString:@", "],
            self.childMapping.tableName,
            [[childIds allObjects] fmdbQueryParameter]];
}

- (NSArray *)childTableQueriedColumns
{
    NSMutableSet * queriedColumns = [NSMutableSet setWithArray:[self.childMapping.properties allKeys]];
    [queriedColumns addObject:DbMappingPrimaryKeyName];
    return [queriedColumns allObjects];
}

@end
