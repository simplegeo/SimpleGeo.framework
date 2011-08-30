//
//  SGASIDownloadCache.h
//  Part of SGASIHTTPRequest -> http://allseeing-i.com/SGASIHTTPRequest
//
//  Created by Ben Copsey on 01/05/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//

// !!! NOTE !!!
//
// The content has been modified in order to address
// namespacing issues.
//
// !!! NOTE !!!

#import <Foundation/Foundation.h>
#import "SGASICacheDelegate.h"

@interface SGASIDownloadCache : NSObject <SGASICacheDelegate> {
	
	// The default cache policy for this cache
	// Requests that store data in the cache will use this cache policy if their cache policy is set to SGASIUseDefaultCachePolicy
	// Defaults to SGASIAskServerIfModifiedWhenStaleCachePolicy
	SGASICachePolicy defaultCachePolicy;
	
	// The directory in which cached data will be stored
	// Defaults to a directory called 'SGASIHTTPRequestCache' in the temporary directory
	NSString *storagePath;
	
	// Mediates access to the cache
	NSRecursiveLock *accessLock;
	
	// When YES, the cache will look for cache-control / pragma: no-cache headers, and won't reuse store responses if it finds them
	BOOL shouldRespectCacheControlHeaders;
}

// Returns a static instance of an SGASIDownloadCache
// In most circumstances, it will make sense to use this as a global cache, rather than creating your own cache
// To make SGASIHTTPRequests use it automatically, use [SGASIHTTPRequest setDefaultCache:[SGASIDownloadCache sharedCache]];
+ (id)sharedCache;

// A helper function that determines if the server has requested data should not be cached by looking at the request's response headers
+ (BOOL)serverAllowsResponseCachingForRequest:(SGASIHTTPRequest *)request;

@property (assign, nonatomic) SGASICachePolicy defaultCachePolicy;
@property (retain, nonatomic) NSString *storagePath;
@property (retain) NSRecursiveLock *accessLock;
@property (assign) BOOL shouldRespectCacheControlHeaders;
@end
