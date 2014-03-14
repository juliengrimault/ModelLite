//
//  NSArray+JGR.h
//  ModelLite
//
//  Created by Julien on 13/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;

typedef  id(^JGMapBlock)(id object);

@interface NSArray (JG)

- (NSArray *)jg_map:(JGMapBlock)mapBlock;

@end
