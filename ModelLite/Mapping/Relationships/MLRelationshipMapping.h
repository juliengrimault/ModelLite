//
//  MLRelationshipMapping.h
//  ModelLite
//
//  Created by Julien on 14/3/14.
//  Copyright (c) 2014 juliengrimault. All rights reserved.
//

@import Foundation;
#import "MLDatabaseObject.h"


@protocol MLRelationshipMapping <NSObject>

@property (nonatomic, copy, readonly) NSString *relationshipName;
@property (nonatomic, readonly) Class<MLDatabaseObject> childClass;

@end

@interface MLRelationshipMapping : NSObject

/// Class factory method - will instantiate the correct subtype
+ (id<MLRelationshipMapping>)mappingWithRelationshipName:(NSString *)relationshipName dictionary:(NSDictionary *)relationshipDict;

@end

