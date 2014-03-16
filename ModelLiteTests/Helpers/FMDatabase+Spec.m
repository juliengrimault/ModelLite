//
//  FMDatabase+Spec.m
//  ModelLite
//
//  Created by Julien on 16/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import "FMDatabase+Spec.h"
#import "MLUser.h"
#import "MLComment.h"

@implementation FMDatabase (Spec)

- (BOOL) createSpecTables
{
    BOOL ok = [self open];
    if (ok) {
        ok = ok && [self executeUpdate:[MLUser createTableStatement]];
    }
    if (ok) {
        ok = ok && [self executeUpdate:[MLComment createTableStatement]];
    }

    return ok;
}
@end
