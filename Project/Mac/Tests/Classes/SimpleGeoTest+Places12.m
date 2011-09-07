//
//  SimpleGeoTest+Places12.m
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

#define SGTestPlaceID @"00000ba3-164c-45f9-b232-2bc5aac8f72a"
#define SGTestPlaceSearchString @"Repair"
#define SGTestPlaceCategory [NSArray arrayWithObject:@"Automotive"]
#define SGTestPlaceFullTextSearchString @"Maggianos"

@interface Places12Tests : SimpleGeoTest
@end
@implementation Places12Tests

#pragma mark Set Up Places 1.2

- (SimpleGeo *)client
{
    SimpleGeo *client = super.client;
    [client setPlacesVersion:@"1.2"];
    return client;
}

#pragma mark Places Requests Tests

- (void)testGetFactualPlaceAndConvert
{
    [self prepare];
    [[self client] getPlace:SGTestPlaceID
                   callback:[SGCallback callbackWithSuccessBlock:
                             ^(id response) {
                                 SGPlace *place = [SGPlace placeWithGeoJSON:(NSDictionary *)response];
                                 [self checkSGFeatureConversion:(NSDictionary *)response object:place];
                                 [self requestDidSucceed:response];
                             } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetFactualPlacesForPoint
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

- (void)testGetFactualPlacesForAddress
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

- (void)testGetFactualPlacesForEnvelope
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

- (void)testGetFactualPlacesWithFilters
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [query setCategories:SGTestPlaceCategory];
    [query setSearchString:SGTestPlaceSearchString];
    [[self client] getPlacesForQuery:query
                            callback:[SGCallback callbackWithSuccessBlock:
                                      ^(id response) {
                                          GHAssertGreaterThan((int)[[response objectForKey:@"features"] count], 1,
                                                              @"Query should return at least one feature.");
                                          [self requestDidSucceed:response];
                                      } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetFactualPlacesWithLimitsAndConvertFeatureCollection
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery queryWithPoint:[self point]];
    [query setRadius:SGTestRadius];
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

- (void)testFactualPlacesFulltextSearch
{
    [self prepare];
    SGPlacesQuery *query = [SGPlacesQuery query];
    [query setSearchString:SGTestPlaceFullTextSearchString];
    [[self client] getPlacesForQuery:query
                            callback:[SGCallback callbackWithSuccessBlock:
                                      ^(id response) {
                                          NSArray *places = [NSArray arrayWithSGCollection:(NSDictionary *)response type:SGCollectionTypePlaces];
                                          GHAssertGreaterThan((int)[places count], 1, @"Query should return at least one matching place.");
                                          [self requestDidSucceed:response];
                                      } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

@end
