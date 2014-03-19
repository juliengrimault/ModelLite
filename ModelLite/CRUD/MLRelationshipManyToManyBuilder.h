//
//  MLRelationshipManyToManyBuilder.h
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLRelationshipBuilder.h"
@class MLRelationshipMappingManyToMany;
@class MLMapping;

@interface MLRelationshipManyToManyBuilder : NSObject <MLRelationshipBuilder>

@property (nonatomic, strong, readonly) MLRelationshipMappingManyToMany *relationshipMapping;
@property (nonatomic, strong, readonly) MLMapping *childMapping;

-(id) initWithInstanceCache:(NSMapTable *)childInstanceCache
        relationshipMapping:(MLRelationshipMappingManyToMany *)relationshipMapping
               childMapping:(MLMapping *)childMapping;

- (void)populateRelationshipForInstances:(NSDictionary *)instances withDB:(FMDatabase *)db;
@end
