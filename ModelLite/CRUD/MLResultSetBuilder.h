//
//  MLResultSetBuilder
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;
#import "MLDatabaseObject.h"
@class MLPropertyMapping;
@class FMResultSet;

@interface MLResultSetBuilder : NSObject

@property (nonatomic, strong, readonly) MLPropertyMapping *mapping;

- (id)initWithInstanceCache:(NSMapTable *)instanceCache mapping:(MLPropertyMapping *)mapping;

// Iterate over the entire result to build an array of model instances
// for each row in the result set, a new instance is built only if it is not already present in the cacheFMResultSet row
- (NSArray *)buildInstancesFromResultSet:(FMResultSet *)resultSet;

// build a new model instance from the current row of the FMResultSet
// this method does not move the FMResultSet index (does not call `next`)
- (id<MLDatabaseObject>)buildInstanceFromRow:(FMResultSet *)row;
@end
