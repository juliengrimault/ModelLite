//
//  JGRUser.m
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRUser.h"
#import "JGRDbMapping.h"
#import "MockResultSet.h"

@implementation JGRUser

#pragma mark - JGRDbObject
- (id)primaryKeyValue
{
    return @(self.id);
}

@end

@implementation JGRUser (SpecFactory)

+ (JGRDbMapping *)databaseMapping
{
    JGRDbMapping *mapping = [[JGRDbMapping alloc] initWithClass:[self class]
                                                      tableName:@"User"
                                                     properties:@{@"id" : @(DbPropertyInt64),
                                                                  @"name": @(DbPropertyString),
                                                                  @"dob" : @(DbPropertyDate),
                                                                  @"deleted": @(DbPropertyBOOL)}];
    return mapping;
}

+ (instancetype)userWithId:(int64_t)id
{
    JGRUser *user = [[JGRUser alloc] init];
    user.id = id;
    user.name = [NSString stringWithFormat:@"user%lld", id];
    user.dob = [NSDate date];
    user.deleted = NO;
    return user;
}

+ (NSString *)createTableStatement
{
    return @"CREATE TABLE User (id INTEGER PRIMARY KEY, name TEXT, dob DATETIME, deleted BOOLEAN);";
}

@end

@implementation FMResultSet (SpecFactory)


+ (NSDictionary *)userSet:(NSUInteger)count
{
    NSMutableArray *users = [NSMutableArray array];
    
    NSDictionary *map = @{@"id" : @0, @"name" : @1, @"dob" : @2, @"deleted": @3};
    NSMutableArray *rows = [NSMutableArray array];
    for (NSUInteger i = 0; i < count; i++) {
        
        NSMutableArray *row = [NSMutableArray array];
        for (NSUInteger j = 0; j < map.count; j++) {
            [row addObject:[NSNull null]];
        }
        
        JGRUser *u = [JGRUser userWithId:i];
        [users addObject:u];
        
        for (NSString *property in map) {
            id value = [u valueForKeyPath:property];
            if (value == nil) {
                value = [NSNull null];
            }
            
            NSUInteger propertyIndex = [map[property] integerValue];
            row[propertyIndex] = value;
        }
        [rows addObject:[row copy]];
    }
    MockResultSet *resultSet = [[MockResultSet alloc] initWithRows:rows columnNameToIndexMap:map];
    
    return @{@"users" : users, @"resultSet" : resultSet};
}

@end
