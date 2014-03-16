#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import "JGDocumentPath.h"
#import <FMDB/FMDatabase.h>

@interface T : NSObject<MLDatabaseObject>
@property (nonatomic) int64_t id;
@end

SpecBegin(DatabaseControllerFetch)

describe(@"DatabaseController Fetch", ^{

    NSURL *mappingURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
    __block MLDatabaseController *controller;
    
    __block NSArray *receivedItems = nil;
    
    beforeEach(^{
        controller = [[MLDatabaseController alloc] initWithMappingURL:mappingURL dbURL:nil];
        [controller.db createSpecTables];
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
                [controller runFetchForClass:[MLUser class]
                                  fetchBlock:nil
                           fetchResultsBlock:^(NSArray *items) {
                               
                           }];
            }).to.raiseAny();
        });
        
        it(@"raises an exception if no completionHandler", ^{
            expect(^{
                [controller runFetchForClass:[MLUser class]
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
            beforeEach(^{
                [MLUser insertInDb:controller.db userCount:5];
            });

            it(@"receives the users", ^{
                [controller runFetchForClass:[MLUser class]
                                  fetchBlock:^FMResultSet *(FMDatabase *db) {
                                      return [db executeQuery:@"SELECT * FROM User"];
                                  }
                           fetchResultsBlock:^(NSArray *items) {
                               receivedItems = items;
                           }];
                expect(receivedItems).willNot.beNil();
            });

            it(@"callback is called on the main thread", ^{
                __block BOOL isCallbackOnMainThread;
                [controller runFetchForClass:[MLUser class]
                                  fetchBlock:^FMResultSet *(FMDatabase *db) {
                                      return [db executeQuery:@"SELECT * FROM User"];
                                  }
                           fetchResultsBlock:^(NSArray *items) {
                               isCallbackOnMainThread = [NSThread isMainThread];
                           }];
                expect(isCallbackOnMainThread).will.equal(YES);
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
