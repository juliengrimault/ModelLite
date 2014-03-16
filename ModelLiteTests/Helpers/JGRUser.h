//
//  JGRUser.h
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <Foundation/Foundation.h>
#import "MLDatabaseObject.h"
#import "MockResultSet.h"

@interface JGRUser : NSObject <MLDatabaseObject>

@property (nonatomic) int64_t id;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSDate *dob;
@property (nonatomic, getter = isDeleted) BOOL deleted;

@property (nonatomic, copy) NSArray *comments;


@property (nonatomic) BOOL hasAwakeFromFetchBeenCalled;

@end

@interface JGRUser (SpecFactory)

+ (MLMapping *)databaseMapping;

+ (instancetype)userWithId:(int64_t)id;

+ (NSString *)createTableStatement;

+ (NSArray *)insertInDb:(FMDatabase *)db userCount:(NSInteger)count;
@end

@interface MockResultSet (SpecFactory)

// returns a dictionary with 2 entries: `users` containing an array of JGRUser
// and `resultSet` containing the `MockResultSet` for the `users`. The order in
// the `resultSet` and in `users` is the same.
+ (NSDictionary *)userSet:(NSUInteger)count;
@end





