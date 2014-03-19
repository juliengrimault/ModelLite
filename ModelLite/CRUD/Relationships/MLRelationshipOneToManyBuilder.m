//
//  MLRelationshipOneToManyBuilder.m
//  ModelLite
//
//  Created by Julien on 15/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "MLRelationshipOneToManyBuilder.h"
#import "MLMapping.h"
#import "MLRelationshipMappingManyToMany.h"
#import <FMDB/FMDatabase.h>
#import "MLDatabaseObject.h"
#import "MLRowBuilder.h"

@interface MLRelationshipOneToManyBuilder ()
@property (nonatomic, strong) NSMapTable *instanceCache;
@property (nonatomic, strong) MLRelationshipMappingOneToMany *relationshipMapping;
@property (nonatomic, strong) MLMapping *childMapping;

@property (nonatomic, strong) MLRowBuilder *rowBuilder;
@end

@implementation MLRelationshipOneToManyBuilder

-(id)initWithInstanceCache:(NSMapTable *)childrenInstanceCache
       relationshipMapping:(MLRelationshipMappingOneToMany *)relationshipMapping
              childMapping:(MLMapping *)childMapping;
{
    NSParameterAssert(childrenInstanceCache != nil);
    NSParameterAssert(relationshipMapping != nil);
    NSParameterAssert(relationshipMapping.childClass == childMapping.modelClass);

    self = [super init];
    if (!self) return nil;

    self.instanceCache = childrenInstanceCache;
    self.relationshipMapping = relationshipMapping;
    self.childMapping = childMapping;
    self.rowBuilder = [[MLRowBuilder alloc] initWithMapping:self.childMapping];

    return self;
}

- (void)populateRelationshipForInstances:(NSDictionary *)instances withDB:(FMDatabase *)db
{
    FMResultSet *rs = [db executeQuery:[self fetchQueryForInstanceIds:[instances allKeys]]];

    NSMutableArray *p = [NSMutableArray array];

    NSObject<MLDatabaseObject> *parent = nil;

    while ([rs next]) {
        NSInteger parentId = [rs intForColumn:self.relationshipMapping.parentIdColumn];

        if (parentId != [parent.primaryKeyValue integerValue]) {
            // new parent
            [parent setValue:[p copy] forKey:self.relationshipMapping.relationshipName];
            [p removeAllObjects];
            parent = instances[@(parentId)];
            NSAssert2(parent != nil, @"Instance with id %ld not in instances dictionary %@", parentId, instances);
        }

        NSInteger childId = [rs intForColumn:DbMappingPrimaryKeyName];
        id<MLDatabaseObject> childInstance = [self.instanceCache objectForKey:@(childId)];
        if (childInstance == nil) {
            childInstance = [self.rowBuilder buildInstanceFromRow:rs];
            [self.instanceCache setObject:childInstance forKey:@(childId)];
        }
        [p addObject:childInstance];
    }
    [parent setValue:[p copy] forKey:self.relationshipMapping.relationshipName];
}

- (NSString *)fetchQueryForInstanceIds:(NSArray *)ids
{
    return [NSString stringWithFormat:
            @"SELECT %@ FROM %@ "
             "WHERE %@ IN (%@) "
             "ORDER BY %@ ASC, %@ ASC",
            [[self queriedColumns] componentsJoinedByString:@", "],
            self.childMapping.tableName,
            self.relationshipMapping.parentIdColumn,
            [ids componentsJoinedByString:@", "],
            self.relationshipMapping.parentIdColumn,
            self.relationshipMapping.indexColumn];
}

- (NSArray *)queriedColumns
{
    NSMutableSet *queriedColumns = [NSMutableSet setWithArray:self.childMapping.properties.allKeys];
    [queriedColumns addObject:self.relationshipMapping.parentIdColumn];
    [queriedColumns addObject:self.relationshipMapping.indexColumn];
    [queriedColumns addObject:DbMappingPrimaryKeyName];
    return [queriedColumns allObjects];
}


@end
