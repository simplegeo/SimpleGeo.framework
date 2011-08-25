//
//  SimpleGeo.h
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

// Requests
#import "SGHTTPClient.h"

// Geometry
#import "SGGeometry.h"
#import "SGPoint.h"
#import "SGEnvelope.h"
#import "SGPolygon.h"
#import "SGMultiPolygon.h"

#if TARGET_OS_IPHONE
    // Mapkit Additions
    #import "SGGeometry+Mapkit.h"
    #import "SGPoint+Mapkit.h"
    #import "SGPolygon+Mapkit.h"
    #import "SGMultiPolygon+Mapkit.h"   
    #import "SGEnvelope+Mapkit.h"
#endif

// Objects
#import "SGAddress.h"
#import "SGPlacemark.h"
#import "SGContext.h"
#import "SGLayer.h"

// Query Objects
#import "SGContextQuery.h"
#import "SGPlacesQuery.h"
#import "SGStorageQuery.h"

// Geo Objects
#import "SGGeoObject.h"
#import "SGFeature.h"
#import "SGPlace.h"
#import "SGStoredRecord.h"

// Helpers
#import "SGTypes.h"
#import "SGCategories.h"
#import "NSArray+SGCollection.h"
#import "NSDictionary+Classifier.h"

/**
 A SimpleGeo object acts as a client for all API requests.
 A SimpleGeo object is created with SimpleGeo credentials (an OAuth consumer key and secret).
 All API requests are made by calling methods in this class.
 
    // Create the client
    SimpleGeo *client = [SimpleGeo clientWithConsumerKey:@"key"
                                          consumerSecret:@"secret"];
    // Example request
    [client getContextForQuery:query callback:callback];
 */
@interface SimpleGeo: SGHTTPClient

#pragma mark -
#pragma mark Instantiation

/**
 * Create a client for making requests
 * @param consumerKey    OAuth consumer key
 * @param consumerSecret OAuth consumer secret
 */
+ (SimpleGeo *)clientWithConsumerKey:(NSString *)consumerKey
                      consumerSecret:(NSString *)consumerSecret;

@end

// Services
#import "SimpleGeo+Context.h"
#import "SimpleGeo+Features.h"
#import "SimpleGeo+Places.h"
#import "SimpleGeo+Storage.h"
