//
//  MLRelationshipBuilder.h
//  ModelLite
//
//  Created by Julien on 15/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MLRelationshipMapping, MLMapping;
@class FMResultSet, FMDatabase;

@interface MLRelationshipBuilder : NSObject

@property (nonatomic, strong, readonly) MLRelationshipMapping *relationshipMapping;
@property (nonatomic, strong, readonly) MLMapping *childMapping;

-(id)initWithInstanceCache:(NSMapTable *)childrenInstanceCache
       relationshipMapping:(MLRelationshipMapping *)relationshipMapping
              childMapping:(MLMapping *)childMapping;


- (void)populateRelationshipForInstances:(NSDictionary *)instances withDB:(FMDatabase *)db;


- (NSString *)fetchQuery;
- (NSArray *)queriedColumns;
@end
