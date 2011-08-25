//
//  SGEnvelope.h
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
@class SGPoint;

/**
 * An SGEnvelope object represents a geometric envelope, or bounding box.
 * Envelopes may be used to create a Context or Storage query.
 * An Envelope may also be useful when displaying results on a map since it can represent a map's visible bounds.
 */
@interface SGEnvelope : SGGeometry <SGRegionGeometry>
{
    @private
    double north;
    double west;
    double south;
    double east;
}

/// Northern latitude (top coordinate)
@property (nonatomic, assign) double north;

/// Southern latitude (bottom coordinate)
@property (nonatomic, assign) double south;

/// Western longitude (left coordinate)
@property (nonatomic, assign) double west;

/// Eastern longitude (right coordinate)
@property (nonatomic, assign) double east;

/// Center coordinate
@property (nonatomic, readonly) SGPoint *center;

#pragma mark -
#pragma mark Instantiation

/**
 * Create a bounding box from edge coordinates
 * @param northernLat   Northern latitude
 * @param westernLon    Western longitude
 * @param southernLat   Southern latitude
 * @param easternLon    Eastern longitude
 */
+ (SGEnvelope *)envelopeWithNorth:(double)northernLat
                             west:(double)westernLon
                            south:(double)southernLat
                             east:(double)easternLon;

/**
 * Construct a bounding box from edge coordinates
 * @param northernLat   Northern latitude
 * @param westernLon    Western longitude
 * @param southernLat   Southern latitude
 * @param easternLon    Eastern longitude
 */
- (id)initWithWithNorth:(double)northernLat
                   west:(double)westernLon
                  south:(double)southernLat
                   east:(double)easternLon;

@end
