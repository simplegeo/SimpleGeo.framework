//
//  SGGeometryTest.m
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
#import "SGGeometry.h"
#import "SGGeometry+Private.h"
#import "SGPoint.h"
#import "SGPolygon.h"


@interface SGGeometryTest : GHTestCase { }
@end


@implementation SGGeometryTest

- (BOOL)shouldRunOnMainThread
{
    return NO;
}

- (void)testGeometryWithGeometryWithSGPoint
{
    SGPoint *input = [SGPoint pointWithLatitude:40.0 longitude:-105.0];
    SGGeometry *geometry = [SGGeometry geometryWithGeometry:input];

    GHAssertEqualObjects(geometry, input, nil);
}

- (void)testGeometryWithGeometryWithDictionaryContainingPoint
{
    double latitude = 40.0;
    double longitude = -105.0;
    NSArray *coordinates = [NSArray arrayWithObjects:[NSNumber numberWithDouble:longitude],
                            [NSNumber numberWithDouble:latitude], nil];
    NSDictionary *geometry = [NSDictionary dictionaryWithObjectsAndKeys:@"Point", @"type",
                              coordinates, @"coordinates", nil];

    SGPoint *point = (SGPoint *) [SGGeometry geometryWithGeometry:geometry];
    GHAssertEquals([point latitude], latitude, @"Latitudes don't match.");
    GHAssertEquals([point longitude], longitude, @"Longitudes don't match.");
}

- (void)testGeometryForGeometryWithDictionaryContainingPolygon
{
    NSArray *coordinates = [NSArray arrayWithObjects:
                            [NSArray arrayWithObjects:
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
                             nil],
                            nil];
    NSDictionary *geometry = [NSDictionary dictionaryWithObjectsAndKeys:@"Polygon", @"type",
                              coordinates, @"coordinates", nil];

    NSArray *rings = [NSArray arrayWithObjects:
                      [NSArray arrayWithObjects:[SGPoint pointWithLatitude:0.0
                                                                 longitude:100.0],
                                                [SGPoint pointWithLatitude:0.0
                                                                 longitude:101.0],
                                                [SGPoint pointWithLatitude:1.0
                                                                 longitude:101.0],
                                                [SGPoint pointWithLatitude:1.0
                                                                 longitude:100.0],
                                                [SGPoint pointWithLatitude:0.0
                                                                 longitude:100.0],
                                                nil],
                      nil];

    SGPolygon *expected = [SGPolygon polygonWithRings:rings];
    SGPolygon *polygon = (SGPolygon *) [SGGeometry geometryWithGeometry:geometry];
    GHAssertEqualObjects(polygon, expected, nil);
}

- (void)testGeometryForGeometryWithDictionaryContainingLineString
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

    GHAssertNil([SGGeometry geometryWithGeometry:geometry], nil);
}

@end
