//
//  SimpleGeoTest.m
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

#import "SimpleGeoTest.h"
#import "SGPolygon.h"


NSString * const TEST_URL_PREFIX = @"http://localhost:4567/";


@implementation SimpleGeoTest

- (BOOL)shouldRunOnMainThread
{
    return NO;
}

#pragma mark Utility Methods

- (SimpleGeo *)createClient
{
    NSURL *url = [NSURL URLWithString:TEST_URL_PREFIX];
    return [SimpleGeo clientWithDelegate:self
                             consumerKey:@"consumerKey"
                          consumerSecret:@"consumerSecret"
                                     URL:url];
}

- (SGPoint *)point
{
    return [[[SGPoint pointWithLatitude:40.0 longitude:-105.0] retain] autorelease];
}

#pragma mark Tests

- (void)testCreateClientWithDefaultURL
{
    NSURL *url = [NSURL URLWithString:SIMPLEGEO_URL_PREFIX];
    GHTestLog(@"SimpleGeo URL prefix: %@", SIMPLEGEO_URL_PREFIX);
    SimpleGeo *client = [SimpleGeo clientWithDelegate:self
                                              consumerKey:@""
                                           consumerSecret:@""];

    GHAssertEqualObjects([client url], url, @"URLs don't match.");
}

- (void)testCreateClientWithURL
{
    NSURL *url = [NSURL URLWithString:TEST_URL_PREFIX];
    SimpleGeo *client = [SimpleGeo clientWithDelegate:self
                                              consumerKey:@""
                                           consumerSecret:@""
                                                      URL:url];

    GHAssertEqualObjects([client url], url, @"URLs don't match.");
}

#pragma mark Async Tests

- (void)testGetPolygonFeatureWithHandle
{
    [self prepare];

    SimpleGeo *client = [self createClient];

    [client getFeatureWithHandle:@"SG_0Bw22I6fWoxnZ4GDc8YlXd"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetPolygonFeatureWithHandleAndZoom
{
    [self prepare];

    SimpleGeo *client = [self createClient];

    [client getFeatureWithHandle:@"SG_3tLT0I5cOUWIpoVOBeScOx"
                            zoom:0];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetPointFeatureWithHandle
{
    [self prepare];

    SimpleGeo *client = [self createClient];

    [client getFeatureWithHandle:@"SG_4CsrE4oNy1gl8hCLdwu0F0"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetFeatureWithHandleAndNonExistentResult
{
    [self prepare];

    SimpleGeo *client = [self createClient];

    [client getFeatureWithHandle:@"foo"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetFeatureWithHandleAndBadCredentials
{
    [self prepare];

    NSURL *url = [NSURL URLWithString:TEST_URL_PREFIX];
    SimpleGeo *client = [SimpleGeo clientWithDelegate:self
                                              consumerKey:@"invalidKey"
                                           consumerSecret:@"invalidSecret"
                                                      URL:url];

    [client getFeatureWithHandle:@"badCredentials"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetFeatureWithHandleShouldCallRequestDidFinish
{
    [self prepare];

    SimpleGeo *client = [self createClient];

    [client getFeatureWithHandle:@"requestDidFinish"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetCategories
{
    [self prepare];

    SimpleGeo *client = [self createClient];

    [client getCategories];
    [self waitForStatus:kGHUnitWaitStatusSuccess
            timeout:0.25];
}

#pragma mark SimpleGeoDelegate Methods

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
    if ([[[request userInfo] objectForKey:@"handle"] isEqual:@"requestDidFinish"]) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetFeatureWithHandleShouldCallRequestDidFinish)];
    }
}

- (void)requestDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"requestDidFail: %@", [request userInfo]);
    if ([[[request userInfo] objectForKey:@"handle"] isEqual:@"badCredentials"]) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetFeatureWithHandleAndBadCredentials)];
    }
}

- (void)didLoadFeature:(SGFeature *)feature
                handle:(NSString *)handle
{
    if ([handle isEqual:@"SG_4CsrE4oNy1gl8hCLdwu0F0"]) {
        GHAssertEqualObjects([feature featureId],
                             @"SG_4CsrE4oNy1gl8hCLdwu0F0_47.046962_-122.937467@1290636830", nil);

        SGPoint *geometry = (SGPoint *) [feature geometry];

        GHAssertEquals([geometry latitude], 47.046962, nil);
        GHAssertEquals([geometry longitude], -122.937467, nil);

        GHAssertEqualObjects([[feature properties] objectForKey:@"name"],
                             @"Burger Master West Olympia", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPointFeatureWithHandle)];
    } else if ([handle isEqual:@"SG_0Bw22I6fWoxnZ4GDc8YlXd"]) {
        GHAssertEqualObjects([feature featureId],
                             @"SG_0Bw22I6fWoxnZ4GDc8YlXd_37.759737_-122.433203", nil);
        GHAssertTrue([[feature geometry] isKindOfClass:[SGPolygon class]], nil);
        GHAssertEqualObjects([[feature properties] objectForKey:@"name"],
                             @"Castro District", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPolygonFeatureWithHandle)];
    } else if ([handle isEqual:@"SG_3tLT0I5cOUWIpoVOBeScOx"]) {
        GHAssertEqualObjects([[feature properties] objectForKey:@"name"],
                             @"America/Los_Angeles @ Zoom 0", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPolygonFeatureWithHandleAndZoom)];
    } else if ([handle isEqual:@"foo"]) {
        GHAssertNil(feature, nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetFeatureWithHandleAndNonExistentResult)];
    }
}

- (void)didLoadCategories:(NSArray *)categories {
    GHAssertEquals([categories count], (NSUInteger) 4, @"Should have read a list of 4 categories.");

    if ([categories count] > 0) {
        GHAssertEqualObjects([[categories objectAtIndex:0] objectForKey:@"category"],
                             @"Administrative", nil);
        GHAssertEqualObjects([[categories objectAtIndex:0] objectForKey:@"category_id"],
                             @"10100100", nil);
        GHAssertEqualObjects([[categories objectAtIndex:0] objectForKey:@"type"],
                             @"Region", nil);
        GHAssertEqualObjects([[categories objectAtIndex:0] objectForKey:@"subcategory"],
                             @"Consolidated City", nil);
    }

    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testGetCategories)];
}

@end
