#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "MLRelationshipMappingOneToMany.h"
#import "MLUser.h"
#import "MLComment.h"

SpecBegin(RelationshipMappingOneToMany)

describe(@"RelationshipMappingOneToMany", ^{
    __block MLRelationshipMappingOneToMany *mapping;

    describe(@"init", ^{
        describe(@"Errors", ^{
            it(@"raises an error if relationship name is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:nil
                                                                           childClass:[MLUser class]
                                                                       parentIdColumn:@"userId"
                                                                          indexColumn:@"index"];
                }).to.raiseAny();
            });

            it(@"raises an error if child class is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:@"comments"
                                                                           childClass:nil
                                                                       parentIdColumn:@"userId"
                                                                          indexColumn:@"index"];
                }).to.raiseAny();
            });


            it(@"raises an error if the parentId column is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:@"comments"
                                                                           childClass:[MLComment class]
                                                                       parentIdColumn:nil
                                                                          indexColumn:@"index"];
                }).to.raiseAny();
            });


            it(@"raises an error if indexColumn is missing", ^{
                expect(^{
                    mapping = [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:@"comments"
                                                                           childClass:[MLComment class]
                                                                       parentIdColumn:@"userId"
                                                                          indexColumn:nil];
                }).to.raiseAny();
            });
        });

        describe(@"assigns the properties", ^{
            beforeEach(^{
                mapping = [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:@"comments"
                                                                       childClass:[MLComment class]
                                                                   parentIdColumn:@"userId"
                                                                      indexColumn:@"index"];
            });

            it(@"assigns the relationship name", ^{
                expect(mapping.relationshipName).to.equal(@"comments");
            });

            it(@"assigns the child class", ^{
                expect(mapping.childClass).to.equal([MLComment class]);
            });

            it(@"assigns the parentId column", ^{
                expect(mapping.parentIdColumn).to.equal(@"userId");
            });


            it(@"assigns the index column", ^{
                expect(mapping.indexColumn).to.equal(@"index");
            });
        });
    });

    describe(@"load from dictionary", ^{
        __block NSDictionary *dictionary;
        beforeEach(^{
            dictionary = @{@"parentIdColumn" : @"userId",
                           @"indexColumn" : @"index",
                           @"childClass" : @"MLComment" };
            mapping = [[MLRelationshipMappingOneToMany alloc] initWithRelationshipName:@"comments"
                                                                            dictionary:dictionary];
        });


        it(@"extract parentIdColumn name from the dictionary", ^{
            expect(mapping.parentIdColumn).to.equal(dictionary[@"parentIdColumn"]);
        });

        it(@"extract indexColumn name from the dictionary", ^{
            expect(mapping.indexColumn).to.equal(dictionary[@"indexColumn"]);
        });

        it(@"extract indexColumn name from the dictionary", ^{
            expect(NSStringFromClass(mapping.childClass)).to.equal(dictionary[@"childClass"]);
        });
    });

});
SpecEnd
