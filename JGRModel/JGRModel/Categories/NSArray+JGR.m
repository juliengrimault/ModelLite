//
//  NSArray+JGR.m
//  JGRModel
//
//  Created by Julien on 13/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "NSArray+JGR.h"

@implementation NSArray (JGR)

- (NSArray *)jgr_map:(JGRMapBlock)mapBlock
{
    NSParameterAssert(mapBlock != nil);
    NSMutableArray *mappedArray = [NSMutableArray array];
    for (id object in self) {
        id mappedObject = mapBlock(object);
        if (mappedObject) {
            [mappedArray addObject:mappedObject];
        }
    }
    return [mappedArray copy];
}
@end
