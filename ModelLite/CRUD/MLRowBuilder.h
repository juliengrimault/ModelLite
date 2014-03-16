//
//  MLRowBuilder.h
//  ModelLite
//
//  Created by Julien on 15/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLDatabaseObject.h"
@class FMResultSet, MLMapping;

@interface MLRowBuilder : NSObject

@property (nonatomic, strong, readonly) MLMapping *mapping;

- (id)initWithMapping:(MLMapping *)mapping;

// build a new model instance from the current row of the FMResultSet
// this method does not move the FMResultSet index (does not call `next`)
- (id<MLDatabaseObject>)buildInstanceFromRow:(FMResultSet *)row;

@end
