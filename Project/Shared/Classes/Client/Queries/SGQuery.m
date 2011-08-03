//
//  SGQuery.m
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

#import "SGQuery.h"
#import "SGPoint.h"
#import "SGEnvelope.h"

@implementation SGQuery

@synthesize point, address, envelope;

#pragma mark -
#pragma mark Instantiation

+ (id)queryWithPoint:(SGPoint *)point
{
    return [[[self alloc] initWithPoint:point] autorelease];
}

+ (id)queryWithAddress:(NSString *)address
{
    return [[[self alloc] initWithAddress:address] autorelease];
}

+ (id)queryWithEnvelope:(SGEnvelope *)envelope
{
    return [[[self alloc] initWithEnvelope:envelope] autorelease];
}

- (id)initWithPoint:(SGPoint *)aPoint
{
    self = [self init];
    if (self) {
        point = [aPoint retain];
    }
    return self;
}

- (id)initWithAddress:(NSString *)anAddress
{
    self = [self init];
    if (self) {
        address = [anAddress retain];
    }
    return self;
}

- (id)initWithEnvelope:(SGEnvelope *)anEnvelope
{
    self = [self init];
    if (self) {
        envelope = [anEnvelope retain];
    }
    return self;
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
    [point release];
    [address release];
    [envelope release];
    [super dealloc];
}

@end
