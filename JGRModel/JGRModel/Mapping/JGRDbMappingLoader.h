//
//  JGRDbMappingLoader.h
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JGRDbMapping;

@interface JGRDbMappingLoader : NSObject

@property (nonatomic, strong) NSArray *allMappings;

- (id)init; // load file name DbMapping.plist
- (id)initWithMappingURL:(NSURL *)url;

- (JGRDbMapping *)mappingForClassName:(NSString *)className;

@end
