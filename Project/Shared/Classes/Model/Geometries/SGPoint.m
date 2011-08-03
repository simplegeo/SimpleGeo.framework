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
#import "SGPoint+Internal.h"

@implementation SGPoint

@synthesize latitude, longitude, created;

#pragma mark -
#pragma mark Instantiation

+ (SGPoint *)pointWithLat:(double)latitude
                      lon:(double)longitude
{
    return [[[SGPoint alloc] initWithLat:latitude
                                     lon:longitude] autorelease];
}

+ (SGGeometry *)geometryWithGeoJSON:(NSDictionary *)geoJSONGeometry
{
    return [[[SGPoint alloc] initWithGeoJSON:geoJSONGeometry] autorelease];
}

- (id)initWithLat:(double)aLatitude
              lon:(double)aLongitude
{
    self = [super init];
    if (self) {
        latitude = aLatitude;
        longitude = aLongitude;
    }
    return self;
}

- (id)initWithGeoJSON:(NSDictionary *)geoJSONGeometry
{
    NSString *type = [geoJSONGeometry objectForKey:@"type"];
    NSArray *coordinates = [geoJSONGeometry objectForKey:@"coordinates"];
    if (type && [type isEqual:@"Point"] && coordinates && [coordinates count] == 2) {        
        self = [self initWithArray:coordinates];
        if (self) {
            NSNumber *epoch = [geoJSONGeometry objectForKey:@"created"];
            if (epoch) created = [[NSDate alloc] initWithTimeIntervalSince1970:[epoch doubleValue]];
        }
        return self;
    }
    return nil;
}

#pragma mark -
#pragma mark Convenience

- (NSDictionary *)asGeoJSON
{
    NSMutableDictionary *geoJSON = [NSMutableDictionary dictionaryWithCapacity:3];
    [geoJSON setValue:@"Point" forKey:@"type"];
    if (created) [geoJSON setValue:[NSNumber numberWithDouble:[created timeIntervalSince1970]] forKey:@"created"];
    [geoJSON setValue:[NSArray arrayWithObjects:
                       [NSNumber numberWithDouble:longitude],
                       [NSNumber numberWithDouble:latitude],
                       nil] forKey:@"coordinates"];
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
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    return (latitude == [object latitude] &&
            longitude == [object longitude]);
}

- (NSUInteger)hash
{
    return [[NSNumber numberWithDouble:latitude] hash] +
           [[NSNumber numberWithDouble:longitude] hash];
}

#pragma mark -
#pragma mark Internal

+ (SGPoint *)pointWithArray:(NSArray *)point
{
    return [[[SGPoint alloc] initWithArray:point] autorelease];
}

- (id)initWithArray:(NSArray *)point
{
    return [[SGPoint alloc] initWithLat:[[point objectAtIndex:1] doubleValue]
                                    lon:[[point objectAtIndex:0] doubleValue]];
}

#pragma mark Memory

- (void)dealloc
{
    [created release];
    [super dealloc];
}

@end
