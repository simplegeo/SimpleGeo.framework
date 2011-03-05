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
#import <YAJL/YAJL.h>
#import "SimpleGeo+Internal.h"
#import "SGFeatureCollection+Private.h"
#import "SGGeometryCollection+Private.h"

#define SIMPLEGEO_API_VERSION_FOR_STORAGE @"0.1"


@implementation SimpleGeo (Storage)

- (void)addOrUpdateRecord:(SGStoredRecord *)record
                  inLayer:(NSString *)layer
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/records/%@/%@.json",
                                                  SIMPLEGEO_API_VERSION_FOR_STORAGE,
                                                  layer,
                                                  [record featureId]]];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];

    [request appendPostData:[[record yajl_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"PUT"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didAddOrUpdateRecord:", @"targetSelector",
                          record, @"record",
                          layer, @"layer",
                          nil]];
    [request startAsynchronous];
}

- (void)addOrUpdateRecords:(NSArray *)records
                   inLayer:(NSString *)layer
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/records/%@.json",
                                                  SIMPLEGEO_API_VERSION_FOR_STORAGE,
                                                  layer]];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    SGFeatureCollection *featureCollection = [SGFeatureCollection featureCollectionWithRecords:records];

    [request appendPostData:[[featureCollection yajl_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didAddOrUpdateRecords:", @"targetSelector",
                          records, @"records",
                          layer, @"layer",
                          nil]];
    [request startAsynchronous];
}

- (void)deleteRecordInLayer:(NSString *)layer
                     withId:(NSString *)id
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/records/%@/%@.json",
                                                  SIMPLEGEO_API_VERSION_FOR_STORAGE,
                                                  layer,
                                                  id]];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setRequestMethod:@"DELETE"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didDeleteRecordInLayer:", @"targetSelector",
                          layer, @"layer",
                          id, @"id",
                          nil]];
    [request startAsynchronous];
}

#pragma mark Methods for querying by point

- (void)getRecordFromLayer:(NSString *)layer
                    withId:(NSString *)id
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/records/%@/%@.json",
                                                  SIMPLEGEO_API_VERSION_FOR_STORAGE,
                                                  layer,
                                                  id]];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setRequestMethod:@"GET"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didLoadRecord:", @"targetSelector",
                          layer, @"layer",
                          id,@"id",
                          nil]];
    [request startAsynchronous];
}

- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
{
    [self getRecordsInLayer:layer
                       near:point
                      count:0];
}

- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
{
    [self getRecordsInLayer:layer
                       near:point
                     radius:radius
                      count:0];
}

- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                    count:(int)count
{
    [self getRecordsInLayer:layer
                       near:point
                     radius:0.0
                      count:count];
}

- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
                    count:(int)count
{
    [self getRecordsInLayer:layer
                       near:point
                     radius:radius
                     cursor:nil
                      count:count];
}
- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   cursor:(NSString *)cursor
{
    [self getRecordsInLayer:layer
                       near:point
                     radius:0.0
                     cursor:cursor];
}

- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
                   cursor:(NSString *)cursor
{
    [self getRecordsInLayer:layer
                       near:point
                     radius:radius
                     cursor:cursor
                      count:0];
}

- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   cursor:(NSString *)cursor
                    count:(int)count
{
    [self getRecordsInLayer:layer
                       near:point
                     radius:0.0
                     cursor:cursor
                      count:count];
}

- (void)getRecordsInLayer:(NSString *)layer
                     near:(SGPoint *)point
                   radius:(double)radius
                   cursor:(NSString *)cursor
                    count:(int)count
{
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/records/%@/nearby/%f,%f.json",
                                 SIMPLEGEO_API_VERSION_FOR_STORAGE,
                                 layer,
                                 [point latitude],
                                 [point longitude]];

    NSMutableArray *queryParams = [NSMutableArray array];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"didLoadRecords:", @"targetSelector",
                                     point, @"point",
                                     layer, @"layer",
                                     nil];

    if (radius > 0.0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%f", @"radius", radius]];
        NSNumber *objRadius = [NSNumber numberWithDouble:radius];
        [userInfo setObject:objRadius
                     forKey:@"radius"];
    }

    if (count > 0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%d", @"limit", count]];
        NSNumber *objCount = [NSNumber numberWithDouble:count];
        [userInfo setObject:objCount
                     forKey:@"limit"];
    }

    if (cursor && ! [cursor isEqual:@""]) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%@", @"cursor", cursor]];
        [userInfo setObject:cursor
                     forKey:@"cursor"];
    }

    if ([queryParams count] > 0) {
        [endpoint appendFormat:@"?%@", [queryParams componentsJoinedByString:@"&"]];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:userInfo];
    [request startAsynchronous];
}

#pragma mark Methods for querying by address

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
{
    [self getRecordsInLayer:layer
                nearAddress:address
                      count:0];
}

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
{
    [self getRecordsInLayer:layer
                nearAddress:address
                     radius:radius
                      count:0];
}

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                    count:(int)count
{
    [self getRecordsInLayer:layer
                nearAddress:address
                     radius:0.0
                      count:count];
}

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
                    count:(int)count
{
        [self getRecordsInLayer:layer
                    nearAddress:address
                         radius:radius
                         cursor:nil
                          count:count];
}

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   cursor:(NSString *)cursor
{
    [self getRecordsInLayer:layer
                nearAddress:address
                     radius:0.0
                     cursor:cursor];
}

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
                   cursor:(NSString *)cursor
{
    [self getRecordsInLayer:layer
                nearAddress:address
                     radius:radius
                     cursor:cursor
                      count:0];
}

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   cursor:(NSString *)cursor
                    count:(int)count
{
    [self getRecordsInLayer:layer
                nearAddress:address
                     radius:0.0
                     cursor:cursor
                      count:count];
}

- (void)getRecordsInLayer:(NSString *)layer
              nearAddress:(NSString *)address
                   radius:(double)radius
                   cursor:(NSString *)cursor
                    count:(int)count
{
    NSMutableString *endpoint  = [NSMutableString stringWithFormat:@"/%@/records/%@/nearby/%@.json",
                                  SIMPLEGEO_API_VERSION_FOR_STORAGE, layer,address];

    NSMutableArray *queryParams = [NSMutableArray array];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"didLoadRecords:", @"targetSelector",
                                     address, @"address",
                                     layer, @"layer",
                                     cursor, @"cursor",
                                     nil];

    if (radius > 0.0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%f", @"radius", radius]];
        NSNumber *objRadius = [NSNumber numberWithDouble:radius];
        [userInfo setObject:objRadius
                     forKey:@"radius"];
    }

    if (count > 0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%d", @"limit", count]];
        NSNumber *objCount = [NSNumber numberWithDouble:count];
        [userInfo setObject:objCount
                     forKey:@"limit"];
    }

    if (cursor&&![cursor isEqualToString:@""]) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%@", @"cursor", cursor]];
        [userInfo setObject:cursor
                     forKey:@"cursor"];
    }

    if ([queryParams count] > 0) {
        [endpoint appendFormat:@"?%@", [queryParams componentsJoinedByString:@"&"]];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:userInfo];
    [request startAsynchronous];
}

#pragma mark Record History

- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer
{
    [self getHistoryForRecordId:recordId
                        inLayer:layer
                          count:0];
}

- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer
                        count:(int)count
{
    [self getHistoryForRecordId:recordId
                        inLayer:layer
                         cursor:nil
                          count:count];
}

- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer
                       cursor:(NSString *)cursor
{
    [self getHistoryForRecordId:recordId
                        inLayer:layer
                         cursor:cursor
                          count:0];
}

- (void)getHistoryForRecordId:(NSString *)recordId
                      inLayer:(NSString *)layer
                       cursor:(NSString *)cursor
                        count:(int)count
{
    NSMutableString *endpoint  = [NSMutableString stringWithFormat:@"/%@/records/%@/%@/history.json",
                                  SIMPLEGEO_API_VERSION_FOR_STORAGE, layer,recordId];
    NSMutableArray *queryParams = [NSMutableArray array];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"didLoadHistory:", @"targetSelector",
                                     recordId, @"recordId",
                                     layer, @"layer",
                                     nil];
    if (count > 0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%d", @"limit", count]];
        NSNumber *objCount = [NSNumber numberWithDouble:count];
        [userInfo setObject:objCount forKey:@"limit"];
    }

    if (cursor && ! [cursor isEqualToString:@""]) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%@", @"cursor", cursor]];
        [userInfo setObject:cursor forKey:@"cursor"];
    }

    if ([queryParams count] > 0) {
        [endpoint appendFormat:@"?%@", [queryParams componentsJoinedByString:@"&"]];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:userInfo];
    [request startAsynchronous];
}

#pragma mark Layer Manipulation

- (void)addOrUpdateLayer:(NSString *)name
                   title:(NSString *)title
             description:(NSString *)description
                  public:(BOOL)public
{
    [self addOrUpdateLayer:name
                     title:title
               description:description
                    public:public
              callbackURLs:[NSArray arrayWithObjects:nil]];
}

- (void)addOrUpdateLayer:(NSString *)name
                   title:(NSString *)title
             description:(NSString *)description
                  public:(BOOL)public
            callbackURLs:(NSArray *)callbackURLs
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/layers/%@.json",
                                                  SIMPLEGEO_API_VERSION_FOR_STORAGE,name]];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
	
    NSMutableDictionary *layerDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
									  name,@"name",
									  title,@"title",
									  description,@"description",
									  callbackURLs,@"callbackURLs",nil];
    if (public) {
        [layerDict setValue:@"true"
                      forKey:@"public"];
    } else {
        [layerDict setValue:@"false"
                      forKey:@"public"];
    }
	
    [request appendPostData:[[layerDict yajl_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"PUT"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"didRequestLoadAddOrUpdateLayer:", @"targetSelector",
                          layerDict, @"layerInfo",
                          nil]];
    [request startAsynchronous];
}

- (void)getLayers
{
    [self getLayersWithCursor:nil];
}

- (void)getLayersWithCursor:(NSString *)cursor
{
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/layers.json",
                                 SIMPLEGEO_API_VERSION_FOR_STORAGE];
    if (cursor) {
		[endpoint appendFormat:@"?%@",[NSString stringWithFormat:@"%@=%@",@"cursor",cursor]];
	}
    NSURL *endpointURL = [self endpointForString:endpoint];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"didRequestLoadLoadLayers:", @"targetSelector",
                          cursor,@"cursor",
                          nil]];
    [request startAsynchronous];
}

- (void)getLayer:(NSString *)layer
{
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/layers/%@.json",
                                 SIMPLEGEO_API_VERSION_FOR_STORAGE,layer];
    NSURL *endpointURL = [self endpointForString:endpoint];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setRequestMethod:@"GET"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didRequestLoadLoadLayer:", @"targetSelector",
                          layer,@"layer",
                          nil]];
    [request startAsynchronous];
}

- (void)deleteLayer:(NSString *)name
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/layers/%@.json",
                                                  SIMPLEGEO_API_VERSION_FOR_STORAGE,name]];
    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setRequestMethod:@"DELETE"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didRequestLoadDeleteLayer:", @"targetSelector",
                          name, @"layer",
                          nil]];
    [request startAsynchronous];
	
}

#pragma mark Dispatcher Methods

- (void)didRequestLoadAddOrUpdateLayer:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didAddOrUpdateLayer:)]) {
        if ([request responseStatusCode] == 404) {
            NSLog(@"Response code = 404");
        } else {
            NSMutableDictionary *layerDict=[[[[request userInfo] objectForKey:@"layerInfo"] retain] autorelease];
            [delegate didAddOrUpdateLayer:[layerDict objectForKey:@"name"]];
		}
	} else {
        NSLog(@"Delegate does not implement didAddOrUpdateLayer:");
	}
}

- (void)didRequestLoadDeleteLayer:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didDeleteLayer:)]) {
        if ([request responseStatusCode] == 404) {
            NSLog(@"Response code = 404");
        } else {
           [delegate didDeleteLayer:[[[[request userInfo] objectForKey:@"layer"] retain] autorelease]];
        }
	} else {
        NSLog(@"Delegate does not implement didDeleteLayer:");
	}
}

- (void)didRequestLoadLoadLayer:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadLayer:withName:)]) {
        if ([request responseStatusCode] == 404) {
            NSLog(@"Response code = 404");
        } else {
            NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
            [delegate didLoadLayer:[[jsonResponse retain] autorelease]
                          withName:[[[[request userInfo] objectForKey:@"layer"] retain] autorelease]];
		}
	} else {
		NSLog(@"Delegate does not implement didLoadLayer:withName:");
	}
}

- (void)didRequestLoadLoadLayers:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadLayers:withCursor:)]) {
        if ([request responseStatusCode] == 404) {
            NSLog(@"Response code = 404");
        } else {
			NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
			[delegate didLoadLayers:[[[jsonResponse objectForKey:@"layers"] retain] autorelease] 
						 withCursor:[[[[request userInfo] objectForKey:@"cursor"] retain] autorelease]];
			
		}
	} else {
		NSLog(@"Delegate does not implement didLoadLayers:withCursor:");
	}
}

- (void)didAddOrUpdateRecord:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didAddOrUpdateRecord:inLayer:)]) {
        if ([request responseStatusCode] == 404) {
            NSLog(@"Response code = 404");
        } else {
            [delegate didAddOrUpdateRecord:[[[[request userInfo] objectForKey:@"record"] retain] autorelease]
                                   inLayer:[[[[request userInfo] objectForKey:@"layer"] retain] autorelease]];
        }
    } else {
        NSLog(@"Delegate does not implement didAddOrUpdateRecord:inLayer:");
    }
}

- (void)didAddOrUpdateRecords:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didAddOrUpdateRecords:inLayer:)]) {
        [delegate didAddOrUpdateRecords:[[[[request userInfo] objectForKey:@"records"] retain] autorelease]
                                inLayer:[[[[request userInfo] objectForKey:@"layer"] retain] autorelease]];
    } else {
        NSLog(@"Delegate does not implement didAddOrUpdateRecords:inLayer:");
    }
}

- (void)didDeleteRecordInLayer:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didDeleteRecordInLayer:withId:)]) {
        [delegate didDeleteRecordInLayer:[[[[request userInfo] objectForKey:@"layer"] retain] autorelease]
                                  withId:[[[[request userInfo] objectForKey:@"id"] retain] autorelease]];
    } else {
        NSLog(@"Delegate does not implement didDeleteRecordInLayer:withId:");
    }
}

- (void)didLoadHistory:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadHistory:forRecordId:forQuery:cursor:)]) {
    NSDictionary *jsonResponse = [[request responseData] yajl_JSON];

    NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[request userInfo]];
    [query removeObjectForKey:@"targetSelector"];

    SGGeometryCollection *history = [SGGeometryCollection geometryCollectionWithDictionary:jsonResponse];
    [delegate didLoadHistory:history
                 forRecordId:[[[[request userInfo] objectForKey:@"recordId"] retain] autorelease]
                    forQuery:query
                      cursor:[[[[request userInfo] objectForKey:@"cursor"] retain] autorelease]];

    } else {
        NSLog(@"Delegate does not implement didLoadHistory:forRecordId:inLayer:cursor:");
    }
}

- (void)didLoadRecord:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadRecord:fromLayer:withId:)]) {
        if ([request responseStatusCode] == 404) {
            NSLog(@"Response code = 404");
        } else {
            NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
            [delegate didLoadRecord:[[jsonResponse retain] autorelease]
                          fromLayer:[[[[request userInfo] objectForKey:@"layer"] retain] autorelease]
                             withId:[[[[request userInfo] objectForKey:@"id"] retain] autorelease]];
        }
    } else {
        NSLog(@"Delegate does not implement didLoadRecord:fromLayer:withId:");
    }
}

- (void)didLoadRecords:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadRecords:forQuery:cursor:)]) {
        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[request userInfo]];
        [query removeObjectForKey:@"targetSelector"];
        NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
        SGFeatureCollection *records = [SGFeatureCollection featureCollectionWithDictionary:jsonResponse];
        [delegate didLoadRecords:records
                        forQuery:query
                          cursor:[[[[request userInfo] objectForKey:@"cursor"] retain] autorelease]];
    } else {
        NSLog(@"Delegate does not implement didLoadRecords:forQuery:cursor:");
    }
}

@end
