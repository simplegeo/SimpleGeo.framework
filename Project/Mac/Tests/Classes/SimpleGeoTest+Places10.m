//
//  SimpleGeoTest+Places10.m
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

#define SGTestPlacesEditLatitude 22.917923
#define SGTestPlacesEditLongitude -125.859375
#define SGTestPlaceID @"SG_7gm91gq6GfsVja5zFsRz6x_37.771718_-122.405139"
#define SGTestPlacesRadius 1.0 // km
#define SGTestPlaceSearchString @"SimpleGeo"
#define SGTestPlaceCategory SGPlaceCategoryOfficeBuilding

@interface Places10Tests : SimpleGeoTest
@end
@implementation Places10Tests

#pragma mark Set Up Places 1.0

- (SimpleGeo *)client
{
    SimpleGeo *client = super.client;
    [client setPlacesVersion:@"1.0"];
    return client;
}

#pragma mark Places Add/Update Tests

- (void)testAddDeletePlace
{
    [self prepare];
    SGPlace *place = [SGPlace placeWithName:@"Simple Place"
                                      point:[SGPoint pointWithLat:SGTestPlacesEditLatitude
                                                              lon:SGTestPlacesEditLongitude]];
    NSDictionary *classifier1 = [NSDictionary classifierWithType:SGFeatureTypePublicPlace
                                                        category:SGPlaceCategoryArtsAndPerformance
                                                     subcategory:SGPlaceCategoryArena];
    NSDictionary *classifier2 = [NSDictionary classifierWithType:SGFeatureTypePublicPlace
                                                        category:SGPlaceCategoryPark
                                                     subcategory:SGPlaceCategoryShopping];
    [place setClassifiers:[NSMutableArray arrayWithObjects:classifier1, classifier2, nil]];
    [place setTags:[NSArray arrayWithObjects:@"tag1", @"tag2", @"tag3", nil]];
    [[self client] addPlace:place
                   callback:[SGCallback callbackWithSuccessBlock:
                             ^(id response) {
                                 [self prepare];
                                 [[self client] deletePlace:[(NSDictionary *)response objectForKey:@"id"]
                                                   callback:[SGCallback callbackWithSuccessBlock:
                                                             ^(id response) {
                                                                 [self requestDidSucceed:response];
                                                             } failureBlock:[self failureBlock]]];
                                 [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
                             } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

#pragma mark Places Requests Tests

- (void)testGetSGPlaceAndConvertFeature
{
    [self prepare];
    [[self client] getFeatureWithHandle:SGTestPlaceID
                                   zoom:nil
                               callback:[SGCallback callbackWithSuccessBlock:
                                         ^(id response) {
                                             SGPlace *place = [SGPlace placeWithGeoJSON:(NSDictionary *)response];
                                             [self checkSGFeatureConversion:(NSDictionary *)response object:place];
                                             [self requestDidSucceed:response];
                                         } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetSGPlacesForPoint
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [[self client] getPlacesForQuery:query callback:[SGCallback callbackWithSuccessBlock:
                                                     ^(id response) {
                                                         GHAssertGreaterThan((int)[[response objectForKey:@"features"] count], 1,
                                                                             @"Query should return at least one feature.");
                                                         [self requestDidSucceed:response];
                                                     } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetSGPlacesForAddress
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithAddress:SGTestAddress];
    [[self client] getPlacesForQuery:query callback:[SGCallback callbackWithSuccessBlock:
                                                     ^(id response) {
                                                         GHAssertGreaterThan((int)[[response objectForKey:@"features"] count], 1,
                                                                             @"Query should return at least one feature.");
                                                         [self requestDidSucceed:response];
                                                     } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetSGPlacesForEnvelope
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithEnvelope:[self envelope]];
    [[self client] getPlacesForQuery:query callback:[SGCallback callbackWithSuccessBlock:
                                                     ^(id response) {
                                                         GHAssertGreaterThan((int)[[response objectForKey:@"features"] count], 1,
                                                                             @"Query should return at least one feature.");
                                                         [self requestDidSucceed:response];
                                                     } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetSGPlacesWithFilters
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [query setCategories:[NSArray arrayWithObject:SGTestPlaceCategory]];
    [query setSearchString:SGTestPlaceSearchString];
    [[self client] getPlacesForQuery:query
                            callback:[SGCallback callbackWithSuccessBlock:
                                      ^(id response) {
                                          GHAssertEquals((int)[[response objectForKey:@"features"] count], 1,
                                                         @"Query should return one matching place.");
                                          [self requestDidSucceed:response];
                                      } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetSGPlacesWithLimitsAndConvertFeatureCollection
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [query setRadius:SGTestPlacesRadius];
    [query setLimit:SGTestLimit];
    [[self client] getPlacesForQuery:query
                            callback:[SGCallback callbackWithSuccessBlock:
                                      ^(id response) {
                                          NSArray *places = [NSArray arrayWithSGCollection:(NSDictionary *)response type:SGCollectionTypePlaces];
                                          GHAssertEquals((int)[places count], SGTestLimit, @"Query should return the limit.");
                                          [self checkSGCollectionConversion:(NSDictionary *)response type:SGCollectionTypePlaces];
                                          [self requestDidSucceed:response];
                                      } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

@end
