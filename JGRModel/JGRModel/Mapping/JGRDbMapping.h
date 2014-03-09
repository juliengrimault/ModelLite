//
//  JGRDatabaseMapping.h
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGRDbPropertyType.h"
#import "JGRDbObject.h"

extern NSString *const DbMappingPrimaryKeyName;


@interface JGRDbMapping : NSObject

@property (nonatomic, strong, readonly) Class<JGRDbObject> modelClass;

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
