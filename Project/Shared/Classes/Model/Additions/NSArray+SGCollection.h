//
//  NSArray+SGGeoJSON.h
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

#import "SGTypes.h"

/**
 * This category on NSArray allows an NSArray to be created from a [GeoJSON Collection.](http://geojson.org/geojson-spec.html#feature-collection-objects)
 * It also allows a GeoJSON Collection to be created from an NSArray.
 * Call *arrayWithSGCollection:* to transform a GeoJSON Collection of
 * SimpleGeo places or records into an array of SGPlaces or SGStoredRecords.
 */
@interface NSArray (SGCollection)

#pragma mark -
#pragma mark SG GeoJSON Collection -> SGGeoObjects

typedef enum {
    SGCollectionTypePoints,
    SGCollectionTypeObjects,
    SGCollectionTypeFeatures,
    SGCollectionTypePlaces,
    SGCollectionTypeRecords,
    SGCollectionTypeLayers,
} SGCollectionType;

/**
 * Create an array of SGGeometry or SGFeature objects from
 * a GeoJSON Collection returned from SimpleGeo
 * @param collection        GeoJSON Collection
 * @param collectionType    Collection type
 */
+ (NSArray *)arrayWithSGCollection:(NSDictionary *)collection
                              type:(SGCollectionType)collectionType;

/**
 * Construct an array of SGGeometry or SGFeature objects from
 * a GeoJSON Collection returned from SimpleGeo
 * @param collection        GeoJSON Collection
 * @param collectionType    Collection type
 */
- (id)initWithSGCollection:(NSDictionary *)collection
                      type:(SGCollectionType)collectionType;

#pragma mark -
#pragma mark SGGeoObjects -> GeoJSONCollection

typedef enum {
    GeoJSONCollectionTypeGeometries,
    GeoJSONCollectionTypeFeatures,
} GeoJSONCollectionType;

/**
 * Create a GeoJSON Collection dictionary from an array
 * of objects that respond to *asGeoJSON*
 * @param collectionType    Collection type
 */
- (NSDictionary *)asGeoJSONCollection:(GeoJSONCollectionType)collectionType;

@end
