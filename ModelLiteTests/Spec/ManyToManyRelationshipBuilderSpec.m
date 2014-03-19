#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import "MLRelationshipManyToManyBuilder.h"
#import "MLRelationshipMapping.h"

SpecBegin(ManyToManyRelationshipBuilder)

describe(@"ManyToManyRelationshipBuilder", ^{
    __block MLRelationshipMappingManyToMany *tagsRelationshipMapping;
    __block MLMapping *tagMapping;
    beforeEach(^{
        tagsRelationshipMapping = [MLUser databaseMapping].relationships[@"tags"];
        tagMapping = [MLTag databaseMapping];
    });

    describe(@"sanity checks", ^{
        it(@"raises exception if child mapping is nil", ^{
            expect(^{
                __unused id b = [[MLRelationshipManyToManyBuilder alloc] initWithInstanceCache:[NSMapTable strongToWeakObjectsMapTable]
                                                                           relationshipMapping:tagsRelationshipMapping
                                                                                  childMapping:nil];
            }).to.raiseAny();
        });

        it(@"raises exception if relationship mapping is nil", ^{
            expect(^{
                __unused id b = [[MLRelationshipManyToManyBuilder alloc] initWithInstanceCache:[NSMapTable strongToWeakObjectsMapTable]
                                                                 relationshipMapping:nil
                                                                        childMapping:tagMapping];
            }).to.raiseAny();
        });

        it(@"raises exception if instance cache is nil", ^{
            expect(^{
                __unused id b = [[MLRelationshipManyToManyBuilder alloc] initWithInstanceCache:nil
                                                                 relationshipMapping:tagsRelationshipMapping
                                                                        childMapping:tagMapping];
            }).to.raiseAny();
        });
    });

    describe(@"", ^{
        __block FMDatabase *db;
        __block MLRelationshipManyToManyBuilder *builder;
        __block NSMapTable *instanceCache;

        beforeEach(^{
            db = [[FMDatabase alloc] initWithPath:nil];
            [db createSpecTables];
            instanceCache = [NSMapTable strongToWeakObjectsMapTable];
            builder = [[MLRelationshipManyToManyBuilder alloc] initWithInstanceCache:instanceCache
                                                                 relationshipMapping:tagsRelationshipMapping
                                                                        childMapping:tagMapping];
        });

        it(@"assign the relationship mapping", ^{
            expect(builder.relationshipMapping).to.equal(tagsRelationshipMapping);
        });

        it(@"assign the child mapping", ^{
            expect(builder.childMapping).to.equal(tagMapping);
        });


        describe(@"populate relationship", ^{
            __block NSMutableDictionary *users;
            __block NSMutableDictionary *tags;
            __block NSDictionary *userTags;
            __block MLTag *cachedTag;

            beforeEach(^{
                tags = [NSMutableDictionary new];
                users = [NSMutableDictionary new];

                NSArray *u = [MLUser insertInDb:db userCount:3];
                for (MLUser *user in u) {
                    users[user.primaryKeyValue] = user;
                }

                NSArray *t = [MLTag insertInDb:db tagCount:2];
                for (MLTag *tag in t) {
                    tags[tag.primaryKeyValue] = tag;
                }

                // user 1 is tagged with tag 1 and tag 2
                // user 2 is tagged with nothing
                // user 3 is tagged with tag 2
                userTags = @{
                             @1 : @[@"tag1", @"tag2"],
                             @3 : @[@"tag2"]
                             };
                [MLTag insertUserTagLookup:userTags inDB:db];


                cachedTag = tags[@"tag1"];
                [instanceCache setObject:cachedTag forKey:cachedTag.primaryKeyValue];

                [builder populateRelationshipForInstances:users withDB:db];
            });

            it(@"populates the relationship", ^{
                [users enumerateKeysAndObjectsUsingBlock:^(NSNumber *userId, MLUser *user, BOOL *stop) {
                    expect(user.tags.count).to.equal([userTags[userId] count]);
                }];
            });

            it(@"does not create a new entity for the cached tag", ^{
                __block BOOL foundCachedInstance = NO;
                [users enumerateKeysAndObjectsUsingBlock:^(NSNumber *userId, MLUser *user, BOOL *stop) {
                    for (MLTag *tag in user.tags) {
                        if (tag.id == cachedTag.id) {
                            expect(cachedTag).to.beIdenticalTo(tag);
                            foundCachedInstance = YES;
                        }
                    }
                }];
                expect(foundCachedInstance).to.equal(YES);
            });

            it(@"creates new entities for the non cached tags", ^{
                __block NSMutableSet *nonCachedTagIds = [NSMutableSet set];
                [users enumerateKeysAndObjectsUsingBlock:^(NSNumber *userId, MLUser *user, BOOL *stop) {
                    for (MLTag *tag in user.tags) {
                        if (tag.id != cachedTag.id) {
                            [nonCachedTagIds addObject:tag.id];

                            MLTag *matchingTag = tags[tag.primaryKeyValue];
                            expect(matchingTag).notTo.beIdenticalTo(tag);
                            expect(matchingTag.id).to.equal(tag.id);
                        }
                    }
                }];
                expect(nonCachedTagIds).to.haveCountOf(tags.count - 1);
            });

            it(@"populates the cache", ^{
                expect(instanceCache).to.haveCountOf([tags count]);
                [tags enumerateKeysAndObjectsUsingBlock:^(NSString *tagId, MLTag *tag, BOOL *stop) {
                    MLTag *tagInCache = [instanceCache objectForKey:tagId];
                    expect(tagInCache.id).to.equal(tag.id);
                }];
            });

        });

    });
    

});

SpecEnd
