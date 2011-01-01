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

    [[self createClient] addPlace:feature
                          private:NO];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testAddPlacePrivately
{
    [self prepare];

    SGPoint *geometry = [self point];
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Mike's Bike Shed", @"name",
                                nil];
    SGFeature *feature = [SGFeature featureWithGeometry:geometry
                                             properties:properties];

    [[self createClient] addPlace:feature
                          private:YES];

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
                              matching:@"öne"];

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

- (void)testGetPlacesNearAddress
{
    [self prepare];

    [[self createClient] getPlacesNearAddress:@"41 Decatur St., San Francisco, CA"];

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
                                with:feature
                             private:NO];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testUpdatePlacePrivately
{
    [self prepare];

    NSString *handle = @"SG_4CsrE4oNy1gl8hCLdwu0F0_47.046962_-122.937467@1290636830";

    SGFeature *feature = [SGFeature featureWithId:handle
                                       properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                   @"Mike's Bike Shed", @"name",
                                                   nil]];

    [[self createClient] updatePlace:handle
                                with:feature
                             private:YES];

    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

#pragma mark SimpleGeoPlaceDelegate Methods

- (void)didAddPlace:(SGFeature *)feature
             handle:(NSString *)handle
                URL:(NSURL *)url
              token:(NSString *)token
{
    if ([[[feature properties] objectForKey:@"name"] isEqual:@"Mike's Burger Shack"]) {
        NSArray *handleComponents = [handle componentsSeparatedByString:@"@"];
        GHAssertEqualObjects([handleComponents objectAtIndex:0],
                             @"SG_07624b34159916851f3df2a0657f6ab5b9af962a_40_-105", nil);
        GHAssertEqualObjects(token, @"596499b4fc2a11dfa39058b035fcf1e5", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testAddPlace)];
    } else if ([[[feature properties] objectForKey:@"name"] isEqual:@"Mike's Bike Shed"]) {
        GHAssertEqualObjects(token, @"0ff119100e1811e0b72e58b035fcf1e5", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testAddPlacePrivately)];
    }
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
             forQuery:(NSDictionary *)query
{
    SGPoint *point = [query objectForKey:@"point"];
    NSString *address = [query objectForKey:@"address"];
    NSString *matching = [query objectForKey:@"matching"];
    NSString *category = [query objectForKey:@"category"];
    double radius = [[query objectForKey:@"radius"] doubleValue];

    if (radius > 0.0f) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEquals([places count], (NSUInteger) 1, @"Should have been 1 place.");
        GHAssertEqualObjects([[[[places features] objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Mountain Sun Pub & Brewery", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearWithRadiusAndMultipleResults)];
    } else if (!address && !matching && !category) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEquals([places count], (NSUInteger) 7, @"Should have been 7 places.");
        GHAssertEqualObjects([[[[places features] objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Burger Master West Olympia", nil);
        GHAssertEqualObjects([[[[places features] objectAtIndex:1] properties] objectForKey:@"name"],
                             @"Red Robin Gourmet Burgers", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearWithMultipleResults)];
    } else if ([matching isEqual:@"öne"]) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEqualObjects(matching, @"öne", nil);
        GHAssertEquals([places count], (NSUInteger) 1, @"Should have been 1 place.");
        NSArray *features = [places features];
        GHAssertEqualObjects([[[features objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Burger Master West Olympia", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearMatchingWithASingleResult)];
    } else if ([matching isEqual:@"burgers"]) {
        GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
        GHAssertEqualObjects(matching, @"burgers", nil);
        GHAssertEqualObjects(category, @"Restaurants", nil);
        GHAssertEquals([places count], (NSUInteger) 7, @"Should have been 7 places.");
        NSArray *features = [places features];
        GHAssertEqualObjects([[[features objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Burger Master West Olympia", nil);
        GHAssertEqualObjects([[[[places features] objectAtIndex:1] properties] objectForKey:@"name"],
                             @"Red Robin Gourmet Burgers", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearMatchingInCategory)];
    } else if (address) {
        GHAssertEqualObjects(address, @"41 Decatur St., San Francisco, CA", @"Reference address didn't match");
        GHAssertEquals([places count], (NSUInteger) 1, @"Should have been 1 place.");
        GHAssertEqualObjects([[[[places features] objectAtIndex:0] properties] objectForKey:@"name"],
                             @"Mountain Sun Pub & Brewery", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetPlacesNearAddress)];
    }
}

- (void)didUpdatePlace:(SGFeature *)feature
                handle:(NSString *)handle
                 token:(NSString *)token
{
    if ([[[feature properties] objectForKey:@"name"] isEqual:@"Mike's Burger Shack"]) {
        GHAssertEqualObjects(handle, @"SG_4CsrE4oNy1gl8hCLdwu0F0_47.046962_-122.937467@1290636830", nil);
        GHAssertEqualObjects(token, @"79ea18ccfc2911dfa39058b035fcf1e5", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testUpdatePlace)];
    } else if ([[[feature properties] objectForKey:@"name"] isEqual:@"Mike's Bike Shed"]) {
        GHAssertEqualObjects(token, @"3489de320e1911e0b72e58b035fcf1e5", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testUpdatePlacePrivately)];
    }
}

@end
