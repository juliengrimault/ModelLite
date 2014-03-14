//
//  NSArray+JGR.m
//  ModelLite
//
//  Created by Julien on 13/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "NSArray+JG.h"

@implementation NSArray (JG)

- (NSArray *)jg_map:(JGMapBlock)mapBlock
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
