//
//  SimpleGeo+Context.m
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

#import "SimpleGeo+Context.h"
#import "SimpleGeo+Internal.h"
#import "SGContextQuery.h"
#import "SGPreprocessorMacros.h"
#import "SGJSONKit.h"

@implementation SimpleGeo (Context)

#pragma mark -
#pragma mark Requests

- (void)getContextForQuery:(SGContextQuery *)query
                  callback:(SGCallback *)callback
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:query.address forKey:@"address"];
    
    [parameters setValue:query.filters forKey:@"filter"];
    [parameters setValue:query.featureCategories forKey:@"features__category"];
    [parameters setValue:query.featureSubcategories forKey:@"features__subcategory"];
    [parameters setValue:query.acsTableIDs forKey:@"demographics.acs__table"];
    
    [self sendHTTPRequest:@"GET"
                   toFile:[NSString stringWithFormat:@"/context/%@",[self baseEndpointForQuery:query]]
               withParams:parameters
                  version:self.contextVersion
                 callback:callback];
}

- (void)getFeatureWithHandle:(NSString *)handle
                        zoom:(NSNumber *)zoom
                    callback:(SGCallback *)callback
{    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (zoom) [parameters setValue:[NSString stringWithFormat:@"%d",[zoom intValue]] forKey:@"zoom"];
    
    [self sendHTTPRequest:@"GET"
                   toFile:[NSString stringWithFormat:@"/features/%@", handle]
               withParams:parameters
                  version:self.contextVersion
                 callback:callback];
}

- (void)getAnnotationsForFeature:(NSString *)handle
                        callback:(SGCallback *)callback
{
    [self sendHTTPRequest:@"GET"
                   toFile:[NSString stringWithFormat:@"/features/%@/annotations", handle]
               withParams:nil
                  version:self.contextVersion
                 callback:callback];
}

- (void)searchDemographicsTables:(NSString *)searchString
                        callback:(SGCallback *)callback
{
    [self sendHTTPRequest:@"GET"
                   toFile:@"/context/demographics/search"
               withParams:[NSDictionary dictionaryWithObject:searchString forKey:@"q"]
                  version:self.contextVersion
                 callback:callback];
}

#pragma mark -
#pragma mark Manipulations

- (void)annotateFeature:(NSString *)handle
         withAnnotation:(NSDictionary *)annotation
              isPrivate:(BOOL)isPrivate
               callback:(SGCallback *)callback
{    
    NSMutableDictionary *annotationDict = [NSMutableDictionary dictionaryWithObject:annotation forKey:@"annotations"];
    [annotationDict setValue:[NSNumber numberWithBool:isPrivate] forKey:@"private"];
    
    [self sendHTTPRequest:@"POST"
                   toFile:[NSString stringWithFormat:@"/features/%@/annotations", handle]
               withParams:[annotationDict JSONData]
                  version:self.contextVersion
                 callback:callback];
}

@end

SG_CATEGORY(SimpleGeoContext)