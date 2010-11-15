//
//  SGAPIClient.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

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

#pragma mark ASIHTTPRequest Delegate Methods

- (void)requestFinished:(ASIHTTPRequest *)request
{
	NSString *response = [request responseString];
	NSLog(@"Received response: %@", response);
	NSLog(@"UserInfo: %@", [request userInfo]);
	
	// TODO figure out what kind of request this was and send it to an appropriate delegate
	NSString *featureId = [[request userInfo] objectForKey:@"featureId"];
	SGFeature *feature = [SGFeature featureWithId:featureId];
	[feature setRawBody:response];
	
	[delegate didLoadFeature:feature withId:featureId];
}


#pragma mark Common API Calls

- (void)getFeatureWithId:(NSString *)featureId
{
	NSString *path = [NSString stringWithFormat:@"/0.1/features/%@.json", featureId];
	NSURL *endpoint = [NSURL URLWithString:path relativeToURL: url];
	
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:endpoint];
	[request setDelegate:self];
	[request setUserInfo:[NSDictionary dictionaryWithObject:featureId forKey:@"featureId"]];
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

@end
