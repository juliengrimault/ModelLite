#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import "JGRRowInsertBuilder.h"
#import <FMDB/FMDatabase.h>

SpecBegin(RowInsertBuilderSpec)

describe(@"RowInsertBuilder", ^{
    __block JGRRowInsertBuilder *builder;
    __block JGRDbMapping *mapping;
    __block JGRUser *instance;
    
    beforeEach(^{
        mapping = [JGRUser databaseMapping];
        instance = [JGRUser userWithId:123];
        instance.dob = nil;
    });
    
    it(@"raises an exception when instance is nil", ^{
        expect(^{
            builder = [[JGRRowInsertBuilder alloc] initWithMapping:mapping instance:nil];
        }).to.raiseAny();
    });
    
    it(@"raises an exception when mapping is nil", ^{
        expect(^{
            builder = [[JGRRowInsertBuilder alloc] initWithMapping:nil instance:instance];
        }).to.raiseAny();
    });
    
    it(@"raises an exception when mapping is not for the instance class", ^{
        expect(^{
            builder = [[JGRRowInsertBuilder alloc] initWithMapping:[JGRComment databaseMapping] instance:instance];
        }).to.raiseAny();
    });    
});

SpecEnd
