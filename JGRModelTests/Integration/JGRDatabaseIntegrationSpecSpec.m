#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import <FMDB/FMDatabase.h>
#import "JGRDatabaseController.h"
#import "JGRDataBaseController_Private.h"
#import "JGRDocumentPath.h"

void clearOldFile(NSString * path) {
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:path]) {
        [defaultManager removeItemAtPath:path error:nil];
    }
}

void createUserTable(JGRDatabaseController *controller) {
    [controller runInTransaction:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE TABLE User (id INTEGER PRIMARY KEY, name TEXT, createdAt DATE);"];
    }];
}

SpecBegin(JGRDatabaseIntegrationSpecSpec)

describe(@"JGRDatabaseIntegrationSpec", ^{
    NSString *databasePath = jgr_PathRelativeToUserDocument(@"test.sqlite3");
    __block JGRDatabaseController *controller;
    beforeEach(^{
        clearOldFile(databasePath);
        controller = [[JGRDatabaseController alloc] initWithPath:databasePath];
        controller.db.traceExecution = YES;
    });
    
    it(@"creates the table", ^{
        
        createUserTable(controller);
        
        __block NSString *tableName = nil;
        __block NSInteger count = 0;
        
        [controller runInTransaction:^(FMDatabase *db) {
            FMResultSet *s = [db executeQuery:
                              @"SELECT name FROM sqlite_master WHERE type = ?", @"table"];
            
            while ([s next]) {
                count++;
                tableName = s[@"name"];
            }
        }];
        
        expect(tableName).will.equal(@"User");
        expect(count).will.equal(1);
        
    });
    
    
    it(@"inserts user elements", ^{
        createUserTable(controller);
        
        NSInteger userCountToInsert = 10;
        [controller runInTransaction:^(FMDatabase *db) {
            for (int i = 0; i < userCountToInsert; i++) {
                [db executeUpdate:@"INSERT INTO User values (NULL, ?, ?)",
                 [NSString stringWithFormat:@"User%d", i],
                 [NSDate date]];
            }
        }];
        
        __block NSInteger userCount = 0;
        [controller runInTransaction:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"SELECT count(*) from User"];
            if ([rs next]) {
                userCount = [rs[0] integerValue];
            }
        }];
        
        expect(userCount).will.equal(userCountToInsert);
    });
});

SpecEnd
