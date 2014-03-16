#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import "MLRowBuilder.h"


@interface JGRUserSubclass : MLUser
@end

SpecBegin(MLRowBuilderSpec)

describe(@"RowBuilder", ^{
    __block FMDatabase *db;
    __block MLRowBuilder *builder;
    __block FMResultSet *rs;
    __block MLUser *julien;

    beforeEach(^{
        db = [[FMDatabase alloc] initWithPath:nil];
        [db createSpecTables];
        builder = [[MLRowBuilder alloc] initWithMapping:[MLUser databaseMapping]];

        julien = [MLUser new];
        julien.id = 10;
        julien.name = @"Julien";
        julien.dob = [NSDate dateWithTimeIntervalSince1970:0];
        julien.deleted = NO;

        [MLUser insertInDb:db user:julien];
    });

    describe(@"matching result set", ^{
        beforeEach(^{
            rs = [db executeQuery:@"select * from User"];
            [rs next];//set to first row
        });
        
        it(@"assigns the class", ^{
            expect(builder.mapping).to.equal([MLUser databaseMapping]);
        });
        
        describe(@"building a model instance", ^{
            it(@"reads each property from the result set row", ^{
                MLUser *user = [builder buildInstanceFromRow:rs];
                expect(user.id).to.equal(julien.id);
                expect(user.name).to.equal(julien.name);
                expect(user.dob).to.equal(julien.dob);
                expect(user.deleted).to.equal(julien.deleted);
            });
            
            it(@"has not called awakeFromFetch since it is not implemented", ^{
                MLUser *user = [builder buildInstanceFromRow:rs];
                expect(user.hasAwakeFromFetchBeenCalled).to.beFalsy();
            });
        });
        
        describe(@"optional awakeFromFetch", ^{
            it(@"calls awakeFromFetch when implemented", ^{
                builder = [[MLRowBuilder alloc] initWithMapping:[JGRUserSubclass databaseMapping]];
                JGRUserSubclass *u = [builder buildInstanceFromRow:rs];
                expect(u.hasAwakeFromFetchBeenCalled).to.beTruthy();
            });
        });
    });
    
    
    describe(@"not matching result set", ^{
        beforeEach(^{
            rs = [db executeQuery:@"SELECT id, name AS yada from User"];
            [rs next];//set to first row
        });
        
        
        it(@"reads available properties from the result set row", ^{
            MLUser *user = [builder buildInstanceFromRow:rs];
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
