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
#import "SGPoint.h"


@implementation SimpleGeoTest (Storage)

- (void)testAddOrUpdateRecord
{
    [self prepare];
    SGPoint *geometry = [self point];
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Mike's Burger Shack", @"name",
                                nil];
    SGFeature *feature = [SGFeature featureWithId:@"Car"
                                         geometry:geometry
                                       properties:properties];
    NSTimeInterval created = 2000;
    SGStoredRecord *record = [SGStoredRecord recordWithFeature:feature
                                              createdTimestamp:created
                                                         layer:@"mojodna.test"];
    [[self createClient] addOrUpdateRecord:record
                                   inLayer:@"mojodna.test" ];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testAddOrUpdateRecords
{
    [self prepare];
    SGPoint *geometry = [self point];
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"Mike's Burger Shack", @"name",
                                nil];
    SGFeature *feature = [SGFeature featureWithGeometry:geometry
                                             properties:properties];
    NSTimeInterval created = 2000;
    SGStoredRecord *record = [SGStoredRecord recordWithFeature:feature
                                              createdTimestamp:created
                                                         layer:@"layer1"];
    SGFeature *feature2 = [SGFeature featureWithGeometry:geometry
                                              properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          @"Shrek", @"name",
                                                          nil]];
    SGStoredRecord *record2 = [SGStoredRecord recordWithFeature:feature2
                                                          layer:@"mojodna.test"];
    [[self createClient] addOrUpdateRecords:[NSArray arrayWithObjects:
                                             record,
                                             record2,
                                             nil]
                                     inLayer:@"mojodna.test"];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testDeleteRecordInLayer
{
    [self prepare];
    [[self createClient] deleteRecordInLayer:@"mojodna.test"
                                      withId:@"boulder" ];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordFromLayer
{
    [self prepare];
    [[self createClient] getRecordFromLayer:@"mojodna.test"
                                     withId:@"simplegeo-boulder"];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayer
{
    [self prepare];
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                                      near:[self point]];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

#pragma mark Methods for testing by point

- (void)testGetRecordsInLayerNearPointWithRadius
{
    [self prepare];
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                                      near:[self point]
                                    radius:1.5];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearPoinWithCount
{
    [self prepare];
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                                      near:[self point]
                                     count:2];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearPoinWithRadiusAndCount
{
        [self prepare];
        [[self createClient] getRecordsInLayer:@"mojodna.test"
                                          near:[self point]
                                        radius:1.5
                                         count:3];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearPoinWithCursor
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                                      near:[self point]
                                    cursor:cursor];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearPoinWithRadiusAndCursor
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                                      near:[self point]
                                    radius:1.5
                                    cursor:cursor];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearPoinWithRadiusCursorAndCount
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                                      near:[self point]
                                    radius:1.5
                                    cursor:cursor
                                     count:4];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearPoinWithCursorAndCount
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                                      near:[self point]
                                    cursor:cursor
                                     count:4];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

#pragma mark Methods for Testing by address

- (void)testGetRecordsInLayerNearAddress
{
    [self prepare];
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearAddressWithRadius
{
    [self prepare];
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"
                                    radius:1.5];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearAddressWithCount
{
    [self prepare];
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"
                                     count:4];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearAddressWithRadiusAndCount
{
    [self prepare];
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"
                                    radius:1.5
                                     count:4];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearAddressWithCursor
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"
                                    cursor:cursor];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearAddressWithRadiusAndCursor
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"
                                    radius:1.5
                                    cursor:cursor];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearAddressWithRadiusCursorAndCount
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"
                                    radius:1.5
                                    cursor:cursor
                                     count:4];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetRecordsInLayerNearAddressWithCursorAndCount
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getRecordsInLayer:@"mojodna.test"
                               nearAddress:@"SiliconValley"
                                    cursor:cursor
                                     count:4];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

#pragma mark Testing Record History

- (void)testGetHistoryForRecordIdInLayer
{
    [self prepare];
    [[self createClient] getHistoryForRecordId:@"com.test.simplegeo"
                                       inLayer:@"mojodna.test"];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetHistoryForRecordIdInLayerWithCount
{
    [self prepare];
    [[self createClient] getHistoryForRecordId:@"com.test.simplegeo"
                                       inLayer:@"mojodna.test"
                                         count:3];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetHistoryForRecordIdInLayerWithCursor
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getHistoryForRecordId:@"com.test.simplegeo"
                                       inLayer:@"mojodna.test"
                                        cursor:cursor];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetHistoryForRecordIdInLayerWithCursorAndCount
{
    [self prepare];
    NSString *cursor = @"page1";
    [[self createClient] getHistoryForRecordId:@"com.test.simplegeo"
                                       inLayer:@"mojodna.test"
                                        cursor:cursor
                                         count:3];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

#pragma mark Testing Layer Manipulation

- (void)testAddOrUpdateLayer
{
	[self prepare];
    [[self createClient] addOrUpdateLayer:@"mojodna.test"
									title:@"TheTitle"
							  description:@"mojodna's description" 
								   public:TRUE];
    [self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
	
}

- (void)testAddOrUpdateLayerWithcallbackURLs
{
	[self prepare];
    [[self createClient] addOrUpdateLayer:@"mojodna.test2"
									title:@"Mojodna Test Layer Title"
							  description:@"This is a test layer for Mojodna"
								   public:FALSE
							 callbackURLs:[NSArray arrayWithObjects:nil]];
	[self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetLayers
{
	[self prepare];
    [[self createClient] getLayers];
	[self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetLayersWithCursor
{
	[self prepare];
    [[self createClient] getLayersWithCursor:@"cursor1"];
	[self waitForStatus:kGHUnitWaitStatusSuccess
                timeout:0.25];
}

- (void)testGetLayer
{
	[self prepare];
	[[self createClient] getLayer:@"mojodna.test"];
	[self waitForStatus:kGHUnitWaitStatusSuccess
				timeout:0.25];
}

- (void)testDeleteLayer
{
	[self prepare];
	[[self createClient] deleteLayer:@"mojodna.test"];
	[self waitForStatus:kGHUnitWaitStatusSuccess
				timeout:0.25];	
}

#pragma mark SimpleGeoStorageDelegate Methods

- (void)didAddOrUpdateLayer:(NSString *)name
{
	if ([name isEqualToString:@"mojodna.test"]) {
		[self notify:kGHUnitWaitStatusSuccess
		 forSelector:@selector(testAddOrUpdateLayer)];		
	} else if ([name isEqualToString:@"mojodna.test2"]) {
		[self notify:kGHUnitWaitStatusSuccess
		 forSelector:@selector(testAddOrUpdateLayerWithcallbackURLs)];
	}
}

- (void)didLoadLayers:(NSArray *)layers withCursor:(NSString *)cursor
{
	if ([layers count] > 0) {
		NSDictionary *layer1=[layers objectAtIndex:0];
		GHAssertEqualObjects([layer1 objectForKey:@"name"],@"mojodna.test",nil);
		GHAssertEqualObjects([layer1 objectForKey:@"title"],@"Mojodna Test Layer",nil);
		GHAssertEqualObjects([layer1 objectForKey:@"description"],@"This is a test layer for Mojodna",nil);
		if ([cursor isEqualToString:@"cursor1"]) {
			[self notify:kGHUnitWaitStatusSuccess
			 forSelector:@selector(testGetLayersWithCursor)];
		} else {
			[self notify:kGHUnitWaitStatusSuccess
			 forSelector:@selector(testGetLayers)];
		}
	}
}

- (void)didLoadLayer:(NSDictionary *)layer
            withName:(NSString *)name
{
	GHAssertEqualObjects([layer objectForKey:@"name"],@"mojodna.test",nil);
	GHAssertEqualObjects([layer objectForKey:@"title"],@"Mojodna Test Layer",nil);
	GHAssertEqualObjects([layer objectForKey:@"description"],@"This is a test layer for Mojodna",nil);
	GHAssertEqualObjects(name,@"mojodna.test",nil);
	[self notify:kGHUnitWaitStatusSuccess
	 forSelector:@selector(testGetLayer)];
}

- (void)didDeleteLayer:(NSString *)name
{
	GHAssertEqualObjects(name,@"mojodna.test",nil);
	[self notify:kGHUnitWaitStatusSuccess
	 forSelector:@selector(testDeleteLayer)];
}

- (void)didAddOrUpdateRecord:(SGStoredRecord *)record
                     inLayer:(NSString *)layer
{
    GHAssertEqualObjects([record featureId],
                         @"Car", nil);
    GHAssertEqualObjects(layer,
                         @"mojodna.test", nil);
    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testAddOrUpdateRecord)];
}

- (void)didAddOrUpdateRecords:(NSArray *)records
                      inLayer:(NSString *)layer
{
    GHAssertEqualObjects(layer,
                         @"mojodna.test", nil);
    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testAddOrUpdateRecords)];
}

- (void)didDeleteRecordInLayer:(NSString *)layer
                        withId:(NSString *)recordId
{
    GHAssertEqualObjects(layer,
                         @"mojodna.test", nil);
    GHAssertEqualObjects(recordId,
                         @"boulder", nil);
    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testDeleteRecordInLayer)];
}

- (void)didLoadHistory:(SGGeometryCollection *)history
           forRecordId:(NSString *)recordId
              forQuery:(NSDictionary *)query
                cursor:(NSString *)cursor
{
    NSString *layer = [query objectForKey:@"layer"];
    int count = [[query objectForKey:@"limit"] intValue];

    GHAssertEqualObjects([history.geometries objectAtIndex:0],
                         [SGPoint pointWithLatitude:37.761835 longitude:-122.422917], nil);

    if (recordId && cursor && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetHistoryForRecordIdInLayerWithCursorAndCount)];
    } else if (recordId && cursor) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetHistoryForRecordIdInLayerWithCursor)];
    } else if (recordId && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetHistoryForRecordIdInLayerWithCount)];
    } else if (recordId&&layer) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetHistoryForRecordIdInLayer)];
    }
}

- (void)didLoadRecord:(SGStoredRecord *)record
            fromLayer:(NSString *)layer
               withId:(NSString *)recordId
{
    GHAssertEqualObjects(layer,
                         @"mojodna.test", nil);
    GHAssertEqualObjects(recordId,
                         @"simplegeo-boulder", nil);
    [self notify:kGHUnitWaitStatusSuccess
     forSelector:@selector(testGetRecordFromLayer)];
}

- (void)didLoadRecords:(SGFeatureCollection *)records
              forQuery:(NSDictionary *)query
                cursor:(NSString *)cursor
{
    NSString *layer = [query objectForKey:@"layer"];
    SGPoint *point = [query objectForKey:@"point"];
    double radius = [[query objectForKey:@"radius"] doubleValue];
    NSString *address = [query objectForKey:@"address"];
    int count = [[query objectForKey:@"limit"] intValue];

    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
        @"value", @"key",
        @"mojodna.test", @"layer",
        @"object", @"type",
        nil];
    SGFeature *feature = [[records features] objectAtIndex:0];

    GHAssertEqualObjects(feature.featureId,
                         @"boulder", nil);
    GHAssertEqualObjects(feature.geometry,
                         [SGPoint pointWithLatitude:40.016850 longitude:-105.277280], nil);
    GHAssertEqualObjects(feature.properties,
                         properties, nil);

    if (address && cursor && radius > 0.0f && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddressWithRadiusCursorAndCount)];
    } else if (address && cursor && radius > 0.0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddressWithRadiusAndCursor)];
    } else if (address && cursor && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddressWithCursorAndCount)];
    } else if (address && cursor) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddressWithCursor)];
    } else if (address && radius > 0.0 && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddressWithRadiusAndCount)];
    } else if (address && radius > 0.0f) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddressWithRadius)];
    } else if (address && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddressWithCount)];
    } else if (address) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearAddress)];
    } else if (cursor && radius > 0.0f && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearPoinWithRadiusCursorAndCount)];
    } else if (cursor && radius > 0.0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearPoinWithRadiusAndCursor)];
    } else if (cursor && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearPoinWithCursorAndCount)];
    } else if (cursor) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearPoinWithCursor)];
    } else if (radius > 0.0f && count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearPoinWithRadiusAndCount)];
    } else if (radius > 0.0f) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearPointWithRadius)];
    } else if (count > 0) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayerNearPoinWithCount)];
    } else if (point&&layer) {
        [self notify:kGHUnitWaitStatusSuccess
         forSelector:@selector(testGetRecordsInLayer)];
    }
}

@end
