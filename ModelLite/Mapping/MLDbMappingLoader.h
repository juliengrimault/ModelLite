//
//  MLDbMappingLoader.h
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <Foundation/Foundation.h>
@class MLDbMapping;

@interface MLDbMappingLoader : NSObject

@property (nonatomic, strong) NSArray *allMappings;

- (id)init; // load file name DbMapping.plist
- (id)initWithMappingURL:(NSURL *)url;

- (MLDbMapping *)mappingForClassName:(NSString *)className;

@end
