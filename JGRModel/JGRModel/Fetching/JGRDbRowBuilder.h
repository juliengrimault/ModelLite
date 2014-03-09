//
//  JGRDbRowBuilder.h
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol JGRDbObject;
@class JGRDbMapping;
@class FMResultSet;

@interface JGRDbRowBuilder : NSObject

@property (nonatomic, strong, readonly) JGRDbMapping *mapping;


- (id)initWithMapping:(JGRDbMapping *)mapping;

- (id<JGRDbObject>)buildInstanceFromRow:(FMResultSet *)row;
@end
