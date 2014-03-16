#define EXP_SHORTHAND
#define HC_SHORTHAND
#define MOCKITO_SHORTHAND
#import <Specta/Specta.h>
#import <Expecta/Expecta.h>
#import <OCHamcrest/OCHamcrest.h>
#import <OCMockito/OCMockito.h>

#import "SpecHelpers.h"
#import "MLRelationshipBuilder.h"
#import "MLMapping.h"
#import "MLRelationshipMapping.h"

SpecBegin(RelationshipBuilder)

describe(@"RelationshipBuilder", ^{
    __block MLRelationshipMapping *commentsRelationshipMapping;
    __block MLMapping *commentMapping;
    beforeEach(^{
        commentsRelationshipMapping = [JGRUser databaseMapping].relationships[@"comments"];
        commentMapping = [JGRComment databaseMapping];
    });

    describe(@"sanity checks", ^{
        it(@"raises exception if child mapping is nil", ^{
            expect(^{
                __unused id b = [[MLRelationshipBuilder alloc] initWithInstanceCache:[NSMapTable strongToWeakObjectsMapTable]
                                                                 relationshipMapping:commentsRelationshipMapping
                                                                        childMapping:nil];
            }).to.raiseAny();
        });

        it(@"raises exception if relationship mapping is nil", ^{
            expect(^{
                __unused id b = [[MLRelationshipBuilder alloc] initWithInstanceCache:[NSMapTable strongToWeakObjectsMapTable]
                                                                 relationshipMapping:nil
                                                                        childMapping:commentMapping];
            }).to.raiseAny();
        });

        it(@"raises exception if instance cache is nil", ^{
            expect(^{
                __unused id b = [[MLRelationshipBuilder alloc] initWithInstanceCache:nil
                                                                 relationshipMapping:commentsRelationshipMapping
                                                                        childMapping:commentMapping];
            }).to.raiseAny();
        });
    });

    describe(@"", ^{
        __block FMDatabase *db;
        __block MLRelationshipBuilder *builder;
        __block NSMapTable *instanceCache;

        beforeEach(^{
            db = [[FMDatabase alloc] initWithPath:nil];
            [db createSpecTables];
            instanceCache = [NSMapTable strongToWeakObjectsMapTable];
            builder = [[MLRelationshipBuilder alloc] initWithInstanceCache:instanceCache
                                                       relationshipMapping:commentsRelationshipMapping
                                                              childMapping:commentMapping];
        });

        it(@"assign the relationship mapping", ^{
            expect(builder.relationshipMapping).to.equal(commentsRelationshipMapping);
        });

        it(@"assign the child mapping", ^{
            expect(builder.childMapping).to.equal(commentMapping);
        });

        describe(@"populate relationship", ^{
            __block NSMutableDictionary *users;
            __block NSMutableDictionary *comments;
            __block NSMutableDictionary *commentsByUser;
            __block JGRComment *cachedComment;

            beforeEach(^{
                comments = [NSMutableDictionary new];
                users = [NSMutableDictionary new];
                commentsByUser = [NSMutableDictionary new];

                NSArray *u = [JGRUser insertInDb:db userCount:3];
                for (JGRUser *user in u) {
                    users[user.primaryKeyValue] = user;
                }

                NSArray *commentsUser1 = [JGRComment insertInDb:db commentsForUserId:1 count:5];
                NSArray *commentsUser2 = [JGRComment insertInDb:db commentsForUserId:2 count:2];
                commentsByUser[@1] = commentsUser1;
                commentsByUser[@2] = commentsUser2;

                NSArray *allComments = [commentsUser1 arrayByAddingObjectsFromArray:commentsUser2];
                for (JGRComment *comment in allComments) {
                    comments[comment.primaryKeyValue] = comment;
                }

                cachedComment = commentsUser1.firstObject;
                [instanceCache setObject:cachedComment forKey:cachedComment.primaryKeyValue];

                [builder populateRelationshipForInstances:users withDB:db];
            });

            it(@"populates the relationship", ^{
                [users enumerateKeysAndObjectsUsingBlock:^(NSNumber *userId, JGRUser *user, BOOL *stop) {
                    expect(user.comments.count).to.equal([commentsByUser[userId] count]);
                }];
            });

            it(@"does not create a new entity for the cached comment", ^{
                __block BOOL foundCachedInstance = NO;
                [users enumerateKeysAndObjectsUsingBlock:^(NSNumber *userId, JGRUser *user, BOOL *stop) {
                    for (JGRComment *comment in user.comments) {
                        if (comment.id == cachedComment.id) {
                            expect(cachedComment).to.beIdenticalTo(comment);
                            foundCachedInstance = YES;
                        }
                    }
                }];
                expect(foundCachedInstance).to.equal(YES);
            });

            it(@"creates new entities for the non cached comments", ^{
                __block NSInteger nonCachedCount = 0;
                [users enumerateKeysAndObjectsUsingBlock:^(NSNumber *userId, JGRUser *user, BOOL *stop) {
                    for (JGRComment *comment in user.comments) {
                        if (comment.id != cachedComment.id) {
                            nonCachedCount++;

                            JGRComment *matchingComment = comments[comment.primaryKeyValue];
                            expect(matchingComment).notTo.beIdenticalTo(comment);
                            expect(matchingComment.id).to.equal(comment.id);
                        }
                    }
                }];
                expect(nonCachedCount).to.equal(comments.count - 1);
            });

            it(@"populates the cache", ^{
                expect(instanceCache).to.haveCountOf([comments count]);
                [comments enumerateKeysAndObjectsUsingBlock:^(NSNumber *commentId, JGRComment *comment, BOOL *stop) {
                    JGRComment *commentInCache = [instanceCache objectForKey:commentId];
                    expect(commentInCache.id).to.equal(comment.id);
                }];
            });


        });
    });
});

SpecEnd
