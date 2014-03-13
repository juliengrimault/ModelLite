//
//  JGRComment.m
//  JGRModel
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRComment.h"
#import "JGRDbMapping.h"

@implementation JGRComment

#pragma mark - JGRDbObject
- (id)primaryKeyValue
{
    return @(self.id);
}

@end


@implementation JGRComment (SpecFactory)


+ (JGRDbMapping *)databaseMapping
{
    JGRDbMapping *mapping = [[JGRDbMapping alloc] initWithClass:[self class]
                                                      tableName:@"Comment"
                                                     properties:@{@"id" : @(DbPropertyInt64),
                                                                  @"text": @(DbPropertyString),
                                                                  @"createdAt" : @(DbPropertyDate)}];
    return mapping;
}

+ (instancetype)commentWithId:(int64_t)id
{
    JGRComment *comment = [[self alloc] init];
    comment.id = id;
    comment.text = [NSString stringWithFormat:@"text%lld", id];
    comment.createdAt = [NSDate date];
    return comment;
}


@end
