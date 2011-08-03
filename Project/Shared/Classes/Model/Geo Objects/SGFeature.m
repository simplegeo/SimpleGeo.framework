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

@implementation SGFeature

@synthesize name, classifiers;

#pragma mark -
#pragma mark Instantiation

+ (SGFeature *)featureWithGeoJSON:(NSDictionary *)geoJSONFeature
{
    return [[[SGFeature alloc] initWithGeoJSON:geoJSONFeature] autorelease];
}

- (id)initWithGeoJSON:(NSDictionary *)geoJSONFeature
{
    self = [super initWithGeoJSON:geoJSONFeature];
    if (self) {
        // name
        name = [[self.properties objectForKey:@"name"] retain];
        [self.properties removeObjectForKey:@"name"];
        // classifiers
        NSArray *someClassifiers = [self.properties objectForKey:@"classifiers"];
        if (someClassifiers && [someClassifiers count] > 0)
            [self setClassifiers:[self.properties objectForKey:@"classifiers"]];
        [self.properties removeObjectForKey:@"classifiers"];
    }
    return self;
}

#pragma mark -
#pragma mark Convenience

- (void)setClassifiers:(NSArray *)someClassifiers
{
    [self setMutableClassifiers:[NSMutableArray arrayWithArray:someClassifiers]];
}

- (void)setMutableClassifiers:(NSMutableArray *)someClassifiers
{
    [classifiers release];
    classifiers = [someClassifiers retain];
}

- (NSDictionary *)asGeoJSON
{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super asGeoJSON];    
    [[dictionary objectForKey:@"properties"] setValue:name forKey:@"name"]; // name
    [[dictionary objectForKey:@"properties"] setValue:classifiers forKey:@"classifiers"]; // classifiers
    
    return dictionary;
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    [name release];
    [classifiers release];
    [super dealloc];
}

@end