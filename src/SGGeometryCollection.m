//
//  SGGeometryCollection.m
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

#import "SGGeometryCollection.h"
#import "NSArray+SGFeature.h"
#import "NSArray+SGGeometry.h"

@interface SGGeometryCollection ()

@property (retain) NSArray* geometries;

@end

@implementation SGGeometryCollection
@synthesize geometries;

+ (SGGeometryCollection *)geometryCollectionWithDictionary:(NSDictionary *)geometries
{
    return [[[SGGeometryCollection alloc] initWithDictionary:geometries] autorelease];
}
+ (SGGeometryCollection *)geometryCollectionWithGeometries:(NSArray *)geometries
{
	return [[[SGGeometryCollection alloc] initWithGeometries:geometries] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)someGeometries
{
    if ([[someGeometries objectForKey:@"type"] isEqual:@"GeometryCollection"]) {
        return [self initWithGeometries:[someGeometries objectForKey:@"geometries"]];
    } else {
        NSLog(@"Invalid type '%@' for a RecordCollection.", [someGeometries objectForKey:@"type"]);
        return nil;
    }
}

- (id)initWithGeometries:(NSArray *)someGeometries
{
    self = [super init];
	
    if (self) {
        if (someGeometries) {
            geometries = [[NSArray arrayWithGeometries:someGeometries] retain];
        } else {
            geometries = [[NSArray alloc] init];
        }
    }
	
    return self;
}

- (void)dealloc
{
    [geometries release];
    [super dealloc];
}

- (NSUInteger)count
{
    return [geometries count];
}


@end
