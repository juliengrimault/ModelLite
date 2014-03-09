//
//  JGRDatabaseController.m
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRDatabaseController.h"
#import <FMDB/FMDatabase.h>

NSString *const DatabaseControllerNestedTransactionCount = @"com.juliengrimault.databasecontroller.nestedTransactionCount";
@interface JGRDatabaseController ()
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation JGRDatabaseController

- (id)initWithPath:(NSString *)dbPath
{
    self = [super init];
    if (!self) return nil;
    
    NSString *queueName = [NSString stringWithFormat:@"%@-%p", self.class, self];
    self.serialQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
    
    self.dbPath = dbPath;
    self.db = [[FMDatabase alloc] initWithPath:self.dbPath];
    if (![self.db open]) {
        NSLog(@"Could not create DatabaseController for path %@", self.dbPath);
        return nil;
    }
    
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
@end
