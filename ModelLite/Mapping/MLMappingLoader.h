//
//  MLMappingLoader.h
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <Foundation/Foundation.h>
@class MLPropertyMapping;

@interface MLMappingLoader : NSObject

@property (nonatomic, strong) NSArray *allMappings;

- (id)init; // load file name DbMapping.plist
- (id)initWithMappingURL:(NSURL *)url;

- (MLPropertyMapping *)mappingForClassName:(NSString *)className;

@end
