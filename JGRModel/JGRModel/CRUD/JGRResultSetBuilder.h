//
//  JGRResultSetBuilder
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGRDbObject.h"
@class JGRDbMapping;
@class FMResultSet;

@interface JGRResultSetBuilder : NSObject

@property (nonatomic, strong, readonly) JGRDbMapping *mapping;

- (id)initWithInstanceCache:(NSMapTable *)instanceCache mapping:(JGRDbMapping *)mapping;

// Iterate over the entire result to build an array of model instances
// for each row in the result set, a new instance is built only if it is not already present in the cacheFMResultSet row
- (NSArray *)buildInstancesFromResultSet:(FMResultSet *)resultSet;

// build a new model instance from the current row of the FMResultSet
// this method does not move the FMResultSet index (does not call `next`)
- (id<JGRDbObject>)buildInstanceFromRow:(FMResultSet *)row;
@end
