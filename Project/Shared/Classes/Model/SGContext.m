//
//  NSDictionary+SGContext.m
//  SimpleGeo
//
//  Copyright (c) 2010-2011, SimpleGeo Inc.
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

#import "SGContext.h"
#import "SGEnvelope.h"
#import "SGFeature.h"
#import "SGPlacemark.h"
#import "SGPlacemark+Internal.h"
#import "NSArray+SGCollection.h"

@interface SGContext ()
- (NSArray *)generateFeatures:(NSArray *)contextFeatures;
@end

@implementation SGContext

@synthesize timestamp, query, address, features, demographics, intersections, weather;

+ (SGContext *)contextWithDictionary:(NSDictionary *)dictionary
{
    return [[[SGContext alloc] initWithDictionary:dictionary] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        // timestamp
        NSNumber *epochDate = [dictionary objectForKey:@"timestamp"];
        if (epochDate) timestamp = [[NSDate dateWithTimeIntervalSince1970:[epochDate doubleValue]] retain];
        // query
        query = [[dictionary objectForKey:@"query"] retain];
        // address
        NSDictionary *addressResponse = [dictionary objectForKey:@"address"];
        if (addressResponse) address = [[SGPlacemark alloc] initWithGeoJSON:addressResponse];
        // features
        features = [[self generateFeatures:[dictionary objectForKey:@"features"]] retain];
        // demographics
        demographics = [[dictionary objectForKey:@"demographics"] retain];
        // intersections
        NSArray *intersectionsResponse = [dictionary objectForKey:@"intersections"];
        if (intersectionsResponse)
            intersections = [[NSArray arrayWithSGCollection:[NSDictionary dictionaryWithObject:intersectionsResponse forKey:@"features"] 
                                                       type:SGCollectionTypeObjects] retain];
        // weather
        weather = [[dictionary objectForKey:@"weather"] retain];
    }
    return self;
}

- (NSArray *)generateFeatures:(NSArray *)contextFeatures
{
    NSMutableArray *newFeatures = [NSMutableArray arrayWithCapacity:[contextFeatures count]];
    for (NSDictionary *feature in contextFeatures) {
        NSMutableDictionary *newFeature = [NSMutableDictionary dictionary];
        NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:feature];
        if (![properties objectForKey:@"abbr"] || [properties objectForKey:@"abbr"] == (id)[NSNull null])
            [properties removeObjectForKey:@"abbr"];
        SGEnvelope *bbox = [SGEnvelope envelopeWithNorth:[[[feature objectForKey:@"bounds"] objectAtIndex:3] doubleValue]
                                                    west:[[[feature objectForKey:@"bounds"] objectAtIndex:0] doubleValue]
                                                   south:[[[feature objectForKey:@"bounds"] objectAtIndex:1] doubleValue]
                                                    east:[[[feature objectForKey:@"bounds"] objectAtIndex:2] doubleValue]];
        [newFeature setObject:[bbox asGeoJSON] forKey:@"geometry"];
        [properties removeObjectForKey:@"bounds"];
        [newFeature setObject:[properties objectForKey:@"handle"] forKey:@"id"];
        [properties removeObjectForKey:@"handle"];
        [newFeature setObject:properties forKey:@"properties"];
        [newFeatures addObject:[SGFeature featureWithGeoJSON:newFeature]];        
    }
    return newFeatures;
}

- (void)dealloc
{
    [timestamp release];
    [query release];
    [address release];
    [features release];
    [demographics release];
    [intersections release];
    [weather release];
    [super dealloc];
}

@end
