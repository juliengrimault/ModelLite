//
//  JGRDbMappingLoader.m
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRDbMappingLoader.h"
#import "JGRDbMapping.h"

@interface JGRDbMappingLoader()
@property (nonatomic, strong) NSDictionary *mappings;
@end

@implementation JGRDbMappingLoader

- (id)init
{
    NSURL *mappingURL = [[NSBundle mainBundle] URLForResource:@"DbMappings" withExtension:@"plist"];
    return [self initWithMappingURL:mappingURL];
}

- (id)initWithMappingURL:(NSURL *)url
{
    self = [super init];
    if (!self) return nil;
    
	NSDictionary *mappingsDictionary = [NSDictionary dictionaryWithContentsOfURL:url];
    
	NSMutableDictionary *mappings = [NSMutableDictionary dictionary];
    
	for (NSString *className in mappingsDictionary) {
		JGRDbMapping *mapping = [[JGRDbMapping alloc] initWithClassName:className dictionary:mappingsDictionary[className]];
		mappings[className] = mapping;
	}
    
    self.mappings = [mappings copy];
    
    return self;
    
}

- (NSArray *)allMappings
{
    return [self.mappings allValues];
}

- (JGRDbMapping *)mappingForClassName:(NSString *)className
{
    return self.mappings[className];
}

@end
