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

- (void)testLatitudeAndLongitude
{
	NSDecimalNumber *latitude = [NSDecimalNumber decimalNumberWithString: @"40.0"];
	NSDecimalNumber *longitude = [NSDecimalNumber decimalNumberWithString: @"-105.0"];
	SGPoint *point = [SGPoint pointWithLatitude: latitude longitude: longitude];

	GHAssertEqualObjects(latitude, [point latitude], @"Latitudes don't match.");
	GHAssertEqualObjects(longitude, [point longitude], @"Longitudes don't match.");
}

@end
