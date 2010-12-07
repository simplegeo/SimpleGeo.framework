//
//  SGFeature.m
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

#import "SGFeature.h"
#import "SGFeature+Private.h"
#import "SGGeometry+Private.h"


// trigger @synthesize in SGFeature to create readwrite accessors
@interface SGFeature ()

@property (retain) NSString* featureId;
@property (retain) SGGeometry* geometry;
@property (retain) NSDictionary* properties;

@end


@implementation SGFeature

@synthesize featureId;
@synthesize properties;

+ (SGFeature *)featureWithId:(NSString *)id
{
    return [SGFeature featureWithId:id
                         dictionary:nil];
}

+ (SGFeature *)featureWithId:(NSString *)id
                  dictionary:(NSDictionary *)data
{
    return [[[SGFeature alloc] initWithId:id
                               dictionary:data] autorelease];
}

+ (SGFeature *)featureWithDictionary:(NSDictionary *)data
{
    return [SGFeature featureWithId:nil
                         dictionary:data];
}

+ (SGFeature *)featureWithId:(NSString *)id
                  properties:(NSDictionary *)properties
{
    return [SGFeature featureWithId:id
                           geometry:nil
                         properties:properties];
}

+ (SGFeature *)featureWithId:(NSString *)id
                    geometry:(SGGeometry *)geometry
{
    return [SGFeature featureWithId:id
                           geometry:geometry
                         properties:nil];
}

+ (SGFeature *)featureWithGeometry:(SGGeometry *)geometry
                        properties:(NSDictionary *)properties
{
    return [SGFeature featureWithId:nil
                           geometry:geometry
                         properties:properties];
}

+ (SGFeature *)featureWithId:(NSString *)id
                    geometry:(SGGeometry *)geometry
                  properties:(NSDictionary *)properties
{
    return [[[SGFeature alloc] initWithId:id
                                 geometry:geometry
                               properties:properties] autorelease];
}

- (id)init
{
    return [self initWithId:nil];
}

- (id)initWithId:(NSString *)id
{
    return [self initWithId:id
                   geometry:nil];
}

- (id)initWithId:(NSString *)id
      properties:(NSDictionary *)someProperties
{
    return [self initWithId:id
                   geometry:nil
                 properties:someProperties];
}

- (id)initWithId:(NSString *)id
        geometry:(SGGeometry *)aGeometry
{
    return [self initWithId:id
                   geometry:aGeometry
                 properties:nil];
}

- (id)initWithGeometry:(SGGeometry *)aGeometry
            properties:(NSDictionary *)someProperties
{
    return [self initWithId:nil
                   geometry:aGeometry
                 properties:someProperties];
}

- (id)initWithId:(NSString *)id
        geometry:(SGGeometry *)aGeometry
      properties:(NSDictionary *)someProperties
{
    self = [super init];

    if (self) {
        featureId = [id retain];
        geometry = [aGeometry retain];
        properties = [someProperties retain];
    }

    return self;
}

- (id)initWithId:(NSString *)id
      dictionary:(NSDictionary *)data
{
    self = [super init];

    if (self) {
        featureId = [id retain];

        if (data) {
            if (! [[data objectForKey:@"type"] isEqual:@"Feature"]) {
                NSLog(@"Unsupported geometry type: %@", [data objectForKey:@"type"]);
                return nil;
            }

            for (NSString *key in data) {
                NSString *selectorString = [NSString stringWithFormat:@"set%@:", [key capitalizedString]];
                SEL selector = NSSelectorFromString(selectorString);

                // properties with well-known names are defined as @properties;
                // anything else is ignored
                // accessor methods shouldn't be used in an init... method (so say the docs), but
                // there's no other way to achieve this otherwise
                if ([self respondsToSelector:selector]) {
                    [self performSelector:selector
                               withObject:[data objectForKey:key]];
                }
            }
        }
    }

    return self;
}

- (void)dealloc
{
    [featureId release];
    [geometry release];
    [properties release];
    [super dealloc];
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:3];

    if (featureId) {
        [dict setObject:featureId forKey:@"id"];
    }

    if (geometry) {
        [dict setObject:geometry forKey:@"geometry"];
    }

    if (properties) {
        [dict setObject:properties forKey:@"properties"];
    }

    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)description
{
    return [[self asDictionary] description];
}

- (id)JSON
{
    return [self asDictionary];
}

- (SGGeometry *)geometry
{
    return geometry;
}

- (void)setGeometry:(id)input
{
    [geometry autorelease];
    geometry = [[SGGeometry geometryWithGeometry:input] retain];
}

/**
 * This method exists to allow the magic setting-by-selector mechanism to set
 * ids properly.
 */
- (void)setId:(NSString *)id
{
    [self setFeatureId:id];
}

@end
