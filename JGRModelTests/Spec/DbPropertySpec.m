#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "JGRDbPropertyType.h"


SpecBegin(DbPropertySpec)

describe(@"DbPropertyType", ^{
    it(@"give type DbPropertyTypeInt64 for string 'int64'", ^{
        expect([@"int64" jgr_propertType]).to.equal(DbPropertyInt64);
    });
    
    it(@"give type DbPropertyTypeNSNumber for string 'number'", ^{
        expect([@"number" jgr_propertType]).to.equal(DbPropertyNSNumber);
    });
    
    it(@"give type DbPropertyTypeBOOL for string 'boolean'", ^{
        expect([@"boolean" jgr_propertType]).to.equal(DbPropertyBOOL);
    });
    
    it(@"give type DbPropertyTypeDate for string 'date'", ^{
        expect([@"boolean" jgr_propertType]).to.equal(DbPropertyBOOL);
    });
    
    it(@"give type DbPropertyTypeString for string 'string'", ^{
        expect([@"string" jgr_propertType]).to.equal(DbPropertyString);
    });
    
    it(@"gives DbPropertyTypeInvalid for other string", ^{
        expect([@"garbage" jgr_propertType]).to.equal(DbPropertyInvalid);
    });
});

SpecEnd
