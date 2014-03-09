#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "JGRDatabaseController.h"
#import "JGRDatabaseController_Private.h"
#import <FMDB/FMDatabase.h>
#import "JGRDocumentPath.h"

SpecBegin(JGRDatabaseController)

describe(@"JGRDatabaseController", ^{

    NSString *dbPath = jgr_PathRelativeToUserDocument(@"test.sqlite3");
    __block JGRDatabaseController *controller;
    beforeEach(^{
        controller = [[JGRDatabaseController alloc] initWithPath:dbPath];
    });
    
    describe(@"init", ^{
        it(@"has the correct path", ^{
            expect(controller.dbPath).to.equal(dbPath);
        });
        
        it(@"has a database initialized", ^{
            expect(controller.db).toNot.beNil();
            expect(controller.db.databasePath).to.equal(dbPath);
        });
        
        it(@"has a serial queue", ^{
            expect(controller.serialQueue).toNot.beNil();
        });
    });    
    
    describe(@"run transaction", ^{
        __block id mockDb;
        beforeEach(^{
            mockDb = mock([FMDatabase class]);
            controller.db = mockDb;
        });
        
        it(@"wraps block in a transaction", ^{
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            
            [controller runInTransaction:^(FMDatabase *db) {
                dispatch_semaphore_signal(sema);
            }];
            
            [controller runInTransaction:^(FMDatabase *db) {
                dispatch_semaphore_signal(sema);
            }];
            
            dispatch_semaphore_wait(sema, 1.0);
            [verifyCount(mockDb, atLeastOnce()) beginTransaction];
            
            dispatch_semaphore_wait(sema, 1.0);
            [verifyCount(mockDb, atLeastOnce()) commit];
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
});

SpecEnd
