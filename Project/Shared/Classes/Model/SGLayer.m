//
//  SGLayer.m
//  SimpleGeo
//
//  Copyright (c) 2010-2011, SimpleGeo Inc.
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

#import "SGLayer.h"

#import "SGPreprocessorMacros.h"

@implementation SGLayer

@synthesize name, title, description, callbackURLs, isPublic, created, updated;

#pragma mark -
#pragma mark Instantiation

+ (SGLayer *)layerWithName:(NSString *)name
                     title:(NSString *)title
               description:(NSString *)description
               callbackURLs:(NSArray *)callbackURLs
{
   return SG_AUTORELEASE([[SGLayer alloc] initWithName:name
                                                 title:title
                                           description:description
                                          callbackURLs:callbackURLs]);
}

+ (SGLayer *)layerWithDictionary:(NSDictionary *)layerDictionary
{
    return SG_AUTORELEASE([[SGLayer alloc] initWithDictionary:layerDictionary]);
}

- (id)initWithName:(NSString *)aName
             title:(NSString *)aTitle
       description:(NSString *)aDescription
       callbackURLs:(NSArray *)someCallbackURLs
{
    self = [super init];
    if (self) {
        name = SG_RETAIN(aName);
        title = SG_RETAIN(aTitle);
        description = SG_RETAIN(aDescription);
        callbackURLs = [someCallbackURLs mutableCopy];
    }
    return self;
}

- (id)initWithDictionary:(NSDictionary *)layerDictionary
{
    self = [super init];
    if (self) {
        name = SG_RETAIN([layerDictionary objectForKey:@"name"]);
        title = SG_RETAIN([layerDictionary objectForKey:@"title"]);
        description = SG_RETAIN([layerDictionary objectForKey:@"description"]);
        callbackURLs = [[layerDictionary objectForKey:@"callback_urls"] mutableCopy];
        BOOL publicValue = [[layerDictionary objectForKey:@"public"] boolValue];
        if (publicValue) isPublic = publicValue;
        NSNumber *createdEpoch = [layerDictionary objectForKey:@"created"];
        if (createdEpoch) created = SG_RETAIN([NSDate dateWithTimeIntervalSince1970:[createdEpoch doubleValue]]);
        NSNumber *updatedEpoch = [layerDictionary objectForKey:@"updated"];
        if (updatedEpoch) updated = SG_RETAIN([NSDate dateWithTimeIntervalSince1970:[updatedEpoch doubleValue]]);
    }
    return self;
}

#pragma mark -
#pragma mark Convenience

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:name forKey:@"name"];
    [dictionary setValue:title forKey:@"title"];
    [dictionary setValue:description forKey:@"description"];
    [dictionary setValue:callbackURLs forKey:@"callback_urls"];
    [dictionary setValue:[NSNumber numberWithBool:isPublic] forKey:@"public"];
    if (created) [dictionary setValue:[NSNumber numberWithDouble:[created timeIntervalSince1970]] forKey:@"created"];
    if (updated) [dictionary setValue:[NSNumber numberWithDouble:[updated timeIntervalSince1970]] forKey:@"updated"];
    return dictionary;
}

- (NSString *)description
{
    return [[self asDictionary] description];
}

#pragma mark -
#pragma mark Comparison

- (BOOL)isEqual:(id)object
{
    if (object == self) return YES;
    if (!object || ![object isKindOfClass:[self class]]) return NO;
    return [name isEqual:[object name]];
}

- (NSUInteger)hash
{
    return [name hash];
}

#pragma mark -
#pragma mark Memory

- (void)dealloc
{
    SG_RELEASE(name);
    SG_RELEASE(title);
    SG_RELEASE(description);
    SG_RELEASE(callbackURLs);
    SG_RELEASE(created);
    SG_RELEASE(updated);
    [super dealloc];
}

@end
