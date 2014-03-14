//
//  MLRowInsertBuilder.h
//  ModelLite
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;
#import "MLDbObject.h"
@class MLDbMapping, FMDatabase;

@interface MLRowInsertBuilder : NSObject

@property (nonatomic, readonly, copy) NSString *statement;
@property (nonatomic, readonly, copy) NSArray *statementArgument;

- (id)initWithMapping:(MLDbMapping *)mapping instance:(NSObject<MLDbObject> *)instance;

- (BOOL)executeStatement:(FMDatabase *)db;
@end
