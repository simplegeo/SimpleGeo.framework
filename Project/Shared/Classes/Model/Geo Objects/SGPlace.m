//
//  SGPlace.m
//  SimpleGeo.framework
//
//  Copyright (c) 2011, SimpleGeo Inc.
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

#import "SGPlace.h"
#import "SGPoint.h"
#import "SGAddress.h"
#import "SGAddress+Internal.h"

#import "SGPreprocessorMacros.h"

@implementation SGPlace

@synthesize address, tags, categories, isPrivate;

#pragma mark -
#pragma mark Instantiation

+ (SGPlace *)placeWithName:(NSString *)name
                     point:(SGPoint *)point
{
    return SG_AUTORELEASE([[SGPlace alloc] initWithName:name point:point]);
}

+ (SGPlace *)placeWithGeoJSON:(NSDictionary *)geoJSONFeature
{
    return SG_AUTORELEASE([[SGPlace alloc] initWithGeoJSON:geoJSONFeature]);
}

- (id)initWithName:(NSString *)aName
             point:(SGPoint *)point
{
    self = [super initWithGeometry:point];
    if (self) {
        [self setName:aName];
    }
    return self;
}

- (id)initWithGeoJSON:(NSDictionary *)geoJSONFeature
{
    self = [super initWithGeoJSON:geoJSONFeature];
    if (self) {
        // address
        address = SG_RETAIN([SGAddress addressStrippedFromDictionary:self.properties]);
        // tags
        NSArray *placeTags = [self.properties objectForKey:@"tags"];
        if (placeTags) {
            tags = [[NSMutableArray arrayWithArray:placeTags] retain];
            [self.properties removeObjectForKey:@"tags"];
        }
        // categories
        NSArray *placeCategories = [self.properties objectForKey:@"categories"];
        if (placeCategories) {
            categories = [[NSMutableArray arrayWithArray:placeCategories] retain];
            [self.properties removeObjectForKey:@"categories"];
        }
        // visibility
        NSString *visibility = [self.properties objectForKey:@"private"];
        if (visibility) {
            isPrivate = [visibility isEqual:@"true"];
            [self.properties removeObjectForKey:@"private"];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Convenience

- (SGPoint *)point
{
    return (SGPoint *)self.geometry;
}

- (void)setTags:(NSArray *)someTags
{
    [self setMutableTags:[[someTags mutableCopy] autorelease]];
}

- (void)setMutableTags:(NSMutableArray *)someTags
{
    SG_RELEASE(tags);
    tags = SG_RETAIN(someTags);
}

- (void)setCategories:(NSArray *)someCategories
{
    [self setMutableTags:[[someCategories mutableCopy] autorelease]];
}

- (void)setMutableCategories:(NSMutableArray *)someCategories
{
    SG_RELEASE(categories);
    tags = SG_RETAIN(someCategories);
}

- (NSDictionary *)asGeoJSON
{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super asGeoJSON];
    [[dictionary objectForKey:@"properties"] addEntriesFromDictionary:address.addressDictionary]; // address
    [[dictionary objectForKey:@"properties"] setValue:tags forKey:@"tags"]; // tags
    [[dictionary objectForKey:@"properties"] setValue:categories forKey:@"categories"]; // categories
    if (isPrivate) [[dictionary objectForKey:@"properties"] setValue:@"true" forKey:@"private"]; // visibility
    return dictionary;
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    SG_RELEASE(tags);
    SG_RELEASE(categories);
    [super dealloc];
}

@end
