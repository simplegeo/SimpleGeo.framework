//
//  SGPolygon.m
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

#import "SGPolygon.h"
#import "SGPolygon+Internal.h"
#import "SGPoint.h"
#import "SGPoint+Internal.h"
#import "SGEnvelope.h"

@implementation SGPolygon

@synthesize rings;

#pragma mark -
#pragma mark Instantiation

+ (SGPolygon *)polygonWithRings:(NSArray *)rings
{
    return [[[SGPolygon alloc] initWithRings:rings] autorelease];
}

+ (SGPolygon *)polygonWithBoundary:(NSArray *)boundary
                             holes:(NSArray *)holes
{
    return [[[SGPolygon alloc] initWithBoundary:boundary
                                          holes:holes] autorelease];
}

+ (SGGeometry *)geometryWithGeoJSON:(NSDictionary *)geoJSONGeometry
{
    return [[[SGPolygon alloc] initWithGeoJSON:geoJSONGeometry] autorelease];
}

- (id)initWithRings:(NSArray *)someRings
{
    self = [super init];
    if (self) {
        rings = [someRings retain];
    }
    return self;
}

- (id)initWithBoundary:(NSArray *)boundary
                 holes:(NSArray *)holes
{
    NSMutableArray *allRings = [NSMutableArray arrayWithArray:boundary];
    [allRings addObjectsFromArray:holes];
    return [self initWithRings:allRings];
}

- (id)initWithGeoJSON:(NSDictionary *)geoJSONGeometry
{
    NSString *type = [geoJSONGeometry objectForKey:@"type"];
    NSArray *coordinates = [geoJSONGeometry objectForKey:@"coordinates"];
    if (type && [type isEqual:@"Polygon"] && coordinates) {
        return [self initWithArray:coordinates];
    }
    return nil;
}

#pragma mark -
#pragma mark Convenience

- (NSArray *)boundary
{
    return [rings objectAtIndex:0];
}

- (NSArray *)holes
{
    NSMutableArray *holesArray = [NSMutableArray arrayWithArray:rings];
    [holesArray removeObjectAtIndex:0];
    return holesArray;
}

- (SGEnvelope *)envelope
{
    double northernLat = -90.0;
    double southernLat = 90;
    double westernLon = 180.0;
    double easternLon = -180.0;
    for (SGPoint *point in [self boundary]) {
        if (point.latitude > northernLat) northernLat = point.latitude;
        if (point.latitude < southernLat) southernLat = point.latitude;
        if (point.longitude < westernLon) westernLon = point.longitude;
        if (point.longitude > easternLon) easternLon = point.longitude;
    }
    return [SGEnvelope envelopeWithNorth:northernLat
                                    west:westernLon
                                   south:southernLat
                                    east:easternLon];
}

- (BOOL)containsPoint:(SGPoint *)point
{
    BOOL contains = NO;
    for (NSArray *ring in rings) {
        for (int p=0; p<[ring count]-1; p++) {
            SGPoint *thisPoint = [ring objectAtIndex:p];
            SGPoint *nextPoint = [ring objectAtIndex:p+1];
            if (([thisPoint latitude]<[point latitude] && [nextPoint latitude]>=[point latitude]) || ([nextPoint latitude]<[point latitude] && [thisPoint latitude]>=[point latitude]))
                if ([thisPoint longitude]+([point latitude]-[thisPoint latitude])/([nextPoint latitude]-[thisPoint latitude])*([nextPoint longitude]-[thisPoint longitude])<[point longitude])
                    contains = !contains;
        }
    }
    return contains;
}

- (NSDictionary *)asGeoJSON
{
    NSMutableArray *newRings = [NSMutableArray arrayWithCapacity:[rings count]];
    for (NSArray *ring in rings) {
        NSMutableArray *newRing = [NSMutableArray arrayWithCapacity:[ring count]];
        for (SGPoint *point in ring) {
            [newRing addObject:[NSArray arrayWithObjects:[NSNumber numberWithDouble:point.longitude],
                                [NSNumber numberWithDouble:point.latitude], nil]];
        }
        [newRings addObject:newRing];
    }
    NSMutableDictionary *geoJSON = [NSMutableDictionary dictionaryWithCapacity:2];
    [geoJSON setValue:@"Polygon" forKey:@"type"];
    [geoJSON setValue:newRings forKey:@"coordinates"];
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
    return [[object rings] isEqual:rings];
}

- (NSUInteger)hash
{
    return [rings hash];
}

#pragma mark -
#pragma mark Internal

+ (SGPolygon *)polygonWithArray:(NSArray *)polygon
{
    return [[[SGPolygon alloc] initWithArray:polygon] autorelease];
}

- (id)initWithArray:(NSArray *)polygon
{
    NSMutableArray *allRings = [NSMutableArray arrayWithCapacity:[polygon count]];
    for (NSArray *ring in polygon) {
        NSMutableArray *thisRing = [NSMutableArray arrayWithCapacity:[ring count]];
        for (NSArray *coordinate in ring) {
            [thisRing addObject:[SGPoint pointWithArray:coordinate]];
        }
        [allRings addObject:thisRing];
    }
    return [self initWithRings:allRings];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    [rings release];
    [super dealloc];
}

@end
