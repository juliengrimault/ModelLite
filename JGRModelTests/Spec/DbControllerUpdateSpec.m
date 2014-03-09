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
#import "MockResultSet.h"
#import "JGRUser.h"
#import "JGRDbMappingLoader.h"
#import "JGRDbMapping.h"

SpecBegin(JGRDatabaseControllerUpdate)

describe(@"DatabaseController", ^{

    NSURL *dbURL = jgr_URLRelativeToUserDocument(@"test.sqlite3");
    NSURL *mappingURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
    
    __block JGRDatabaseController *controller;
    beforeEach(^{
        controller = [[JGRDatabaseController alloc] initWithMappingURL:mappingURL dbURL:dbURL];
    });
    
    describe(@"init", ^{
        it(@"has the correct path", ^{
            expect(controller.dbURL).to.equal(dbURL);
        });
        
        it(@"has a database initialized", ^{
            expect(controller.db).toNot.beNil();
            expect(controller.db.databasePath).to.equal([dbURL path]);
        });
        
        it(@"has a serial queue", ^{
            expect(controller.serialQueue).toNot.beNil();
        });
        
        it(@"has database mappings", ^{
            JGRDbMappingLoader *mappingLoader = [[JGRDbMappingLoader alloc] initWithMappingURL:mappingURL];
            for (JGRDbMapping *m in mappingLoader.allMappings) {
                expect(controller.databaseMappings[m.modelClass]).to.equal(m);
            }
        });
    });
    
    describe(@"wrong initialization", ^{
        it(@"raises if no db url is given", ^{
            expect(^{
                __unused id c = [[JGRDatabaseController alloc] initWithMappingURL:mappingURL dbURL:nil];
            }).to.raiseAny();
        });
        
        it(@"raises if no mapping url is given", ^{
            expect(^{
                __unused id c = [[JGRDatabaseController alloc] initWithMappingURL:nil dbURL:dbURL];
            }).to.raiseAny();
        });
        
        it(@"raises if the db url cannot be opened", ^{
            expect(^{
                NSURL *garbageURL = [NSURL fileURLWithPath:@"/yada/youpi/super.sqlite3"];
                __unused id c = [[JGRDatabaseController alloc] initWithMappingURL:mappingURL dbURL:garbageURL];
            }).to.raiseAny();
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
