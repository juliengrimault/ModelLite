//
//  MLTag.m
//  ModelLite
//
//  Created by Julien on 18/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "MLTag.h"
#import "MLMapping.h"
#import <FMDB/FMDatabase.h>

@interface MLTag()
@property (nonatomic, copy) NSString *id;
@end

@implementation MLTag

- (void)setName:(NSString *)name
{
    if (name == _name) return;

    _name = [name copy];
    self.id = [name lowercaseString];
}

- (id)primaryKeyValue
{
    return self.id;
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}
@end

@implementation MLTag (SpecFactory)

+ (MLMapping *)databaseMapping
{
    MLMapping *mapping = [[MLMapping alloc] initWithClass:[self class]
                                                tableName:@"Tag"
                                               properties:@{@"id" : @(MLPropertyString),
                                                            @"name" : @(MLPropertyString)}
                                            relationships:nil];
    return mapping;
}

+ (NSString *)createTableStatement
{
    return @"CREATE TABLE Tag("
    "  id TEXT PRIMARY KEY,"
    "  name TEXT NOT NULL"
    ");";
}

+ (NSString *)createUserTagLookupTableStatement
{
    return @"CREATE TABLE UsersTagsLookup("
    "  userId INTEGER NOT NULL,"
    "  tagId TEXT NOT NULL,"
    "  idx INTEGER NOT NULL,"
    "  PRIMARY KEY (userId, tagId)"
    ");";

}

+ (instancetype)tagWithName:(NSString *)name
{
    MLTag *tag = [[self alloc] init];
    tag.name = name;
    tag.id = [name lowercaseString];
    return tag;
}

+ (NSArray *)insertInDb:(FMDatabase *)db tagCount:(NSInteger)count
{
    NSMutableArray *tags = [NSMutableArray new];
    for (int i = 1; i <= count; i++) {
        MLTag *tag = [self tagWithName:[NSString stringWithFormat:@"tag%d", i]];
        [tags addObject:tag];
        BOOL ok = [self insertInDb:db tag:tag];
        if (!ok) {
            [NSException raise:[NSString stringWithFormat:@"%@SpecException",self.class]
                        format:@"Unable to insert test data"];
        }
    }
    return [tags copy];
}

+ (BOOL)insertInDb:(FMDatabase *)db tag:(MLTag *)tag
{
    return [db executeUpdate:@"INSERT OR REPLACE INTO Tag (id, name) VALUES (?, ?)", tag.id, tag.name];
}

+ (BOOL)insertUserTagLookup:(NSDictionary *)userTagsLookup inDB:(FMDatabase *)db
{
    [db beginTransaction];
    for (NSNumber *userId in userTagsLookup) {
        NSArray *tagIds = userTagsLookup[userId];
        NSInteger i = 0;
        for (NSNumber *tagId in tagIds) {
            BOOL ok = [db executeUpdate:@"INSERT OR REPLACE INTO UsersTagsLookup (userId, tagId, idx) VALUES (?, ?, ?)", userId, tagId, @(i)];
            if (!ok) {
                [NSException raise:[NSString stringWithFormat:@"%@SpecException",self.class]
                            format:@"Unable to insert test data"];
            }
            i++;
        }
    }
    [db commit];
    return YES;
}


@end
