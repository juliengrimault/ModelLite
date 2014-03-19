#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import "MLRelationshipMappingManyToMany.h"


SpecBegin(ManyToManyRelationshipshipMapping)

describe(@"ManyToManyRelationshipshipMapping", ^{
    __block MLRelationshipMappingManyToMany *mapping;

    describe(@"init", ^{
        describe(@"Errors", ^{
            it(@"raises an error if relationship name is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:nil
                                                                                    lookupTable:@"UsersTagsLookup"
                                                                                 parentIdColumn:@"userId"
                                                                                     childClass:[MLTag class]
                                                                                  childIdColumn:@"tagId"
                                                                                    indexColumn:@"idx"];
                }).to.raiseAny();
            });

            it(@"raises an error if lookup table is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:@"tags"
                                                                                    lookupTable:nil
                                                                                 parentIdColumn:@"userId"
                                                                                     childClass:[MLTag class]
                                                                                  childIdColumn:@"tagId"
                                                                                    indexColumn:@"idx"];
                }).to.raiseAny();
            });

            it(@"raises an error if parentId column is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:@"tags"
                                                                                    lookupTable:@"UsersTagsLookup"
                                                                                 parentIdColumn:nil
                                                                                     childClass:[MLTag class]
                                                                                  childIdColumn:@"tagId"
                                                                                    indexColumn:@"idx"];
                }).to.raiseAny();
            });

            it(@"raises an error if child class is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:@"tags"
                                                                                    lookupTable:@"UsersTagsLookup"
                                                                                 parentIdColumn:@"userId"
                                                                                     childClass:nil
                                                                                  childIdColumn:@"tagId"
                                                                                    indexColumn:@"idx"];
                }).to.raiseAny();
            });

            it(@"raises an error if childId column is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:@"tags"
                                                                                    lookupTable:@"UsersTagsLookup"
                                                                                 parentIdColumn:@"userId"
                                                                                     childClass:[MLTag class]
                                                                                  childIdColumn:nil
                                                                                    indexColumn:@"idx"];
                }).to.raiseAny();
            });

            it(@"raises an error if index column is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:@"tags"
                                                                                    lookupTable:@"UsersTagsLookup"
                                                                                 parentIdColumn:@"userId"
                                                                                     childClass:[MLTag class]
                                                                                  childIdColumn:@"tagId"
                                                                                    indexColumn:nil];
                }).to.raiseAny();
            });
        });

        describe(@"assigns the properties", ^{
            beforeEach(^{
                mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:@"tags"
                                                                                    lookupTable:@"UsersTagsLookup"
                                                                                 parentIdColumn:@"userId"
                                                                                     childClass:[MLTag class]
                                                                                  childIdColumn:@"tagId"
                                                                                    indexColumn:@"idx"];

            });

            it(@"assigns the relationship name", ^{
                expect(mapping.relationshipName).to.equal(@"tags");
            });

            it(@"assigns the parentId column", ^{
                expect(mapping.parentIdColumn).to.equal(@"userId");
            });

            it(@"assigns the child class", ^{
                expect(mapping.childClass).to.equal([MLTag class]);
            });

            it(@"assigns the userId column", ^{
                expect(mapping.childIdColumn).to.equal(@"tagId");
            });

            it(@"assigns the index column", ^{
                expect(mapping.indexColumn).to.equal(@"idx");
            });
        });

    });

    describe(@"load from dictionary", ^{
        __block NSDictionary *dictionary;
        beforeEach(^{
            dictionary = @{@"lookupTable" : @"UsersTagsLookup",
                           @"parentIdColumn" : @"userId",
                           @"childClass" : @"MLTag",
                           @"childIdColumn" : @"tagId",
                           @"indexColumn" : @"index" };
            mapping = [[MLRelationshipMappingManyToMany alloc] initWithRelationshipName:@"tags"
                                                                             dictionary:dictionary];
        });

        it(@"extract the table loppup name from the dictionary", ^{
            expect(mapping.lookupTable).to.equal(dictionary[@"lookupTable"]);
        });


        it(@"extract parentIdColumn name from the dictionary", ^{
            expect(mapping.parentIdColumn).to.equal(dictionary[@"parentIdColumn"]);
        });

        it(@"extract childClass name from the dictionary", ^{
            expect(mapping.childClass).to.equal(NSClassFromString(dictionary[@"childClass"]));
        });

        it(@"extract childIdColumn name from the dictionary", ^{
            expect(mapping.childIdColumn).to.equal(dictionary[@"childIdColumn"]);
        });

        it(@"extract indexColumn name from the dictionary", ^{
            expect(mapping.indexColumn).to.equal(dictionary[@"indexColumn"]);
        });

    });
            

});

SpecEnd
