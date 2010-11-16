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

    GHAssertThrowsSpecificNamed([SGPoint pointForGeometry:geometry],
                                NSException,
                                NSInvalidArgumentException,
                                @"NSInvalidArgumentException should have been thrown.");
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

    GHAssertThrowsSpecificNamed([SGPoint pointForGeometry:geometry],
                                NSException,
                                NSInvalidArgumentException,
                                @"NSInvalidArgumentException should have been thrown.");
}

@end
