//
//  FMResultSet+JGRModel.m
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "FMResultSet+JGRModel.h"

@implementation FMResultSet (JGRModel)

- (id)valueForColumnName:(NSString *)name type:(DbPropertyType)propertyType
{
    switch (propertyType) {
        case DbPropertyBOOL:
            return @([self boolForColumn:name]);
            
        case DbPropertyDate:
            return [self dateForColumn:name];
            
        case DbPropertyInt64:
            return @([self longForColumn:name]);
            
        case DbPropertyString:
            return [self stringForColumn:name];
            
        case DbPropertyNSNumber:
            return [self objectForColumnName:name];
            
        default:
            NSAssert1(NO, @"Unknown DbPropertyType %ld", (NSInteger)propertyType);
            break;
    }
    return nil;
}

@end
