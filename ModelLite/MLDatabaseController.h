//
//  MLDatabaseController.h
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;
@class FMDatabase;
@class FMResultSet;
@protocol MLDbObject;

typedef void(^MLDatabaseUpdateBlock)(FMDatabase *db);
typedef FMResultSet *(^MLDatabaseFetchBlock)(FMDatabase *db);
typedef  void(^MLDatabaseFetchResultsBlock)(NSArray *items);

@interface MLDatabaseController : NSObject

@property (nonatomic, readonly, strong) NSURL *dbURL;

#pragma mark - Initialization
- (id)initWithMappingURL:(NSURL *)mappingURL dbURL:(NSURL *)dbURL;

#pragma mark - Updates
- (void)runInTransaction:(MLDatabaseUpdateBlock)block;
- (void)saveInstance:(NSObject<MLDbObject> *)instance;

#pragma mark - Query
- (void)runFetchForClass:(Class<MLDbObject>)klass
              fetchBlock:(MLDatabaseFetchBlock)fetchBlock
       fetchResultsBlock:(MLDatabaseFetchResultsBlock)fetchResultBlock;



@end
