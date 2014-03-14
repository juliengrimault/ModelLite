//
//  JGRResultSetBuilder
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//
#import <objc/objc-runtime.h>
#import "JGRResultSetBuilder.h"
#import "JGRDbMapping.h"
#import "FMResultSet+JGRModel.h"

@interface JGRResultSetBuilder()
@property (nonatomic, strong) NSMapTable *instanceCache;

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
    
    return self;
}

- (NSArray *)buildInstancesFromResultSet:(FMResultSet *)resultSet
{
    NSMutableArray *instances = [NSMutableArray array];
    while ([resultSet next]) {
        id primaryKeyValue = [resultSet valueForColumnName:DbMappingPrimaryKeyName type:self.mapping.primaryKeyType];
        id<JGRDbObject> instance = [self.instanceCache objectForKey:primaryKeyValue];
        
        if (instance == nil) {
            instance = [self buildInstanceFromRow:resultSet];
            [self.instanceCache setObject:instance forKey:instance.primaryKeyValue];
        }
        
        [instances addObject:instance];
    }
    
    return [instances copy];

}

- (id<JGRDbObject>)buildInstanceFromRow:(FMResultSet *)row
{
    id instance = [[(Class)self.mapping.modelClass alloc] init];

    for (NSString *propertyName in self.mapping.properties) {

        if (class_getProperty(self.mapping.modelClass, propertyName.UTF8String) == NULL) {
            [NSException raise:@"DbMappingException" format:@"No property %@ on class %@. DbMapping: %@", propertyName, self.mapping.modelClass, self.mapping];
            continue;
        }

        if (row.columnNameToIndexMap[propertyName] == nil) {
            NSLog(@"Unknown column name %@ in result set %@", propertyName, row);
            continue;
        }

        DbPropertyType propertyType = [self.mapping.properties[propertyName] integerValue];
        id value = [row valueForColumnName:propertyName type:propertyType];

        [instance setValue:value forKey:propertyName];
    }

    if ([instance respondsToSelector:@selector(awakeFromFetch)]) {
        [instance awakeFromFetch];
    }

    return instance;
}

@end
