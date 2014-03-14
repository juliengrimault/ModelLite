#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "MLPropertyMapping.h"
#import "JGRUser.h"

SpecBegin(JGRDbMapping)

describe(@"MLPropertyMapping", ^{
    __block MLPropertyMapping *mapping;
    
    describe(@"init", ^{
        describe(@"Errors", ^{
            it(@"raises an error if the modelClass is missing", ^{
                expect(^{
                    mapping = [[MLPropertyMapping alloc] initWithClass:nil
                                                        tableName:@"User"
                                                       properties:@{ @"id" : @(MLPropertyInt64)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error if tableName is missing", ^{
                expect(^{
                    mapping = [[MLPropertyMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:nil
                                                       properties:@{ @"id" : @(MLPropertyInt64)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error if properties are missing", ^{
                expect(^{
                    mapping = [[MLPropertyMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:nil];
                }).to.raiseAny();
            });
            
            it(@"raises an error if the id property is missing", ^{
                expect(^{
                    mapping = [[MLPropertyMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:@{@"someProp" : @(MLPropertyString)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error if the id property is not either int64, NSNumber * or NSString *", ^{
                expect(^{
                    mapping = [[MLPropertyMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:@{@"id" : @(MLPropertyDate)}];
                }).to.raiseAny();
                
                expect(^{
                    mapping = [[MLPropertyMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:@{@"id" : @(MLPropertyBOOL)}];
                }).to.raiseAny();
            });
            
            it(@"raises an error when the mapping references a property which does not exist on the model class", ^{
                NSDictionary *properties = @{@"id" : @(MLPropertyInt64), @"doesNotExist": @(MLPropertyString)};
                expect(^{
                    mapping = [[MLPropertyMapping alloc] initWithClass:[JGRUser class]
                                                        tableName:@"User"
                                                       properties:properties];
                }).to.raiseAny();
                
            });
        });
        
        describe(@"Success", ^{
            NSDictionary *properties = @{@"id" : @(MLPropertyInt64),
                                         @"name" : @(MLPropertyString)};
            beforeEach(^{
                mapping = [[MLPropertyMapping alloc] initWithClass:[JGRUser class]
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
            mapping = [[MLPropertyMapping alloc] initWithClassName:@"JGRUser" dictionary:dictionary];
        });
        
        it(@"extract table name from the dictionary", ^{
            expect(mapping.tableName).to.equal(dictionary[@"tableName"]);
        });
        
        it(@"extract the properties from the dictionary", ^{
            [mapping.properties enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id object, BOOL *stop) {
                MLPropertyType propertyType = (MLPropertyType)[object integerValue];
                NSString *propertyTypeString = dictionary[@"properties"][propertyName];
                expect(propertyType).to.equal([propertyTypeString ml_propertType]);
            }];
        });
    });
});

SpecEnd
