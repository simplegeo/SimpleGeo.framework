//
//  SimpleGeo.m
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

#import "SimpleGeo.h"
#import "SimpleGeo+Internal.h"
#import "SGPreprocessorMacros.h"

@implementation SimpleGeo

@synthesize storageVersion, contextVersion, placesVersion, apiURL;

#pragma mark -
#pragma mark Instantiation

+ (SimpleGeo *)clientWithConsumerKey:(NSString *)key
                      consumerSecret:(NSString *)secret
{
    SimpleGeo *client = [[SimpleGeo alloc] initWithConsumerKey:key consumerSecret:secret];
    [client setStorageVersion:@"0.1"]; // Default Storage version
    [client setContextVersion:@"1.0"]; // Default Context version
    [client setPlacesVersion:@"1.2"]; // Default Places version
    [client setApiURL:@"https://api.simplegeo.com"];
    return SG_AUTORELEASE(client);
}

#pragma mark -
#pragma mark Requests

- (void)getCategoriesWithCallback:(SGCallback *)callback
{    
    
    [self sendHTTPRequest:@"GET"
                   toFile:@"/features/categories"
               withParams:nil
                  version:self.contextVersion
                 callback:callback];
}

#pragma mark -
#pragma mark Helpers

- (NSString *)baseEndpointForQuery:(SGQuery *)query
{
    if (query.point) return [NSString stringWithFormat:@"%f,%f",
                             query.point.latitude,
                             query.point.longitude];
    else if (query.envelope) return [NSString stringWithFormat:@"%f,%f",
                                     [query.envelope.center latitude],
                                     [query.envelope.center longitude]];
    else if (query.address) return [NSString stringWithFormat:@"address"];
    else return [NSString stringWithFormat:@"search"];
}

- (void)sendHTTPRequest:(NSString *)type
                 toFile:(NSString *)file
             withParams:(id)params 
                version:(NSString *)version
               callback:(SGCallback *)callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@%@.json", 
                           self.apiURL, version, 
                           [file stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding], nil];

    [self sendHTTPRequest:type
                    toURL:[NSURL URLWithString:urlString]
               withParams:params 
                 callback:callback];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    SG_RELEASE(storageVersion);
    SG_RELEASE(placesVersion);
    SG_RELEASE(contextVersion);
    SG_RELEASE(apiURL);
    [super dealloc];
}

@end
