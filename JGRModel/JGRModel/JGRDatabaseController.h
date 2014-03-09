//
//  JGRDatabaseController.h
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;
@class FMResultSet;
@protocol JGRDbObject;

typedef void(^JGRDatabaseUpdateBlock)(FMDatabase *db);
typedef FMResultSet *(^JGRDatabaseFetchBlock)(FMDatabase *db);
typedef  void(^JGRDatabaseFetchResultsBlock)(NSArray *items);

@interface JGRDatabaseController : NSObject

@property (nonatomic, readonly, strong) NSURL *dbURL;

- (id)initWithMappingURL:(NSURL *)mappingURL dbURL:(NSURL *)dbURL;


- (void)runInTransaction:(JGRDatabaseUpdateBlock)block;

- (void)runFetchForClass:(Class<JGRDbObject>)klass
              fetchBlock:(JGRDatabaseFetchBlock)fetchBlock
       fetchResultsBlock:(JGRDatabaseFetchResultsBlock)fetchResultBlock;

@end
