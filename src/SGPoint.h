//
//  SGPoint.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface SGPoint : NSObject
{
	NSDecimalNumber* latitude;
	NSDecimalNumber* longitude;
}

@property (retain) NSDecimalNumber* latitude;
@property (retain) NSDecimalNumber* longitude;

+ (SGPoint *)pointWithLatitude:(NSDecimalNumber *)latitude longitude:(NSDecimalNumber *) longitude;

@end
