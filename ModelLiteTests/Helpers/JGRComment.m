//
//  JGRComment.m
//  ModelLite
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "JGRComment.h"
#import "MLPropertyMapping.h"

@implementation JGRComment

#pragma mark - JGRDbObject
- (id)primaryKeyValue
{
    return @(self.id);
}

@end


@implementation JGRComment (SpecFactory)


+ (MLPropertyMapping *)databaseMapping
{
    MLPropertyMapping *mapping = [[MLPropertyMapping alloc] initWithClass:[self class]
                                                      tableName:@"Comment"
                                                     properties:@{@"id" : @(MLPropertyInt64),
                                                                  @"text": @(MLPropertyString),
                                                                  @"createdAt" : @(MLPropertyDate)}];
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
