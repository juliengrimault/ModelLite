//
//  MLRelationshipMappingOneToMany.h
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLRelationshipMapping.h"

/// Represent a one to many relationship with a foreign key in the child entity table
@interface MLRelationshipMappingOneToMany : NSObject <MLRelationshipMapping>

@property (nonatomic, copy, readonly) NSString *relationshipName;

@property (nonatomic, strong, readonly) Class<MLDatabaseObject> childClass;
@property (nonatomic, copy, readonly) NSString *parentIdColumn;
@property (nonatomic, copy, readonly) NSString *indexColumn;

- (id)initWithRelationshipName:(NSString *)relationshipName
                    childClass:(Class<MLDatabaseObject>)childClass
                parentIdColumn:(NSString *)parentIdColumn
                   indexColumn:(NSString *)indexColumn;

- (id)initWithRelationshipName:(NSString *)relationshipName
                    dictionary:(NSDictionary *)dictionary;

@end
