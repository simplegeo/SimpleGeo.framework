//
//  SGStoredRecord.h
//  SimpleGeo.framework
//
//  Copyright (c) 2011, SimpleGeo Inc.
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

#import "SGGeoObject.h"
@class SGPoint;

/**
 * An SGStoredRecord object represents a record in a SimpleGeo Storage layer.
 * Like any SGGeoObject, a SGStoredRecord object stores a geometry (specifically, a point) and a properties dictionary.
 * A SGStoredRecord object also stores the name of its associated layer and a creation date.
 * If the SGStoredRecord originated from an API query response, it will also store a distance value (its distance from the query point).
 */
@interface SGStoredRecord : SGGeoObject
{
    @private
    // required
    NSString *layer;
    // optional
    NSDate *created;
    // from API
    NSDictionary *layerLink;
}

/// Record location
@property (nonatomic, readonly) SGPoint *point;

/// Layer name
@property (nonatomic, retain) NSString *layer;

/// Record timestamp
@property (nonatomic, retain) NSDate *created;

/// API URL for the record layer.
// Only present if the record originated from an API request
@property (nonatomic, readonly) NSDictionary *layerLink;

#pragma mark -
#pragma mark Instantiation

/**
 * Create an SGStoredRecord with an ID, point, and layer
 * @param identifier    Record ID
 * @param point         Record location
 * @param layerName     Record layer
 */
+ (SGStoredRecord *)recordWithID:(NSString *)identifier
                           point:(SGPoint *)point
                           layer:(NSString *)layerName;

/**
 * Create an SGStoredRecord from a dictionary that
 * abides by the GeoJSON Feature specification.
 * Note: geoJSON Feature must contain a "layer"
 * key and value in the property dictionary
 * @param geoJSONFeature    Feature dictionary
 */
+ (SGStoredRecord *)recordWithGeoJSON:(NSDictionary *)geoJSONFeature;

/**
 * Construct an SGStoredRecord with an ID, point, and layer
 * @param identifier    Record ID
 * @param point         Record location
 * @param layerName     Record layer
 */
- (id)initWithID:(NSString *)identifier
           point:(SGPoint *)point
           layer:(NSString *)layerName;

@end
