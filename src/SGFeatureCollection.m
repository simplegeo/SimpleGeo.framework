//
//  SGFeatureCollection.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGFeatureCollection.h"
#import "NSArray+SGFeature.h"


// trigger @synthesize in SGFeature to create readwrite accessors
@interface SGFeatureCollection ()

@property (retain) NSArray* features;

@end


@implementation SGFeatureCollection

@synthesize features;

+ (SGFeatureCollection *)featureCollectionWithDictionary:(NSDictionary *)features
{
    return [[[SGFeatureCollection alloc] initWithDictionary:features] autorelease];
}

+ (SGFeatureCollection *)featureCollectionWithFeatures:(NSArray *)features
{
    return [[[SGFeatureCollection alloc] initWithFeatures:features] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)someFeatures
{
    if ([[someFeatures objectForKey:@"type"] isEqual:@"FeatureCollection"]) {
        return [self initWithFeatures:[someFeatures objectForKey:@"features"]];
    } else {
        NSLog(@"Invalid type '%@' for a FeatureCollection.", [someFeatures objectForKey:@"type"]);
        return nil;
    }
}

- (id)initWithFeatures:(NSArray *)someFeatures
{
    self = [super init];

    if (self) {
        if (someFeatures) {
            features = [NSArray arrayWithFeatures:someFeatures];
        } else {
            features = [[NSArray alloc] init];
        }
    }

    return self;
}

- (NSUInteger)count
{
    return [features count];
}

@end
