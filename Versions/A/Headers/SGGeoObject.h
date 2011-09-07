//
//  SGGeoObject.h
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

/**
 * An SGGeoObject represents a basic geo object.
 * SGGeoObjects store a geometry (SGPoint, SGPolygon, SGMultiPolygon, or SGEnvelope) and a property dictionary.
 * An example of a very basic geo object is an intersection.
 */
@interface SGGeoObject : NSObject
{
    @private
    // required
    SGGeometry *geometry;
    // optional
    NSString *identifier;
    NSMutableDictionary *properties;
    // from request
    NSNumber *distance;
}

/// Object geometry
@property (nonatomic, readonly) SGGeometry *geometry;

/// Object ID
@property (nonatomic, retain) NSString *identifier;

/// Object properties
@property (nonatomic, retain, setter = setMutableProperties:) NSMutableDictionary *properties;

/// Distance (in meters) from the query point.
/// Valid for SGGeoObjects with point geometry
/// Only present if the Object originated from a nearby request
@property (nonatomic, readonly) NSNumber *distance;

#pragma mark -
#pragma mark Instantiation

/**
 * Construct an SGGeoObject with a geometry
 * @param geometry          Object geometry
 */
- (id)initWithGeometry:(SGGeometry *)geometry;

/**
 * Construct an SGGeoObject from a dictionary that
 * abides by the GeoJSON Feature specification
 * @param geoJSONFeature    Feature dictionary
 */
- (id)initWithGeoJSON:(NSDictionary *)geoJSONFeature;

#pragma mark -
#pragma mark Convenience

/**
 * Set properties from an immutable properties dictionary
 * @param properties        Feature properties
 */
- (void)setProperties:(NSDictionary *)properties;

/**
 * Dictionary representation of the SGGeoObject that
 * conforms to the geoJSON Feature specification
 */
- (NSDictionary *)asGeoJSON;

@end
