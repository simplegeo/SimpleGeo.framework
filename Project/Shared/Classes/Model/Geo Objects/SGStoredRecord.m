//
//  SGStoredRecord.m
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

#import "SGStoredRecord.h"
#import "SGPoint.h"

@implementation SGStoredRecord

@synthesize layer, created, layerLink;

#pragma mark -
#pragma mark Instantiation

+ (SGStoredRecord *)recordWithID:(NSString *)identifier
                           point:(SGPoint *)point
                           layer:(NSString *)layerName
{
    return [[[SGStoredRecord alloc] initWithID:identifier
                                        point:point
                                        layer:layerName] autorelease];
}

+ (SGStoredRecord *)recordWithGeoJSON:(NSDictionary *)geoJSONFeature
{
    return [[[SGStoredRecord alloc] initWithGeoJSON:geoJSONFeature] autorelease];
}

- (id)initWithID:(NSString *)anIdentifier
           point:(SGPoint *)point
           layer:(NSString *)layerName
{
    self = [super initWithGeometry:point];
    if (self) {
        [self setIdentifier:anIdentifier];
        layer = [layerName retain];
    }
    return self;
}

- (id)initWithGeoJSON:(NSDictionary *)geoJSONFeature
{
    self = [super initWithGeoJSON:geoJSONFeature];
    if (self) {        
        // layer
        layer = [[self.properties objectForKey:@"layer"] retain];
        [self.properties removeObjectForKey:@"layer"];
        // created
        NSNumber *epoch = [geoJSONFeature objectForKey:@"created"];
        if (epoch) created = [[NSDate alloc] initWithTimeIntervalSince1970:[epoch intValue]];
        // layerLink
        NSDictionary *layerLinkDict = [geoJSONFeature objectForKey:@"layerLink"];
        if (layerLinkDict) layerLink = [[layerLinkDict objectForKey:@"href"] retain];
    }
    return self;
}

#pragma mark -
#pragma mark Convenience

- (SGPoint *)point
{
    return (SGPoint *)self.geometry;
}

- (NSDictionary *)asGeoJSON
{
    NSMutableDictionary *dictionary = (NSMutableDictionary *)[super asGeoJSON];    
    [[dictionary objectForKey:@"properties"] setValue:layer forKey:@"layer"]; // layer
    if (created) [dictionary setValue:[NSNumber numberWithDouble:[created timeIntervalSince1970]] forKey:@"created"]; // created
    // if (layerLink) [dictionary setValue:[NSDictionary dictionaryWithObject:layerLink forKey:@"href"] forKey:@"layerLink"]; // layerLink
    return dictionary;
}

#pragma mark -
#pragma mark Comparison

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    return ([super isEqual:object] &&
            [layer isEqual:[object layer]]);
}

- (NSUInteger)hash
{
    return [super hash] + [layer hash];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    [layer release];
    [created release];
    [layerLink release];
    [super dealloc];
}

@end
