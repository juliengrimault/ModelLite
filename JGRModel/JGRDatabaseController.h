//
//  JGRDatabaseController.h
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FMDatabase;

typedef void(^JGRDatabaseUpdateBlock)(FMDatabase *db);

@interface JGRDatabaseController : NSObject

@property (nonatomic, readonly, copy) NSString *dbPath;

- (id)initWithPath:(NSString *)dbPath;


- (void)runInTransaction:(JGRDatabaseUpdateBlock)block;

@end
