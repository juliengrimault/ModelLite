//
//  MLMapping.m
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//


#import "MLMapping.h"   
#import "MLRelationshipMapping.h"

@import ObjectiveC.runtime;

NSString *const DbMappingPrimaryKeyName = @"id";

@interface MLMapping ()
@property (nonatomic, strong) Class<MLDatabaseObject> modelClass;
@property (nonatomic, copy) NSString *tableName;
@property (nonatomic, copy) NSDictionary *properties;
@property (nonatomic, copy) NSDictionary *relationships;
@end

@implementation MLMapping

- (id)initWithClass:(Class<MLDatabaseObject>)modelClass
          tableName:(NSString *)tableName
         properties:(NSDictionary *)properties
      relationships:(NSDictionary *)relationships
{
    NSParameterAssert(modelClass != nil);
    NSParameterAssert(tableName != nil);
    NSParameterAssert(properties != nil);
    NSParameterAssert(properties[DbMappingPrimaryKeyName] != nil);
    
    MLPropertyType primaryKeyType = (MLPropertyType)[properties[DbMappingPrimaryKeyName] integerValue];
    NSAssert(primaryKeyType == MLPropertyInt64 || primaryKeyType == MLPropertyNSNumber  || primaryKeyType == MLPropertyString ,
             @"the primary key type must be either DbPropertyInt64, DbPropertyNSNumber or DbPropertyString");
    
    self = [super init];
    if (!self) return nil;
    
    self.modelClass = modelClass;
    self.tableName = tableName;
    self.properties = properties;
    self.relationships = relationships;
    
    [self verifyMappingValidity];
    
    return self;
}

- (id)initWithClassName:(NSString *)className dictionary:(NSDictionary *)mappingDictionary
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    [mappingDictionary[DbMappingKeyProperties] enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, NSString *propertyTypeString, BOOL *stop) {
        properties[propertyName] = @([propertyTypeString ml_propertType]);
    }];


    NSMutableDictionary *relationships = [NSMutableDictionary dictionary];
    [mappingDictionary[DbMappingKeyRelationships] enumerateKeysAndObjectsUsingBlock:^(NSString *relationshipName, NSDictionary *relationshipDict, BOOL *stop) {
        MLRelationshipMapping *relationshipMapping = [MLRelationshipMapping mappingWithRelationshipName:relationshipName dictionary:relationshipDict];
        relationships[relationshipName] = relationshipMapping;
    }];

    Class modelClass = NSClassFromString(className);
    
    return [self initWithClass:modelClass
                     tableName:mappingDictionary[DbMappingKeyTableName]
                    properties:properties
                 relationships:relationships];
}

- (MLPropertyType) primaryKeyType
{
    return (MLPropertyType)[self.properties[DbMappingPrimaryKeyName] integerValue];
}

- (void)verifyMappingValidity
{
    [self verifyPropertiesValidity];
    [self verifyRelationshipsValidity];
}

- (void)verifyPropertiesValidity
{
    for (NSString *propertyName in self.properties) {
        if (class_getProperty(self.modelClass, propertyName.UTF8String) == NULL) {
            [NSException raise:[NSString stringWithFormat:@"%@Exception", self.class]
                        format:@"Property %@ does not exist on class %@. Mapping: %@", propertyName, self.modelClass, self];
        }
    }
}

- (void)verifyRelationshipsValidity
{
    for (NSString *relationship in self.relationships) {
        id m = self.relationships[relationship];
        if (![m conformsToProtocol:@protocol(MLRelationshipMapping)]) {
            [NSException raise:[NSString stringWithFormat:@"%@Exception", self.class]
                        format:@"Relationship entry %@ does not conform to protocol %@, class: %@.", relationship,@protocol(MLRelationshipMapping), [m class]];
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
    
    return [self isEqualToDbMapping:(MLMapping *)object];
}

- (BOOL)isEqualToDbMapping:(MLMapping *)mapping
{
    return [mapping.tableName isEqualToString:self.tableName] &&
    [mapping.properties isEqualToDictionary:self.properties];
}

@end

NSString *const DbMappingKeyTableName = @"tableName";
NSString *const DbMappingKeyProperties = @"properties";
NSString *const DbMappingKeyRelationships = @"relationships";
