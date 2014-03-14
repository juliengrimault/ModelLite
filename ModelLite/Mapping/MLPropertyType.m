//
//  MLPropertyType.m
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLPropertyType.h"


NSDictionary *_propertyTypeToString() {
    static dispatch_once_t onceToken;
    static NSDictionary *mapping;
    dispatch_once(&onceToken, ^{
        mapping = @{ @"int64" : @(MLPropertyInt64),
                     @"date" : @(MLPropertyDate),
                     @"string" : @(MLPropertyString),
                     @"number" : @(MLPropertyNSNumber),
                     @"boolean" : @(MLPropertyBOOL)
                     };
    });
    return mapping;
}

NSString *NSStringFromMLPropertyType(MLPropertyType type) {
    return [_propertyTypeToString() allKeysForObject:@(type)].firstObject;
}


@implementation NSString (MLPropertyType)

- (MLPropertyType)ml_propertType
{
    return (MLPropertyType)[_propertyTypeToString()[self] integerValue];
}

@end
