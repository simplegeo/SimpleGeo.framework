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
@synthesize rawBody;

+ (SGFeature *)featureWithId:(NSString *)id
{
	SGFeature *feature = [[SGFeature alloc] init];
	[feature setFeatureId:id];
	
	return feature;
}

- (void)dealloc
{
	[featureId release];
	[super dealloc];
}

- (NSString *)description
{
	return rawBody;
}

@end
