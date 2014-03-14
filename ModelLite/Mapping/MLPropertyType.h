//
//  MLPropertyType.h
//  ModelLite
//
//  Created by Julien on 10/3/14.
//  Copyright (c) 2014 juliengrimault. See included LICENSE file.
//

@import Foundation;

typedef NS_ENUM(NSInteger, MLPropertyType) {
    MLPropertyInvalid = 0,
    MLPropertyString,
    MLPropertyDate,
    MLPropertyInt64,
    MLPropertyNSNumber,
    MLPropertyBOOL
};

NSString *NSStringFromMLPropertyType(MLPropertyType type);


@interface NSString (MLPropertyType)

- (MLPropertyType)ml_propertType;

@end
