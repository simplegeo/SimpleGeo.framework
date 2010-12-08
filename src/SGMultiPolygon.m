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
#import "SGPolygon+Private.h"


@implementation SGMultiPolygon

@synthesize polygons;

+ (SGMultiPolygon *)multiPolygonWithArray:(NSArray *)coordinates
{
    NSMutableArray *polygons = [NSMutableArray arrayWithCapacity:[coordinates count]];

    for (NSArray *polygon in coordinates) {
        [polygons addObject:[SGPolygon polygonWithArray:polygon]];
    }

    return [SGMultiPolygon multiPolygonWithPolygons:[NSArray arrayWithArray:polygons]];
}

+ (SGMultiPolygon *)multiPolygonWithDictionary:(NSDictionary *)dictionary
{
    if ([[dictionary objectForKey:@"type"] isEqual:@"MultiPolygon"]) {
        return [SGMultiPolygon multiPolygonWithArray:[dictionary objectForKey:@"coordinates"]];
    } else {
        NSLog(@"%@ could not be converted into a multi-polygon.", dictionary);
        return nil;
    }
}

+ (SGMultiPolygon *)multiPolygonWithPolygons:(NSArray *)polygons
{
    return [[SGMultiPolygon alloc] initWithPolygons:polygons];
}

- (id)init
{
    return [self initWithPolygons:nil];
}

- (id)initWithPolygons:(NSArray *)somePolygons
{
    self = [super init];

    if (self) {
        polygons = [somePolygons retain];
    }

    return self;
}

- (void)dealloc
{
    [polygons release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<SGMultiPolygon: %@>", polygons];
}

- (BOOL)isEqual:(id)object
{
    return [[object polygons] isEqual:polygons];
}

- (NSUInteger)hash
{
    return [polygons hash];
}

@end
