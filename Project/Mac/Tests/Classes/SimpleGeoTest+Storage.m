//
//  SimpleGeoTest+Storage.m
//  SimpleGeo.framework
//
//  Copyright (c) 2011, SimpleGeo Inc.
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
#import "SimpleGeo+Storage.h"
#import "NSArray+SGCollection.h"

#define SGTestRecordID @"Simple Test Record"
#define SGTestLayer @"com.simplegeo.testing.ios"
#define SGTestNumRecords 4
#define SGTestLayersCursor @"ImVkdS5jb2x1bWJpYS5jaWVzaW4uZ3B3My5wZGVucy4yMDEwYSI="
#define SGTestPropStringKey @"stringKey"
#define SGTestPropStringValue @"stringValue"
#define SGTestPropNumberKey @"numKey"
#define SGTestPropNumberValue [NSNumber numberWithDouble:1.2345]
#define SGTestPropBooleanKey @"boolKey"
#define SGTestPropBooleanValue [NSNumber numberWithBool:YES]

#pragma mark Storage Test Data

@interface SimpleGeoTest (StorageData)
@end
@implementation SimpleGeoTest (StorageData)

- (SGStoredRecord *)recordSimple
{
    return [SGStoredRecord recordWithID:SGTestRecordID
                                  point:[self point]
                                  layer:SGTestLayer];
}

- (SGStoredRecord *)recordSimpleMoved
{
    return [SGStoredRecord recordWithID:SGTestRecordID
                                  point:[self outlierPoint]
                                  layer:SGTestLayer];
}

- (SGStoredRecord *)recordWithCreationDate
{
    SGStoredRecord *record = [SGStoredRecord recordWithID:@"Test Record With Creation Date"
                                                    point:[self point]
                                                    layer:SGTestLayer];
    [record setCreated:[NSDate dateWithTimeIntervalSince1970:12345]];
    return record;
}

- (SGStoredRecord *)recordWithProperties
{
    SGStoredRecord *record = [SGStoredRecord recordWithID:@"Test Record With Properties"
                                                    point:[self point]
                                                    layer:SGTestLayer];
    [record setProperties:[NSDictionary dictionaryWithObjectsAndKeys:
                           SGTestPropStringValue, SGTestPropStringKey,
                           SGTestPropNumberValue, SGTestPropNumberKey,
                           SGTestPropBooleanValue, SGTestPropBooleanKey,
                           nil]];
    return record;
}

- (SGStoredRecord *)recordWithFakeProperties
{
    SGStoredRecord *record = [SGStoredRecord recordWithID:@"Test Record With Fake Properties"
                                                    point:[self point]
                                                    layer:SGTestLayer];
    [record setProperties:[NSDictionary dictionaryWithObjectsAndKeys:
                           @"fake", SGTestPropStringKey,
                           [NSNumber numberWithInt:69], SGTestPropNumberKey,
                           [NSNumber numberWithBool:NO], SGTestPropBooleanKey,
                           nil]];
    return record;
}

- (SGLayer *)layer
{
    return [SGLayer layerWithName:SGTestLayer
                            title:@"Temporary iOS Test Layer"
                      description:@"SimpleGeo iOS client test layer"
                     callbackURLs:[NSArray arrayWithObject:@"http://simplegeo.com"]];
}

@end

#pragma mark Storage Add/Update Tests

@interface StorageAddTests : SimpleGeoTest
@end
@implementation StorageAddTests

- (void)testAddLayer
{
    [self prepare];
    [[self client] addOrUpdateLayer:[self layer] callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testAddedLayerUpdate
{
    [self prepare];
    SGLayer *layer = [self layer];
    [layer setDescription:@"updated!"];
    [layer setCallbackURLs:nil];
    [[self client] addOrUpdateLayer:layer callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testAddRecord
{
    [self prepare];
    [[self client] addOrUpdateRecord:[self recordSimple]
                            callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testAddUpdateRecords
{
    [self prepare];
    NSArray *records = [NSArray arrayWithObjects:
                        [self recordSimpleMoved],
                        [self recordWithCreationDate],
                        [self recordWithProperties],
                        [self recordWithFakeProperties],
                        nil];
    [[self client] addOrUpdateRecords:records
                              inLayer:SGTestLayer
                             callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

@end

#pragma mark Storage Requests Tests

@interface StorageGetTests : SimpleGeoTest
@end
@implementation StorageGetTests

- (void)testGetRecordAndConvert
{
    [self prepare];
    [[self client] getRecord:[self recordSimple].identifier
                     inLayer:SGTestLayer
                    callback:[SGCallback callbackWithSuccessBlock:
                              ^(id response) {
                                  SGStoredRecord *record = [SGStoredRecord recordWithGeoJSON:(NSDictionary *)response];
                                  SGLog(@"SGStoredRecord: %@", record);
                                  NSMutableDictionary *recordDict = [NSMutableDictionary dictionaryWithDictionary:response];
                                  [self removeAPISpecificKeys:recordDict];
                                  GHAssertEqualObjects(recordDict, [record asGeoJSON],
                                                       @"Record's GeoJSON should match response geoJSON");
                                  [self requestDidSucceed:response];
                              } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordsForPointAndConvertRecordCollection
{
    [self prepare];
    SGStorageQuery *query = [SGStorageQuery queryWithPoint:[self point] layer:SGTestLayer];
    [[self client] getRecordsForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           GHAssertEquals((int)[[(NSDictionary *)response objectForKey:@"features"] count], SGTestNumRecords,
                                                          @"Should return all records");
                                           [self checkSGCollectionConversion:response type:SGCollectionTypeRecords];
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordsForAddress
{
    [self prepare];
    SGStorageQuery *query = [SGStorageQuery queryWithAddress:SGTestAddress layer:SGTestLayer];
    [[self client] getRecordsForQuery:query callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordsForEnvelope
{
    [self prepare];
    SGStorageQuery *query = [SGStorageQuery queryWithEnvelope:[self envelope] layer:SGTestLayer];
    SGSuccessBlock sBlock = ^(id response) {
        NSArray *features = [response objectForKey:@"features"];
        GHAssertNotNil(features, @"the feature collection should contain features");
        GHAssertTrue([features count] > 0, @"there should be more than 0 features");
        [self notify:kGHUnitWaitStatusSuccess];
    };
    
    SGFailureBlock fBlock = ^(NSError *error) {
        GHTestLog(@"%@", error);
        [self notify:kGHUnitWaitStatusFailure];
    };
    
    [[self client] getRecordsForQuery:query callback:[SGCallback callbackWithSuccessBlock:sBlock failureBlock:fBlock]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordsWithLimit
{
    [self prepare];
    SGStorageQuery *query = [SGStorageQuery queryWithPoint:[self point] layer:SGTestLayer];
    [query setLimit:SGTestLimit];
    [[self client] getRecordsForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           GHAssertLessThanOrEqual((int)[[(NSDictionary *)response objectForKey:@"features"] count],
                                                                   SGTestLimit, @"Should return no more records than the limit");
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordsWithRadius
{
    [self prepare];
    SGStorageQuery *query = [SGStorageQuery queryWithPoint:[self point] layer:SGTestLayer];
    [query setRadius:SGTestRadius];
    [[self client] getRecordsForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           GHAssertEquals((int)[[(NSDictionary *)response objectForKey:@"features"] count],
                                                          SGTestNumRecords-1, @"Should omit outlier record");
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordsInDateRange
{
    [self prepare];
    SGStorageQuery *query = [SGStorageQuery queryWithPoint:[self point] layer:SGTestLayer];
    [query setDateRangeFrom:[[self recordWithCreationDate].created dateByAddingTimeInterval:-1]
                         to:[[self recordWithCreationDate].created dateByAddingTimeInterval:1]];
    [[self client] getRecordsForQuery:query
                             callback:[SGCallback callbackWithSuccessBlock:
                                       ^(id response) {
                                           GHAssertEquals((int)[[(NSDictionary *)response objectForKey:@"features"] count],
                                                          1, @"Should return single matching record");
                                           [self requestDidSucceed:response];
                                       } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordHistoryAndConvertGeometryCollection
{
    [self prepare];
    [[self client] getHistoryForRecord:SGTestRecordID
                               inLayer:SGTestLayer
                                 limit:[NSNumber numberWithInt:1]
                                cursor:nil
                              callback:[SGCallback callbackWithSuccessBlock:
                                        ^(id response) {
                                            NSObject *cursor = [(NSDictionary *)response objectForKey:@"next_cursor"];
                                            if ([cursor isKindOfClass:[NSString class]]) [self setRecordHistoryCursor:(NSString *)cursor];
                                            GHAssertGreaterThan((int)[[(NSDictionary *)response objectForKey:@"geometries"] count], 0,
                                                                @"Should return at least one geometry");
                                            GHAssertLessThanOrEqual((int)[[(NSDictionary *)response objectForKey:@"geometries"] count],
                                                                   SGTestLimit, @"Should return no more history records than the limit");
                                            [self checkSGCollectionConversion:response type:SGCollectionTypePoints];
                                            [self requestDidSucceed:response];
                                        } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetRecordHistoryWithCursor
{
    [self prepare];
    [[self client] getHistoryForRecord:SGTestRecordID
                               inLayer:SGTestLayer
                                 limit:nil
                                cursor:self.recordHistoryCursor
                              callback:[SGCallback callbackWithSuccessBlock:
                                        ^(id response) {
                                            GHAssertGreaterThan((int)[[(NSDictionary *)response objectForKey:@"geometries"] count], 0,
                                                                @"Should return at least one geometry");
                                            [self requestDidSucceed:response];
                                        } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

#pragma mark Layers Request Tests

- (void)testGetLayer
{
    [self prepare];
    [[self client] getLayer:SGTestLayer callback:[SGCallback callbackWithSuccessBlock:
                                                  ^(id response) {
                                                      SGLayer *layer = [SGLayer layerWithDictionary:(NSDictionary *)response];
                                                      SGLog(@"SGLayer: %@", layer);
                                                      GHAssertEqualObjects(response, [layer asDictionary],
                                                                           @"Layers's JSON should match response JSON");
                                                      [self requestDidSucceed:response];
                                                  } failureBlock:[self failureBlock]]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetLayers
{
    [self prepare];
    [[self client] getLayersWithCallback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)testGetLayersWithCursor
{
    [self prepare];
    [[self client] getLayersWithCursor:SGTestLayersCursor callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

@end

#pragma mark Storage Delete Tests

@interface StorageRemoveTests : SimpleGeoTest
@end
@implementation StorageRemoveTests

- (void)test_DeleteRecord
{
    [self prepare];
    [[self client] deleteRecord:SGTestRecordID
                        inLayer:SGTestLayer
                       callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

- (void)test__DeleteLayer
{
    [self prepare];
    [[self client] deleteLayer:@"com.simplegeo.testing.ios"
                      callback:[self delegateCallbacks]];
    [self waitForStatus:kGHUnitWaitStatusSuccess timeout:SGTestTimeout];
}

@end
