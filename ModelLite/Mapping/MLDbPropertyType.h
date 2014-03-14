//
//  MLDbPropertyType.h
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
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

NSString *NSStringFromDbPropertyType(DbPropertyType type);


@interface NSString (MLDbPropertyType)

- (DbPropertyType)jgr_propertType;

@end
