//
//  MLRelationshipMappingManyToMany.h
//  ModelLite
//
//  Created by Julien on 18/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLDatabaseObject.h"

@interface MLRelationshipMappingManyToMany : NSObject

@property (nonatomic, copy, readonly) NSString *relationshipName;

@property (nonatomic, copy, readonly) NSString *lookupTable;

@property (nonatomic, strong, readonly) Class<MLDatabaseObject> parentClass;
@property (nonatomic, copy, readonly) NSString *parentIdColumn;

@property (nonatomic, strong, readonly) Class<MLDatabaseObject> childClass;
@property (nonatomic, copy, readonly) NSString *childIdColumn;

@property (nonatomic, copy, readonly) NSString *indexColumn;

-(id)initWithRelationshipName:(NSString *)relationshipName
                  lookupTable:(NSString *)lookupTable
                  parentClass:(Class<MLDatabaseObject>)parentKlass
               parentIdColumn:(NSString *)parentIdColumn
                   childClass:(Class<MLDatabaseObject>)childKlass
                childIdColumn:(NSString *)childIdColumn
                  indexColumn:(NSString *)indexColumn;

- (id)initWithRelationshipName:(NSString *)relationshipName
                    dictionary:(NSDictionary *)dictionary;
@end
