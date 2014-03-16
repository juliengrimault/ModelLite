//
//  MLComment.m
//  ModelLite
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLComment.h"
#import "MLMapping.h"
#import <FMDB/FMDatabase.h>

@implementation MLComment

#pragma mark - JGRDbObject
-(id)copyWithZone:(NSZone *)zone
{
    return self;
}

- (id)primaryKeyValue
{
    return @(self.id);
}

@end


@implementation MLComment (SpecFactory)


+ (MLMapping *)databaseMapping
{
    MLMapping *mapping = [[MLMapping alloc] initWithClass:[self class]
                                                                tableName:@"Comment"
                                                               properties:@{@"id" : @(MLPropertyInt64),
                                                                            @"text": @(MLPropertyString),
                                                                            @"createdAt" : @(MLPropertyDate)}
                                                            relationships:nil];
    return mapping;
}

+ (NSString *)createTableStatement
{
    return @"CREATE TABLE Comment("
            "  id INTEGER PRIMARY KEY,"
            "  userId INTEGER NOT NULL,"
            "  idx INTEGER NOT NULL,"
            "  text TEXT NOT NULL,"
            "  createdAt DATETIME NOT NULL,"
            "  FOREIGN KEY (userId) REFERENCES User(id)"
            ");";
}

+ (instancetype)commentWithId:(int64_t)id
{
    MLComment *comment = [[self alloc] init];
    comment.id = id;
    comment.text = [NSString stringWithFormat:@"text%lld", id];
    comment.createdAt = [NSDate date];
    return comment;
}

+ (NSArray *)insertInDb:(FMDatabase *)db commentsForUserId:(int64_t)userId count:(NSInteger)count
{
    NSMutableArray *comments = [NSMutableArray new];
    [db beginTransaction];
    for (int i = 1; i <= count; i++) {
        MLComment *comment = [self commentWithId:userId * 100 + i];
        [comments addObject:comment];
        BOOL ok = [db executeUpdate:@"INSERT OR REPLACE INTO Comment (id, userId, idx, text, createdAt) VALUES (?, ?, ?, ?, ?)", @(comment.id), @(userId), @(i), comment.text, comment.createdAt];
        if (!ok) {
            [NSException raise:@"MLComment" format:@"unable to insert test data"];
        }
    }
    [db commit];
    return [comments copy];
}

@end
