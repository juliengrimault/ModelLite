//
//  MLRelationshipMapping.m
//  ModelLite
//
//  Created by Julien on 14/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

@import ObjectiveC.runtime;
#import "MLRelationshipMapping.h"

@implementation MLRelationshipMapping

+ (instancetype)mappingWithRelationshipName:(NSString *)relationshipName dictionary:(NSDictionary *)relationshipDict
{
    if (relationshipDict[@"lookupTable"] != nil) {
        return [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:relationshipName dictionary:relationshipDict];
    } else {
        return [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:relationshipName dictionary:relationshipDict];
    }

}

@end


@interface MLRelationshipMappingOneToMany()
@property (nonatomic, copy) NSString *relationshipName;
@property (nonatomic, strong) Class<MLDatabaseObject> childClass;
@property (nonatomic, copy) NSString *parentIdColumn;
@property (nonatomic, copy) NSString *indexColumn;
@end

@implementation MLRelationshipMappingOneToMany

- (id)initWithRelationshipName:(NSString *)relationshipName
                    childClass:(Class<MLDatabaseObject>)childClass
                parentIdColumn:(NSString *)parentIdColumn
                   indexColumn:(NSString *)indexColumn
{
    NSParameterAssert(relationshipName);
    NSParameterAssert(childClass != nil);
    NSParameterAssert(parentIdColumn != nil);
    NSParameterAssert(indexColumn != nil);


    self = [super init];
    if (!self) return nil;

    self.relationshipName = relationshipName;
    self.childClass = childClass;
    self.parentIdColumn = parentIdColumn;
    self.indexColumn = indexColumn;
    
    return self;
}

- (id)initWithRelationshipName:(NSString *)relationshipName
                    dictionary:(NSDictionary *)dictionary
{
    return [self initWithRelationshipName:relationshipName
                               childClass:NSClassFromString(dictionary[@"childClass"])
                           parentIdColumn:dictionary[@"parentIdColumn"]
                              indexColumn:dictionary[@"indexColumn"]];
}

@end




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
