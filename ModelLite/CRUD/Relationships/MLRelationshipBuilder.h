//
//  MLRelationshipBuilder.h
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class MLMapping, MLRelationshipMapping;

@protocol MLRelationshipBuilder <NSObject>

- (void)populateRelationshipForInstances:(NSDictionary *)instances withDB:(FMDatabase *)db;

@end

@interface MLRelationshipBuilder : NSObject

+ (id<MLRelationshipBuilder>)builderWithRelationshipMapping:(MLRelationshipMapping *)mapping
                                                         childMapping:(MLMapping *)childMapping
                                                        instanceCache:(NSMapTable *)childInstanceCache;
@end
