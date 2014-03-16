//
//  MLResultSetBuilder
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//
@import ObjectiveC.runtime;
#import "MLResultSetBuilder.h"
#import "MLMapping.h"
#import "FMResultSet+ModelLite.h"
#import "MLRowBuilder.h"

@interface MLResultSetBuilder ()
@property (nonatomic, strong) NSMapTable *instanceCache;
@property (nonatomic, strong) MLMapping *mapping;
@property (nonatomic, strong) MLRowBuilder *rowBuilder;
@end

@implementation MLResultSetBuilder

- (id)initWithInstanceCache:(NSMapTable *)instanceCache mapping:(MLMapping *)mapping
{
    NSParameterAssert(instanceCache != nil);
    NSParameterAssert(mapping != nil);
    
    self = [super init];
    if (!self) return nil;
    
    self.mapping = mapping;
    self.instanceCache = instanceCache;
    self.rowBuilder = [[MLRowBuilder alloc] initWithMapping:self.mapping];
    
    return self;
}

- (NSArray *)buildInstancesFromResultSet:(FMResultSet *)resultSet
{
    NSMutableArray *instances = [NSMutableArray array];
    while ([resultSet next]) {
        id primaryKeyValue = [resultSet valueForColumnName:DbMappingPrimaryKeyName type:self.mapping.primaryKeyType];
        id<MLDatabaseObject> instance = [self.instanceCache objectForKey:primaryKeyValue];
        
        if (instance == nil) {
            instance = [self.rowBuilder buildInstanceFromRow:resultSet];
            [self.instanceCache setObject:instance forKey:instance.primaryKeyValue];
        }
        
        [instances addObject:instance];
    }
    
    return [instances copy];

}



@end
