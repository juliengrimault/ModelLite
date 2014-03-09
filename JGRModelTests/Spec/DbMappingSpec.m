#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "JGRDbMapping.h"
#import "JGRUser.h"

SpecBegin(JGRDbMapping)

describe(@"JGRDbMapping", ^{
    __block JGRDbMapping *mapping;
    
    describe(@"init", ^{
        describe(@"Errors", ^{
            it(@"raises an error if the modelClass is missing", ^{
                expect(^{
                    mapping = [[JGRDbMapping alloc] initWithClass:nil
                                                        tableName:@"User"
                                                       properties:@{ @"id" : @(DbPropertyInt64)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error if tableName is missing", ^{
                expect(^{
                    mapping = [[JGRDbMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:nil
                                                       properties:@{ @"id" : @(DbPropertyInt64)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error if properties are missing", ^{
                expect(^{
                    mapping = [[JGRDbMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:nil];
                }).to.raiseAny();
            });
            
            it(@"raises an error if the id property is missing", ^{
                expect(^{
                    mapping = [[JGRDbMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:@{@"someProp" : @(DbPropertyString)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error if the id property is not either int64, NSNumber * or NSString *", ^{
                expect(^{
                    mapping = [[JGRDbMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:@{@"id" : @(DbPropertyDate)}];
                }).to.raiseAny();
                
                expect(^{
                    mapping = [[JGRDbMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:@{@"id" : @(DbPropertyBOOL)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error when the mapping references a property which does not exist on the model class", ^{
                NSDictionary *properties = @{@"id" : @(DbPropertyInt64), @"doesNotExist": @(DbPropertyString)};
                expect(^{
                    mapping = [[JGRDbMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:properties];
                }).to.raiseAny();
                
            });
        });
        
        describe(@"Success", ^{
            NSDictionary *properties = @{@"id" : @(DbPropertyInt64),
                                         @"name" : @(DbPropertyString)};
            beforeEach(^{
                mapping = [[JGRDbMapping alloc] initWithClass:[JGRUser class]
                                                    tableName:@"User"
                                                   properties:properties];
            });
            
            it(@"takes the model class", ^{
                expect(mapping.modelClass).to.equal([JGRUser class]);
            });
            
            it(@"takes the table name", ^{
                expect(mapping.tableName).to.equal(@"User");
            });
            
            it(@"takes the properties", ^{
                expect(mapping.properties).to.equal(properties);
            });
        });

    });
    
    describe(@"load from dictionary", ^{
        __block NSDictionary *dictionary;
        beforeEach(^{
            dictionary = @{@"tableName" : @"SuperUser", @"properties" : @{@"id" : @"int64", @"name" : @"string"}};
            mapping = [[JGRDbMapping alloc] initWithClassName:@"JGRUser" dictionary:dictionary];
        });
        
        it(@"extract table name from the dictionary", ^{
            expect(mapping.tableName).to.equal(dictionary[@"tableName"]);
        });
        
        it(@"extract the properties from the dictionary", ^{
            [mapping.properties enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id object, BOOL *stop) {
                DbPropertyType propertyType = [object integerValue];
                NSString *propertyTypeString = dictionary[@"properties"][propertyName];
                expect(propertyType).to.equal([propertyTypeString jgr_propertType]);
            }];
        });
    });
});

SpecEnd
