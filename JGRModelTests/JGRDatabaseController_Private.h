//
//  JGRDatabaseController_Private.h
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRDatabaseController.h"

@interface JGRDatabaseController ()

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, copy) NSString *dbPath;
@property (nonatomic, strong) FMDatabase *db;

@end
