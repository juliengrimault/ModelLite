#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import <FMDB/FMDatabase.h>
#import <ObjectiveSugar/ObjectiveSugar.h>

SpecBegin(JGRDatabaseControllerUpdate)

describe(@"DatabaseController", ^{
    NSURL *mappingURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
    __block MLDatabaseController *controller;
    
    beforeEach(^{
        // in memory database
        controller = [[MLDatabaseController alloc] initWithMappingURL:mappingURL dbURL:nil];
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
            instance.dob = [[@20 years] ago];
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

        describe(@"existing row in the db", ^{
            beforeEach(^{
                BOOL success = [controller.db executeUpdate:@"INSERT INTO User (id, name, dob, deleted) VALUES (?, ?, ?, ?)"
                                       withArgumentsInArray:@[@(instance.id), @"Another Name", [NSDate date] , @(instance.deleted)]];
                expect(success).to.beTruthy();
            });

            it(@"it does not create a new row", ^{
                [controller saveInstance:instance];

                __block NSInteger rowCount = 0;
                dispatch_async(controller.serialQueue, ^{
                    FMResultSet *rs = [controller.db executeQuery:@"SELECT COUNT(*) FROM User"];
                    if ([rs next]) {
                        rowCount = [rs intForColumnIndex:0];
                    }
                });

                expect(rowCount).will.equal(1);
            });

            it(@"it updates the existing row", ^{
                [controller saveInstance:instance];

                __block BOOL rowFetched = NO;
                dispatch_async(controller.serialQueue, ^{
                    FMResultSet *rs = [controller.db executeQuery:@"SELECT * FROM User"];
                    if ([rs next]) {
                        rowFetched = YES;

                        expect([rs intForColumn:@"id"]).to.equal(instance.id);
                        expect([rs stringForColumn:@"name"]).to.equal(instance.name);
                        expect([rs dateForColumn:@"dob"]).to.equal(instance.dob);
                        expect([rs boolForColumn:@"deleted"]).to.equal(instance.deleted);
                    }
                });

                expect(rowFetched).will.equal(YES);
            });
        });
        
    });
});

SpecEnd
