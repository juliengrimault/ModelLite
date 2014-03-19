//
//  MLRelationshipMappingManyToMany.h
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLRelationshipMappingOneToMany.h"

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
