//
//  JGRDbRowBuilder.m
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <objc/objc-runtime.h>
#import "JGRDbRowBuilder.h"
#import <FMDB/FMResultSet.h>
#import "FMResultSet+JGRModel.h"
#import "JGRDbObject.h"

@interface JGRDbRowBuilder()
@property (nonatomic, strong) JGRDbMapping *mapping;
@end

@implementation JGRDbRowBuilder

- (id)initWithMapping:(JGRDbMapping *)mapping
{
    self = [super init];
    if (!self) return nil;
    
    self.mapping = mapping;
    
    return self;
}

- (id<JGRDbObject>)buildInstanceFromRow:(FMResultSet *)row
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
        
        DbPropertyType propertyType = [self.mapping.properties[propertyName] integerValue];
        id value = [row valueForColumnName:propertyName type:propertyType];
        
        [instance setValue:value forKey:propertyName];
    }
    
    return instance;
}

@end
