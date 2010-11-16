//
//  SGPointTest.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "SGPoint.h"

@interface SGPointTest : GHTestCase { }
@end


@implementation SGPointTest

- (BOOL)shouldRunOnMainThread
{
    return NO;
}

- (void)testPointWithLatitudeAndLongitude
{
    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];
    SGPoint *point = [SGPoint pointWithLatitude: latitude longitude: longitude];

    GHAssertEqualObjects(latitude, [point latitude], @"Latitudes don't match.");
    GHAssertEqualObjects(longitude, [point longitude], @"Longitudes don't match.");
}

- (void)testPointForGeometryWithSGPoint
{
    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];
    SGPoint *input = [SGPoint pointWithLatitude: latitude longitude: longitude];

    SGPoint *point = [SGPoint pointForGeometry:input];

    GHAssertEqualObjects(input, point, nil);
}

- (void)testPointForGeometryWithDictionaryContainingPoint
{
    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];
    NSArray *coordinates = [NSArray arrayWithObjects:longitude, latitude, nil];
    NSDictionary *geometry = [NSDictionary dictionaryWithObjectsAndKeys:@"Point", @"type",
                              coordinates, @"coordinates", nil];

    SGPoint *point = [SGPoint pointForGeometry:geometry];
    GHAssertEqualObjects(latitude, [point latitude], @"Latitudes don't match.");
    GHAssertEqualObjects(longitude, [point longitude], @"Longitudes don't match.");
}

- (void)testPointForGeometryWithDictionaryContainingPolygon
{
    GHFail(@"Not implemented.");
}

@end
