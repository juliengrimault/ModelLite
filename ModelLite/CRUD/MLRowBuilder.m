//
//  MLRowBuilder.m
//  ModelLite
//
//  Created by Julien on 15/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

@import ObjectiveC.runtime;
#import "MLRowBuilder.h"
#import "MLMapping.h"
#import "FMResultSet+ModelLite.h"

@interface MLRowBuilder()
@property (nonatomic, strong) MLMapping *mapping;
@end

@implementation MLRowBuilder
- (id)initWithMapping:(MLMapping *)mapping
{
    self = [super init];
    if (!self) return nil;

    self.mapping = mapping;

    return self;
}

- (id<MLDatabaseObject>)buildInstanceFromRow:(FMResultSet *)row
{
    id instance = [[(Class)self.mapping.modelClass alloc] init];

    for (NSString *propertyName in self.mapping.properties) {

        if (class_getProperty(self.mapping.modelClass, propertyName.UTF8String) == NULL) {
            [NSException raise:@"DbMappingException" format:@"No property %@ on class %@. DbMapping: %@", propertyName, self.mapping.modelClass, self.mapping];
            continue;
        }

        if (row.columnNameToIndexMap[propertyName] == nil) {
            NSLog(@"Unknown column name %@ in result set %@", propertyName, row);
            continue;
        }

        MLPropertyType propertyType = (MLPropertyType)[self.mapping.properties[propertyName] integerValue];
        id value = [row valueForColumnName:propertyName type:propertyType];

        [instance setValue:value forKey:propertyName];
    }

    if ([instance respondsToSelector:@selector(awakeFromFetch)]) {
        [instance awakeFromFetch];
    }
    
    return instance;
}

@end
