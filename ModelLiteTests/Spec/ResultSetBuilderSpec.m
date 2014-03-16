#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "MLResultSetBuilder.h"
#import "JGRUser.h"
#import "MockResultSet.h"

@interface MLResultSetBuilder ()
@property (nonatomic, strong) NSMapTable *instanceCache;
@end

SpecBegin(JGRDbResultSetBuilder)
describe(@"sanity checks", ^{
    it(@"raises exception if mapping is nil", ^{
        expect(^{
            __unused id b = [[MLResultSetBuilder alloc] initWithInstanceCache:[NSMapTable strongToWeakObjectsMapTable]
                                                                         mapping:nil];
        }).to.raiseAny();
    });
    
    it(@"raises exception if instance cache is nil", ^{
        expect(^{
            __unused id b = [[MLResultSetBuilder alloc] initWithInstanceCache:nil
                                                                         mapping:[JGRUser databaseMapping]];
        }).to.raiseAny();
    });
});

describe(@"JGRDbResultSetBuilder", ^{
    __block MLResultSetBuilder *builder;
    __block NSMapTable *instanceCache;
    
    __block NSArray *users;
    __block JGRUser *userInCache;
    
    __block NSArray *fetchedUsers;
    beforeEach(^{
        instanceCache = [NSMapTable strongToWeakObjectsMapTable];
        builder = [[MLResultSetBuilder alloc] initWithInstanceCache:instanceCache mapping:[JGRUser databaseMapping]];
    });
    
    it(@"assign the class", ^{
        expect(builder.mapping).to.equal([JGRUser databaseMapping]);
    });
    
    describe(@"Fetching", ^{
        beforeEach(^{
            NSDictionary *d = [MockResultSet userSet:5];
            MockResultSet *mockResultSet = d[@"resultSet"];
            users = d[@"users"];
            userInCache = users.firstObject;
            
            [instanceCache setObject:userInCache forKey:@(userInCache.id)];
            
           fetchedUsers = [builder buildInstancesFromResultSet:mockResultSet];
        });
        
        it(@"has the expected number of user", ^{
            expect(fetchedUsers).to.haveCountOf(users.count);
        });
        
        it(@"does not create new instances when the primary key in the cache", ^{
            BOOL foundCachedVersion = NO;
            for (JGRUser *u in fetchedUsers) {
                if (u.id == userInCache.id) {
                    expect(u).to.beIdenticalTo(userInCache);
                    foundCachedVersion = YES;
                }
            }
            expect(foundCachedVersion).to.beTruthy();
        });
        
        it(@"creates new instance when the primary key is not in the cache", ^{
            NSInteger i = 0;
            for (JGRUser *fetchedUser in fetchedUsers) {
                JGRUser *u = users[i];
                expect(fetchedUser.id).to.equal(u.id);
                
                if (fetchedUser.id != userInCache.id) {
                    expect(fetchedUser).toNot.beIdenticalTo(u);
                }
                i++;
            }
        });
        
        it(@"populate the cache with the entity created", ^{
            for (JGRUser *u in fetchedUsers) {
                expect([builder.instanceCache objectForKey:@(u.id)]).notTo.beNil();
            }
        });
    });
});

SpecEnd
