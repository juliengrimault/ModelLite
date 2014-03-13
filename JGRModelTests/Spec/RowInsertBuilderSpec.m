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
    
    describe(@"", ^{
        beforeEach(^{
            builder = [[JGRRowInsertBuilder alloc] initWithMapping:mapping instance:instance];
        });
        
        describe(@"generate insert statement", ^{
            it(@"generates the prefix of the statement ", ^{
                NSString *downcased = [builder.statement lowercaseString];
                
                NSString *columnNames = [mapping.properties.allKeys componentsJoinedByString:@", "];
                NSString *valuePlaceHolders = [[mapping.properties.allKeys jgr_map:^id(id object) {
                    return @"?";
                }] componentsJoinedByString:@", "];
                
                NSString *statement = [NSString stringWithFormat:@"insert or replace into user (%@) values (%@);",
                                      columnNames,
                                      valuePlaceHolders];
                expect(downcased).to.equal(statement);
                
            });
            
            
            it(@"generates the insert value", ^{
                expect(builder.statementArgument).to.haveCountOf(mapping.properties.count);
                int i = 0;
                for (NSString *columnName in [mapping.properties allKeys]) {
                    id value = [instance valueForKeyPath:columnName];
                    if (value == nil) {
                        value = [NSNull null];
                    }
                    expect(builder.statementArgument[i]).to.equal(value);
                    i++;
                }
            });
        });
        
        describe(@"execute statement", ^{
            it(@"executes the statement with the parameters against the db", ^{
                FMDatabase *mockDb = mock([FMDatabase class]);
                [builder executeStatement:mockDb];
                [verify(mockDb) executeUpdate:builder.statement withArgumentsInArray:builder.statementArgument];
            });
        });
    });
});

SpecEnd
