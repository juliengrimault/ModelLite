//
//  MLUser.m
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLUser.h"
#import "MLMapping.h"
#import "MLRelationshipMapping.h"
#import "MLComment.h"
#import <FMDB/FMDatabase.h>

@implementation MLUser

#pragma mark - JGRDbObject
- (id)primaryKeyValue
{
    return @(self.id);
}

- (id)copyWithZone:(NSZone *)zone
{
    return self;
}

@end

@implementation MLUser (SpecFactory)

+ (MLMapping *)databaseMapping
{
    MLMapping *mapping = [[MLMapping alloc] initWithClass:[self class]
                                                                tableName:@"User"
                                                               properties:@{@"id" : @(MLPropertyInt64),
                                                                            @"name": @(MLPropertyString),
                                                                            @"dob" : @(MLPropertyDate),
                                                                            @"deleted": @(MLPropertyBOOL)}
                                            relationships:@{@"comments" : [[MLRelationshipMapping alloc] initWithRelationshipName:@"comments"
                                                                                                                       childClass:[MLComment class]
                                                                                                                   parentIdColumn:@"userId"
                                                                                                                      indexColumn:@"idx"]}];
    return mapping;
}

+ (instancetype)userWithId:(int64_t)id
{
    MLUser *user = [[MLUser alloc] init];
    user.id = id;
    user.name = [NSString stringWithFormat:@"user%lld", id];
    user.dob = [NSDate date];
    user.deleted = NO;
    return user;
}

+ (NSString *)createTableStatement
{
    return @"CREATE TABLE User ("
                "id INTEGER PRIMARY KEY,"
                "name TEXT NOT NULL,"
                "dob DATETIME NOT NULL,"
                "deleted BOOLEAN NOT NULL"
            ");";
}

+ (NSArray *)insertInDb:(FMDatabase *)db userCount:(NSInteger)count
{
    NSMutableArray *users = [NSMutableArray new];
    for (int i = 1; i <= count; i++) {
        MLUser *user = [self userWithId:i];
        [users addObject:user];
        BOOL ok = [self insertInDb:db user:user];
        if (!ok) {
            [NSException raise:@"JGRUserSpecException" format:@"Unable to insert test data"];
        }
    }
    return [users copy];
}

+ (BOOL)insertInDb:(FMDatabase *)db user:(MLUser *)user
{
    return [db executeUpdate:@"INSERT OR REPLACE INTO User (id, name, dob, deleted) VALUES (?, ?, ?, ?)", @(user.id), user.name, user.dob, @(user.deleted)];
}

@end
