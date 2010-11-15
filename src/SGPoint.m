//
//  SGPoint.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGPoint.h"


@implementation SGPoint

@synthesize latitude;
@synthesize longitude;

+ (SGPoint *)pointWithLatitude:(NSDecimalNumber *)latitude longitude:(NSDecimalNumber *)longitude
{
	SGPoint *point = [[SGPoint alloc] init];
	[point setLatitude:latitude];
	[point setLongitude:longitude];
	
	return point;
}

- (void)dealloc
{
	[latitude release];
	[longitude release];
	[super dealloc];
}

@end
