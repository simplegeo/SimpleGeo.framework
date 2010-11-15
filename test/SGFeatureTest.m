//
//  SGFeatureTest.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
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

    GHAssertEqualObjects(featureId, [feature featureId], @"Feature ids don't match.");
}

- (void)testFeatureWithData
{
    // this is how SGFeatures will be created in the wild
    NSString *jsonData = @"{\"type\":\"Feature\",\"geometry\":{\"coordinates\":[-122.938,37.079],\"type\":\"Point\"},\"properties\":{\"type\":\"place\"}}";
    NSDictionary *featureData = [jsonData yajl_JSON];

    SGFeature *feature = [SGFeature featureWithId:@"SG_asdf" data:featureData];

    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"37.079"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-122.938"];

    GHAssertEqualObjects(@"place", [[feature properties] objectForKey:@"type"], @"'type' should be 'place'");
    GHAssertEqualObjects(latitude, [[feature geometry] latitude], @"Latitudes don't match.");
    GHAssertEqualObjects(longitude, [[feature geometry] longitude], @"Longitudes don't match.");
}

- (void)testFeatureWithDataWithAnArray
{
    // JSON array w/ 1+ Features
    NSString *jsonData = @"[{\"type\":\"Feature\",\"geometry\":{\"coordinates\":[-122.938,37.079],\"type\":\"Point\"},\"properties\":{\"type\":\"place\"}}]";
    id featureData = [jsonData yajl_JSON];

    GHAssertThrowsSpecificNamed([SGFeature featureWithId:@"SG_asdf" data:featureData],
                                NSException,
                                NSInvalidArgumentException,
                                @"NSInvalidArgumentException should have been thrown.");
}

- (void)testFeatureWithDataWithAFeatureCollection
{
    // GeoJSON FeatureCollection
    NSString *jsonData = @"{\"type\":\"FeatureCollection\",\"features\":[{\"type\":\"Feature\",\"geometry\":{\"coordinates\":[-122.938,37.079],\"type\":\"Point\"},\"properties\":{\"type\":\"place\"}}]}";
    NSDictionary *featureData = [jsonData yajl_JSON];

    GHAssertThrowsSpecificNamed([SGFeature featureWithId:@"SG_asdf" data:featureData],
                                NSException,
                                NSInvalidArgumentException,
                                @"NSInvalidArgumentException should have been thrown.");
}

@end
