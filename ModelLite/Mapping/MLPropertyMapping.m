//
//  JGRDatabaseMapping.m
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLPropertyMapping.h"
@import ObjectiveC.runtime;

NSString *const DbMappingPrimaryKeyName = @"id";

@interface MLPropertyMapping ()
@property (nonatomic, strong) Class<MLDatabaseObject> modelClass;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSDictionary *properties;
@end

@implementation MLPropertyMapping

- (id)initWithClass:(Class<MLDatabaseObject>)modelClass
          tableName:(NSString *)tableName
         properties:(NSDictionary *)properties;
{
    NSParameterAssert(modelClass != nil);
    NSParameterAssert(tableName != nil);
    NSParameterAssert(properties != nil);
    NSParameterAssert(properties[DbMappingPrimaryKeyName] != nil);
    
    MLPropertyType primaryKeyType = (MLPropertyType)[properties[DbMappingPrimaryKeyName] integerValue];
    NSAssert(primaryKeyType == MLPropertyInt64 || primaryKeyType == MLPropertyNSNumber  || primaryKeyType == MLPropertyNSNumber ,
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
        properties[propertyName] = @([propertyTypeString ml_propertType]);
    }];
    
    Class modelClass = NSClassFromString(className);
    
    return [self initWithClass:modelClass
                     tableName:mappingDictionary[DbMappingKeyTableName]
                    properties:properties];
}

- (MLPropertyType) primaryKeyType
{
    return (MLPropertyType)[self.properties[DbMappingPrimaryKeyName] integerValue];
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
        MLPropertyType propertyType = (MLPropertyType)[self.properties[propertyName] integerValue];
        [propertiesDescriptions addObject:[NSString stringWithFormat:@"%@ -> %@", propertyName, NSStringFromMLPropertyType(propertyType)]];
    }
    [description appendFormat:@"%@)>", [propertiesDescriptions componentsJoinedByString:@", "]];
    return description;
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    
    return [self isEqualToDbMapping:(MLPropertyMapping *)object];
}

- (BOOL)isEqualToDbMapping:(MLPropertyMapping *)mapping
{
    return [mapping.tableName isEqualToString:self.tableName] &&
    [mapping.properties isEqualToDictionary:self.properties];
}

@end

NSString *const DbMappingKeyTableName = @"tableName";
NSString *const DbMappingKeyProperties = @"properties";
