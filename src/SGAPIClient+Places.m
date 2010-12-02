//
//  SGAPIClient+Places.m
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
#import "SGAPIClient+Places.h"
#import "SGAPIClient+Internal.h"


@implementation SGAPIClient (Places)

- (void)getPlacesNear:(SGPoint *)point
{
    [self getPlacesNear:point matching:nil];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
{
    [self getPlacesNear:point matching:query inCategory:nil];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
{
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/places/%f,%f.json",
                                 SIMPLEGEO_API_VERSION, [point latitude], [point longitude]
                                 ];

    // this is ugly because NSURL doesn't handle setting query parameters well
    if (query && category) {
        [endpoint appendFormat:@"?q=%@&category=%@",
         [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
         [category stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
         ];
    } else if (category) {
        [endpoint appendFormat:@"?category=%@",
         [category stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
         ];
    } else if (query) {
        [endpoint appendFormat:@"?q=%@",
         [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
         ];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];
    NSLog(@"Endpoint: %@", endpoint);

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didLoadPlaces:", @"targetSelector",
                          point, @"point",
                          query, @"matching",
                          category, @"category",
                          nil
                          ]];
    [request startAsynchronous];
}

- (void)updatePlace:(NSString *)handle
               with:(SGFeature *)feature
{
    NSURL *endpointURL = [self endpointForString:[NSString stringWithFormat:@"/%@/places/%@.json",
                                                  SIMPLEGEO_API_VERSION, handle]];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request appendPostData:[[feature yajl_JSONString] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"POST"];
    [request addRequestHeader:@"Content-Type" value:@"application/json"];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didUpdatePlace:", @"targetSelector",
                          handle, @"handle",
                          nil]];
    [request startAsynchronous];
}

#pragma mark Dispatcher Methods

- (void)didLoadPlaces:(ASIHTTPRequest *)request
{
    NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
    SGFeatureCollection *places = [SGFeatureCollection featureCollectionWithDictionary:jsonResponse];

    [delegate didLoadPlaces:[[places retain] autorelease]
                       near:[[[[request userInfo] objectForKey:@"point"] retain] autorelease]
                   matching:[[[[request userInfo] objectForKey:@"matching"] retain] autorelease]
                 inCategory:[[[[request userInfo] objectForKey:@"category"] retain] autorelease]];
}

- (void)didUpdatePlace:(ASIHTTPRequest *)request
{
    NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
    NSString *token = [jsonResponse objectForKey:@"token"];

    [delegate didUpdatePlace:[[[[request userInfo] objectForKey:@"handle"] retain] autorelease]
                       token:[[token retain] autorelease]];
}

@end
