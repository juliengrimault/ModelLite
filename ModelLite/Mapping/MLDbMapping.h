//
//  JGRDatabaseMapping.h
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;
#import "MLDbPropertyType.h"
#import "MLDbObject.h"

extern NSString *const DbMappingPrimaryKeyName;


@interface MLDbMapping : NSObject

@property (nonatomic, strong, readonly) Class<MLDbObject> modelClass;

@property (nonatomic, copy, readonly) NSString *tableName;

@property (nonatomic, readonly) DbPropertyType primaryKeyType;

// the properties persisted to the databse - the dictionary is propertyName --> propertyType
@property (nonatomic, copy, readonly) NSDictionary *properties;

- (id)initWithClass:(Class)modelClass
          tableName:(NSString *)tableName
         properties:(NSDictionary *)properties;

- (id)initWithClassName:(NSString *)className dictionary:(NSDictionary *)mappingDictionary;


extern NSString *const DbMappingKeyTableName;
extern NSString *const DbMappingKeyProperties;

@end
