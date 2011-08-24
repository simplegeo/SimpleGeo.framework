//
//  SimpleGeo+Storage.m
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

#import "SimpleGeo+Storage.h"
#import "SimpleGeo+Internal.h"
#import "SGStorageQuery.h"
#import "NSArray+SGCollection.h"
#import "SGLayer.h"
#import "SGJSONKit.h"
#import "SGPreprocessorMacros.h"

static NSString *storageAPIVersion = @"0.1";

@implementation SimpleGeo (Storage)

#pragma mark -
#pragma mark Record Requests

- (void)getRecord:(NSString *)recordID
          inLayer:(NSString *)layerName
         callback:(SGCallback *)callback
{
    NSString *url = [NSString stringWithFormat:@"/records/%@/%@", layerName, recordID];
    
    [self sendHTTPRequest:@"GET"
                    toFile:url
               withParams:nil
                  version:storageAPIVersion
                 callback:callback];
}

- (void)getRecordsForQuery:(SGStorageQuery *)query
                  callback:(SGCallback *)callback
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:query.address forKey:@"address"];
    [parameters setValue:query.cursor forKey:@"cursor"];
    [parameters setValue:query.sortType forKey:@"order"];
    [parameters setValue:[NSString stringWithFormat:@"%f", query.radius] forKey:@"radius"];
    [parameters setValue:[NSString stringWithFormat:@"%d", query.limit] forKey:@"limit"];
    if (query.startDate) [parameters setValue:[NSString stringWithFormat:@"%f", [query.startDate timeIntervalSince1970]] forKey:@"start"];
    if (query.endDate) [parameters setValue:[NSString stringWithFormat:@"%f", [query.endDate timeIntervalSince1970]] forKey:@"end"];
    if (query.envelope) {
        NSDictionary *geoJSON = [query.envelope asGeoJSON];
        [parameters setValue:[[geoJSON objectForKey:@"bbox"] componentsJoinedByString:@","] forKey:@"bbox"];
    }
    
    NSString *url = [NSString stringWithFormat:@"/records/%@/nearby/%@", query.layer, [self baseEndpointForQuery:query]];

    [self sendHTTPRequest:@"GET"
                   toFile:url
               withParams:parameters
                  version:storageAPIVersion     
                 callback:callback];
}

- (void)getHistoryForRecord:(NSString *)recordID
                    inLayer:(NSString *)layerName
                      limit:(NSNumber *)limit
                     cursor:(NSString *)cursor
                   callback:(SGCallback *)callback
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (limit) [parameters setValue:[NSString stringWithFormat:@"%d", [limit intValue]] forKey:@"limit"];
    [parameters setValue:cursor forKey:@"cursor"];
    
    NSString *url = [NSString stringWithFormat:@"/records/%@/%@/history", layerName, recordID];
    
    [self sendHTTPRequest:@"GET"
                    toFile:url
               withParams:parameters
                  version:storageAPIVersion
                 callback:callback];
}

#pragma mark -
#pragma mark Record Manipulations

- (void)addOrUpdateRecord:(SGStoredRecord *)record
                 callback:(SGCallback *)callback
{
    [self addOrUpdateRecords:[NSArray arrayWithObject:record]
                     inLayer:record.layer
                    callback:callback];
}

- (void)addOrUpdateRecords:(NSArray *)records
                   inLayer:(NSString *)layerName
                  callback:(SGCallback *)callback
{
    NSString *url = [NSString stringWithFormat:@"/records/%@", layerName];
    
    NSDictionary *featureCollection = [records asGeoJSONCollection:GeoJSONCollectionTypeFeatures];
    
    [self sendHTTPRequest:@"POST"
                    toFile:url
               withParams:[featureCollection JSONData]
                  version:storageAPIVersion
                 callback:callback];
}

- (void)deleteRecord:(NSString *)recordID
             inLayer:(NSString *)layerName
            callback:(SGCallback *)callback
{
    NSString *url = [NSString stringWithFormat:@"/records/%@/%@", layerName, recordID];
    
    [self sendHTTPRequest:@"DELETE"
                    toFile:url
               withParams:nil
                  version:storageAPIVersion     
                 callback:callback];
}

#pragma mark -
#pragma mark Layer Requests

- (void)getLayer:(NSString *)layerName
        callback:(SGCallback *)callback
{    
    NSString *url = [NSString stringWithFormat:@"/layers/%@", layerName];
    
    [self sendHTTPRequest:@"GET"
                    toFile:url
               withParams:nil
                  version:storageAPIVersion
                 callback:callback];
}

- (void)getLayersWithCallback:(SGCallback *)callback
{
    [self getLayersWithCursor:nil
                     callback:callback];
}

- (void)getLayersWithCursor:(NSString *)cursor
                   callback:(SGCallback *)callback
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:cursor forKey:@"cursor"];
    
    [self sendHTTPRequest:@"GET"
                    toFile:@"/layers"
               withParams:parameters
                  version:storageAPIVersion
                 callback:callback];
}

#pragma mark -
#pragma mark Layer Manipulations

- (void)addOrUpdateLayer:(SGLayer *)layer
                callback:(SGCallback *)callback
{    
    NSString *url = [NSString stringWithFormat:@"/layers/%@", layer.name];
    
    [self sendHTTPRequest:@"PUT"
                    toFile:url
               withParams:[[layer asDictionary] JSONData]
                  version:storageAPIVersion
                 callback:callback];
}

- (void)deleteLayer:(NSString *)layerName
           callback:(SGCallback *)callback
{
    NSString *url = [NSString stringWithFormat:@"/layers/%@", layerName];
    
    [self sendHTTPRequest:@"DELETE"
                    toFile:url
               withParams:nil
                  version:storageAPIVersion
                 callback:callback];
}

@end

SG_CATEGORY(SimpleGeoStorage)
