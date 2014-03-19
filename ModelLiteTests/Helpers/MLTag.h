//
//  MLTag.h
//  ModelLite
//
//  Created by Julien on 18/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLDatabaseObject.h"
@class FMDatabase;

@interface MLTag : NSObject <MLDatabaseObject>

@property (nonatomic, copy, readonly) NSString *id;
@property (nonatomic, copy) NSString *name;

@end


@interface MLTag (SpecFactory)

+ (MLMapping *)databaseMapping;

+ (instancetype)tagWithName:(NSString *)name;

+ (NSString *)createTableStatement;
+ (NSString *)createUserTagLookupTableStatement;

+ (NSArray *)insertInDb:(FMDatabase *)db tagCount:(NSInteger)count;
+ (BOOL)insertInDb:(FMDatabase *)db tag:(MLTag *)tag;

+ (BOOL)insertUserTagLookup:(NSDictionary *)userTagsLookup inDB:(FMDatabase *)db;

@end
