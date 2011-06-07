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
#import "SGPoint+Private.h"

@implementation SGPolygon

@synthesize rings;

+ (SGPolygon *)polygonWithArray:(NSArray *)coordinates
{
    NSMutableArray *rings = [NSMutableArray arrayWithCapacity:[coordinates count]];

    for (NSArray *ring in coordinates) {
        NSMutableArray *r = [NSMutableArray arrayWithCapacity:[ring count]];
        for (NSArray *coordinate in ring) {
            [r addObject:[SGPoint pointWithLatitude:[[coordinate objectAtIndex:1] doubleValue]
                                          longitude:[[coordinate objectAtIndex:0] doubleValue]]];
        }
        [rings addObject:r];
    }

    return [SGPolygon polygonWithRings:[NSArray arrayWithArray:rings]];
}

+ (SGPolygon *)polygonWithDictionary:(NSDictionary *)dictionary
{
    if ([[dictionary objectForKey:@"type"] isEqual:@"Polygon"]) {
        return [SGPolygon polygonWithArray:[dictionary objectForKey:@"coordinates"]];
    } else {
        NSLog(@"%@ could not be converted into a polygon.", dictionary);
        return nil;
    }
}

+ (SGPolygon *)polygonWithRings:(NSArray *)rings
{
    return [[[SGPolygon alloc] initWithRings:rings] autorelease];
}

- (id)init
{
    return [self initWithRings:nil];
}

- (id)initWithRings:(NSArray *)someRings
{
    self = [super init];

    if (self) {
        rings = [someRings retain];
    }

    return self;
}

- (BOOL)containsPoint:(SGPoint*)point
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

- (void)dealloc
{
    [rings release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<SGPolygon: %@>", rings];
}

- (BOOL)isEqual:(id)object
{
    return [[object rings] isEqual:rings];
}

- (NSUInteger)hash
{
    return [rings hash];
}

@end
