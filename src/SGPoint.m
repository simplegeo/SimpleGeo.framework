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
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Non-Point geometries aren't currently supported."
                                     userInfo:nil];
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

+ (SGPoint *)pointWithLatitude:(id)latitude longitude:(id)longitude
{
    if ([latitude isKindOfClass:[NSDecimalNumber class]] &&
        [longitude isKindOfClass:[NSDecimalNumber class]]) {

        return [[SGPoint alloc]initWithLatitude:latitude longitude:longitude];
    } else if ([latitude isKindOfClass:[NSNumber class]] &&
        [longitude isKindOfClass:[NSNumber class]]) {

        return [[SGPoint alloc]initWithLatitude:[NSDecimalNumber decimalNumberWithString:
                                                 [latitude stringValue]]
                                      longitude:[NSDecimalNumber decimalNumberWithString:
                                                 [longitude stringValue]]];
    } else if ([latitude isKindOfClass:[NSString class]] &&
               [longitude isKindOfClass:[NSString class]]) {

        return [[SGPoint alloc]initWithLatitude:[NSDecimalNumber decimalNumberWithString:latitude]
                                      longitude:[NSDecimalNumber decimalNumberWithString:longitude]];
    } else {
        @throw [NSException exceptionWithName:NSInvalidArgumentException
                                       reason:@"Input couldn't be converted to a number."
                                     userInfo:nil];
    }
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

- (NSString *)description
{
    return [NSString stringWithFormat:@"<SGPoint: %@, %@>",
            [latitude stringValue],
            [longitude stringValue]];
}

- (BOOL) isEqual:(id)object
{
    return [latitude isEqual:[object latitude]] && [longitude isEqual:[object longitude]];
}

- (NSUInteger)hash
{
    return [latitude hash] + [longitude hash];
}

@end
