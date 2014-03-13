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

#pragma mark - Initialization
- (id)initWithMappingURL:(NSURL *)mappingURL dbURL:(NSURL *)dbURL;

#pragma mark - Updates
- (void)runInTransaction:(JGRDatabaseUpdateBlock)block;
- (void)saveInstance:(NSObject<JGRDbObject> *)instance;

#pragma mark - Query
- (void)runFetchForClass:(Class<JGRDbObject>)klass
              fetchBlock:(JGRDatabaseFetchBlock)fetchBlock
       fetchResultsBlock:(JGRDatabaseFetchResultsBlock)fetchResultBlock;



@end
