//
//  SGMultiPolygon.m
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

#import "SGMultiPolygon.h"
#import "SGPolygon.h"
#import "SGPolygon+Internal.h"
#import "SGPoint.h"
#import "SGEnvelope.h"

@implementation SGMultiPolygon

@synthesize polygons;

#pragma mark -
#pragma mark Instantiation

+ (SGMultiPolygon *)multiPolygonWithPolygons:(NSArray *)polygons
{
    return [[[SGMultiPolygon alloc] initWithPolygons:polygons] autorelease];
}

+ (SGGeometry *)geometryWithGeoJSON:(NSDictionary *)geoJSONGeometry
{
    return [[[SGMultiPolygon alloc] initWithGeoJSON:geoJSONGeometry] autorelease];
}

- (id)initWithPolygons:(NSArray *)somePolygons
{
    self = [super init];
    if (self) {
        polygons = [somePolygons retain];
    }
    return self;
}

- (id)initWithGeoJSON:(NSDictionary *)geoJSONGeometry
{
    NSString *type = [geoJSONGeometry objectForKey:@"type"];
    NSArray *coordinates = [geoJSONGeometry objectForKey:@"coordinates"];
    if (type && [type isEqual:@"MultiPolygon"] && coordinates) {
        NSMutableArray *allPolygons = [NSMutableArray arrayWithCapacity:[coordinates count]];
        for (NSArray *polygon in coordinates) {
            [allPolygons addObject:[SGPolygon polygonWithArray:polygon]];
        }
        return [self initWithPolygons:allPolygons];
    }
    return nil;
}

#pragma mark -
#pragma mark Convenience

-(BOOL)containsPoint:(SGPoint *)point
{
    for (SGPolygon *polygon in polygons)
        if ([polygon containsPoint:point])
            return YES;
    return NO;
}

- (SGEnvelope *)envelope
{
    double northernLat = -90.0;
    double southernLat = 90;
    double westernLon = 180.0;
    double easternLon = -180.0;    
    for (SGPolygon *polygon in polygons) {
        SGEnvelope *envelope = [polygon envelope];
        if (envelope.north > northernLat) northernLat = envelope.north;
        if (envelope.south < southernLat) southernLat = envelope.south;
        if (envelope.west < westernLon) westernLon = envelope.west;
        if (envelope.east > easternLon) easternLon = envelope.east;
    }
    return [SGEnvelope envelopeWithNorth:northernLat
                                    west:westernLon
                                   south:southernLat
                                    east:easternLon];
}

- (NSDictionary *)asGeoJSON
{
    NSMutableArray *polygonsArray = [NSMutableArray arrayWithCapacity:[polygons count]];
    for (SGPolygon *polygon in polygons) {
        [polygonsArray addObject:[[polygon asGeoJSON] objectForKey:@"coordinates"]];
    }
    NSMutableDictionary *geoJSON = [NSMutableDictionary dictionaryWithCapacity:2];
    [geoJSON setValue:@"MultiPolygon" forKey:@"type"];
    [geoJSON setValue:polygonsArray forKey:@"coordinates"];
    return geoJSON;
}

- (NSString *)description
{
    return [[self asGeoJSON] description];
}

#pragma mark -
#pragma mark Comparison

- (BOOL)isEqual:(id)object
{
    return [[object polygons] isEqual:polygons];
}

- (NSUInteger)hash
{
    return [polygons hash];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    [polygons release];
    [super dealloc];
}

@end
