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

        return [SGPoint pointWithLatitude:[coordinates objectAtIndex:1]
                                longitude:[coordinates objectAtIndex:0]];
    } else {
        NSLog(@"Non-Point geometries aren't currently supported.");
            // TODO raise an exception
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
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:[NSString stringWithFormat:@"Unrecognized geometry input: %@ (%@)",
                                               [geometry description], [geometry class]]
                                     userInfo:nil];
    }
}

+ (SGPoint *)pointWithLatitude:(NSDecimalNumber *)latitude longitude:(NSDecimalNumber *)longitude
{
    return [[SGPoint alloc]initWithLatitude:latitude longitude:longitude];
}

- (id)init
{
    return [self initWithLatitude:nil longitude:nil];
}

- (id)initWithLatitude:(NSDecimalNumber *)lat longitude:(NSDecimalNumber *)lon
{
    self = [super init];

    if (self) {
        [self setLatitude:lat];
        [self setLongitude:lon];
    }

    return self;
}

- (void)dealloc
{
    [latitude release];
    [longitude release];
    [super dealloc];
}

@end
