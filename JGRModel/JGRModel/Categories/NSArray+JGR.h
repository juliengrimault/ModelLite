//
//  NSArray+JGR.h
//  JGRModel
//
//  Created by Julien on 13/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef  id(^JGRMapBlock)(id object);

@interface NSArray (JGR)

- (NSArray *)jgr_map:(JGRMapBlock)mapBlock;

@end
