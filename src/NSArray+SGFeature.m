//
//  NSArray+SGFeature.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/16/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSArray+SGFeature.h"
#import "SGFeature.h"


@implementation NSArray (SGFeature)

+ (NSArray *)arrayWithFeatures:(NSArray *)input
{
    NSMutableArray *features = [NSMutableArray arrayWithCapacity:[input count]];
    
    // Assumption: features is an NSArray containing a set of NSDictionary
    // objects that are actually features
    for (NSDictionary *feature in input) {
        [features addObject:[SGFeature featureWithData:feature]];
    }
    
    return features;
}

@end
