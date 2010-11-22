//
//  SGAPIClient.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <YAJL/YAJL.h>
#import "SGAPIClient.h"


NSString * const SIMPLEGEO_URL_PREFIX = @"http://api.simplegeo.com/";


@implementation SGAPIClient

@synthesize delegate;
@synthesize url;

#pragma mark Class Methods

+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate
{
    return [SGAPIClient clientWithDelegate:delegate URL:[NSURL URLWithString:SIMPLEGEO_URL_PREFIX]];
}

+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate URL:(NSURL *)url
{
    SGAPIClient *client = [[[SGAPIClient alloc] init] autorelease];
    [client setDelegate:delegate];
    [client setUrl:url];

    return client;
}

#pragma mark Generic Instance Methods

- (void) dealloc
{
    [delegate release];
    [url release];
    [super dealloc];
}

#pragma mark Utility Methods

-(NSURL *)endpointForString:(NSString *)path
{
    return [NSURL URLWithString:path relativeToURL:url];
}

#pragma mark Common API Calls

- (void)getFeatureWithId:(NSString *)featureId
{
    NSURL *endpoint = [self endpointForString:
                       [NSString stringWithFormat:@"/0.1/features/%@.json", featureId]];

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:endpoint];
    [request setDelegate:self];
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

- (void)getPlacesNear:(SGPoint *)point matching:(NSString *)query
{
    // TODO omit q= if query is nil
    NSURL *endpoint = [self endpointForString:
                       [NSString stringWithFormat:@"/0.1/places/%@,%@/search.json?q=%@",
                        [point latitude], [point longitude],
                        [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]
                       ];

    NSLog(@"Endpoint: %@", endpoint);

    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:endpoint];
    [request setDelegate:self];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didLoadPlacesJSON:", @"targetSelector",
                          point, @"point",
                          query, @"matching",
                          nil
                          ]];
    [request startAsynchronous];
}

- (void)getPlacesNear:(SGPoint *)point matching:(NSString *)query inCategory:(NSString *)category
{
}

#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
    // TODO check response status code

    // assume that "targetSelector" was set on the request and use that to dispatch appropriately
    SEL targetSelector = NSSelectorFromString([[request userInfo] objectForKey:@"targetSelector"]);
    [self performSelector:targetSelector withObject:request];
}

#pragma mark Dispatcher Methods

- (void)didLoadFeatureJSON:(ASIHTTPRequest *)request
{
    NSDictionary *jsonResponse = [[request responseData] yajl_JSON];
    NSString *featureId = [[request userInfo] objectForKey:@"featureId"];

    SGFeature *feature = [SGFeature featureWithId:featureId
                                             data:jsonResponse
                                          rawBody:[request responseString]];

    [delegate didLoadFeature:feature withId:featureId];
}

- (void)didLoadPlacesJSON:(ASIHTTPRequest *)request
{
    NSArray *jsonResponse = [[request responseData] yajl_JSON];
    SGPoint *point = [[request userInfo] objectForKey:@"point"];
    NSString *matching = [[request userInfo] objectForKey:@"matching"];

    NSArray *places = [NSArray arrayWithFeatures:jsonResponse];

    if (matching) {
        [delegate didLoadPlaces:places near:point matching:matching];
    } else {
        [delegate didLoadPlaces:places near:point];
    }
}

@end
