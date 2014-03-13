//
//  JGRComment.h
//  JGRModel
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGRDbMapping;


@interface JGRComment : NSObject

@property (nonatomic) int64_t id;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSDate *createdAt;

@end


@interface JGRComment (SpecFactory)

+ (JGRDbMapping *)databaseMapping;

+ (instancetype)commentWithId:(int64_t)id;

@end


