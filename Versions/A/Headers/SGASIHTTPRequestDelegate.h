//
//  SGASIHTTPRequestDelegate.h
//  Part of SGASIHTTPRequest -> http://allseeing-i.com/SGASIHTTPRequest
//
//  Created by Ben Copsey on 13/04/2010.
//  Copyright 2010 All-Seeing Interactive. All rights reserved.
//

// !!! NOTE !!!
//
// The content has been modified in order to address
// namespacing issues.
//
// !!! NOTE !!!

@class SGASIHTTPRequest;

@protocol SGASIHTTPRequestDelegate <NSObject>

@optional

// These are the default delegate methods for request status
// You can use different ones by setting didStartSelector / didFinishSelector / didFailSelector
- (void)requestStarted:(SGASIHTTPRequest *)request;
- (void)request:(SGASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders;
- (void)request:(SGASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL;
- (void)requestFinished:(SGASIHTTPRequest *)request;
- (void)requestFailed:(SGASIHTTPRequest *)request;
- (void)requestRedirected:(SGASIHTTPRequest *)request;

// When a delegate implements this method, it is expected to process all incoming data itself
// This means that responseData / responseString / downloadDestinationPath etc are ignored
// You can have the request call a different method by setting didReceiveDataSelector
- (void)request:(SGASIHTTPRequest *)request didReceiveData:(NSData *)data;

// If a delegate implements one of these, it will be asked to supply credentials when none are available
// The delegate can then either restart the request ([request retryUsingSuppliedCredentials]) once credentials have been set
// or cancel it ([request cancelAuthentication])
- (void)authenticationNeededForRequest:(SGASIHTTPRequest *)request;
- (void)proxyAuthenticationNeededForRequest:(SGASIHTTPRequest *)request;

@end
