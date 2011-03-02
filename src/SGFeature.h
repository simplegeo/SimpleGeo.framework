//
//  SGFeature.h
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

#import "SGGeometry.h"


/*!
 * Feature.
 */
@interface SGFeature : NSObject
{
  @private
    NSString* featureId;
    SGGeometry* geometry;
    NSDictionary* properties;
}

//! Feature id
@property (retain,readonly) NSString* featureId;

//! Feature geometry
@property (retain,readonly) SGGeometry* geometry;

//! Feature properties
@property (retain,readonly) NSDictionary* properties;

/*!
 * Create a Feature with an id.
 * @param id Feature id.
 */
+ (SGFeature *)featureWithId:(NSString *)id;

/*!
 * Create a Feature with an id and some properties.
 * @param id         Feature id.
 * @param properties Feature properties.
 */
+ (SGFeature *)featureWithId:(NSString *)id
                  properties:(NSDictionary *)properties;

/*!
 * Create a Feature with an id and a geometry.
 * @param id       Feature id.
 * @param geometry Feature geometry.
 */
+ (SGFeature *)featureWithId:(NSString *)id
                    geometry:(SGGeometry *)geometry;

/*!
 * Create a Feature with an id, a geometry, and some properties.
 * @param id         Feature id.
 * @param geometry   Feature geometry.
 * @param properties Feature properties.
 */
+ (SGFeature *)featureWithId:(NSString *)id
                    geometry:(SGGeometry *)geometry
                  properties:(NSDictionary *)properties;

/*!
 * Create a Feature with a geometry and some properties.
 * @param geometry   Feature geometry.
 * @param properties Feature properties.
 */
+ (SGFeature *)featureWithGeometry:(SGGeometry *)geometry
                        properties:(NSDictionary *)properties;

/*!
 * Construct a Feature with an id.
 * @param id Feature id.
 */
- (id)initWithId:(NSString *)id;

/*!
 * Construct a Feature with an id and some properties.
 * @param id         Feature id.
 * @param properties Feature properties.
 */
- (id)initWithId:(NSString *)id
      properties:(NSDictionary *)properties;

/*!
 * Construct a Feature with an id and a geometry.
 * @param id       Feature id.
 * @param geometry Feature geometry.
 */
- (id)initWithId:(NSString *)id
        geometry:(SGGeometry *)geometry;

/*!
 * Construct a Feature with an id, a geometry, and some properties.
 * @param id         Feature id.
 * @param geometry   Feature geometry.
 * @param properties Feature properties.
 */
- (id)initWithId:(NSString *)id
        geometry:(SGGeometry *)geometry
      properties:(NSDictionary *)properties;

/*!
 * Construct a Feature with a geometry and some properties.
 * @param geometry   Feature geometry.
 * @param properties Feature properties.
 */
- (id)initWithGeometry:(SGGeometry *)geometry
            properties:(NSDictionary *)properties;

/*!
 * Return an NSDictionary representation of this feature;
 */
- (NSDictionary *)asDictionary;

@end
