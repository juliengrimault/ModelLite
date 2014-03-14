//
//  FMResultSet+ModelLite.m
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "FMResultSet+ModelLite.h"

@implementation FMResultSet (ModelLite)

- (id)valueForColumnName:(NSString *)name type:(MLPropertyType)propertyType
{
    switch (propertyType) {
        case MLPropertyBOOL:
            return @([self boolForColumn:name]);
            
        case MLPropertyDate:
            return [self dateForColumn:name];
            
        case MLPropertyInt64:
            return @([self longForColumn:name]);
            
        case MLPropertyString:
            return [self stringForColumn:name];
            
        case MLPropertyNSNumber:
            return [self objectForColumnName:name];
            
        default:
            NSAssert1(NO, @"Unknown MLPropertyType %ld", (NSInteger)propertyType);
            break;
    }
    return nil;
}

@end
