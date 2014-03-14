#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import <FMDB/FMDatabase.h>
#import "JGRDbMappingLoader.h"
#import "JGRDocumentPath.h"

SpecBegin(JGRDatabaseControllerUpdate)

describe(@"DatabaseController", ^{
    NSURL *mappingURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
    __block JGRDatabaseController *controller;
    
    beforeEach(^{
        // in memory database
        controller = [[JGRDatabaseController alloc] initWithMappingURL:mappingURL dbURL:nil];
        controller.db.traceExecution = YES;
    });
    
    describe(@"run transaction", ^{
        __block id mockDb;
        beforeEach(^{
            mockDb = mock([FMDatabase class]);
            controller.db = mockDb;
        });
        
        it(@"wraps block in a transaction", ^{
            
            [controller runInTransaction:^(FMDatabase *db) {
            }];

            __block BOOL mockVerificationRan = NO;
            dispatch_async(controller.serialQueue, ^{
                [verify(mockDb) beginTransaction];
                [verify(mockDb) commit];
                mockVerificationRan = YES;
            });
            expect(mockVerificationRan).will.equal(YES);
        });
        
        it(@"executes the block in the serial queue", ^{
            __block dispatch_queue_t ranOnQueue;
            [controller runInTransaction:^(FMDatabase *db) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
                ranOnQueue = dispatch_get_current_queue();
#pragma GCC diagnositc pop
            }];
            
            expect(ranOnQueue).will.equal(controller.serialQueue);
        });
    });
    
    describe(@"save instance", ^{
        __block JGRUser *instance;
        beforeEach(^{
            // run directly against the db so that it's synchronous
            [controller.db executeUpdate:[JGRUser createTableStatement]];
            
            instance = [[JGRUser alloc] init];
            instance.id = 123;
            instance.name = @"Julien";
            instance.dob = [NSDate date];
            instance.deleted = NO;
        });
        
        it(@"insert a new row in the user table", ^{
            [controller saveInstance:instance];
            
            __block NSInteger idFetched = 0;
            dispatch_async(controller.serialQueue, ^{
                FMResultSet * rs = [controller.db executeQuery:@"SELECT * FROM User WHERE id = ?", @(instance.id)];
                if ([rs next]) {
                    idFetched = [rs intForColumnIndex:0];
                }
            });
            
            expect(idFetched).will.equal(instance.id);
        });
        
        it(@"adds the instance to the entity cache", ^{
            [controller saveInstance:instance];
            
            expect([controller.classCache[[JGRUser class]] objectForKey:@(instance.id)]).willNot.beNil();
        });
        
    });
});

SpecEnd
