//
//  FMResultSet+JGRModel.h
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "FMResultSet.h"
#import "JGRDbMapping.h"
#import "JGRDbPropertyType.h"

@interface FMResultSet (JGRModel)

- (id)valueForColumnName:(NSString *)name type:(DbPropertyType)propertyType;

@end
