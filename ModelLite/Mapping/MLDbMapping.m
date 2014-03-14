//
//  JGRDatabaseMapping.m
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLDbMapping.h"
@import ObjectiveC.runtime;

NSString *const DbMappingPrimaryKeyName = @"id";

@interface MLDbMapping ()
@property (nonatomic, strong) Class<MLDbObject> modelClass;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSDictionary *properties;
@end

@implementation MLDbMapping

- (id)initWithClass:(Class<MLDbObject>)modelClass
          tableName:(NSString *)tableName
         properties:(NSDictionary *)properties;
{
    NSParameterAssert(modelClass != nil);
    NSParameterAssert(tableName != nil);
    NSParameterAssert(properties != nil);
    NSParameterAssert(properties[DbMappingPrimaryKeyName] != nil);
    
    DbPropertyType primaryKeyType = [properties[DbMappingPrimaryKeyName] integerValue];
    NSAssert(primaryKeyType == DbPropertyInt64 || primaryKeyType == DbPropertyNSNumber  || primaryKeyType == DbPropertyNSNumber ,
             @"the primary key type must be either DbPropertyInt64, DbPropertyNSNumber or DbPropertyNSNumber");
    
    self = [super init];
    if (!self) return nil;
    
    self.modelClass = modelClass;
    self.tableName = tableName;
    self.properties = properties;
    
    [self verifyMappingValidity];
    
    return self;
}

- (id)initWithClassName:(NSString *)className dictionary:(NSDictionary *)mappingDictionary
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [mappingDictionary[DbMappingKeyProperties] enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *propertyTypeString, BOOL *stop) {
        properties[propertyName] = @([propertyTypeString jgr_propertType]);
    }];
    
    Class modelClass = NSClassFromString(className);
    
    return [self initWithClass:modelClass
                     tableName:mappingDictionary[DbMappingKeyTableName]
                    properties:properties];
}

- (DbPropertyType) primaryKeyType
{
    return [self.properties[DbMappingPrimaryKeyName] integerValue];
}

- (void)verifyMappingValidity
{
    for (NSString *propertyName in self.properties) {
        if (class_getProperty(self.modelClass, propertyName.UTF8String) == NULL) {
            [NSException raise:[NSString stringWithFormat:@"%@Exception", self.class]
                        format:@"Property %@ does not exist on class %@. Mapping: %@", propertyName, self.modelClass, self];
        }
    }
}

- (NSString *)description
{
    NSMutableString *description = [NSMutableString stringWithFormat:@"<%@:%p - tableName: %@\n relationships:(", self.class, self, self.tableName];
    NSMutableArray *propertiesDescriptions = [NSMutableArray array];
    for (NSString *propertyName in self.properties) {
        DbPropertyType propertyType = [self.properties[propertyName] integerValue];
        [propertiesDescriptions addObject:[NSString stringWithFormat:@"%@ -> %@", propertyName, NSStringFromDbPropertyType(propertyType)]];
    }
    [description appendFormat:@"%@)>", [propertiesDescriptions componentsJoinedByString:@", "]];
    return description;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToDbMapping:(MLDbMapping *)object];
}

- (BOOL)isEqualToDbMapping:(MLDbMapping *)mapping
{
    return [mapping.tableName isEqualToString:self.tableName] &&
    [mapping.properties isEqualToDictionary:self.properties];
}

@end

NSString *const DbMappingKeyTableName = @"tableName";
NSString *const DbMappingKeyProperties = @"properties";