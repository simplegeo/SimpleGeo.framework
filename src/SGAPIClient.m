//
//  SGAPIClient.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <YAJL/YAJL.h>
#import "SGAPIClient.h"
#import "NSArray+SGFeature.h"
#import "ASIHTTPRequest+OAuth.h"


NSString * const SIMPLEGEO_URL_PREFIX = @"http://api.simplegeo.com/";
NSString * const SIMPLEGEO_API_VERSION = @"0.1";
NSString * const USER_AGENT = @"SimpleGeo/Obj-C 1.0";


@implementation SGAPIClient

@synthesize consumerKey;
@synthesize consumerSecret;
@synthesize delegate;
@synthesize url;

#pragma mark Class Methods

+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate
                        consumerKey:(NSString *)consumerKey
                     consumerSecret:(NSString *)consumerSecret
{
    return [SGAPIClient clientWithDelegate:delegate
                               consumerKey:consumerKey
                            consumerSecret:consumerSecret
                                       URL:[NSURL URLWithString:SIMPLEGEO_URL_PREFIX]];
}

+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate
                        consumerKey:(NSString *)consumerKey
                     consumerSecret:(NSString *)consumerSecret
                                URL:(NSURL *)url
{
    return [[[SGAPIClient alloc] initWithDelegate:delegate
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

- (id)initWithDelegate:(id<SGAPIClientDelegate>)_delegate
           consumerKey:(NSString *)key
        consumerSecret:(NSString *)secret
{
    return [self initWithDelegate:_delegate
                      consumerKey:key
                   consumerSecret:secret
                              URL:[NSURL URLWithString:SIMPLEGEO_URL_PREFIX]];
}

- (id)initWithDelegate:(id<SGAPIClientDelegate>)_delegate
           consumerKey:(NSString *)key
        consumerSecret:(NSString *)secret
                   URL:(NSURL *)_url
{
    self = [super init];

    if (self) {
        delegate = [_delegate retain];
        consumerKey = [key retain];
        consumerSecret = [secret retain];
        url = [_url retain];
    }

    return self;
}


- (void) dealloc
{
    [delegate release];
    [url release];
    [super dealloc];
}

#pragma mark Utility Methods

- (NSURL *)endpointForString:(NSString *)path
{
    return [[[NSURL alloc] initWithString:path relativeToURL:url] autorelease];
}

- (ASIHTTPRequest *)requestWithURL:(NSURL *)aURL
{
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:aURL
                                                      consumerKey:consumerKey
                                                   consumerSecret:consumerSecret];
    [request setDelegate:self];
    [request addRequestHeader:@"User-Agent" value:USER_AGENT];

    return [request autorelease];
}

#pragma mark Common API Calls

- (void)getFeatureWithId:(NSString *)featureId
{
    NSURL *endpoint = [self endpointForString:
                       [NSString stringWithFormat:@"/%@/features/%@.json",
                        SIMPLEGEO_API_VERSION, featureId]];

    ASIHTTPRequest *request = [self requestWithURL:endpoint];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                            @"didLoadFeatureJSON:", @"targetSelector",
                            featureId, @"featureId",
                            nil
                          ]];
    [request startAsynchronous];
}

#pragma mark Places API Calls

- (void)getPlacesNear:(SGPoint *)point
{
    [self getPlacesNear:point matching:nil];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
{
    NSURL *endpoint;

    if (query) {
        endpoint = [self endpointForString:
                    [NSString stringWithFormat:@"/%@/places/%f,%f/search.json?q=%@",
                     SIMPLEGEO_API_VERSION, [point latitude], [point longitude],
                     [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]
                    ];
    } else {
        endpoint = [self endpointForString:
                    [NSString stringWithFormat:@"/%@/places/%f,%f/search.json",
                     SIMPLEGEO_API_VERSION, [point latitude], [point longitude]]
                    ];
    }

    NSLog(@"Endpoint: %@", endpoint);

    ASIHTTPRequest *request = [self requestWithURL:endpoint];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didLoadPlacesJSON:", @"targetSelector",
                          point, @"point",
                          query, @"matching",
                          nil
                          ]];
    [request startAsynchronous];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
{
}

#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSLog(@"request finished: %i", [request responseStatusCode]);
    NSLog(@"body: %@", [request responseString]);

    if (([request responseStatusCode] >= 200 && [request responseStatusCode < 400]) ||
        [request responseStatusCode] == 404) {

        // call requestDidFinish first
        [delegate requestDidFinish:[[request retain] autorelease]];

        // assume that "targetSelector" was set on the request and use that to dispatch appropriately
        SEL targetSelector = NSSelectorFromString([[request userInfo] objectForKey:@"targetSelector"]);
        [self performSelector:targetSelector withObject:request];
    } else {
        // consider non-2xx, 3xx, or 404s to be failures
        [self requestFailed:[[request retain] autorelease]];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"Request failed: %@", [request error]);

    // TODO how can clients identify which request failed that they queued?
    [delegate requestDidFail:[[request retain] autorelease]];
}

#pragma mark Dispatcher Methods

- (void)didLoadFeatureJSON:(ASIHTTPRequest *)request
{
    NSString *featureId = [[request userInfo] objectForKey:@"featureId"];

    if ([request responseStatusCode] == 404) {
        [delegate didLoadFeature:nil
                          withId:[[featureId retain] autorelease]];
    } else {
        NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
        SGFeature *feature = [SGFeature featureWithId:featureId
                                                 data:jsonResponse
                                              rawBody:[request responseString]];

        [delegate didLoadFeature:[[feature retain] autorelease]
                          withId:[[featureId retain] autorelease]];
    }
}

- (void)didLoadPlacesJSON:(ASIHTTPRequest *)request
{
    NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
    SGPoint *point = [[request userInfo] objectForKey:@"point"];
    NSString *matching = [[request userInfo] objectForKey:@"matching"];

    SGFeatureCollection *places = [SGFeatureCollection featureCollectionWithDictionary:jsonResponse];

    if (matching) {
        [delegate didLoadPlaces:[[places retain] autorelease]
                           near:[[point retain] autorelease]
                       matching:[[matching retain] autorelease]];
    } else {
        [delegate didLoadPlaces:[[places retain] autorelease]
                           near:[[point retain] autorelease]];
    }
}

@end
