#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import "JGRDatabaseController.h"
#import "JGRDocumentPath.h"
#import <FMDB/FMDatabase.h>

@interface T : NSObject<JGRDbObject>
@property (nonatomic) int64_t id;
@end

SpecBegin(DatabaseControllerFetch)

describe(@"DatabaseController Fetch", ^{
    
    NSURL *dbURL = jgr_URLRelativeToUserDocument(@"test.sqlite3");
    NSURL *mappingURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
    __block JGRDatabaseController *controller;
    
    __block NSArray *receivedItems = nil;
    
    beforeEach(^{
        controller = [[JGRDatabaseController alloc] initWithMappingURL:mappingURL dbURL:dbURL];
    });
    
    describe(@"fetch query", ^{
        it(@"raises an exception if no class", ^{
            expect(^{
                [controller runFetchForClass:nil
                                  fetchBlock:^FMResultSet *(FMDatabase *db) {
                                      return nil;
                                  }
                           fetchResultsBlock:^(NSArray *items) {
                               
                           }];
            }).to.raiseAny();
        });
        
        it(@"raises an exception if no fetchBlock", ^{
            expect(^{
                [controller runFetchForClass:[JGRUser class]
                                  fetchBlock:nil
                           fetchResultsBlock:^(NSArray *items) {
                               
                           }];
            }).to.raiseAny();
        });
        
        it(@"raises an exception if no completionHandler", ^{
            expect(^{
                [controller runFetchForClass:[JGRUser class]
                                  fetchBlock:^FMResultSet *(FMDatabase *db) {
                                      return nil;
                                  }
                           fetchResultsBlock:nil];
            }).to.raiseAny();
        });
        
        it(@"raises an exception if there is no mapping for the class", ^{
            expect(^{
                [controller runFetchForClass:[T class]
                                  fetchBlock:^FMResultSet *(FMDatabase *db) {
                                      return nil;
                                  }
                           fetchResultsBlock:^(NSArray *items) {
                               
                           }];
            }).to.raiseAny();
        });
        
        describe(@"successful query", ^{
            __block MockResultSet *resultSet;
            beforeEach(^{
                resultSet = [MockResultSet userSet:2][@"resultSet"];
                FMDatabase *mockDb = mock([FMDatabase class]);
                [given([mockDb executeQuery:anything()]) willReturn:resultSet];
                controller.db = mockDb;
            });
            
            it(@"receives the users", ^{
                [controller runFetchForClass:[JGRUser class]
                                  fetchBlock:^FMResultSet *(FMDatabase *db) {
                                      return [db executeQuery:@"SELECT * FROM User"];
                                  }
                           fetchResultsBlock:^(NSArray *items) {
                               receivedItems = items;
                           }];
                expect(receivedItems).willNot.beNil();
            });
        });
    });

});

SpecEnd

@implementation T

- (id)primaryKeyValue
{
    return @(self.id);
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end
