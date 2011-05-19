//
//  SimpleGeo.m
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
#import "NSArray+SGFeature.h"
#import "SimpleGeo.h"
#import "SimpleGeo+Internal.h"
#import "SGFeature+Private.h"


NSString * const SIMPLEGEO_API_VERSION = @"1.0";
NSString * const SIMPLEGEO_URL_PREFIX = @"http://api.simplegeo.com";
NSString * const SIMPLEGEO_HOSTNAME = @"api.simplegeo.com";

@interface SimpleGeo ()

- (void)requestFailed:(ASIHTTPRequest *)request;

@end


@implementation SimpleGeo

@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize delegate;
@synthesize url;
@synthesize userAgent;
@dynamic    sslEnabled;

#pragma mark Class Methods

+ (SimpleGeo *)clientWithDelegate:(id)delegate
                        consumerKey:(NSString *)consumerKey
                     consumerSecret:(NSString *)consumerSecret
{
    return [SimpleGeo clientWithDelegate:delegate
                             consumerKey:consumerKey
                          consumerSecret:consumerSecret
                                  useSSL:YES];
}

+ (SimpleGeo *)clientWithDelegate:(id)delegate
                      consumerKey:(NSString *)consumerKey
                   consumerSecret:(NSString *)consumerSecret
                           useSSL:(BOOL)doesUseSSL
{
    
    NSString *urlScheme;
    if (doesUseSSL) {
        urlScheme = @"https";
    } else {
        urlScheme = @"http";
    }
    NSString *simpleGeoURL = [NSString stringWithFormat:@"%@://%@",urlScheme,SIMPLEGEO_HOSTNAME];
    return [SimpleGeo clientWithDelegate:delegate
                             consumerKey:consumerKey
                          consumerSecret:consumerSecret
                                     URL:[NSURL URLWithString:simpleGeoURL]];
}

+ (SimpleGeo *)clientWithDelegate:(id)delegate
                        consumerKey:(NSString *)consumerKey
                     consumerSecret:(NSString *)consumerSecret
                                URL:(NSURL *)url
{
    return [[[SimpleGeo alloc] initWithDelegate:delegate
                                    consumerKey:consumerKey
                                 consumerSecret:consumerSecret
                                            URL:url] autorelease];
}

#pragma mark Generic Instance Methods

- (id)init
{
    return [self initWithDelegate:nil
                      consumerKey:nil
                   consumerSecret:nil];
}

- (id)initWithDelegate:(id)aDelegate
           consumerKey:(NSString *)key
        consumerSecret:(NSString *)secret
{
    return [self initWithDelegate:aDelegate
                      consumerKey:key
                   consumerSecret:secret
                              URL:[NSURL URLWithString:[NSString stringWithFormat:@"https://%@",SIMPLEGEO_HOSTNAME]]];
}

- (id)initWithDelegate:(id)aDelegate
           consumerKey:(NSString *)key
        consumerSecret:(NSString *)secret
                   URL:(NSURL *)aURL
{
    self = [super init];

    if (self) {
        delegate = aDelegate;
        consumerKey = [key copy];
        consumerSecret = [secret copy];
        url = [aURL copy];
        NSDictionary *infoDictionary = [[NSBundle bundleForClass:[SimpleGeo class]] infoDictionary];
        userAgent = [[NSString stringWithFormat:@"SimpleGeo/Obj-C %@", [infoDictionary objectForKey:@"CFBundleVersion"]] retain];
    }

    return self;
}

- (BOOL)isSSLEnabled
{
    return [[[[self url] scheme] lowercaseString] isEqualToString:@"https"];
}

- (void)dealloc
{
    [consumerKey release];
    [consumerSecret release];
    [url release];
    [super dealloc];
}

#pragma mark Common API Calls

- (void)getFeatureWithHandle:(NSString *)handle
{
    [self getFeatureWithHandle:handle
                          zoom:-1];
}

- (void)getFeatureWithHandle:(NSString *)handle
                        zoom:(int)zoom
{
    // TODO extract shared boilerplate w/ SimpleGeo+Places.m
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/features/%@.json",
                                 SIMPLEGEO_API_VERSION, handle];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"didRequestFeature:", @"targetSelector",
                                     handle, @"handle",
                                     nil];

    if (zoom >= 0) {
        [endpoint appendFormat:@"?zoom=%i", zoom];
        [userInfo setObject:[NSNumber numberWithInt:zoom]
                     forKey:@"zoom"];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:userInfo];
    [request startAsynchronous];
}

- (void)getCategories
{
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/features/categories.json",
                                 SIMPLEGEO_API_VERSION];

    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     @"didRequestCategories:", @"targetSelector",
                                     nil];
    NSURL *endpointURL = [self endpointForString:endpoint];

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:userInfo];
    [request startAsynchronous];
}

#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    if (([request responseStatusCode] >= 200 && [request responseStatusCode] < 400) ||
        [request responseStatusCode] == 404) {

        // call requestDidFinish first
        if ([delegate respondsToSelector:@selector(requestDidFinish:)]) {
            [delegate requestDidFinish:request];
        }

        // assume that "targetSelector" was set on the request and use that to dispatch appropriately
        SEL targetSelector = NSSelectorFromString([[request userInfo] objectForKey:@"targetSelector"]);
        [self performSelector:targetSelector withObject:request];
    } else {
        // consider non-2xx, 3xx, or 404s to be failures

        if ([request responseStatusCode] == 400) {
            NSLog(@"Bad request. Please double-check your OAuth key and secret.");
        }

        [self requestFailed:request];
    }
    
    [request setDelegate:nil];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request failed: %@", [request error]);

    // TODO how can clients identify which request failed that they queued?
    if ([delegate respondsToSelector:@selector(requestDidFail:)]) {
        [delegate requestDidFail:request];
    }
    
    [request setDelegate:nil];
}

#pragma mark Dispatcher Methods

- (void)didRequestFeature:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadFeature:handle:)]) {
        NSString *handle = [[[[request userInfo] objectForKey:@"handle"] retain] autorelease];

        if ([request responseStatusCode] == 404) {
            [delegate didLoadFeature:nil
                              handle:handle];
        } else {
            NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
            SGFeature *feature = [SGFeature featureWithId:handle
                                               dictionary:jsonResponse];

            [delegate didLoadFeature:feature
                              handle:handle];
        }
    }
}

- (void)didRequestCategories:(ASIHTTPRequest *)request
{
    if ([delegate respondsToSelector:@selector(didLoadCategories:)]) {
        NSArray *jsonResponse = [[request responseData] yajl_JSON];
        [delegate didLoadCategories:jsonResponse];
    }
}

@end
