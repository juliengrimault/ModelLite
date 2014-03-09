//
//  JGRDocumentPath.m
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRDocumentPath.h"

NSString *jgr_UserDocumentPath() {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

NSString *jgr_PathRelativeToUserDocument(NSString *relativePath) {
    return [jgr_UserDocumentPath() stringByAppendingPathComponent:relativePath];
}

