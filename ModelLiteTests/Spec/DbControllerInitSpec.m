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
#import "MLMappingLoader.h"

SpecBegin(DbControllerInitSpec)

describe(@"DbControllerInit", ^{

    NSURL *dbURL = jg_URLRelativeToUserDocument(@"test.sqlite3");
    NSURL *mappingURL = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
    
    __block MLDatabaseController *controller;
    beforeEach(^{
        [Integration deleteFileIfExist:dbURL];
        controller = [[MLDatabaseController alloc] initWithMappingURL:mappingURL dbURL:dbURL];
        controller.db.traceExecution = YES;
    });
    
    describe(@"init", ^{
        it(@"has the correct path", ^{
            expect(controller.dbURL).to.equal(dbURL);
        });
        
        it(@"has a database initialized", ^{
            expect(controller.db).toNot.beNil();
            expect(controller.db.databasePath).to.equal([dbURL path]);
        });
        
        it(@"has a serial queue", ^{
            expect(controller.serialQueue).toNot.beNil();
        });
        
        it(@"has database mappings", ^{
            MLMappingLoader *mappingLoader = [[MLMappingLoader alloc] initWithMappingURL:mappingURL];
            for (
MLPropertyMapping *m in mappingLoader.allMappings) {
                expect(controller.databaseMappings[m.modelClass]).to.equal(m);
            }
        });
    });
    
    describe(@"wrong initialization", ^{
        it(@"raises if no mapping url is given", ^{
            expect(^{
                __unused id c = [[MLDatabaseController alloc] initWithMappingURL:nil dbURL:dbURL];
            }).to.raiseAny();
        });
        
        it(@"raises if the db url cannot be opened", ^{
            expect(^{
                NSURL *garbageURL = [NSURL fileURLWithPath:@"/yada/youpi/super.sqlite3"];
                __unused id c = [[MLDatabaseController alloc] initWithMappingURL:mappingURL dbURL:garbageURL];
            }).to.raiseAny();
        });
    });
    

    
});

SpecEnd
