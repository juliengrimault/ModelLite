//
//  JGRDbObject.h
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGRDbMapping;

@protocol JGRDbObject <NSObject>

@property (nonatomic, readonly) id primaryKeyValue;

@optional
- (void)awakeFromFetch;
@end
