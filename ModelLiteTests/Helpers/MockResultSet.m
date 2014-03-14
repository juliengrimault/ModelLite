//
//  MockResultSet.m
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MockResultSet.h"
@interface MockResultSet()
@property (nonatomic, copy) NSArray *rows;
@property (nonatomic, copy) NSDictionary *map;

@property (nonatomic) NSInteger currentRowIndex;
@property (nonatomic, readonly) NSArray *currentRow;
@end

@implementation MockResultSet

- (id)initWithRows:(NSArray *)rows columnNameToIndexMap:(NSDictionary *)map
{
    self = [super init];
    if (!self) return nil;
    
    self.rows = rows;
    self.map = map;
    self.currentRowIndex = -1;
    
    return self;
}

- (NSMutableDictionary *)columnNameToIndexMap
{
    return [self.map mutableCopy];
}

- (NSArray *)currentRow
{
    if (self.currentRowIndex >= 0 && self.currentRowIndex < (NSInteger)self.rows.count) {
        return self.rows[self.currentRowIndex];
    }
    return nil;
}

- (BOOL)next
{
    if ([self hasAnotherRow]) {
        self.currentRowIndex++;
        return YES;
    }
    return NO;
}

- (BOOL)hasAnotherRow
{
    return self.currentRowIndex < (NSInteger)self.rows.count - 1;
}

- (int)columnCount
{
    return (int)self.map.count;
}

- (int)columnIndexForName:(NSString*)columnName
{
    id n = self.map[columnName];
    if (n) {
        return (int)[n integerValue];
    }
    return -1;
}

- (NSString*)columnNameForIndex:(int)columnIdx
{
    return [self.map allKeysForObject:@(columnIdx)].firstObject;
}

- (int)intForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self intForColumnIndex:idx];
}

- (int)intForColumnIndex:(int)columnIdx
{
    return (int)[self.currentRow[columnIdx] integerValue];
}


- (long)longForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self longForColumnIndex:idx];
}

-(long)longForColumnIndex:(int)columnIdx
{
    return [self.currentRow[columnIdx] longValue];
}

-(long long int)longLongIntForColumn:(NSString *)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self longLongIntForColumnIndex:idx];
}

-(long long int)longLongIntForColumnIndex:(int)columnIdx
{
    return [self.currentRow[columnIdx] longLongValue];
}

- (unsigned long long int)unsignedLongLongIntForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self unsignedLongLongIntForColumnIndex:idx];
}

- (unsigned long long int)unsignedLongLongIntForColumnIndex:(int)columnIdx
{
    return [self.currentRow[columnIdx] unsignedLongLongValue];
}

- (BOOL)boolForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self boolForColumnIndex:idx];
}

- (BOOL)boolForColumnIndex:(int)columnIdx
{
    return [self.currentRow[columnIdx] boolValue];
}

- (double)doubleForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self doubleForColumnIndex:idx];
}

- (double)doubleForColumnIndex:(int)columnIdx
{
    return [self.currentRow[columnIdx] doubleValue];
}

- (NSString*)stringForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self stringForColumnIndex:idx];
}

- (NSString*)stringForColumnIndex:(int)columnIdx
{
    id v = self.currentRow[columnIdx];
    if ([v isKindOfClass:[NSString class]]) {
        return v;
    } else {
        return nil;
    }
}

- (NSDate*)dateForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self dateForColumnIndex:idx];
}

- (NSDate*)dateForColumnIndex:(int)columnIdx
{
    id v = self.currentRow[columnIdx];
    if ([v isKindOfClass:[NSDate class]]) {
        return v;
    } else {
        return nil;
    }
}

- (NSData*)dataForColumn:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self dataForColumnIndex:idx];
}

- (NSData*)dataForColumnIndex:(int)columnIdx
{
    id v = self.currentRow[columnIdx];
    if ([v isKindOfClass:[NSData class]]) {
        return v;
    } else {
        return nil;
    }
}

- (const unsigned char *)UTF8StringForColumnName:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self UTF8StringForColumnIndex:idx];
}

- (const unsigned char *)UTF8StringForColumnIndex:(int)columnIdx
{
    NSAssert(NO, @"Not Implemented");
    return NULL;
}

- (id)objectForColumnName:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self objectForColumnIndex:idx];
}

- (id)objectForColumnIndex:(int)columnIdx
{
    return self.currentRow[columnIdx];
}

- (id)objectForKeyedSubscript:(NSString *)columnName
{
    return [self objectForColumnName:columnName];
}

- (id)objectAtIndexedSubscript:(int)columnIdx
{
    return [self objectForColumnIndex:columnIdx];
}

- (BOOL)columnIsNull:(NSString*)columnName
{
    int idx = [self columnIndexForName:columnName];
    return [self columnIndexIsNull:idx];
}

- (BOOL)columnIndexIsNull:(int)columnIdx
{
    return [self.currentRow[columnIdx] isEqual:[NSNull null]];
}

- (NSDictionary *)resultDictionary
{
    NSMutableDictionary *row = [NSMutableDictionary dictionary];
    for (int i = 0; i < (int)self.currentRow.count; i++) {
        NSString *columnName = [self columnNameForIndex:i];
        row[columnName] = [self objectForColumnIndex:i];
    }
    return row;
}


@end
