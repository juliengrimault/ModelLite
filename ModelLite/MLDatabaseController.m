//
//  MLDatabaseController.m
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLDatabaseController.h"
#import <FMDB/FMDatabase.h>
#import "MLDatabaseObject.h"
#import "MLPropertyMapping.h"
#import "FMResultSet+ModelLite.h"
#import "MLResultSetBuilder.h"
#import "MLMappingLoader.h"
#import "MLRowInsertBuilder.h"

NSString *const DatabaseControllerNestedTransactionCount = @"com.juliengrimault.databasecontroller.nestedTransactionCount";
@interface MLDatabaseController ()
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSURL *dbURL;
@property (nonatomic, strong) NSURL *mappingURL;
@property (nonatomic, strong) FMDatabase *db;

@property (nonatomic, strong) NSDictionary *databaseMappings;
@property (nonatomic, strong) NSMutableDictionary *classCache;
@end

@implementation MLDatabaseController

#pragma mark - Initialization
- (id)initWithMappingURL:(NSURL *)mappingURL dbURL:(NSURL *)dbURL
{
    NSParameterAssert(mappingURL != nil);
    
    self = [super init];
    if (!self) return nil;
    
    NSString *queueName = [NSString stringWithFormat:@"%@.%p", self.class, self];
    self.serialQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
 
    self.dbURL = dbURL;
    [self openDatabase];
    
    self.mappingURL = mappingURL;
    [self loadMappings];
    
    self.classCache = [[NSMutableDictionary alloc] init];
    
    return self;
}

- (void)openDatabase
{
    self.db = [[FMDatabase alloc] initWithPath:[self.dbURL path]];
    if (![self.db open]) {
        [NSException raise:[NSString stringWithFormat:@"%@Exception", self.class]
                    format:@"Could not create DatabaseController at URL %@", self.dbURL];
    }
}

- (void)loadMappings
{
    MLMappingLoader *loader = [[MLMappingLoader alloc] initWithMappingURL:self.mappingURL];
    NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    for (MLPropertyMapping *m in loader.allMappings) {
        mappings[(Class<NSCopying>)m.modelClass] = m;
    }
    self.databaseMappings = [mappings copy];
}


#pragma mark - Updates

- (void)runInTransaction:(MLDatabaseUpdateBlock)block
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


- (void)saveInstance:(NSObject<MLDatabaseObject> *)instance
{
    MLPropertyMapping *mapping = self.databaseMappings[instance.class];
    NSAssert1(mapping != nil, @"No database mapping found for class %@", instance.class);
    
    [self runInTransaction:^(FMDatabase *db) {
        
        // add the instance to the global cache
        NSMapTable *cache = [self instanceCacheForClass:[instance class]];
        [cache setObject:instance forKey:instance.primaryKeyValue];
        
        // insert in the db
        MLRowInsertBuilder *builder = [[MLRowInsertBuilder alloc] initWithMapping:mapping
                                                                           instance:instance];
        [builder executeStatement:db];
    }];
}

#pragma mark - Query

- (void)runFetchForClass:(Class<MLDatabaseObject>)klass
              fetchBlock:(MLDatabaseFetchBlock)fetchBlock
       fetchResultsBlock:(MLDatabaseFetchResultsBlock)fetchResultBlock
{
    NSParameterAssert(klass); NSParameterAssert(fetchBlock); NSParameterAssert(fetchResultBlock);
    
    MLPropertyMapping *mapping = self.databaseMappings[klass];
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
        dispatch_async(dispatch_get_main_queue(), ^{
            fetchResultBlock(fetchedObjects);
        });
    });
}

- (NSArray *)databaseObjectsWithResultSet:(FMResultSet *)resultSet mapping:(MLPropertyMapping *)mapping
{
    NSMapTable *instanceCache = [self instanceCacheForClass:mapping.modelClass];
    MLResultSetBuilder *resultSetBuilder = [[MLResultSetBuilder alloc] initWithInstanceCache:instanceCache mapping:mapping];
    return [resultSetBuilder buildInstancesFromResultSet:resultSet];
}


#pragma mark - Helper

// not thread-safe but is only called inside the serial queue
// hence no concurrent access
- (NSMapTable *)instanceCacheForClass:(Class<MLDatabaseObject>)klass
{
    NSMapTable *instanceCache = self.classCache[klass];
    if (instanceCache == nil) {
        instanceCache = [NSMapTable strongToWeakObjectsMapTable];
        self.classCache[(id<NSCopying>)klass] = instanceCache;
    }
    return instanceCache;
}

@end
