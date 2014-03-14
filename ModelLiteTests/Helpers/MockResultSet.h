//
//  MockResultSet.h
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "FMResultSet.h"

@interface MockResultSet : FMResultSet

@property (nonatomic, readonly) NSInteger currentRowIndex;

// an array of arrays
- (id)initWithRows:(NSArray *)rows columnNameToIndexMap:(NSDictionary *)map;
@end
