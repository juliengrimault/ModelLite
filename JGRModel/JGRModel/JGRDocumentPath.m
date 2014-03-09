//
//  JGRDocumentPath.m
//  JGRModel
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "JGRDocumentPath.h"

NSURL *jgr_UserDocumentURL() {
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

NSURL *jgr_URLRelativeToUserDocument(NSString *relativePath) {
    return [jgr_UserDocumentURL() URLByAppendingPathComponent:relativePath];
}

