//
//  SGGeoObject.m
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

#import "SGGeoObject.h"
#import "SGGeometry.h"

@implementation SGGeoObject

@synthesize identifier, geometry, properties, distance, selfLink;

#pragma mark -
#pragma mark Instantiation

- (id)initWithGeometry:(SGGeometry *)aGeometry
{
    self = [super init];
    if (self) {
        geometry = [aGeometry retain];
    }
    return self;
}


- (id)initWithGeoJSON:(NSDictionary *)geoJSONFeature
{
    self = [super init];
    if (self) {
        geometry = [[SGGeometry alloc] initWithGeoJSON:[geoJSONFeature objectForKey:@"geometry"]];
        identifier = [[geoJSONFeature objectForKey:@"id"] retain];
        [self setProperties:[geoJSONFeature objectForKey:@"properties"]];
        // self link
        NSDictionary *selfLinkDict = [geoJSONFeature objectForKey:@"selfLink"];
        if (selfLinkDict) selfLink = [[selfLinkDict objectForKey:@"href"] retain];
        else {
            selfLink = [[properties objectForKey:@"href"] retain];
            [properties removeObjectForKey:@"href"];
        }
        // distance
        distance = [[geoJSONFeature objectForKey:@"distance"] retain];
        if (!distance) {
            distance = [[properties objectForKey:@"distance"] retain];
            [properties removeObjectForKey:@"distance"];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Convenience

- (void)setProperties:(NSDictionary *)someProperties
{
    [self setMutableProperties:[NSMutableDictionary dictionaryWithDictionary:someProperties]];
}

- (void)setMutableProperties:(NSMutableDictionary *)someProperties
{
    [properties release];
    properties = [someProperties retain];
}

- (NSDictionary *)asGeoJSON
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:@"Feature" forKey:@"type"];
    [dictionary setValue:[geometry asGeoJSON] forKey:@"geometry"];
    [dictionary setValue:identifier forKey:@"id"];
    [dictionary setValue:[NSMutableDictionary dictionaryWithDictionary:properties] forKey:@"properties"];
    // if (selfLink) [dictionary setValue:[NSDictionary dictionaryWithObject:selfLink forKey:@"href"] forKey:@"selfLink"]; // self link
    // [dictionary setValue:distance forKey:@"distance"]; // distance
    return dictionary;
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
    return [identifier isEqual:[object identifier]];
}

- (NSUInteger)hash
{
    return [identifier hash];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    [geometry release];
    [identifier release];
    [properties release];
    [distance release];
    [selfLink release];
    [super dealloc];
}

@end
