#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "JGRDbRowBuilder.h"
#import "JGRUser.h"
#import "MockResultSet.h"
#import "JGRDbMapping.h"

SpecBegin(JGRDbRowBuilderSpec)

describe(@"JGRDbRowBuilder", ^{
    __block JGRDbRowBuilder *builder;
    __block MockResultSet *mockResultSet;
    
    beforeEach(^{
        builder = [[JGRDbRowBuilder alloc] initWithMapping:[JGRUser databaseMapping]];
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
