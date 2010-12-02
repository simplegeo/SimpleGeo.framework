//
//  SGFeatureTest.m
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

#import <GHUnit/GHUnit.h>
#import <YAJL/YAJL.h>
#import "SGFeature.h"

@interface SGFeatureTest : GHTestCase { }
@end


@implementation SGFeatureTest

- (BOOL)shouldRunOnMainThread
{
    return NO;
}

- (void)testFeatureId
{
    NSString *featureId = @"SG_asdf";
    SGFeature *feature = [SGFeature featureWithId: featureId];

    GHAssertEqualObjects([feature featureId], featureId, @"Feature ids don't match.");
}

- (void)testFeatureWithDictionary
{
    // this is how SGFeatures will be created in the wild
    NSString *jsonData = @"{\"type\":\"Feature\",\"geometry\":{\"coordinates\":[-122.938,37.079],\"type\":\"Point\"},\"properties\":{\"type\":\"place\"}}";
    NSDictionary *featureData = [jsonData yajl_JSON];

    SGFeature *feature = [SGFeature featureWithId:@"SG_asdf"
                                       dictionary:featureData];

    GHAssertEqualObjects([[feature properties] objectForKey:@"type"], @"place", @"'type' should be 'place'");
    GHAssertEquals([[feature geometry] latitude], 37.079, @"Latitudes don't match.");
    GHAssertEquals([[feature geometry] longitude], -122.938, @"Longitudes don't match.");
}

- (void)testFeatureWithDictionaryAndRawBody
{
    // this is how SGFeatures will be created in the wild
    NSString *jsonData = @"{\"type\":\"Feature\",\"geometry\":{\"coordinates\":[-122.938,37.079],\"type\":\"Point\"},\"properties\":{\"type\":\"place\"}}";
    NSDictionary *featureData = [jsonData yajl_JSON];

    SGFeature *feature = [SGFeature featureWithId:@"SG_asdf"
                                       dictionary:featureData
                                          rawBody:jsonData];

    GHAssertEqualObjects([[feature properties] objectForKey:@"type"], @"place", @"'type' should be 'place'");
    GHAssertEquals([[feature geometry] latitude], 37.079, @"Latitudes don't match.");
    GHAssertEquals([[feature geometry] longitude], -122.938, @"Longitudes don't match.");
    GHAssertEqualObjects([feature rawBody], jsonData, nil);
}

- (void)testFeatureWithDictionaryWithAnArray
{
    // JSON array w/ 1+ Features
    NSString *jsonData = @"[{\"type\":\"Feature\",\"geometry\":{\"coordinates\":[-122.938,37.079],\"type\":\"Point\"},\"properties\":{\"type\":\"place\"}}]";
    id featureData = [jsonData yajl_JSON];

    GHAssertThrows([SGFeature featureWithId:@"SG_asdf"
                                 dictionary:featureData], nil);
}

- (void)testFeatureWithDictionaryWithAParsedFeatureCollection
{
    // GeoJSON FeatureCollection
    NSString *jsonData = @"{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"coordinates\":[-122.938,37.079],\"type\":\"Point\"},\"properties\":{\"type\":\"place\"}}]}";
    NSDictionary *featureData = [jsonData yajl_JSON];

    GHAssertNil([SGFeature featureWithId:@"SG_asdf"
                              dictionary:featureData], nil);
}

@end
