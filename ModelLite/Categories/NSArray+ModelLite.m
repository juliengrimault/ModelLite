//
//  NSArray+ModelLite.m
//  ModelLite
//
//  Created by Julien on 19/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "NSArray+ModelLite.h"
#import <ObjectiveSugar/ObjectiveSugar.h>

@implementation NSArray (ModelLite)

- (NSString *)fmdbQueryParameter
{
    NSArray *sanatizedElements = [self map:^id(id object) {
        if ([object isKindOfClass:[NSString class]]) {
            return [NSString stringWithFormat:@"'%@'", object];
        }
        return object;
    }];
    return [sanatizedElements componentsJoinedByString:@", "];
}

@end
