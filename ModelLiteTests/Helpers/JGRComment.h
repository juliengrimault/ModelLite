//
//  JGRComment.h
//  ModelLite
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <Foundation/Foundation.h>
@class MLPropertyMapping;


@interface JGRComment : NSObject

@property (nonatomic) int64_t id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *createdAt;

@end


@interface JGRComment (SpecFactory)

+ (MLPropertyMapping *)databaseMapping;

+ (instancetype)commentWithId:(int64_t)id;

@end


