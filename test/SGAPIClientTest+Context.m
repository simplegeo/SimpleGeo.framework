//
//  SGAPIClientTest+Context.m
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

#import "SGAPIClientTest.h"
#import "SGAPIClient+Context.h"

@implementation SGAPIClientTest (Context)

- (void)testGetContextFor
{
    [self prepare];

    [[self createClient] getContextFor:[self point]];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

#pragma mark SGAPIClientContextDelegate Methods

- (void)didLoadContext:(NSDictionary *)context
                   for:(SGPoint *)point
{
    GHAssertNotNil([context objectForKey:@"demographics"], nil);
    GHAssertNotNil([context objectForKey:@"weather"], nil);
    GHAssertTrue([[context objectForKey:@"features"] isKindOfClass:[NSArray class]], nil);

    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testGetContextFor)];
}

@end
