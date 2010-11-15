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
	SGAPIClient *client = [[SGAPIClient alloc] init];
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

#pragma mark Common API Calls

- (void)getFeatureWithId:(NSString *)featureId
{
	NSString *path = [NSString stringWithFormat:@"/0.1/features/%@.json", featureId];
	NSURL *endpoint = [NSURL URLWithString:path relativeToURL: url];
	
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

- (NSArray *)getPlacesNear:(SGPoint *)point
{
	return nil;
}

- (NSArray *)getPlacesNear:(SGPoint *)point matching:(NSString *)query
{
	return nil;
}

- (NSArray *)getPlacesNear:(SGPoint *)point matching:(NSString *)query inCategory:(NSString *)category
{
	return nil;
}

#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSLog(@"UserInfo: %@", [request userInfo]);

	// assume that "targetSelector" was set on the request and use that to dispatch appropriately
	SEL targetSelector = NSSelectorFromString([[request userInfo] objectForKey:@"targetSelector"]);
	[self performSelector:targetSelector withObject:request];
}

#pragma mark Dispatcher Methods

- (void)didLoadFeatureJSON:(ASIHTTPRequest *)request
{
	NSLog(@"didLoadFeature!");

	NSString *response = [request responseString];
	NSLog(@"Received response: %@", response);

	NSArray *jsonResponse = [[request responseData] yajl_JSON];
	NSLog(@"JSON response: %@", jsonResponse);

	NSString *featureId = [[request userInfo] objectForKey:@"featureId"];
	SGFeature *feature = [SGFeature featureWithId:featureId];
	[feature setRawBody:response];

	[delegate didLoadFeature:feature withId:featureId];
}

@end
