//
//  MLDbPropertyType.m
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLDbPropertyType.h"


NSDictionary *_propertyTypeToString() {
    static dispatch_once_t onceToken;
    static NSDictionary *mapping;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"int64" : @(DbPropertyInt64),
                     @"date" : @(DbPropertyDate),
                     @"string" : @(DbPropertyString),
                     @"number" : @(DbPropertyNSNumber),
                     @"boolean" : @(DbPropertyBOOL)
                     };
    });
    return mapping;
}

NSString *NSStringFromDbPropertyType(DbPropertyType type) {
    return [_propertyTypeToString() allKeysForObject:@(type)].firstObject;
}


@implementation NSString (MLDbPropertyType)

- (DbPropertyType)jgr_propertType
{
    return [_propertyTypeToString()[self] integerValue];
}

@end
