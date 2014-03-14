//
//  FMResultSet+ModelLite.h
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <FMDB/FMResultSet.h>
#import "MLDbMapping.h"
#import "MLDbPropertyType.h"

@interface FMResultSet (ModelLite)

- (id)valueForColumnName:(NSString *)name type:(DbPropertyType)propertyType;

@end
