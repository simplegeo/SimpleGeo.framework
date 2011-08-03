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

#define SGTestPlacesLatitude 22.917923
#define SGTestPlacesLongitude -125.859375

#pragma mark Places Add/Update Tests

@interface PlacesEditTests : SimpleGeoTest
@end
@implementation PlacesEditTests

- (void)testAddDeletePlace
{
    [self prepare];
    SGPlace *place = [SGPlace placeWithName:@"Simple Place"
                                      point:[SGPoint pointWithLat:SGTestPlacesLatitude
                                                              lon:SGTestPlacesLongitude]];
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

@end

#pragma mark Places Requests Tests

@interface PlacesGetTests : SimpleGeoTest
@end
@implementation PlacesGetTests

- (void)testGetPlacesForPoint
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [[self client] getPlacesForQuery:query callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetPlacesForAddress
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithAddress:SGTestAddress];
    [[self client] getPlacesForQuery:query callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

/*
COMING SOON
- (void)testGetPlacesForEnvelope
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithEnvelope:[self envelope]];
    [[self client] getPlacesForQuery:query callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}*/

- (void)testGetPlacesWithLimitsAndConvertFeatureCollection
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [query setRadius:SGTestRadius];
    [query setLimit:SGTestLimit];
    [[self client] getPlacesForQuery:query
                            callback:[SGCallback callbackWithSuccessBlock:
                                      ^(id response) {
                                          GHTestLog(@"%@",response);
                                          NSArray *places = [NSArray arrayWithSGCollection:(NSDictionary *)response type:SGCollectionTypePlaces];
                                          GHTestLog(@"%d %@",(int)[places count],places);
                                          GHAssertEquals((int)[places count], SGTestLimit, @"query should return the limit");
                                          [self checkSGCollectionConversion:(NSDictionary *)response type:SGCollectionTypePlaces];
                                          [self requestDidSucceed:response];
                                      } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetPlacesWithFilters
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [query setCategories:[NSArray arrayWithObject:SGPlaceSubcategoryOfficeBuilding]];
    [query setSearchString:@"SimpleGeo"];
    [[self client] getPlacesForQuery:query
                            callback:[SGCallback callbackWithSuccessBlock:
                                      ^(id response) {
                                          NSArray *places = [NSArray arrayWithSGCollection:(NSDictionary *)response type:SGCollectionTypePlaces];
                                          GHAssertEquals((int)[places count], 1, @"query should return one matching place");
                                          [self requestDidSucceed:response];
                                      } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

@end
