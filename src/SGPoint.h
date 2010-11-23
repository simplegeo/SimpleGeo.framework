//
//  SGPoint.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface SGPoint : NSObject
{
    double latitude;
    double longitude;
}

@property double latitude;
@property double longitude;

/**
 * Suitable for "creating" SGPoints from other SGPoints or from NSDictionaries (such as those
 * present in a GeoJSON document).
 */
+ (SGPoint *)pointForGeometry:(id)point;
+ (SGPoint *)pointWithLatitude:(double)latitude
                     longitude:(double) longitude;
- (id)initWithLatitude:(double)latitude
             longitude:(double)longitude;

@end
