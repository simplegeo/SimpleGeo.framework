//
//  SGPoint.m
//  SimpleGeo.framework
//
//  Copyright (c) 2010, SimpleGeo Inc.
//  All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "SGPoint.h"


@implementation SGPoint

@synthesize latitude;
@synthesize longitude;

+ (SGPoint *)pointWithArray:(NSArray *)coordinates
{
    return [SGPoint pointWithLatitude:[[coordinates objectAtIndex:1] doubleValue]
                            longitude:[[coordinates objectAtIndex:0] doubleValue]];
}

+ (SGPoint *)pointWithDictionary:(NSDictionary *)input
{
    if ([[input objectForKey:@"type"] isEqual:@"Point"]) {
        return [SGPoint pointWithArray:[input objectForKey:@"coordinates"]];
    } else {
        NSLog(@"%@ could not be converted into a point.", input);
        return nil;
    }
}

+ (SGPoint *)pointWithGeometry:(id)geometry
{
    if ([geometry isKindOfClass:[SGPoint class]]) {
        return geometry;
    } else if ([geometry isKindOfClass:[NSDictionary class]]) {
        return [SGPoint pointWithDictionary:geometry];
    } else {
        NSLog(@"%@ could not be converted into a point.", geometry);
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

- (id)JSON
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
             @"Point", @"type",
             [NSArray arrayWithObjects:
              [NSNumber numberWithDouble:longitude],
              [NSNumber numberWithDouble:latitude],
              nil], @"coordinates",
             nil];
}

@end
