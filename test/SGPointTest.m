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

- (void)testPointWithLatitudeAndLongitudeWithNSDecimalNumber
{
    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];
    SGPoint *point = [SGPoint pointWithLatitude:latitude longitude:longitude];

    GHAssertEqualObjects([point latitude], latitude, @"Latitudes don't match.");
    GHAssertEqualObjects([point longitude], longitude, @"Longitudes don't match.");
}

- (void)testPointWithLatitudeAndLongitudeWithString
{
    SGPoint *point = [SGPoint pointWithLatitude:@"40.0" longitude:@"-105.0"];

    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];

    GHAssertEqualObjects([point latitude], latitude, @"Latitudes don't match.");
    GHAssertEqualObjects([point longitude], longitude, @"Longitudes don't match.");
}

- (void)testPointWithLatitudeAndLongitudeWithNSNumber
{
    SGPoint *point = [SGPoint pointWithLatitude:[NSNumber numberWithFloat:40.0]
                                      longitude:[NSNumber numberWithFloat:-105.0]];

    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];

    GHAssertEqualObjects([point latitude], latitude, @"Latitudes don't match.");
    GHAssertEqualObjects([point longitude], longitude, @"Longitudes don't match.");
}

- (void)testPointForGeometryWithSGPoint
{
    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];
    SGPoint *input = [SGPoint pointWithLatitude:latitude longitude:longitude];

    SGPoint *point = [SGPoint pointForGeometry:input];

    GHAssertEqualObjects(point, input, nil);
}

- (void)testPointForGeometryWithDictionaryContainingPoint
{
    NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
    NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];
    NSArray *coordinates = [NSArray arrayWithObjects:longitude, latitude, nil];
    NSDictionary *geometry = [NSDictionary dictionaryWithObjectsAndKeys:@"Point", @"type",
                              coordinates, @"coordinates", nil];

    SGPoint *point = [SGPoint pointForGeometry:geometry];
    GHAssertEqualObjects([point latitude], latitude, @"Latitudes don't match.");
    GHAssertEqualObjects([point longitude], longitude, @"Longitudes don't match.");
}

- (void)testPointForGeometryWithDictionaryContainingPolygon
{
    NSArray *coordinates = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"100.0"],
                             [NSDecimalNumber decimalNumberWithString:@"0.0"],
                             nil],
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"101.0"],
                             [NSDecimalNumber decimalNumberWithString:@"0.0"],
                             nil],
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"101.0"],
                             [NSDecimalNumber decimalNumberWithString:@"1.0"],
                             nil],
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"100.0"],
                             [NSDecimalNumber decimalNumberWithString:@"1.0"],
                             nil],
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"100.0"],
                             [NSDecimalNumber decimalNumberWithString:@"0.0"],
                             nil],
                            nil];
    NSDictionary *geometry = [NSDictionary dictionaryWithObjectsAndKeys:@"Polygon", @"type",
                              coordinates, @"coordinates", nil];

    GHAssertNil([SGPoint pointForGeometry:geometry], nil);
}

- (void)testPointForGeometryWithDictionaryContainingLineString
{
    NSArray *coordinates = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"102.0"],
                             [NSDecimalNumber decimalNumberWithString:@"0.0"],
                             nil],
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"103.0"],
                             [NSDecimalNumber decimalNumberWithString:@"1.0"],
                             nil],
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"104.0"],
                             [NSDecimalNumber decimalNumberWithString:@"0.0"],
                             nil],
                            [NSArray arrayWithObjects:
                             [NSDecimalNumber decimalNumberWithString:@"105.0"],
                             [NSDecimalNumber decimalNumberWithString:@"1.0"],
                             nil],
                            nil];
    NSDictionary *geometry = [NSDictionary dictionaryWithObjectsAndKeys:@"LineString", @"type",
                              coordinates, @"coordinates", nil];

    GHAssertNil([SGPoint pointForGeometry:geometry], nil);
}

@end
