//
//  MLResultSetBuilder
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;
#import "MLDatabaseObject.h"
@class MLMapping;
@class FMResultSet;

@interface MLResultSetBuilder : NSObject

@property (nonatomic, strong, readonly) MLMapping *mapping;

- (id)initWithInstanceCache:(NSMapTable *)instanceCache mapping:(MLMapping *)mapping;

// Iterate over the entire result to build an array of model instances
// for each row in the result set, a new instance is built only if it is not already present in the cacheFMResultSet row
- (NSArray *)buildInstancesFromResultSet:(FMResultSet *)resultSet;


@end
