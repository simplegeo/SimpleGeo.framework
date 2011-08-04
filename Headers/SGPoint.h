//
//  SGPoint.h
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

#import "SGGeometry.h"
#import "SGPolygon.h"
#import "SGMultiPolygon.h"

/**
 * An SGPoint object stores information about a geometric coordinate.
 * In addition to latitude and longitude, an SGPoint object may store an associated date
 * if it originates from a SimpleGeo Storage _record history request._
 */
@interface SGPoint : SGGeometry
{
    @private
    double latitude;
    double longitude;
    NSDate *created;
}

/// Latitude (y coordinate)
@property (nonatomic, assign) double latitude;

/// Longitude (x coordinate)
@property (nonatomic, assign) double longitude;

/// Date created
@property (nonatomic, retain) NSDate *created;

#pragma mark -
#pragma mark Instantiation

/**
 * Create a point from a pair of coordinates
 * @param latitude Latitude
 * @param longitude Longitude
 */
+ (SGPoint *)pointWithLat:(double)latitude
                      lon:(double)longitude;

/**
 * Construct a point from a pair of coordinates
 * @param latitude Latitude
 * @param longitude Longitude
 */
- (id)initWithLat:(double)latitude
              lon:(double)longitude;

@end