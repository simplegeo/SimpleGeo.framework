//
//  SimpleGeo+Places.m
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

#import "SimpleGeo+Places.h"
#import "SimpleGeo+Internal.h"
#import "SGPlacesQuery.h"
#import "SGPlace.h"
#import "JSONKit.h"

@implementation SimpleGeo (Places)

#pragma mark -
#pragma mark Requests

- (void)getPlacesForQuery:(SGPlacesQuery *)query
                 callback:(SGCallback *)callback
{  
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:query.address forKey:@"address"];
    [parameters setValue:query.searchString forKey:@"q"];
    [parameters setValue:query.categories forKey:@"category"];
    [parameters setValue:[NSString stringWithFormat:@"%f", query.radius] forKey:@"radius"];
    [parameters setValue:[NSString stringWithFormat:@"%d", query.limit] forKey:@"num"];
                  
    [self sendHTTPRequest:@"GET"
                    toFile:[NSString stringWithFormat:@"/places/%@",[self baseEndpointForQuery:query]]
             withParams:parameters
               callback:callback];
}

#pragma mark -
#pragma mark Manipulations

- (void)addPlace:(SGPlace *)place
        callback:(SGCallback *)callback
{
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/places", 
                           SG_MAIN_URL, SG_API_VERSION, nil];
    
    [self sendHTTPRequest:@"POST"
                    toURL:[NSURL URLWithString:urlString]
               withParams:[[place asGeoJSON] JSONData]
                 callback:callback];    
}

- (void)updatePlace:(NSString *)identifier
          withPlace:(SGPlace *)place
           callback:(SGCallback *)callback
{
    [self sendHTTPRequest:@"POST"
                   toFile:[NSString stringWithFormat:@"/features/%@", identifier]
               withParams:[[place asGeoJSON] JSONData]
                 callback:callback];
}

- (void)deletePlace:(NSString *)identifier
           callback:(SGCallback *)callback
{   
    [self sendHTTPRequest:@"DELETE"
                   toFile:[NSString stringWithFormat:@"/features/%@", identifier]
               withParams:nil
                 callback:callback];
}

@end
