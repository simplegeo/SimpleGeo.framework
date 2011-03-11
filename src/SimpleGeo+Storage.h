//
//  SimpleGeo+Storage.h
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

#import "SimpleGeo.h"
#import "SGFeatureCollection.h"
#import "SGGeometryCollection.h"
#import "SGStoredRecord.h"


/*!
 * Informal delegate protocol for Storage functionality.
 */
@interface NSObject (SimpleGeoStorageDelegate)

/*!
 * Called when a layer was successfully added or updated.
 *
 * @param name Layer name.
 */
- (void)didAddOrUpdateLayer:(NSString *)name;

/*!
 * Called when a record was successfully added or updated.
 *
 * @param record Record that was added or updated.
 * @param layer  Layer that the record belongs to.
 */
- (void)didAddOrUpdateRecord:(SGStoredRecord *)record
                     inLayer:(NSString *)layer;

/*!
 * Called when records were successfully added or updated.
 *
 * @param records Records that were added or updated.
 * @param layer  Layer that the record belongs to.
 */
- (void)didAddOrUpdateRecords:(NSArray *)records
                      inLayer:(NSString *)layer;

/*!
 * Called when a layer was successfully deleted.
 *
 * @param name Layer name.
 */
- (void)didDeleteLayer:(NSString *)name;

/*!
 * Called when a record was successfully deleted.
 *
 * @param layer Layer that the record was deleted from.
 * @param recordId ID of the record that was deleted.
 */
- (void)didDeleteRecordInLayer:(NSString *)layer
                        withId:(NSString *)recordId;

/*!
 * Called when the location history for a record was loaded.
 *
 * @param history  Record history.
 * @param recordId Record ID.
 * @param query    Query information.
 * @param cursor   Cursor string to retrieve the next set of historical
 *                 locations.
 */
- (void)didLoadHistory:(SGGeometryCollection *)history
           forRecordId:(NSString *)recordId
              forQuery:(NSDictionary *)query
                cursor:(NSString *)cursor;

/*!
 * Called when layer information was loaded.
 *
 * @param layer Layer data.
 * @param name  Layer name.
 */
- (void)didLoadLayer:(NSDictionary *)layer
            withName:(NSString *)name;

/*!
 * Called when information about all available layers was loaded.
 *
 * @param layers List of NSDictionarys containing layer data.
 * @param cursor Cursor string (used for pagination).
 */
- (void)didLoadLayers:(NSArray *)layers
           withCursor:(NSString *)cursor;

/*!
 * Called when a record was loaded.
 *
 * @param record Record that was loaded.
 * @param layer  Layer that the record was loaded from.
 * @param id     Id of the record that was loaded.
 */
- (void)didLoadRecord:(SGStoredRecord *)record
            fromLayer:(NSString *)layer
               withId:(NSString *)id;

/*!
 * Called when records were loaded.
 *
 * @param records Matching records.
 * @param query   Query information.
 * @param cursor  Cursor string to retrieve the next set of records.
 */
- (void)didLoadRecords:(SGFeatureCollection *)records
              forQuery:(NSDictionary *)query
                cursor:(NSString *)cursor;

@end


/*!
 * Client support for the Storage API.
 */
@interface SimpleGeo (Storage)

#pragma mark Record Manipulation

/*!
 * Add or update a record. If a record already exists with the provided ID, it
 * will be updated, otherwise it will be added.
 *
 * @param record Record to add or update. Its `id` property must be set.
 * @param layer  Layer to apply this record to.
 */
- (void)addOrUpdateRecord:(SGStoredRecord *)record
                  inLayer:(NSString *)layer;

/*!
 * Add or update a collection of records.
 *
 * @param records List of records to add or update. Each record must have its
 *                `id` property set.
 * @param layer  Layer to apply these records to.
 */
- (void)addOrUpdateRecords:(NSArray *)records
                   inLayer:(NSString *)layer;

/*!
 * Delete a record.
 *
 * @param layer Layer to delete the record from.
 * @param id    ID of the record to delete.
 */
- (void)deleteRecordInLayer:(NSString *)layer
                     withId:(NSString *)id;

- (void)getRecordFromLayer:(NSString *)layer
                    withId:(NSString *)id;

#pragma mark Methods for querying by point

/*!
 * Get records nearest to a point.
 *
 * @param layer Layer to query.
 * @param point Origin point.
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point;

/*!
 * Get records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param radius Radius (in km) to limit results to.
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius;

/*!
 * Get records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param count  Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                    count:(int)count;

/*!
 * Get records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param radius Radius (in km) to limit results to.
 * @param count  Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
                    count:(int)count;

/*!
 * Get additional records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param cursor Cursor string (used for pagination).
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   cursor:(NSString *)cursor;

/*!
 * Get additional records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param radius Radius (in km) to limit results to.
 * @param cursor Cursor string (used for pagination).
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
                   cursor:(NSString *)cursor;

/*!
 * Get additional records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param radius Radius (in km) to limit results to.
 * @param cursor Cursor string (used for pagination).
 * @param count  Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
                   cursor:(NSString *)cursor
                    count:(int)count;

/*!
 * Get additional records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param cursor Cursor string (used for pagination).
 * @param count  Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   cursor:(NSString *)cursor
                    count:(int)count;

/*!
 * Get additional records nearest to a point.
 *
 * @param layer  Layer to query.
 * @param point  Origin point.
 * @param radius Radius (in km) to limit results to.
 * @param cursor Cursor string (used for pagination).
 * @param count  Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
                   cursor:(NSString *)cursor
                    count:(int)count;

#pragma mark Methods for querying by address

/*!
 * Get records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address;

/*!
 * Get records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param radius  Radius (in km) to limit results to.
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius;

/*!
 * Get records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param count   Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                    count:(int)count;

/*!
 * Get records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param radius  Radius (in km) to limit results to.
 * @param count   Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
                    count:(int)count;

/*!
 * Get additional records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param cursor  Cursor string (used for pagination).
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   cursor:(NSString *)cursor;

/*!
 * Get additional records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param radius  Radius (in km) to limit results to.
 * @param cursor  Cursor string (used for pagination).
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
                   cursor:(NSString *)cursor;

/*!
 * Get additional records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param radius  Radius (in km) to limit results to.
 * @param cursor  Cursor string (used for pagination).
 * @param count   Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
                   cursor:(NSString *)cursor
                    count:(int)count;

/*!
 * Get additional records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param cursor  Cursor string (used for pagination).
 * @param count   Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   cursor:(NSString *)cursor
                    count:(int)count;

/*!
 * Get additional records nearest to an address.
 *
 * @param layer   Layer to query.
 * @param address Address.
 * @param radius  Radius (in km) to limit results to.
 * @param cursor  Cursor string (used for pagination).
 * @param count   Number of results to return.
 */
- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
                   cursor:(NSString *)cursor
                    count:(int)count;

#pragma mark Record History

/*!
 * Get the location history for a record.
 *
 * @param recordId Record ID.
 * @param layer    Layer containing the record.
 */
- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer;

/*!
 * Get the location history for a record.
 *
 * @param recordId Record ID.
 * @param layer    Layer containing the record.
 * @param count    Number of results to return.
 */
- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer
                        count:(int)count;

/*!
 * Get additional location history for a record.
 *
 * @param recordId Record ID.
 * @param layer    Layer containing the record.
 * @param cursor   Cursor string (used for pagination).
 */
- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer
                       cursor:(NSString *)cursor;

/*!
 * Get additional location history for a record.
 *
 * @param recordId Record ID.
 * @param layer    Layer containing the record.
 * @param cursor   Cursor string (used for pagination).
 * @param count    Number of results to return.
 */
- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer
                       cursor:(NSString *)cursor
                        count:(int)count;

#pragma mark Layer Manipulation

/*!
 * Add or update a layer.
 *
 * @param name        Layer name.
 * @param title       Layer title.
 * @param description Layer description.
 * @param public      Whether this layer should be public.
 */
- (void)addOrUpdateLayer:(NSString *)name
                   title:(NSString *)title
             description:(NSString *)description
                  public:(BOOL)public;

/*!
 * Add or update a layer.
 *
 * @param name         Layer name.
 * @param title        Layer title.
 * @param description  Layer description.
 * @param public       Whether this layer should be public.
 * @param callbackURLs List of callback URLs.
 */
- (void)addOrUpdateLayer:(NSString *)name
                   title:(NSString *)title
             description:(NSString *)description
                  public:(BOOL)public
            callbackURLs:(NSArray *)callbackURLs;

/*!
 * Get a list of all available layers.
 */
- (void)getLayers;

/*!
 * Get a list of all available layers.
 *
 * @param cursor Cursor string (used for pagination).
 */
- (void)getLayersWithCursor:(NSString *)cursor;

/*!
 * Get information about a specific layer.
 *
 * @param layer Layer name.
 */
- (void)getLayer:(NSString *)layer;

/*!
 * Delete a layer.
 *
 * @param name Layer name.
 */
- (void)deleteLayer:(NSString *)name;

@end
