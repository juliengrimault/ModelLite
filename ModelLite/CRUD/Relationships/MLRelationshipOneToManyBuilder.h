//
//  MLRelationshipOneToManyBuilder.h
//  ModelLite
//
//  Created by Julien on 15/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLRelationshipBuilder.h"
@class MLRelationshipMappingOneToMany, MLMapping;
@class FMResultSet, FMDatabase;

@interface MLRelationshipOneToManyBuilder : NSObject <MLRelationshipBuilder>

@property (nonatomic, strong, readonly) MLRelationshipMappingOneToMany *relationshipMapping;
@property (nonatomic, strong, readonly) MLMapping *childMapping;

-(id)initWithInstanceCache:(NSMapTable *)childrenInstanceCache
       relationshipMapping:(MLRelationshipMappingOneToMany *)relationshipMapping
              childMapping:(MLMapping *)childMapping;


- (void)populateRelationshipForInstances:(NSDictionary *)instances withDB:(FMDatabase *)db;

@end
