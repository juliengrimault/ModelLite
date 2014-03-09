//
//  JGRDatabaseController.m
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRDatabaseController.h"
#import <FMDB/FMDatabase.h>
#import "JGRDbObject.h"
#import "JGRDbMapping.h"
#import "FMResultSet+JGRModel.h"
#import "JGRDbResultSetBuilder.h"
#import "JGRDbMappingLoader.h"

NSString *const DatabaseControllerNestedTransactionCount = @"com.juliengrimault.databasecontroller.nestedTransactionCount";
@interface JGRDatabaseController ()
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSURL *dbURL;
@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) NSDictionary *databaseMappings;
@property (nonatomic, strong) NSMutableDictionary *classCache;
@end

@implementation JGRDatabaseController

- (id)initWithMappingURL:(NSURL *)mappingURL dbURL:(NSURL *)dbURL
{
    NSParameterAssert(mappingURL != nil);
    NSParameterAssert(dbURL != nil);
    
    self = [super init];
    if (!self) return nil;
    
    NSString *queueName = [NSString stringWithFormat:@"%@-%p", self.class, self];
    self.serialQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
    
    self.dbURL = dbURL;
    self.db = [[FMDatabase alloc] initWithPath:[self.dbURL path]];
    if (![self.db open]) {
        [NSException raise:[NSString stringWithFormat:@"%@Exception", self.class]
                    format:@"Could not create DatabaseController at URL %@", self.dbURL];
        return nil;
    }
    
    JGRDbMappingLoader *loader = [[JGRDbMappingLoader alloc] initWithMappingURL:mappingURL];
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    for (JGRDbMapping *m in loader.allMappings) {
        mappings[(Class<NSCopying>)m.modelClass] = m;
    }
    self.databaseMappings = [mappings copy];
    
    self.classCache = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)runInTransaction:(JGRDatabaseUpdateBlock)block
{
    NSParameterAssert(block);
    
    dispatch_async(self.serialQueue, ^{
        @autoreleasepool {
            [self.db beginTransaction];
            block(self.db);
            [self.db commit];
        }
    });
}


- (void)runFetchForClass:(Class<JGRDbObject>)klass
              fetchBlock:(JGRDatabaseFetchBlock)fetchBlock
       fetchResultsBlock:(JGRDatabaseFetchResultsBlock)fetchResultBlock
{
    NSParameterAssert(klass); NSParameterAssert(fetchBlock); NSParameterAssert(fetchResultBlock);
    
    JGRDbMapping *mapping = self.databaseMappings[klass];
    NSAssert1(mapping != nil, @"No database mapping found for class %@", klass);
    
    dispatch_async(self.serialQueue, ^{
        FMResultSet *rs = fetchBlock(self.db);
        
        if (rs == nil && self.db.lastError != nil) {
            [NSException raise:[NSString stringWithFormat:@"%@Exception", self.class]
                        format:@"Invalid querry: %@", self.db.lastError];
            fetchResultBlock(nil);
            return;
        }
        
        NSArray *fetchedObjects = [self databaseObjectsWithResultSet:rs mapping:mapping];
        fetchResultBlock(fetchedObjects);
    });
}

- (NSArray *)databaseObjectsWithResultSet:(FMResultSet *)resultSet mapping:(JGRDbMapping *)mapping
{
    NSMapTable *instanceCache = [self instanceCacheForClass:mapping.modelClass];
    JGRDbResultSetBuilder *resultSetBuilder = [[JGRDbResultSetBuilder alloc] initWithInstanceCache:instanceCache mapping:mapping];
    return [resultSetBuilder buildInstancesFromResultSet:resultSet];
}

- (NSMapTable *)instanceCacheForClass:(Class<JGRDbObject>)klass
{
    NSMapTable *instanceCache = self.classCache[klass];
    if (instanceCache == nil) {
        instanceCache = [NSMapTable strongToWeakObjectsMapTable];
        self.classCache[(id<NSCopying>)klass] = instanceCache;
    }
    return instanceCache;
}

@end
