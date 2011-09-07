//
//  SimpleGeoTest.m
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

#import "SimpleGeoTest.h"
#import "NSArray+SGCollection.h"

static SimpleGeo *sharedClient = nil;

@interface SimpleGeoTest ()
- (void)removeAPISpecificKeys:(NSMutableDictionary *)geoObject;
@end

@implementation SimpleGeoTest

@synthesize failureBlock;

- (BOOL)shouldRunOnMainThread
{
    return NO;
}

#pragma mark Test Objects

- (SimpleGeo *)client
{
    if(!sharedClient) {
        sharedClient = [[SimpleGeo clientWithConsumerKey:SGTestKey
                                          consumerSecret:SGTestSecret] retain];
        [sharedClient setApiURL:SGTestApiURL];
    }
    return sharedClient;
}

- (SimpleGeo *)placesClient:(NSString *)version
{
    SimpleGeo *client = self.client;
    [client setPlacesVersion:version];
    return client;
}

- (SGPoint *)point
{
    return [SGPoint pointWithLat:SGTestLatitude
                             lon:SGTestLongitude];
}

- (SGPoint *)outlierPoint
{
    return [SGPoint pointWithLat:SGTestLatitude+20.0f
                             lon:SGTestLongitude];
}

- (SGEnvelope *)envelope
{
    return [SGEnvelope envelopeWithNorth:SGTestEnvelopeNorth
                                    west:SGTestEnvelopeWest
                                   south:SGTestEnvelopeSouth
                                    east:SGTestEnvelopeEast];
}

#pragma mark Basic Callbacks

- (SGCallback *)delegateCallbacks
{
    return [[[SGCallback alloc] initWithDelegate:self
                                  successMethod:@selector(requestDidSucceed:)
                                  failureMethod:@selector(requestDidFail:)] autorelease];
}

- (void)requestDidSucceed:(NSObject *)response
{
    GHTestLog(@"%@", response);
    [self notify:kGHUnitWaitStatusSuccess];
}

- (void)requestDidFail:(NSError *)error
{
    GHTestLog(@"%@", error.description);
    [self notify:kGHUnitWaitStatusFailure];
}

- (SGFailureBlock)failureBlock
{
    return [[^(NSError *error) {
        GHTestLog(@"%@", error.description);
        [self notify:kGHUnitWaitStatusFailure];
    } copy] autorelease];
}

#pragma mark Basic Check Methods

- (void)checkSGFeatureConversion:(id)response
                          object:(SGGeoObject *)object
{
    NSMutableDictionary *alteredResponse = [[NSMutableDictionary dictionaryWithDictionary:response] retain];;
    [self removeAPISpecificKeys:alteredResponse];
    GHAssertEqualObjects(alteredResponse, [object asGeoJSON],
                         @"Feature's GeoJSON should match response geoJSON");
    [alteredResponse release];
}

- (void)checkSGCollectionConversion:(id)response
                               type:(SGCollectionType)type
{
    // do the conversion
    NSArray *features = [NSArray arrayWithSGCollection:response type:type];
    GeoJSONCollectionType collectionType = GeoJSONCollectionTypeFeatures;
    if (type == SGCollectionTypePoints) collectionType = GeoJSONCollectionTypeGeometries;
    NSDictionary *featureCollection = [features asGeoJSONCollection:collectionType];
    
    // remove API-specific object keys from the response
    NSMutableDictionary *alteredResponse = [NSMutableDictionary dictionaryWithDictionary:response];
    NSMutableArray *objects = [NSMutableArray array];
    for (NSDictionary *object in [alteredResponse objectForKey:@"features"]) {
        NSMutableDictionary *feature = [NSMutableDictionary dictionaryWithDictionary:object];
        [self removeAPISpecificKeys:feature];
        [objects addObject:feature];
    }
    [alteredResponse setObject:objects forKey:@"features"];
    
    // remove API-specific top-level keys from the response
    NSMutableDictionary *cleanResponse = [NSMutableDictionary dictionary];
    [cleanResponse setValue:[alteredResponse objectForKey:@"type"] forKey:@"type"];
    if (type != SGCollectionTypePoints) [cleanResponse setValue:[alteredResponse objectForKey:@"features"] forKey:@"features"];
    [cleanResponse setValue:[alteredResponse objectForKey:@"geometries"] forKey:@"geometries"];
    
    // compare
    GHAssertEqualObjects(cleanResponse, featureCollection, @"Feature's GeoJSON should match response geoJSON");
}

- (void)removeAPISpecificKeys:(NSMutableDictionary *)object
{
    [object removeObjectForKey:@"distance"];
    [object removeObjectForKey:@"selfLink"];
    [object removeObjectForKey:@"layerLink"];
    [object setObject:@"Feature" forKey:@"type"]; // TODO
    
    NSMutableDictionary *propsDict = [NSMutableDictionary dictionaryWithDictionary:[object objectForKey:@"properties"]];
    [propsDict removeObjectForKey:@"distance"];
    [object setObject:propsDict forKey:@"properties"];
}

#pragma mark General Tests

- (void)testGetCategories
{
    [self prepare];
    [[self client] getCategoriesWithCallback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];    
}

@end
