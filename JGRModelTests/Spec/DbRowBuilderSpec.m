#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "JGRRowFetchBuilder.h"
#import "JGRUser.h"
#import "MockResultSet.h"
#import "JGRDbMapping.h"

@interface JGRUserSubclass :JGRUser
@end

SpecBegin(JGRDbRowBuilderSpec)

describe(@"JGRDbRowBuilder", ^{
    __block JGRRowFetchBuilder *builder;
    __block MockResultSet *mockResultSet;
    
    beforeEach(^{
        builder = [[JGRRowFetchBuilder alloc] initWithMapping:[JGRUser databaseMapping]];
    });
    
    describe(@"matching result set", ^{
        beforeEach(^{
            mockResultSet = [[MockResultSet alloc] initWithRows:@[@[@10, @"Julien", [NSDate dateWithTimeIntervalSince1970:0], @NO]]
                                           columnNameToIndexMap:@{@"id" : @0, @"name" : @1, @"dob" : @2, @"deleted" : @3}];
            [mockResultSet next];//set to first row
        });
        
        it(@"assigns the class", ^{
            expect(builder.mapping).to.equal([JGRUser databaseMapping]);
        });
        
        describe(@"building a model instance", ^{
            it(@"reads each property from the result set row", ^{
                JGRUser *user = [builder buildInstanceFromRow:mockResultSet];
                expect(user.id).to.equal(10);
                expect(user.name).to.equal(@"Julien");
                expect(user.dob).to.equal([NSDate dateWithTimeIntervalSince1970:0]);
                expect(user.deleted).to.equal(NO);
            });
            
            it(@"doest not move the currentIndex", ^{
                __unused JGRUser *user = [builder buildInstanceFromRow:mockResultSet];
                expect(mockResultSet.currentRowIndex).to.equal(0);
            });
            
            it(@"has not called awakeFromFetch since it is not implemented", ^{
                JGRUser *user = [builder buildInstanceFromRow:mockResultSet];
                expect(user.hasAwakeFromFetchBeenCalled).to.beFalsy();
            });
        });
        
        describe(@"optional awakeFromFetch", ^{
            it(@"calls awakeFromFetch when implemented", ^{
                builder = [[JGRRowFetchBuilder alloc] initWithMapping:[JGRUserSubclass databaseMapping]];
                JGRUserSubclass *u = [builder buildInstanceFromRow:mockResultSet];
                expect(u.hasAwakeFromFetchBeenCalled).to.beTruthy();
            });
        });
    });
    
    
    describe(@"not matching result set", ^{
        beforeEach(^{
            mockResultSet = [[MockResultSet alloc] initWithRows:@[@[@10, @"Yada"]]
                                           columnNameToIndexMap:@{@"id" : @0, @"yada" : @1}];
            [mockResultSet next];//set to first row
        });
        
        
        it(@"reads available properties from the result set row", ^{
            JGRUser *user = [builder buildInstanceFromRow:mockResultSet];
            expect(user.id).to.equal(10);
            expect(user.name).to.beNil();
            expect(user.dob).to.beNil();
            expect(user.deleted).to.beFalsy();
        });
    });
});

SpecEnd

@implementation JGRUserSubclass
- (void)awakeFromFetch
{
    self.hasAwakeFromFetchBeenCalled = YES;
}
@end
