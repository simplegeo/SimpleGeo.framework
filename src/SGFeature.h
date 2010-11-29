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

@property (retain,readonly) NSString* featureId;
@property (retain,readonly) SGPoint* geometry;
@property (retain,readonly) NSDictionary* properties;
@property (retain,readonly) NSString* rawBody;

+ (SGFeature *)featureWithId:(NSString *)id;
+ (SGFeature *)featureWithId:(NSString *)id
                        data:(NSDictionary *)data;
+ (SGFeature *)featureWithId:(NSString *)id
                        data:(NSDictionary *)data
                     rawBody:(NSString *)rawBody;
+ (SGFeature *)featureWithData:(NSDictionary *)data;
- (id)initWithId:(NSString *)id;
- (id)initWithId:(NSString *)id
            data:(NSDictionary *)data;
- (id)initWithId:(NSString *)id
            data:(NSDictionary *)data
         rawBody:(NSString *)rawBody;

@end
