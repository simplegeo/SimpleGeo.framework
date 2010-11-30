//
//  SGAPIClient+Internal.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest+OAuth.h"
#import "SGAPIClient+Internal.h"


NSString * const USER_AGENT = @"SimpleGeo/Obj-C 1.0";


@implementation SGAPIClient (Internal)

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
    [request addRequestHeader:@"Accept" value:@"application/json, application/javascript, */*"];

    return [request autorelease];
}

@end
