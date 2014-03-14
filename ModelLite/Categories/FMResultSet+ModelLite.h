//
//  FMResultSet+ModelLite.h
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <FMDB/FMResultSet.h>
#import "MLPropertyMapping.h"
#import "MLPropertyType.h"

@interface FMResultSet (ModelLite)

- (id)valueForColumnName:(NSString *)name type:(MLPropertyType)propertyType;

@end
