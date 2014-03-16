#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "MLMapping.h"
#import "MLUser.h"
#import "MLComment.h"
#import "MLRelationshipMapping.h"

SpecBegin(MLMapping)

describe(@"MLMapping", ^{
    __block MLMapping *mapping;
    
    describe(@"init", ^{
        describe(@"Errors", ^{
            it(@"raises an error if the modelClass is missing", ^{
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:nil
                                                        tableName:@"User"
                                                       properties:@{ @"id" : @(MLPropertyInt64)}
                                                         relationships:nil];
                }).to.raiseAny();
            });
            
            it(@"raises an error if tableName is missing", ^{
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                        tableName:nil
                                                       properties:@{ @"id" : @(MLPropertyInt64)}
                                                         relationships:nil];
                }).to.raiseAny();
            });
            
            it(@"raises an error if properties are missing", ^{
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                             tableName:@"User"
                                                            properties:nil
                                                         relationships:nil];
                }).to.raiseAny();
            });
            
            it(@"raises an error if the id property is missing", ^{
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                             tableName:@"User"
                                                            properties:@{@"someProp" : @(MLPropertyString)}
                                                         relationships:nil];
                }).to.raiseAny();
            });
            
            it(@"raises an error if the id property is not either int64, NSNumber * or NSString *", ^{
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                             tableName:@"User"
                                                            properties:@{@"id" : @(MLPropertyDate)}
                                                         relationships:nil];
                }).to.raiseAny();
                
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                             tableName:@"User"
                                                            properties:@{@"id" : @(MLPropertyBOOL)}
                                                         relationships:nil];
                }).to.raiseAny();
            });
            
            it(@"raises an error when the mapping references a property which does not exist on the model class", ^{
                NSDictionary *properties = @{@"id" : @(MLPropertyInt64), @"doesNotExist": @(MLPropertyString)};
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                             tableName:@"User"
                                                            properties:properties
                                                         relationships:nil];
                }).to.raiseAny();
                
            });

            it(@"raises an error when the relationship dictionary does not contain only MLRelationshipMapping", ^{
                NSDictionary *properties = @{@"id" : @(MLPropertyInt64), @"doesNotExist": @(MLPropertyString)};
                expect(^{
                    mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                             tableName:@"User"
                                                            properties:properties
                                                         relationships:@{@"comments" : @3}];
                }).to.raiseAny();

            });
        });
        
        describe(@"Success", ^{
            NSDictionary *properties = @{@"id" : @(MLPropertyInt64),
                                         @"name" : @(MLPropertyString)};

            NSDictionary *relationships = @{@"comments" : [[MLRelationshipMapping alloc] initWithRelationshipName:@"comments"
                                                                                                       childClass:[MLComment class]
                                                                                                   parentIdColumn:@"userId"
                                                                                                      indexColumn:@"index"]};


            beforeEach(^{
                mapping = [[MLMapping alloc] initWithClass:[MLUser class]
                                                         tableName:@"User"
                                                        properties:properties
                                                     relationships:relationships];
            });

            it(@"takes the model class", ^{
                expect(mapping.modelClass).to.equal([MLUser class]);
            });

            it(@"takes the table name", ^{
                expect(mapping.tableName).to.equal(@"User");
            });

            it(@"takes the properties", ^{
                expect(mapping.properties).to.equal(properties);
            });

            it(@"assigns the relationships", ^{
                expect(mapping.relationships).to.equal(relationships);
            });
        });

    });


    
    describe(@"load from dictionary", ^{
        __block NSDictionary *dictionary;
        beforeEach(^{
            dictionary = @{@"tableName" : @"SuperUser",
                           @"properties" : @{@"id" : @"int64", @"name" : @"string"},
                           @"relationships" : @{ @"comments": @{ @"childClass" : @"MLComment",
                                                                 @"lookupTable" : @"UsersCommentsLookup",
                                                                 @"parentIdColumn" : @"userId",
                                                                 @"childIdColumn" : @"commentId",
                                                                 @"indexColumn" : @"index"}
                                                 }};
            mapping = [[MLMapping alloc] initWithClassName:@"MLUser" dictionary:dictionary];
        });
        
        it(@"extract table name from the dictionary", ^{
            expect(mapping.tableName).to.equal(dictionary[@"tableName"]);
        });
        
        it(@"extract the properties from the dictionary", ^{
            expect(mapping.properties).to.haveCountOf([dictionary[@"properties"] count]);
            [mapping.properties enumerateKeysAndObjectsUsingBlock:^(NSString *propertyName, id object, BOOL *stop) {
                MLPropertyType propertyType = (MLPropertyType)[object integerValue];
                NSString *propertyTypeString = dictionary[@"properties"][propertyName];
                expect(propertyType).to.equal([propertyTypeString ml_propertType]);
            }];
        });

        it(@"extract the relationships from the dictionary", ^{
            expect(mapping.relationships).to.haveCountOf([dictionary[@"relationships"] count]);
            [mapping.relationships enumerateKeysAndObjectsUsingBlock:^(NSString *relationshipName, id relationship, BOOL *stop) {
                expect(relationship).to.beKindOf([MLRelationshipMapping class]);
            }];
        });
    });
});

SpecEnd
