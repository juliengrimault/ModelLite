//
//  MLDatabaseObject.h
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;
@class MLPropertyMapping;

@protocol MLDatabaseObject <NSObject, NSCopying>

@property (nonatomic, readonly) id primaryKeyValue;

@optional
- (void)awakeFromFetch;
@end
