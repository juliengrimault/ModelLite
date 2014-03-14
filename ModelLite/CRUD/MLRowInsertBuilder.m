//
//  MLRowInsertBuilder.m
//  ModelLite
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import <FMDB/FMDatabase.h>
#import <ObjectiveSugar/ObjectiveSugar.h>
#import "MLRowInsertBuilder.h"
#import "MLPropertyMapping.h"

@interface MLRowInsertBuilder ()
@property (nonatomic, strong) NSObject<MLDatabaseObject> *instance;
@property (nonatomic, strong) MLPropertyMapping *mapping;

@property (nonatomic, copy) NSString *statement;
@property (nonatomic, copy) NSArray *statementArgument;
@end

@implementation MLRowInsertBuilder

- (id)initWithMapping:(MLPropertyMapping *)mapping instance:(NSObject<MLDatabaseObject> *)instance
{
    NSParameterAssert(instance != nil);
    NSParameterAssert(mapping != nil);
    NSParameterAssert([instance isKindOfClass:mapping.modelClass]);
    
    self = [super init];
    if (!self) return nil;
    
    self.mapping = mapping;
    self.instance = instance;
    
    [self prepareStatement];
    
    return self;
}

- (void)prepareStatement
{
    NSArray *columns = [self.mapping.properties allKeys];
    
    NSArray *values = [columns map:^id(NSString *columnName) {
        id value = [self.instance valueForKey:columnName];
        if (value == nil) {
            value = [NSNull null];
        }
        return value;
    }];
    
    NSString *valuePlaceHolders = [[columns map:^id(id object) {
        return @"?";
    }] componentsJoinedByString:@", "];
    
    self.statement = [NSString stringWithFormat:@"INSERT OR REPLACE INTO %@ (%@) VALUES (%@);",
                      self.mapping.tableName,
                      [columns componentsJoinedByString:@", "],
                      valuePlaceHolders];
    
    self.statementArgument = [values copy];
}

- (BOOL)executeStatement:(FMDatabase *)db
{
    return [db executeUpdate:self.statement withArgumentsInArray:self.statementArgument];
}
@end
