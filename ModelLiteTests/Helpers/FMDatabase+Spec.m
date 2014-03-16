//
//  FMDatabase+Spec.m
//  ModelLite
//
//  Created by Julien on 16/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "FMDatabase+Spec.h"
#import "JGRUser.h"
#import "JGRComment.h"

@implementation FMDatabase (Spec)

- (BOOL) createSpecTables
{
    BOOL ok = [self open];
    if (ok) {
        ok = ok && [self executeUpdate:[JGRUser createTableStatement]];
    }
    if (ok) {
        ok = ok && [self executeUpdate:[JGRComment createTableStatement]];
    }

    return ok;
}
@end
