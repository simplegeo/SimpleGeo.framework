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
	return [[SGFeature alloc] initWithId:id];
}

+ (SGFeature *)featureWithId:(NSString *)id data:(NSDictionary *)data
{
	return [[SGFeature alloc] initWithId:id data:data];
}

- (id)init
{
	return [self initWithId:NULL];
}

- (id)initWithId:(NSString *)id
{
	return [self initWithId:id data:NULL];
}

- (id)initWithId:(NSString *)id data:(NSDictionary *) data
{
	self = [super init];

	if (self) {
		[self setFeatureId:id];

		if (data) {
			// data will either be an NSDictionary or an NSArray depending on the input JSON;
			// this class represents a single feature, so if it gets passed an NSArray, that's
			// just wrong
			if (! [data isKindOfClass:[NSDictionary class]]) {
				@throw [NSException exceptionWithName:NSInvalidArgumentException
											   reason:[NSString stringWithFormat:@"Invalid data type: %@",
													   [data class]]
											 userInfo:nil];
			}

			if (! [[data objectForKey:@"type"] isEqual:@"Feature"]) {
				@throw [NSException exceptionWithName:NSInvalidArgumentException
											   reason:[NSString stringWithFormat:@"Unsupported type: %@",
													   [data objectForKey:@"type"]]
											 userInfo:nil];
			}

			for (NSString *key in data) {
				NSString *selectorString = [NSString stringWithFormat:@"set%@:", [key capitalizedString]];
				SEL selector = NSSelectorFromString(selectorString);

				// properties with well-known names are defined as @properties;
				// anything else is ignored
				if ([self respondsToSelector:selector]) {
					[self performSelector:selector withObject:[data objectForKey:key]];
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
	[rawBody release];
	[super dealloc];
}

- (NSString *)description
{
	return rawBody;
}

- (SGPoint *)geometry
{
	return geometry;
}

- (void)setGeometry:(id)input
{
	if ([input isKindOfClass:[SGPoint class]]) {
		[geometry autorelease];
		geometry = [input retain];
	} else if ([input isKindOfClass:[NSDictionary class]]) {
		// TODO this probably belongs in an SGPoint constructor like "pointForGeometry:"
		// (accepting both SGPoints and NSDictionaries) (or "geometryForGeometry:")
		[self setGeometryWithDictionary:input];
	} else {
		NSLog(@"Unrecognized geometry input: %@ (%@)", [input description], [input class]);
		// TODO throw an NSInvalidArgumentException???
	}
}

- (void)setGeometryWithDictionary:(NSDictionary *)input
{
	NSLog(@"geometry from dictionary: %@", input);

	if ([[input objectForKey:@"type"] isEqual:@"Point"]) {
		NSArray *coordinates = [input objectForKey:@"coordinates"];
		NSLog(@"Coordinates class: %@", [coordinates class]);
		[self setGeometry:[SGPoint pointWithLatitude:[coordinates objectAtIndex:1] longitude:[coordinates objectAtIndex:0]]];
	} else {
		NSLog(@"Non-Point geometries aren't currently supported.");
	}
}

@end
