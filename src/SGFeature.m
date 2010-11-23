//
//  SGFeature.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGFeature.h"


@implementation SGFeature

@synthesize featureId;
@synthesize properties;
@synthesize rawBody;

+ (SGFeature *)featureWithId:(NSString *)id
{
    return [SGFeature featureWithId:id data:nil];
}

+ (SGFeature *)featureWithId:(NSString *)id
                        data:(NSDictionary *)data
{
    return [SGFeature featureWithId:id
                               data:data
                            rawBody:nil];
}

+ (SGFeature *)featureWithId:(NSString *)id
                        data:(NSDictionary *)data
                     rawBody:(NSString *)rawBody
{
    return [[[SGFeature alloc] initWithId:id
                                    data:data
                                 rawBody:rawBody] autorelease];
}

+ (SGFeature *)featureWithData:(NSDictionary *)data
{
    return [SGFeature featureWithId:nil
                               data:data];
}

- (id)init
{
    return [self initWithId:nil];
}

- (id)initWithId:(NSString *)id
{
    return [self initWithId:id
                       data:nil];
}

- (id)initWithId:(NSString *)id
            data:(NSDictionary *)data
{
    return [self initWithId:id
                       data:data
                    rawBody:nil];
}

- (id)initWithId:(NSString *)id
            data:(NSDictionary *)data
         rawBody:(NSString *)body
{
    self = [super init];

    if (self) {
        [self setFeatureId:id];

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

        rawBody = [body retain];
    }

    return self;
}

- (void)dealloc
{
    [featureId release];
    [geometry release];
    [properties release];
    [rawBody release];
    [super dealloc];
}

- (NSString *)description
{
    if (rawBody) {
        return rawBody;
    } else {
        return [[NSDictionary dictionaryWithObjectsAndKeys:featureId, @"id",
                geometry, @"geometry",
                properties, @"properties",
                nil] description];
    }
}

- (SGPoint *)geometry
{
    return geometry;
}

- (void)setGeometry:(id)input
{
    [geometry autorelease];
    geometry = [[SGPoint pointForGeometry:input] retain];
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
