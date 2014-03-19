//
//  MLTag.m
//  ModelLite
//
//  Created by Julien on 18/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "MLTag.h"

@implementation MLTag

- (id)primaryKeyValue
{
    return [self.name lowercaseString];
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end
