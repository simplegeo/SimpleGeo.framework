//
//  SimpleGeo+Places.h
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

#import "SimpleGeo.h"


/*!
 * Informal delegate protocol for Places functionality.
 */
@interface NSObject (SimpleGeoPlaceDelegate)

/*!
 * Called when a feature was successfully added to the Places database.
 * @param feature Feature that was added.
 * @param handle  Assigned handle.
 * @param url     Canonical URL for the created feature.
 * @param token   Status token.
 */
- (void)didAddPlace:(SGFeature *)feature
             handle:(NSString *)handle
                URL:(NSURL *)url
              token:(NSString *)token;

/*!
 * Called when a place was successfully removed from the Places database.
 * @param handle Handle of deleted place.
 * @param token  Status token.
 */
- (void)didDeletePlace:(NSString *)handle
                 token:(NSString *)token;

/*!
 * Called when a collection of places were loaded from the Places database.
 * @param places Collection of places.
 * @param query  Query information.
 */
- (void)didLoadPlaces:(SGFeatureCollection *)places
             forQuery:(NSDictionary *)query;

/*!
 * Called when a place was successfully updated in the Places database.
 * @param feature Updated feature.
 * @param handle  Handle of updated place.
 * @param token   Status token.
 */
- (void)didUpdatePlace:(SGFeature *)feature
                handle:(NSString *)handle
                 token:(NSString *)token;

@end


/*!
 * Client support for the Places API.
 */
@interface SimpleGeo (Places)

/*!
 * Add a feature to the Places database (SimpleGeo+Places.h).
 * @param feature Feature to add.
 * @param private Whether this addition should be private.
 */
- (void)addPlace:(SGFeature *)feature
         private:(BOOL)private;

/*!
 * Delete a place from the Places database (SimpleGeo+Places.h).
 * @param handle Handle of feature to remove.
 */
- (void)deletePlace:(NSString *)handle;

/*!
 * Find places near a point (SimpleGeo+Places.h).
 * @param point Query point.
 */
- (void)getPlacesNear:(SGPoint *)point;

/*!
 * Find places near an address. SimpleGeo will geocode the address for you.
 * (SimpleGeo+Places.h)
 * @param address Query address.
 */
- (void)getPlacesNearAddress:(NSString *)address;

/*!
 * Find places near a point (SimpleGeo+Places.h).
 * @param point  Query point.
 * @param radius Radius of query (km)
 */
- (void)getPlacesNear:(SGPoint *)point
               within:(double)radius;

/*!
 * Find places near an address. SimpleGeo will geocode the address for you.
 * (SimpleGeo+Places.h)
 * @param address Query address.
 * @param radius  Radius of query (km)
 */
- (void)getPlacesNearAddress:(NSString *)address
                      within:(double)radius;

/*!
 * Find places near a point matching a query string (SimpleGeo+Places.h).
 * @param point Query point.
 * @param query Query string.
 */
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query;

/*!
 * Find places near an address. SimpleGeo will geocode the address for you.
 * (SimpleGeo+Places.h)
 * @param address Query address.
 * @param query   Query string.
 */
- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query;

/*!
 * Find places near a point matching a query string (SimpleGeo+Places.h).
 * @param point  Query point.
 * @param query  Query string.
 * @param radius Radius of query (km)
 */
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
               within:(double)radius;

/*!
 * Find places near an address. SimpleGeo will geocode the address for you.
 * (SimpleGeo+Places.h)
 * @param address Query address.
 * @param query   Query string.
 * @param radius  Radius of query (km)
 */
- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                      within:(double)radius;

/*!
 * Find places near a point matching a query string in a specific category (SimpleGeo+Places.h).
 * @param point    Query point.
 * @param query    Query string.
 * @param category Query category.
 */
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category;

/*!
 * Find places near an address. SimpleGeo will geocode the address for you.
 * (SimpleGeo+Places.h)
 * @param address  Query address.
 * @param query    Query string.
 * @param category Query category.
 */
- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                  inCategory:(NSString *)category;

/*!
 * Find places near a point matching a query string in a specific category (SimpleGeo+Places.h).
 * @param point    Query point.
 * @param query    Query string.
 * @param category Query category.
 * @param radius   Radius of query (km)
 */
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
               within:(double)radius;

/*!
 * Find places near an address. SimpleGeo will geocode the address for you.
 * (SimpleGeo+Places.h)
 * @param address  Query address.
 * @param query    Query string.
 * @param category Query category.
 * @param radius   Radius of query (km)
 */
- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                  inCategory:(NSString *)category
                      within:(double)radius;

/*!
 * Update a place in the Places database (SimpleGeo+Places.h).
 * @param handle Handle of feature to update.
 * @param data   Data to update with (geometry/properties optional).
 * @param private Whether this update should be private.
 */
- (void)updatePlace:(NSString *)handle
               with:(SGFeature *)data
            private:(BOOL)private;

@end
