//
//  SimpleGeo+Storage.h
//  SimpleGeo.framework
//
//  Copyright (c) 2011, SimpleGeo Inc
//  All rights reserved
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission
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
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE
//

#import "SimpleGeo.h"
@class SGStoredRecord;
@class SGStorageQuery;
@class SGCallback;

/**
 * Client support for Storage API
 */
@interface SimpleGeo (Storage)

#pragma mark -
#pragma mark Record Requests

/**
 * Request a record by ID
 * @param recordID  Record ID
 * @param layerName Layer name
 * @param callback  Request callback
 */
- (void)getRecord:(NSString *)recordID
          inLayer:(NSString *)layerName
         callback:(SGCallback *)callback;

/**
 * Get records matching an SGStorageQuery
 * @param query     Query
 * @param callback  Request callback
 */
- (void)getRecordsForQuery:(SGStorageQuery *)query
                  callback:(SGCallback *)callback;

/**
 * Get location history for a record
 * @param recordID  Record ID
 * @param layerName Layer name
 * @param limit     Number of results to return
 * @param cursor    Cursor string (used for pagination)
 * @param callback  Request callback
 */
- (void)getHistoryForRecord:(NSString *)recordID
                    inLayer:(NSString *)layerName
                      limit:(NSNumber *)limit
                     cursor:(NSString *)cursor
                   callback:(SGCallback *)callback;

#pragma mark -
#pragma mark Record Manipulations

/**
 * Add or update a record; If a record already exists with the provided ID, it
 * will be updated, otherwise it will be added
 * @param record    Record to add or update
 * @param callback  Request callback
 */
- (void)addOrUpdateRecord:(SGStoredRecord *)record
                 callback:(SGCallback *)callback;

/**
 * Add or update a collection of records
 * @param records   List of records to add or update
 * @param layerName Layer name
 * @param callback  Request callback
 */
- (void)addOrUpdateRecords:(NSArray *)records
                   inLayer:(NSString *)layerName
                  callback:(SGCallback *)callback;

/**
 * Delete a record
 * @param recordID  Record ID
 * @param layerName Layer name
 * @param callback  Request callback
 */
- (void)deleteRecord:(NSString *)recordID
             inLayer:(NSString *)layerName
            callback:(SGCallback *)callback;

#pragma mark -
#pragma mark Layer Requests

/**
 * Get information about a specific layer
 * @param layerName Layer name
 * @param callback  Request callback
 */
- (void)getLayer:(NSString *)layerName
        callback:(SGCallback *)callback;

/**
 * Get a list of all available layers
 * @param callback  Request callback
 */
- (void)getLayersWithCallback:(SGCallback *)callback;

/**
 * Get a list of all available layers
 * @param cursor    Cursor string (used for pagination)
 * @param callback  Request callback
 */
- (void)getLayersWithCursor:(NSString *)cursor
                   callback:(SGCallback *)callback;

#pragma mark -
#pragma mark Layer Manipulations

/**
 * Add or update a layer
 * @param layer     Layer
 * @param callback  Request callback
 */
- (void)addOrUpdateLayer:(SGLayer *)layer
                callback:(SGCallback *)callback;

/**
 * Delete a layer
 * @param layerName Layer name
 * @param callback  Request callback
 */
- (void)deleteLayer:(NSString *)layerName
           callback:(SGCallback *)callback;

@end
