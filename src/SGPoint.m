//
//  SGPoint.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGPoint.h"


@implementation SGPoint

@synthesize latitude;
@synthesize longitude;

+ (SGPoint *)pointForDictionary:(NSDictionary *)input
{
    if ([[input objectForKey:@"type"] isEqual:@"Point"]) {
        NSArray *coordinates = [input objectForKey:@"coordinates"];

        return [SGPoint pointWithLatitude:[[coordinates objectAtIndex:1] doubleValue]
                                longitude:[[coordinates objectAtIndex:0] doubleValue]];
    } else {
        return nil;
    }
}

+ (SGPoint *)pointForGeometry:(id)geometry
{
    if ([geometry isKindOfClass:[SGPoint class]]) {
        return geometry;
    } else if ([geometry isKindOfClass:[NSDictionary class]]) {
        return [SGPoint pointForDictionary:geometry];
    } else {
        return nil;
    }
}

+ (SGPoint *)pointWithLatitude:(double)latitude
                     longitude:(double)longitude
{
    return [[[SGPoint alloc] initWithLatitude:latitude
                                    longitude:longitude] autorelease];
}

- (id)init
{
    return [self initWithLatitude:0
                        longitude:0];
}

- (id)initWithLatitude:(double)lat
             longitude:(double)lon
{
    self = [super init];

    if (self) {
        latitude = lat;
        longitude = lon;
    }

    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<SGPoint: %f, %f>", latitude, longitude];
}

- (BOOL) isEqual:(id)object
{
    return latitude == [object latitude] && longitude == [object longitude];
}

- (NSUInteger)hash
{
    return [[NSNumber numberWithDouble:latitude] hash] +
           [[NSNumber numberWithDouble:longitude] hash];
}

@end
