//
//  MLRelationshipMappingManyToMany.m
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "MLRelationshipMappingManyToMany.h"


@interface MLRelationshipMappingManyToMany()

@property (nonatomic, copy) NSString *lookupTable;
@property (nonatomic, strong, readonly) Class<MLDatabaseObject> parentClass;
@property (nonatomic, copy) NSString *childIdColumn;
@end

@implementation MLRelationshipMappingManyToMany

-(id)initWithRelationshipName:(NSString *)relationshipName
                  lookupTable:(NSString *)lookupTable
               parentIdColumn:(NSString *)parentIdColumn
                   childClass:(Class<MLDatabaseObject>)childKlass
                childIdColumn:(NSString *)childIdColumn
                  indexColumn:(NSString *)indexColumn
{
    NSParameterAssert(lookupTable != nil);
    NSParameterAssert(childIdColumn != nil);

    self = [super initWithRelationshipName:relationshipName
                                childClass:childKlass
                            parentIdColumn:parentIdColumn
                               indexColumn:indexColumn];
    if (!self) return nil;


    self.lookupTable = lookupTable;
    self.childIdColumn = childIdColumn;

    return self;
}

- (id)initWithRelationshipName:(NSString *)relationshipName
                    dictionary:(NSDictionary *)dictionary
{
    Class childClass = NSClassFromString(dictionary[@"childClass"]);

    return [self initWithRelationshipName:relationshipName
                              lookupTable:dictionary[@"lookupTable"]
                           parentIdColumn:dictionary[@"parentIdColumn"]
                               childClass:childClass
                            childIdColumn:dictionary[@"childIdColumn"]
                              indexColumn:dictionary[@"indexColumn"]];
}

@end
