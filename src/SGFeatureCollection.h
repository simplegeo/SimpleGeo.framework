//
//  SGFeatureCollection.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//


@interface SGFeatureCollection : NSObject
{
    NSArray* features;
}

@property (retain,readonly) NSArray* features;

+ (SGFeatureCollection *)featureCollectionWithDictionary:(NSDictionary *)features;
+ (SGFeatureCollection *)featureCollectionWithFeatures:(NSArray *)features;

- (id)initWithDictionary:(NSDictionary *)features;
- (id)initWithFeatures:(NSArray *)features;

- (NSUInteger)count;

@end
