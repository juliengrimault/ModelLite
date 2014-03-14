//
//  Integration.m
//  ModelLite
//
//  Created by Julien on 11/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "Integration.h"

@implementation Integration

+ (void)deleteFileIfExist:(NSURL *)url
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if ([defaultManager fileExistsAtPath:[url path]]) {
        [defaultManager removeItemAtPath:[url path] error:nil];
    }
}

@end
