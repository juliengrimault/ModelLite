//
//  MLDbMappingLoader.m
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLDbMappingLoader.h"
#import "MLDbMapping.h"

@interface MLDbMappingLoader ()
@property (nonatomic, strong) NSDictionary *mappings;
@end

@implementation MLDbMappingLoader

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
		MLDbMapping *mapping = [[MLDbMapping alloc] initWithClassName:className dictionary:mappingsDictionary[className]];
		mappings[className] = mapping;
	}
    
    self.mappings = [mappings copy];
    
    return self;
    
}

- (NSArray *)allMappings
{
    return [self.mappings allValues];
}

- (MLDbMapping *)mappingForClassName:(NSString *)className
{
    return self.mappings[className];
}

@end
