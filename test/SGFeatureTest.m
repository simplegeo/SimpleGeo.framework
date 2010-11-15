//
//  SGFeatureTest.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "SGFeature.h"

@interface SGFeatureTest : GHTestCase { }
@end


@implementation SGFeatureTest

- (BOOL)shouldRunOnMainThread
{
	return NO;
}

- (void)testFeatureId
{
	NSString *featureId = @"SG_asdf";
	SGFeature *feature = [SGFeature featureWithId: featureId];
	
	GHAssertEqualObjects(featureId, [feature featureId], @"Feature ids don't match.");
}

@end
