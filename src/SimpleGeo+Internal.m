//
//  SimpleGeo+Internal.m
//  SimpleGeo.framework
//
//  Copyright (c) 2010, SimpleGeo Inc.
//  All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above copyright
//       notice, this list of conditions and the following disclaimer in the
//       documentation and/or other materials provided with the distribution.
//     * Neither the name of the <organization> nor the
//       names of its contributors may be used to endorse or promote products
//       derived from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
// ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
// DISCLAIMED. IN NO EVENT SHALL <COPYRIGHT HOLDER> BE LIABLE FOR ANY
// DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
// (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
// LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
// ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
// (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

#import "ASIHTTPRequest+OAuth.h"
#import "SimpleGeo+Internal.h"


@implementation SimpleGeo (Internal)

- (NSURL *)endpointForString:(NSString *)path
{
    NSURL *endpoint = [[[NSURL alloc] initWithString:path relativeToURL:url] autorelease];
    NSLog(@"Endpoint: %@", endpoint);
    return endpoint;
}

- (ASIHTTPRequest *)requestWithURL:(NSURL *)aURL
{
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:aURL];
    [request setDelegate:self];
    [request setShouldRedirect:NO];
    [request addRequestHeader:@"User-Agent" value:self.userAgent];
    [request addRequestHeader:@"Accept" value:@"application/json, application/javascript, */*"];
    [request signRequestWithClientIdentifier:consumerKey
                                      secret:consumerSecret
                             tokenIdentifier:nil
                                      secret:nil
                                 usingMethod:ASIOAuthHMAC_SHA1SignatureMethod];

    return request;
}

- (NSDictionary *)markFeature:(SGFeature *)feature
                      private:(BOOL)private
{
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithDictionary:[feature properties]];

    if (private) {
        [properties setValue:@"true"
                      forKey:@"private"];
    } else {
        [properties setValue:@"false"
                      forKey:@"private"];
    }

    NSMutableDictionary *featureDict = [NSMutableDictionary dictionaryWithDictionary:[feature asDictionary]];
    [featureDict setValue:properties
                   forKey:@"properties"];

    return featureDict;
}

- (NSString *)URLEncodedString:(NSString *)string
{

    NSString *result = (NSString *) NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)string,
                                                                                              NULL,
                                                                                              CFSTR("!*'();:@&=+$,/?#[]"),
                                                                                              kCFStringEncodingUTF8));
    return [result autorelease];
}

- (NSString *)URLDecodedString:(NSString *)string
{
    NSString *result = (NSString *) NSMakeCollectable(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                              (CFStringRef)string,
                                                                                                              CFSTR(""),
                                                                                                              kCFStringEncodingUTF8));
    return [result autorelease];
}

@end
