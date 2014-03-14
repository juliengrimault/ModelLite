//
//  JGRDatabaseController_Private.h
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "MLDatabaseController.h"

@interface MLDatabaseController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSURL *dbURL;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSDictionary *databaseMappings;
@property (nonatomic, strong) NSMutableDictionary *classCache;
@end
