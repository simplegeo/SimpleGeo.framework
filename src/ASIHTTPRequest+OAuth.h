//
//  ASIHTTPRequest+OAuth.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/23/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"


@interface ASIHTTPRequest (OAuth)

+ (id)requestWithURL:(NSURL *)newURL
         consumerKey:(NSString *)consumerKey
      consumerSecret:(NSString *)consumerSecret;

- (id)initWithURL:(NSURL *)newURL
      consumerKey:(NSString *)consumerKey
   consumerSecret:(NSString *)consumerSecret;

@end
