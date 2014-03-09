#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>
#import "Integration.h"

#import <FMDB/FMDatabase.h>
#import "JGRDatabaseController.h"
#import "JGRDataBaseController_Private.h"
#import "JGRDocumentPath.h"
#import "JGRUser.h"

void createUserTable(JGRDatabaseController *controller) {
    [controller runInTransaction:^(FMDatabase *db) {
        [db executeUpdate:[JGRUser createTableStatement]];
    }];
}

SpecBegin(JGRDatabaseIntegrationSpecSpec)

describe(@"JGRDatabaseIntegrationSpec", ^{
    NSURL *databaseURL = jgr_URLRelativeToUserDocument(@"test.sqlite3");
    NSURL *mappingURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
    __block JGRDatabaseController *controller;
    beforeEach(^{
        [Integration deleteFileIfExist:databaseURL];
        controller = [[JGRDatabaseController alloc] initWithMappingURL:mappingURL dbURL:databaseURL];
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
                [db executeUpdate:@"INSERT INTO User values (NULL, ?, ?, ?)",
                 [NSString stringWithFormat:@"User%d", i],
                 [NSDate date],
                 @NO];
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
