//
//  MLRelationshipMappingManyToMany.m
//  ModelLite
//
//  Created by Julien on 18/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "MLRelationshipMappingManyToMany.h"
@interface MLRelationshipMappingManyToMany()
@property (nonatomic, copy) NSString *relationshipName;

@property (nonatomic, copy) NSString *lookupTable;

@property (nonatomic, strong) Class<MLDatabaseObject> parentClass;
@property (nonatomic, copy) NSString *parentIdColumn;

@property (nonatomic, strong) Class<MLDatabaseObject> childClass;
@property (nonatomic, copy) NSString *childIdColumn;

@property (nonatomic, copy) NSString *indexColumn;
@end

@implementation MLRelationshipMappingManyToMany

-(id)initWithRelationshipName:(NSString *)relationshipName
                  lookupTable:(NSString *)lookupTable
                  parentClass:(Class<MLDatabaseObject>)parentKlass
               parentIdColumn:(NSString *)parentIdColumn
                   childClass:(Class<MLDatabaseObject>)childKlass
                childIdColumn:(NSString *)childIdColumn
                  indexColumn:(NSString *)indexColumn
{
    NSParameterAssert(relationshipName != nil);
    NSParameterAssert(lookupTable != nil);
    NSParameterAssert(parentKlass != nil);
    NSParameterAssert(parentIdColumn != nil);
    NSParameterAssert(childKlass != nil);
    NSParameterAssert(childIdColumn != nil);
    NSParameterAssert(indexColumn != nil);
    
    self = [super init];
    if (!self) return nil;

    self.relationshipName = relationshipName;
    self.lookupTable = lookupTable;
    self.parentClass = parentKlass;
    self.parentIdColumn = parentIdColumn;
    self.childClass = childKlass;
    self.childIdColumn = childIdColumn;
    self.indexColumn = indexColumn;

    return self;
}

- (id)initWithRelationshipName:(NSString *)relationshipName
                    dictionary:(NSDictionary *)dictionary
{
    Class parentClass = NSClassFromString(dictionary[@"parentClass"]);
    Class childClass = NSClassFromString(dictionary[@"childClass"]);

    return [self initWithRelationshipName:relationshipName
                              lookupTable:dictionary[@"lookupTable"]
                              parentClass:parentClass
                           parentIdColumn:dictionary[@"parentIdColumn"]
                               childClass:childClass
                            childIdColumn:dictionary[@"childIdColumn"]
                              indexColumn:dictionary[@"indexColumn"]];
}

@end
