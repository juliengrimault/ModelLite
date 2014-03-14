//
//  JGRDocumentPath.m
//  ModelLite
//
//  Created by Julien on 9/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

#import "JGDocumentPath.h"

NSURL *jg_UserDocumentURL() {
    return [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
}

NSURL *jg_URLRelativeToUserDocument(NSString *relativePath) {
    return [jg_UserDocumentURL() URLByAppendingPathComponent:relativePath];
}

