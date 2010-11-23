//
//  SGAPIClientTest.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "SGAPIClient.h"


NSString * const TEST_URL_PREFIX = @"http://localhost:4567/";


@interface SGAPIClientTest : GHAsyncTestCase <SGAPIClientDelegate> { }
@end


@implementation SGAPIClientTest

- (BOOL)shouldRunOnMainThread
{
    return NO;
}

#pragma mark Utility Methods

- (SGAPIClient *)createClient
{
    NSURL *url = [NSURL URLWithString:TEST_URL_PREFIX];
    return [[SGAPIClient clientWithDelegate:self
                                consumerKey:@""
                             consumerSecret:@""
                                        URL:url] retain];
}

- (SGPoint *)point
{
    return [[SGPoint pointWithLatitude:40.0 longitude:-105.0] retain];
}

#pragma mark Tests

- (void)testCreateWithDefaultURL
{
    NSURL *url = [NSURL URLWithString:SIMPLEGEO_URL_PREFIX];
    GHTestLog(@"SimpleGeo URL prefix: %@", SIMPLEGEO_URL_PREFIX);
    SGAPIClient *client = [SGAPIClient clientWithDelegate:self
                                              consumerKey:@""
                                           consumerSecret:@""];

    GHAssertEqualObjects([client url], url, @"URLs don't match.");
}

- (void)testCreateWithURL
{
    NSURL *url = [NSURL URLWithString:TEST_URL_PREFIX];
    SGAPIClient *client = [SGAPIClient clientWithDelegate:self
                                              consumerKey:@""
                                           consumerSecret:@""
                                                      URL:url];

    GHAssertEqualObjects([client url], url, @"URLs don't match.");
}

#pragma mark Async Tests

- (void)testGetFeatureWithId
{
    [self prepare];

    SGAPIClient *client = [self createClient];

    [client getFeatureWithId:@"foo"];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.25];
}

- (void)testGetFeatureWithIdShouldCallRequestDidFinish
{
    [self prepare];

    SGAPIClient *client = [self createClient];

    [client getFeatureWithId:@"requestDidFinish"];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.25];
}

- (void)testGetPlacesNearWithMultipleResults
{
    [self prepare];

    [[self createClient] getPlacesNear:[self point]];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.25];
}

- (void)testGetPlacesNearMatchingWithASingleResult
{
    [self prepare];

    [[self createClient] getPlacesNear:[self point] matching:@"one"];

    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:0.25];
}

#pragma mark SGAPIClientDelegate Methods

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
    NSLog(@"requestDidFinish: %@", [request userInfo]);
    if ([[[request userInfo] objectForKey:@"featureId"] isEqual:@"requestDidFinish"]) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetFeatureWithIdShouldCallRequestDidFinish)];
    }
}

- (void)didLoadFeature:(SGFeature *)feature
                withId:(NSString *)featureId
{
    if ([featureId isEqual:@"foo"]) {
        GHAssertEqualObjects(featureId, @"foo", nil);

        GHAssertEquals([[feature geometry] latitude], 37.77241, nil);
        GHAssertEquals([[feature geometry] longitude], -122.40593, nil);

        GHAssertEqualObjects([[feature properties] objectForKey:@"name"], @"SimpleGeo San Francisco", nil);

        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetFeatureWithId)];
    }
}

- (void)didLoadPlaces:(NSArray *)places
                 near:(SGPoint *)point
{
    // TODO currently expects to only be triggered by testGetPlacesNearWithMultipleResults
    GHAssertEqualObjects(point, [self point], @"Reference point didn't match");
    GHAssertEquals([places count], (NSUInteger) 2, @"Should have been 2 places.");
    GHAssertEqualObjects([[[places objectAtIndex:0] properties] objectForKey:@"name"],
                         @"SimpleGeo Boulder", nil);
    GHAssertEqualObjects([[[places objectAtIndex:1] properties] objectForKey:@"name"],
                         @"SimpleGeo San Francisco", nil);

    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testGetPlacesNearWithMultipleResults)];
}

- (void)didLoadPlaces:(NSArray *)places
                 near:(SGPoint *)point
             matching:(NSString *)query;
{
    // TODO currently expects to only be triggered by testGetPlacesNearMatchingWithASingleResult
    GHAssertEquals([places count], (NSUInteger) 1, @"Should have been 1 place.");
    GHAssertEqualObjects([[[places objectAtIndex:0] properties] objectForKey:@"name"],
                         @"SimpleGeo Boulder", nil);

    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testGetPlacesNearMatchingWithASingleResult)];
}

@end
