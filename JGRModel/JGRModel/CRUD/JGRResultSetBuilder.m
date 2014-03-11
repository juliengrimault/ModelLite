//
//  JGRResultSetBuilder
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRResultSetBuilder.h"
#import "JGRDbMapping.h"
#import "JGRRowFetchBuilder.h"
#import "FMResultSet+JGRModel.h"

@interface JGRResultSetBuilder()
@property (nonatomic, strong) NSMapTable *instanceCache;

@property (nonatomic, strong) JGRRowFetchBuilder *rowBuilder;
@property (nonatomic, strong) JGRDbMapping *mapping;
@end

@implementation JGRResultSetBuilder

- (id)initWithInstanceCache:(NSMapTable *)instanceCache mapping:(JGRDbMapping *)mapping
{
    NSParameterAssert(instanceCache != nil);
    NSParameterAssert(mapping != nil);
    
    self = [super init];
    if (!self) return nil;
    
    self.mapping = mapping;
    self.instanceCache = instanceCache;
    self.rowBuilder = [[JGRRowFetchBuilder alloc] initWithMapping:mapping];
    
    return self;
}

- (NSArray *)buildInstancesFromResultSet:(FMResultSet *)resultSet
{
    NSMutableArray *instances = [NSMutableArray array];
    while ([resultSet next]) {
        id primaryKeyValue = [resultSet valueForColumnName:DbMappingPrimaryKeyName type:self.mapping.primaryKeyType];
        id<JGRDbObject> instance = [self.instanceCache objectForKey:primaryKeyValue];
        
        if (instance == nil) {
            instance = [self.rowBuilder buildInstanceFromRow:resultSet];
            [self.instanceCache setObject:instance forKey:instance.primaryKeyValue];
        }
        
        [instances addObject:instance];
    }
    
    return [instances copy];

}

@end
