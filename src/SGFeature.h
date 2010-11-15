//
//  SGFeature.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGPoint.h"


@interface SGFeature : NSObject
{
    NSString* featureId;
    SGPoint* geometry;
    NSDictionary* properties;
    NSString* rawBody;
}

@property (retain) NSString* featureId;
@property (retain) SGPoint* geometry;
@property (retain) NSDictionary* properties;
@property (retain) NSString* rawBody;

+ (SGFeature *)featureWithId:(NSString *)id;
+ (SGFeature *)featureWithId:(NSString *)id data:(NSDictionary *)data;
- (id)initWithId:(NSString *)id;
- (id)initWithId:(NSString *)id data:(NSDictionary *)data;

- (void)setGeometryWithDictionary:(NSDictionary *)dictionary;

@end
