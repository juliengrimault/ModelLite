//
//  MLMapping.h
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;
#import "MLPropertyType.h"
#import "MLDatabaseObject.h"

extern NSString *const DbMappingPrimaryKeyName;


@interface MLMapping : NSObject

@property (nonatomic, strong, readonly) Class<MLDatabaseObject> modelClass;

@property (nonatomic, copy, readonly) NSString *tableName;

@property (nonatomic, readonly) MLPropertyType primaryKeyType;

// the properties persisted to the database - the dictionary is propertyName --> propertyType
@property (nonatomic, copy, readonly) NSDictionary *properties;


@property (nonatomic, copy, readonly) NSDictionary *relationships;

- (id)initWithClass:(Class<MLDatabaseObject>)modelClass
          tableName:(NSString *)tableName
         properties:(NSDictionary *)properties
      relationships:(NSDictionary *)relationships;

- (id)initWithClassName:(NSString *)className dictionary:(NSDictionary *)mappingDictionary;


extern NSString *const DbMappingKeyTableName;
extern NSString *const DbMappingKeyProperties;
extern NSString *const DbMappingKeyRelationships;

@end
