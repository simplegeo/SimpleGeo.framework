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
#import "SGPreprocessorMacros.h"

@implementation SGQuery

@synthesize point, address, envelope;

#pragma mark -
#pragma mark Instantiation

+ (id)query
{
    return SG_AUTORELEASE([[self alloc] init]);
}

+ (id)queryWithPoint:(SGPoint *)point
{
    return SG_AUTORELEASE([[self alloc] initWithPoint:point]);
}

+ (id)queryWithAddress:(NSString *)address
{
    return SG_AUTORELEASE([[self alloc] initWithAddress:address]);
}

+ (id)queryWithEnvelope:(SGEnvelope *)envelope
{
    return SG_AUTORELEASE([[self alloc] initWithEnvelope:envelope]);
}

- (id)initWithPoint:(SGPoint *)aPoint
{
    self = [self init];
    if (self) {
        point = SG_RETAIN(aPoint);
    }
    return self;
}

- (id)initWithAddress:(NSString *)anAddress
{
    self = [self init];
    if (self) {
        address = SG_RETAIN(anAddress);
    }
    return self;
}

- (id)initWithEnvelope:(SGEnvelope *)anEnvelope
{
    self = [self init];
    if (self) {
        envelope = SG_RETAIN(anEnvelope);
    }
    return self;
}

#pragma mark -
#pragma mark Memory

- (void)dealloc {
    SG_RELEASE(point);
    SG_RELEASE(address);
    SG_RELEASE(envelope);
    [super dealloc];
}

@end
