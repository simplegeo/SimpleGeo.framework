//
//  SGFeature.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface SGFeature : NSObject
{
	NSString* featureId;
	NSString* rawBody;
}

@property (retain) NSString* featureId;
@property (retain) NSString* rawBody;

+ (SGFeature *)featureWithId:(NSString *)id;

@end
