//
//  JGRResultSetBuilder
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGRDbMapping;
@class FMResultSet;

@interface JGRResultSetBuilder : NSObject

@property (nonatomic, strong, readonly) JGRDbMapping *mapping;

- (id)initWithInstanceCache:(NSMapTable *)instanceCache mapping:(JGRDbMapping *)mapping;

- (NSArray *)buildInstancesFromResultSet:(FMResultSet *)resultSet;
@end
