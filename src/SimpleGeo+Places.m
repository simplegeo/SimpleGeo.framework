//
//  SimpleGeo+Places.m
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

#import <YAJL/YAJL.h>
#import "SimpleGeo+Places.h"
#import "SimpleGeo+Internal.h"
#import "SGFeatureCollection+Private.h"


@implementation SimpleGeo (Places)

- (void)addPlace:(SGFeature *)feature
         private:(BOOL)private
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/places",
                                                  SIMPLEGEO_API_VERSION]];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];

    NSDictionary *featureDict = [self markFeature:feature
                                          private:private];

    [request appendPostData:[[featureDict yajl_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didAddPlace:", @"targetSelector",
                          feature, @"feature",
                          [NSNumber numberWithBool:private], @"private",
                          nil]];
    [request startAsynchronous];
}

- (void)deletePlace:(NSString *)handle
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/features/%@.json",
                                                  SIMPLEGEO_API_VERSION, handle]];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setRequestMethod:@"DELETE"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didDeletePlace:", @"targetSelector",
                          handle, @"handle",
                          nil]];
    [request startAsynchronous];
}

- (void)getPlacesNear:(SGPoint *)point
{
    [self getPlacesNear:point
               matching:nil];
}

- (void)getPlacesNear:(SGPoint *)point 
                count:(int)limit
{
    [self getPlacesNear:point
               matching:nil
                  count:limit];
}

- (void)getPlacesNearAddress:(NSString *)address
{
    [self getPlacesNearAddress:address
                      matching:nil];
}

- (void)getPlacesNearAddress:(NSString *)address 
                       count:(int)limit
{
    [self getPlacesNearAddress:address
                      matching:nil
                         count:limit];
}

- (void)getPlacesNear:(SGPoint *)point
               within:(double)radius
{
    [self getPlacesNear:point
               matching:nil
             inCategory:nil
                 within:radius];
}

- (void)getPlacesNear:(SGPoint *)point
               within:(double)radius
                count:(int)limit;
{
    [self getPlacesNear:point
               matching:nil
             inCategory:nil
                 within:radius
                  count:limit];
}

- (void)getPlacesNearAddress:(NSString *)address
                      within:(double)radius
{
    [self getPlacesNearAddress:address
                      matching:nil
                    inCategory:nil
                        within:radius];
}
- (void)getPlacesNearAddress:(NSString *)address
                      within:(double)radius
                       count:(int)limit
{
    [self getPlacesNearAddress:address
                      matching:nil
                    inCategory:nil
                        within:radius
                         count:limit];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
{
    [self getPlacesNear:point
               matching:query
             inCategory:nil
                 within:0.0f];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
                count:(int)limit
{
    [self getPlacesNear:point
               matching:query
             inCategory:nil
                 within:0.0f
                  count:limit];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
{
    [self getPlacesNearAddress:address
                      matching:query
                    inCategory:nil
                        within:0.0f];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                       count:(int)limit
{
    [self getPlacesNearAddress:address
                      matching:query
                    inCategory:nil
                        within:0.0f
                         count:limit];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
               within:(double)radius
{
    [self getPlacesNear:point
               matching:query
             inCategory:nil
                 within:radius];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
               within:(double)radius
                count:(int)limit
{
    [self getPlacesNear:point
               matching:query
             inCategory:nil
                 within:radius
                  count:limit];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                      within:(double)radius
{
    [self getPlacesNearAddress:address
                      matching:query
                    inCategory:nil
                        within:radius];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                      within:(double)radius
                       count:(int)limit
{
    [self getPlacesNearAddress:address
                      matching:query
                    inCategory:nil
                        within:radius
                         count:limit];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
{
    [self getPlacesNear:point
               matching:query
             inCategory:category
                 within:0.0f];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
                count:(int)limit
{
    [self getPlacesNear:point
               matching:query
             inCategory:category
                 within:0.0f
                  count:limit];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                  inCategory:(NSString *)category
{
    [self getPlacesNearAddress:address
                      matching:query
                    inCategory:category
                        within:0.0f];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                  inCategory:(NSString *)category
                       count:(int)limit
{
    [self getPlacesNearAddress:address
                      matching:query
                    inCategory:category
                        within:0.0f
                         count:limit];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
               within:(double)radius
{
    [self getPlacesNear:point 
               matching:query
             inCategory:category
                 within:radius
                  count:0];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
               within:(double)radius
                count:(int)limit
{
    // TODO extract boilerplate
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/places/%f,%f.json",
                                 SIMPLEGEO_API_VERSION, [point latitude], [point longitude]
                                 ];

    NSMutableArray *queryParams = [NSMutableArray array];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        @"didRequestPlaces:", @"targetSelector",
                                        point, @"point",
                                     query, @"matching",
                                     category, @"category",
                                     [NSNumber numberWithDouble:radius], @"radius",
                                     [NSNumber numberWithInt:limit], @"limit",
                                      nil];

    if (query && ! [query isEqual:@""]) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%@", @"q",
                                [self URLEncodedString:query]]];
        [userInfo setObject:query forKey:@"matching"];
    }

    if (category && ! [category isEqual:@""]) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%@", @"category",
                                [self URLEncodedString:category]]];
        [userInfo setObject:category forKey:@"category"];
    }

    if (radius > 0.0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%f", @"radius", radius]];
        NSNumber *objRadius = [NSNumber numberWithDouble:radius];
        [userInfo setObject:objRadius forKey:@"radius"];
    }

	if (limit > 0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%d", @"num", limit]];
        NSNumber *objLimit = [NSNumber numberWithInt:limit];
        [userInfo setObject:objLimit forKey:@"limit"];
	}

    if ([queryParams count] > 0) {
        [endpoint appendFormat:@"?%@", [queryParams componentsJoinedByString:@"&"]];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:userInfo];
    [request startAsynchronous];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                  inCategory:(NSString *)category
                      within:(double)radius
{
	[self getPlacesNearAddress:address
                      matching:query
                    inCategory:category
                        within:radius
                         count:0];
}

- (void)getPlacesNearAddress:(NSString *)address
                    matching:(NSString *)query
                  inCategory:(NSString *)category
                      within:(double)radius
                       count:(int)limit
{
    // TODO extract boilerplate
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/places/address.json",
                                 SIMPLEGEO_API_VERSION];

    NSMutableArray *queryParams = [NSMutableArray array];
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                      @"didRequestPlaces:", @"targetSelector",
                                      address, @"address",
                                      query, @"matching",
                                     category, @"category",
                                     [NSNumber numberWithDouble:radius], @"radius",
                                     [NSNumber numberWithInt:limit], @"limit",
                                      nil];
    if (address && ! [address isEqualToString:@""]) {
         [queryParams addObject:[NSString stringWithFormat:@"%@=%@",@"address",
                                 [self URLEncodedString:address]]];
	}
	
    if (query && ! [query isEqual:@""]) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%@", @"q",
                                [self URLEncodedString:query]]];
        [userInfo setObject:query forKey:@"matching"];
    }

    if (category && ! [category isEqual:@""]) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%@", @"category",
                                [self URLEncodedString:category]]];
        [userInfo setObject:category forKey:@"category"];
    }

    if (radius > 0.0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%f", @"radius", radius]];
        NSNumber *objRadius = [NSNumber numberWithDouble:radius];
        [userInfo setObject:objRadius forKey:@"radius"];
    }
	
	if (limit > 0) {
        [queryParams addObject:[NSString stringWithFormat:@"%@=%d", @"num", limit]];
        NSNumber *objLimit = [NSNumber numberWithInt:limit];
        [userInfo setObject:objLimit forKey:@"limit"];
	}

    if ([queryParams count] > 0) {
        [endpoint appendFormat:@"?%@", [queryParams componentsJoinedByString:@"&"]];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:userInfo];
    [request startAsynchronous];
}

- (void)updatePlace:(NSString *)handle
               with:(SGFeature *)feature
            private:(BOOL)private
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/features/%@.json",
                                                  SIMPLEGEO_API_VERSION, handle]];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];

    NSDictionary *featureDict = [self markFeature:feature
                                          private:private];

    [request appendPostData:[[featureDict yajl_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didUpdatePlace:", @"targetSelector",
                          handle, @"handle",
                          feature, @"feature",
                          [NSNumber numberWithBool:private], @"private",
                          nil]];
    [request startAsynchronous];
}

#pragma mark Dispatcher Methods

- (void)didAddPlace:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didAddPlace:handle:URL:token:)]) {
        NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
        NSURL *placeURL = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",
                                                SIMPLEGEO_HOSTNAME,
                                                [jsonResponse objectForKey:@"uri"]]];

        [delegate didAddPlace:[[[[request userInfo] objectForKey:@"feature"] retain] autorelease]
                       handle:[[[jsonResponse objectForKey:@"id"] retain] autorelease]
                          URL:placeURL
                        token:[[[jsonResponse objectForKey:@"token"] retain] autorelease]];
    } else {
        NSLog(@"Delegate does not implement didAddPlace:handle:URL:token:");
    }
}

- (void)didDeletePlace:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didDeletePlace:token:)]) {
        NSDictionary *jsonResponse = [[request responseData] yajl_JSON];

        [delegate didDeletePlace:[[[[request userInfo] objectForKey:@"handle"] retain] autorelease]
                           token:[[[jsonResponse objectForKey:@"token"] retain] autorelease]];
    } else {
        NSLog(@"Delegate does not implement didDeletePlace:token:");
    }
}

- (void)didRequestPlaces:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadPlaces:forQuery:)]) {
        NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
        SGFeatureCollection *places = [SGFeatureCollection featureCollectionWithDictionary:jsonResponse];

        NSMutableDictionary *query = [NSMutableDictionary dictionaryWithDictionary:[request userInfo]];
        [query removeObjectForKey:@"targetSelector"];

        [delegate didLoadPlaces:places
                       forQuery:query];
    } else {
        NSLog(@"Delegate does not implement didLoadPlaces:forQuery:");
    }
}

- (void)didUpdatePlace:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didUpdatePlace:handle:token:)]) {
        NSDictionary *jsonResponse = [[request responseData] yajl_JSON];

        [delegate didUpdatePlace:[[[[request userInfo] objectForKey:@"feature"] retain] autorelease]
                          handle:[[[[request userInfo] objectForKey:@"handle"] retain] autorelease]
                           token:[[[jsonResponse objectForKey:@"token"] retain] autorelease]];
    } else {
        NSLog(@"Delegate does not implement didUpdatePlace:handle:token:");
    }
}

@end
