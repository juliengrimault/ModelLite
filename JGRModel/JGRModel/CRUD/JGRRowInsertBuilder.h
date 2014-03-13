//
//  JGRRowInsertBuilder.h
//  JGRModel
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JGRDbObject.h"
@class JGRDbMapping, FMDatabase;

@interface JGRRowInsertBuilder : NSObject

@property (nonatomic, readonly, copy) NSString *statement;
@property (nonatomic, readonly, copy) NSArray *statementArgument;

- (id)initWithMapping:(JGRDbMapping *)mapping instance:(NSObject<JGRDbObject> *)instance;

- (BOOL)executeStatement:(FMDatabase *)db;
@end
