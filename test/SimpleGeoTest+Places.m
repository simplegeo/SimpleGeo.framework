//
//  SimpleGeoTest+Places.m
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
#import "SimpleGeo+Places.h"

@implementation SimpleGeoTest (Places)

- (void)testAddPlace
{
    [self prepare];

    SGPoint *geometry = [self point];
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Mike's Burger Shack", @"name",
                                nil];
    SGFeature *feature = [SGFeature featureWithGeometry:geometry
                                             properties:properties];

    [[self createClient] addPlace:feature];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testDeletePlace
{
    [self prepare];

    [[self createClient] deletePlace:@"SG_4CsrE4oNy1gl8hCLdwu0F0_47.046962_-122.937467@1290636830"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetPlacesNearWithMultipleResults
{
    [self prepare];

    [[self createClient] getPlacesNear:[self point]];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetPlacesNearWithRadiusAndMultipleResults
{
    [self prepare];

    [[self createClient] getPlacesNear:[self point] within:1.5];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.5];
}

- (void)testGetPlacesNearMatchingWithASingleResult
{
    [self prepare];

    [[self createClient] getPlacesNear:[self point]
                              matching:@"one"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetPlacesNearMatchingInCategory
{
    [self prepare];

    [[self createClient] getPlacesNear:[self point]
                              matching:@"burgers"
                            inCategory:@"Restaurants"];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testUpdatePlace
{
    [self prepare];

    NSString *handle = @"SG_4CsrE4oNy1gl8hCLdwu0F0_47.046962_-122.937467@1290636830";

    SGFeature *feature = [SGFeature featureWithId:handle
                                       properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"Mike's Burger Shack", @"name",
                                                   nil]];

    [[self createClient] updatePlace:handle
                                with:feature];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

#pragma mark SimpleGeoPlaceDelegate Methods

- (void)didAddPlace:(SGFeature *)feature
             handle:(NSString *)handle
                URL:(NSURL *)url
              token:(NSString *)token
{
    NSArray *handleComponents = [handle componentsSeparatedByString:@"@"];
    GHAssertEqualObjects([handleComponents objectAtIndex:0],
                         @"SG_07624b34159916851f3df2a0657f6ab5b9af962a_40_-105", nil);
    GHAssertEqualObjects(token, @"596499b4fc2a11dfa39058b035fcf1e5", nil);

    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testAddPlace)];
}

- (void)didDeletePlace:(NSString *)handle
                 token:(NSString *)token
{
    GHAssertEqualObjects(handle, @"SG_4CsrE4oNy1gl8hCLdwu0F0_47.046962_-122.937467@1290636830", nil);
    GHAssertEqualObjects(token, @"8fa0d1c4fc2911dfa39058b035fcf1e5", nil);

    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testDeletePlace)];
}

- (void)didLoadPlaces:(SGFeatureCollection *)places
                 near:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
               within:(double)radius
{
    NSLog(@"in didLoadPlaces, radius = %f", radius);
    if (radius > 0.0f) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEquals([places count], (NSUInteger) 1, @"Should have been 1 place.");
        GHAssertEqualObjects([[[[places features] objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Mountain Sun Pub & Brewery", nil);
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearWithRadiusAndMultipleResults)];
    } else if (!query && !category) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEquals([places count], (NSUInteger) 7, @"Should have been 7 places.");
        GHAssertEqualObjects([[[[places features] objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Burger Master West Olympia", nil);
        GHAssertEqualObjects([[[[places features] objectAtIndex:1] properties] objectForKey:@"name"],
                             @"Red Robin Gourmet Burgers", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearWithMultipleResults)];
    } else if ([query isEqual:@"one"]) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEqualObjects(query, @"one", nil);
        GHAssertEquals([places count], (NSUInteger) 1, @"Should have been 1 place.");
        NSArray *features = [places features];
        GHAssertEqualObjects([[[features objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Burger Master West Olympia", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearMatchingWithASingleResult)];
    } else if ([query isEqual:@"burgers"]) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEqualObjects(query, @"burgers", nil);
        GHAssertEqualObjects(category, @"Restaurants", nil);
        GHAssertEquals([places count], (NSUInteger) 7, @"Should have been 7 places.");
        NSArray *features = [places features];
        GHAssertEqualObjects([[[features objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Burger Master West Olympia", nil);
        GHAssertEqualObjects([[[[places features] objectAtIndex:1] properties] objectForKey:@"name"],
                             @"Red Robin Gourmet Burgers", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearMatchingInCategory)];
    }
}

- (void)didUpdatePlace:(NSString *)handle
                 token:(NSString *)token
{
    GHAssertEqualObjects(handle, @"SG_4CsrE4oNy1gl8hCLdwu0F0_47.046962_-122.937467@1290636830", nil);
    GHAssertEqualObjects(token, @"79ea18ccfc2911dfa39058b035fcf1e5", nil);

    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testUpdatePlace)];
}

@end
