//
//  MLRelationshipMapping.m
//  ModelLite
//
//  Created by Julien on 14/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

@import ObjectiveC.runtime;
#import "MLRelationshipMapping.h"

@interface MLRelationshipMapping()
@property (nonatomic, copy) NSString *relationshipName;
@property (nonatomic, strong) Class<MLDatabaseObject> childClass;
@property (nonatomic, copy) NSString *parentIdColumn;
@property (nonatomic, copy) NSString *indexColumn;
@end

@implementation MLRelationshipMapping

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
