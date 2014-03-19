//
//  MLRelationshipMapping.h
//  ModelLite
//
//  Created by Julien on 14/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

@import Foundation;
#import "MLDatabaseObject.h"



@interface MLRelationshipMapping : NSObject

/// Class factory method - will instantiate the correct subtype
+ (instancetype)mappingWithRelationshipName:(NSString *)relationshipName dictionary:(NSDictionary *)relationshipDict;

@end


/// Represent a one to many relationship with a foreign key in the child entity table
@interface MLRelationshipMappingOneToMany : MLRelationshipMapping

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


/// Represents a many to many relationship via a lookup table
@interface MLRelationshipMappingManyToMany : MLRelationshipMappingOneToMany

@property (nonatomic, copy, readonly) NSString *lookupTable;
@property (nonatomic, copy, readonly) NSString *childIdColumn;


-(id)initWithRelationshipName:(NSString *)relationshipName
                  lookupTable:(NSString *)lookupTable
               parentIdColumn:(NSString *)parentIdColumn
                   childClass:(Class<MLDatabaseObject>)childKlass
                childIdColumn:(NSString *)childIdColumn
                  indexColumn:(NSString *)indexColumn;

- (id)initWithRelationshipName:(NSString *)relationshipName
                    dictionary:(NSDictionary *)dictionary;
@end
