//
//  MLTag.h
//  ModelLite
//
//  Created by Julien on 18/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MLDatabaseObject.h"

@interface MLTag : NSObject <MLDatabaseObject>

@property (nonatomic, copy) NSString *name;

@end
