//
//  MLComment.h
//  ModelLite
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <Foundation/Foundation.h>
#import "MLDatabaseObject.h"
@class MLMapping;
@class FMDatabase;

@interface MLComment : NSObject <MLDatabaseObject>

@property (nonatomic) int64_t id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *createdAt;

@end


@interface MLComment (SpecFactory)

+ (MLMapping *)databaseMapping;
+ (NSString *)createTableStatement;
+ (instancetype)commentWithId:(int64_t)id;
+ (NSArray *)insertInDb:(FMDatabase *)db commentsForUserId:(int64_t)userId count:(NSInteger)count;
@end


