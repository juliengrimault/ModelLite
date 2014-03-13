//
//  JGRRowInsertBuilder.m
//  JGRModel
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRRowInsertBuilder.h"
#import <FMDB/FMDatabase.h>
#import "JGRDbMapping.h"

@interface JGRRowInsertBuilder ()
@property (nonatomic, strong) NSObject<JGRDbObject> *instance;
@property (nonatomic, strong) JGRDbMapping *mapping;

@property (nonatomic, copy) NSString *statement;
@property (nonatomic, copy) NSArray *statementArgument;
@end

@implementation JGRRowInsertBuilder

- (id)initWithMapping:(JGRDbMapping *)mapping instance:(NSObject<JGRDbObject> *)instance
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
    
    NSArray *values = [columns jgr_map:^id(NSString *columnName) {
        id value = [self.instance valueForKey:columnName];
        if (value == nil) {
            value = [NSNull null];
        }
        return value;
    }];
    
    NSString *valuePlaceHolders = [[columns jgr_map:^id(id object) {
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
