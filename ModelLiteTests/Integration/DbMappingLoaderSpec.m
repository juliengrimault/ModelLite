#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "MLMappingLoader.h"
#import "MLPropertyMapping.h"

SpecBegin(JGRDbMappingLoader)

describe(@"MLMappingLoader", ^{
    __block MLMappingLoader *loader;
    __block NSDictionary *loadedDictionary;
    beforeEach(^{
        NSURL *url = [[NSBundle bundleForClass:[self class]] URLForResource:@"TestMapping" withExtension:@"plist"];
        loadedDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
        
        loader = [[MLMappingLoader alloc] initWithMappingURL:url];
    });
    
    it(@"has the mappings from the files", ^{
        expect(loader.allMappings).to.haveCountOf(loadedDictionary.count);
    });
    
    it(@"access the mapping by class name", ^{
        for (NSString *className in loadedDictionary) {
            NSDictionary *dict = loadedDictionary[className];
            MLPropertyMapping *mapping = [loader mappingForClassName:className];
            
            expect(mapping.tableName).to.equal(dict[@"tableName"]);
            expect(mapping.properties).to.haveCountOf([dict[@"properties"] count]);
        }
    });
    
});

SpecEnd
