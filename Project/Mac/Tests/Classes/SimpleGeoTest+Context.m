//
//  SimpleGeoTest+Context.m
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
#import "SimpleGeo+Context.h"
#import "NSArray+SGCollection.h"

#pragma mark Context Test Data

@interface SimpleGeoTest (ContextData)
@end
@implementation SimpleGeoTest (ContextData)

- (NSMutableArray *)contextFilters
{
    return [NSMutableArray arrayWithObjects:SGContextFilterWeather, SGContextFilterIntersections, nil];
}

- (NSArray *)contextCategories
{
    return [NSMutableArray arrayWithObjects:SGFeatureCategoryNational, SGFeatureCategoryTimeZone, nil];
}

- (NSArray *)contextSubcategories
{
    return [NSMutableArray arrayWithObjects:SGFeatureSubcategoryCounty, SGFeatureSubcategoryState, nil];
}

- (NSArray *)contextDemographicsTables
{
    return [NSMutableArray arrayWithObjects:@"B01001", @"B01002", nil];
}

@end

#pragma mark Context Requests Tests

@interface ContextTests : SimpleGeoTest
@end
@implementation ContextTests

- (void)testGetContextForPoint
{
    [self prepare];
    SGContextQuery *query = [SGContextQuery queryWithPoint:[self point]];
    [[self client] getContextForQuery:query callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetContextForAddress
{
    [self prepare];
    SGContextQuery *query = [SGContextQuery queryWithAddress:SGTestAddress];
    [[self client] getContextForQuery:query callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetContextForEnvelope
{
    [self prepare];
    SGContextQuery *query = [SGContextQuery queryWithEnvelope:[self envelope]];
    [[self client] getContextForQuery:query callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetContextWithFilters
{
    [self prepare];
    SGContextQuery *query = [SGContextQuery queryWithPoint:[self point]];
    [query setFilters:[self contextFilters]];
    [[self client] getContextForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           GHAssertEquals([query.filters count]+2, [(NSDictionary *)response count],
                                                          @"Response should contain only filtered parts");
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetContextWithFeatureCategories
{
    [self prepare];
    SGContextQuery *query = [SGContextQuery queryWithPoint:[self point]];
    [query setFeatureCategories:[self contextCategories]];
    [[self client] getContextForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           GHAssertEquals([query.featureCategories count], [[(NSDictionary *)response objectForKey:@"features"] count],
                                                          @"Response should contain only features with specified categories");
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetContextWithFeatureSubcategories
{
    [self prepare];
    SGContextQuery *query = [SGContextQuery queryWithPoint:[self point]];
    [query setFeatureSubcategories:[self contextSubcategories]];
    [[self client] getContextForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           GHAssertEquals([query.featureSubcategories count], [[(NSDictionary *)response objectForKey:@"features"] count],
                                                          @"Response should contain only features with specified subcategories");
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetContextWithDemographics
{
    [self prepare];
    SGContextQuery *query = [SGContextQuery queryWithPoint:[self point]];
    [query setAcsTableIDs:[self contextDemographicsTables]];
    [[self client] getContextForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           for (NSString *table in [query acsTableIDs]) {
                                               GHAssertNotNil([[[(NSDictionary *)response objectForKey:@"demographics"] objectForKey:@"acs"] objectForKey:table],
                                                              @"Response should contain specified demographics tables");
                                           }
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

@end
