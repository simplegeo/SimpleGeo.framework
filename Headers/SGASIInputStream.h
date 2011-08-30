//
//  SGASIInputStream.h
//  Part of SGASIHTTPRequest -> http://allseeing-i.com/SGASIHTTPRequest
//
//  Created by Ben Copsey on 10/08/2009.
//  Copyright 2009 All-Seeing Interactive. All rights reserved.
//

// !!! NOTE !!!
//
// The content has been modified in order to address
// namespacing issues.
//
// !!! NOTE !!!

#import <Foundation/Foundation.h>

@class SGASIHTTPRequest;

// This is a wrapper for NSInputStream that pretends to be an NSInputStream itself
// Subclassing NSInputStream seems to be tricky, and may involve overriding undocumented methods, so we'll cheat instead.
// It is used by SGASIHTTPRequest whenever we have a request body, and handles measuring and throttling the bandwidth used for uploading

@interface SGASIInputStream : NSObject {
	NSInputStream *stream;
	SGASIHTTPRequest *request;
}
+ (id)inputStreamWithFileAtPath:(NSString *)path request:(SGASIHTTPRequest *)request;
+ (id)inputStreamWithData:(NSData *)data request:(SGASIHTTPRequest *)request;

@property (retain, nonatomic) NSInputStream *stream;
@property (assign, nonatomic) SGASIHTTPRequest *request;
@end
