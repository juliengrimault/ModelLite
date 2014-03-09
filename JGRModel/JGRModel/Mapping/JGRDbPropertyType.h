//
//  JGRDbPropertyType.h
//  JGRModel
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DbPropertyType) {
    DbPropertyInvalid = 0,
    DbPropertyString,
    DbPropertyDate,
    DbPropertyInt64,
    DbPropertyNSNumber,
    DbPropertyBOOL
};

NSString *JGRDbNSStringFromDbPropertyType(DbPropertyType type);


@interface NSString (JGRDbPropertyType)

- (DbPropertyType)jgr_propertType;

@end
