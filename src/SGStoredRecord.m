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
#import "SGStoredRecord+Private.h"


@implementation SGStoredRecord

@synthesize created;
@synthesize layer;

+ (SGStoredRecord *)recordWithDictionary:(NSDictionary *)data
{
    return [[[SGStoredRecord alloc] initWithId:nil
                              dictionary:data] autorelease];
}

+ (SGStoredRecord *)recordWithCreatedTimestamp:(NSTimeInterval)created
{
    return [SGStoredRecord recordWithCreatedTimestamp:created
                                          layer:nil];
}

+ (SGStoredRecord *)recordWithLayer:(NSString *)layer
{
    return [SGStoredRecord recordWithCreatedTimestamp:0
                                          layer:layer];
}
+ (SGStoredRecord *)recordWithCreatedTimestamp:(NSTimeInterval)created
                                         layer:(NSString *)layer
{
    return [[[SGStoredRecord alloc] initWithCreatedTimestamp:created
                                                 layer:layer] autorelease];
}

+ (SGStoredRecord *)recordWithFeature:(SGFeature *)feature
                     createdTimestamp:(NSTimeInterval)created
{
    return [SGStoredRecord recordWithFeature:feature
                      createdTimestamp:created
                                 layer:nil];
}

+ (SGStoredRecord *)recordWithFeature:(SGFeature *)feature
                                layer:(NSString *)layer
{
    return [SGStoredRecord recordWithFeature:feature
                      createdTimestamp:0
                                 layer:layer];
}

+ (SGStoredRecord *)recordWithFeature:(SGFeature *)feature
                     createdTimestamp:(NSTimeInterval)created
                                layer:(NSString *)layer
{
    return [[[SGStoredRecord alloc] initWithFeature:feature
                             createdTimestamp:created
                                        layer:layer] autorelease];
}

- (id)init
{
    return [self initWithLayer:nil];
}

- (id)initWithCreatedTimestamp:(NSTimeInterval)timestampCreated
{
    return [self initWithCreatedTimestamp:timestampCreated
                                    layer:nil];
}

- (id)initWithLayer:(NSString *)theLayer
{
    return [self initWithCreatedTimestamp:0
                                    layer:theLayer];
}
- (id)initWithCreatedTimestamp:(NSTimeInterval)createdTimestamp
                         layer:(NSString *)theLayer
{
    self = [super init];

    if (self) {
        created = createdTimestamp;
        layer = [theLayer retain];
    }

    return self;
}

- (id)initWithFeature:(SGFeature *)feature
     createdTimestamp:(NSTimeInterval)createdTimestamp
{
    return [self initWithFeature:feature
                createdTimestamp:createdTimestamp
                           layer:nil];
}

- (id)initWithFeature:(SGFeature *)feature
                layer:(NSString *)theLayer
{
    return [self initWithFeature:feature
                createdTimestamp:0
                           layer:theLayer];
}

- (id)initWithFeature:(SGFeature *)feature
     createdTimestamp:(NSTimeInterval)createdTimestamp
                layer:(NSString *)theLayer
{
    self = [super initWithId:[feature featureId]
                    geometry:[feature geometry]
                  properties:[feature properties]];

    if (self) {
        created = createdTimestamp;
        layer = [theLayer retain];
    }

    return self;
}

- (void)dealloc
{
    [layer release];
    [super dealloc];
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super asDictionary]];

    if (created) {
        NSNumber *objCreated = [NSNumber numberWithDouble:created];
        [dict setObject:objCreated
                 forKey:@"created"];
    }

    if (layer) {
        [dict setObject:layer
                 forKey:@"layer"];
    }

    return [NSDictionary dictionaryWithDictionary:dict];
}


- (id)JSON
{
    return [self asDictionary];
}

@end
