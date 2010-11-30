//
//  SGAPIClient+Internal.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGAPIClient.h"


@interface SGAPIClient (Internal)

- (NSURL *)endpointForString:(NSString *)path;
- (ASIHTTPRequest *)requestWithURL:(NSURL *)aURL;

@end