//
//  NSDictionary+SGContext.h
//  SimpleGeo
//
//  Copyright (c) 2010-2011, SimpleGeo Inc.
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

@class SGPlacemark;

/**
 * An SGContext object stores information from a SimpleGeo Context response.
 * Context information includes a nearest address, a collection of feature polygons,
 * weather and demographic information, as well as nearby intersections.
 * To create an SGContext object from a Context response, call [SGContext contextWithDictionary:].
 * This will transform the response dictionary into an SContext object, which generates SG model objects where appropriate.
 * E.g., an SGPlacemark object will be created to hold the response address.
 */
@interface SGContext : NSObject
{
    @private
    NSDate *timestamp;
    NSDictionary *query;
    SGPlacemark *address;
    NSArray *features;
    NSDictionary *demographics;
    NSArray *intersections;
    NSDictionary *weather;
}

/// Timestamp for the Context request
@property (nonatomic, readonly) NSDate *timestamp;

/// Submitted query
@property (nonatomic, readonly) NSDictionary *query;

/// Nearest address
@property (nonatomic, readonly) SGPlacemark *address;

/// Feature polygons
@property (nonatomic, readonly) NSArray *features;

/// Demographics information
@property (nonatomic, readonly) NSDictionary *demographics;

/// Nearest intersections
@property (nonatomic, readonly) NSArray *intersections;

/// Local weather
@property (nonatomic, readonly) NSDictionary *weather;

/**
 * Create an SGContext object from a SimpleGeo Context response
 * @param dictionary    Context response dictionary
 */
+ (SGContext *)contextWithDictionary:(NSDictionary *)dictionary;

/**
 * Construct an SGContext object from a SimpleGeo Context response
 * @param dictionary    Context response dictionary
 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
