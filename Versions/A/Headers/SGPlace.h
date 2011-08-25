//
//  SGPlace.h
//  SimpleGeo.framework
//
//  Copyright (c) 2011, SimpleGeo Inc.
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

#import "SGFeature.h"
@class SGPoint;
@class SGAddress;

/**
 * An SGPlace object represents a place in the SimpleGeo Places database.
 * Places are SGFeatures with an associated *address* and *tag array.*
 * SGPlace objects usually originate from a SimpleGeo Places API request,
 * although you can also create them explicitly yourself if you would like to add a private Place to the database.
 */
@interface SGPlace : SGFeature
{
    @private
    SGAddress *address;
    NSMutableArray *tags;
    BOOL isPrivate;
}

/// Place location
@property (nonatomic, readonly) SGPoint *point;

/// Place address
@property (nonatomic, readonly) SGAddress *address;

/// Place tags
@property (nonatomic, retain, setter = setMutableTags:) NSMutableArray *tags;

/// Place visibility
@property (nonatomic, assign) BOOL isPrivate;

#pragma mark -
#pragma mark Instantiation

/**
 * Create an SGPlace with a name, and location
 * @param name          Place name
 * @param point         Place location
 */
+ (SGPlace *)placeWithName:(NSString *)name
                     point:(SGPoint *)point;

/**
 * Construct an SGPlace from a dictionary that
 * abides by the GeoJSON Feature specification.
 * Note: geoJSON Feature must contain a "name"
 * key and value in the property dictionary
 * @param geoJSONFeature    Feature dictionary
 */
+ (SGPlace *)placeWithGeoJSON:(NSDictionary *)geoJSONFeature;

/**
 * Construct an SGPlace with a name and location
 * @param name          Place name
 * @param point         Place location
 */
- (id)initWithName:(NSString *)name
             point:(SGPoint *)point;

#pragma mark -
#pragma mark Convenience

/**
 * Set tags from an immutable array of tags
 * @param tags          Tags
 */
- (void)setTags:(NSMutableArray *)tags;

@end