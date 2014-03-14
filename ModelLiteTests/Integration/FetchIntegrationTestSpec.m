#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "JGRDatabaseController_Private.h"
#import <FMDB/FMDatabase.h>
#import "JGRUser.h"
#import "JGDocumentPath.h"
#import "Integration.h"

void insertUsers(FMDatabase *db) {
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    comps.year = 1987;
    comps.month = 3;
    comps.day = 22;
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDate *julienDOB = [cal dateFromComponents:comps];
    
    comps.month = 8;
    NSDate *peiJunDOB = [cal dateFromComponents:comps];
    
    comps.year = 1989;
    comps.month = 6;
    comps.day = 21;
    NSDate *alexDOB = [cal dateFromComponents:comps];
    
    [db executeUpdate:@"INSERT INTO User values (NULL, ?, ?, ?)", @"Julien", julienDOB, @NO];
    [db executeUpdate:@"INSERT INTO User values (NULL, ?, ?, ?)", @"Pei Jun", peiJunDOB, @NO];
    [db executeUpdate:@"INSERT INTO User values (NULL, ?, ?, ?)", @"Alexandre", alexDOB, @YES];
}

SpecBegin(FetchIntegrationTestSpec)

describe(@"FetchIntegrationTest", ^{
    __block MLDatabaseController *controller;
    
    beforeEach(^{
        NSURL *dbURL = jg_URLRelativeToUserDocument(@"test.sqlite3");
        [Integration deleteFileIfExist:dbURL];
        controller = [[MLDatabaseController alloc] initWithMappingURL:nil dbURL:dbURL];
        
        //run create and insert directly against the db so that it is synchronous.
        [controller.db executeUpdate:[JGRUser createTableStatement]];
        insertUsers(controller.db);
    });
    
//    it(@"fetches users", ^{
//        __block NSArray *fetchedUsers = nil;
//        [controller runFetchForClass:[JGRUser class]
//                          fetchBlock:^FMResultSet *(FMDatabase *db) {
//                              return [db executeQuery:@"SELECT * from User where name = ?", @"Julien"];
//                          }
//                   fetchResultsBlock:^void(NSArray *items) {
//                       fetchedUsers = items;
//                   }];
//        expect(fetchedUsers).willNot.beNil();
//        expect(fetchedUsers.count).will.equal(1);
//    });
});

SpecEnd
