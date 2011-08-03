//
//  SGEnvelope.m
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

#import "SGEnvelope.h"
#import "SGPoint.h"

@implementation SGEnvelope

@synthesize north, east, south, west;

#pragma mark -
#pragma mark Instantiation

+ (SGEnvelope *)envelopeWithNorth:(double)northernLat
                             west:(double)westernLon
                            south:(double)southernLat
                             east:(double)easternLon
{
    return [[[SGEnvelope alloc] initWithWithNorth:northernLat
                                             west:westernLon
                                            south:southernLat
                                             east:easternLon] autorelease];
}

- (id)initWithWithNorth:(double)northernLat
                   west:(double)westernLon
                  south:(double)southernLat
                   east:(double)easternLon
{
    self = [super init];
    if (self) {
        north = northernLat;
        west = westernLon;
        south = southernLat;
        east = easternLon;
    }
    return self;
}

- (id)initWithGeoJSON:(NSDictionary *)geoJSONGeometry
{
    NSArray *points = [geoJSONGeometry objectForKey:@"bbox"];
    if (points && [points count] == 4) 
        return [self initWithWithNorth:[[points objectAtIndex:0] doubleValue]
                                  west:[[points objectAtIndex:1] doubleValue]
                                 south:[[points objectAtIndex:2] doubleValue]
                                  east:[[points objectAtIndex:3] doubleValue]];
    return nil;
}

#pragma mark -
#pragma mark Convenience

- (SGPoint *)center
{
    double lon = (east + west) / 2.0;
    if (west > east) {
        if (lon > 0) lon += -180;
        else lon += 180;
    }
    return [SGPoint pointWithLat:(north + south) / 2.0
                             lon:lon];
}

- (SGEnvelope *)envelope
{
    return self;
}

- (BOOL)containsPoint:(SGPoint *)point
{
    BOOL inLatitudeRange = (point.latitude > south && point.latitude < north);
    BOOL inLongitudeRange;
    if (east > west) {
        inLongitudeRange = (point.longitude > west && point.longitude < east);
    } else {
        inLongitudeRange = (point.longitude > west || point.longitude < east);
    }
    return (inLatitudeRange && inLongitudeRange);
}

- (NSDictionary *)asGeoJSON
{
    return [NSDictionary dictionaryWithObject:[NSArray arrayWithObjects:
                                               [NSNumber numberWithDouble:north],
                                               [NSNumber numberWithDouble:west],
                                               [NSNumber numberWithDouble:south],
                                               [NSNumber numberWithDouble:east],
                                               nil] forKey:@"bbox"];
}

- (NSString *)description
{
    return [[self asGeoJSON] description];
}

#pragma mark -
#pragma mark Comparison

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    return (north == [object north] &&
            west == [object west] &&
            south == [object south] &&
            east == [object east]);
}

- (NSUInteger)hash
{
    return [[NSNumber numberWithDouble:north] hash] +
           [[NSNumber numberWithDouble:west] hash] +
           [[NSNumber numberWithDouble:south] hash] +
           [[NSNumber numberWithDouble:east] hash];
}

@end
