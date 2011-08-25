//
//  SGStorageQuery.h
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

#import "SGNearbyQuery.h"
#import "SGTypes.h"

/**
 * An SGStorageQuery object stores query information for a SimpleGeo Storage API request.
 * To make a Storage request, create an SGStorageQuery object and call [SimpleGeo getRecordsForQuery:callback:].
 *
 * - Specify the Storage *layer* you wish to query (required).
 * - Specify *start/end dates* to constrain your query to records created in a certain timeframe.
 * - Specify a *sort type* to control the order by which results are returned.
 */
@interface SGStorageQuery : SGNearbyQuery
{
    @private
    NSString *layer;
    NSString *cursor;
    SGSortOrder sortType;
    
    NSDate *startDate;
    NSDate *endDate;
}

/// Layer to query
@property (nonatomic, retain) NSString *layer;

/// Cursor for paginating query results
@property (nonatomic, retain) NSString *cursor;

/// Sorting method for query
@property (nonatomic, retain) SGSortOrder sortType;

/// Start date for query
@property (nonatomic, retain, readonly) NSDate *startDate;

/// End date for query
@property (nonatomic, retain, readonly) NSDate *endDate;

#pragma mark -
#pragma mark Instantiation

/**
 * Create a point-based Storage query
 * @param point     Point
 * @param layer     Layer
 */
+ (SGStorageQuery *)queryWithPoint:(SGPoint *)point
                             layer:(NSString *)layer;

/**
 * Create an address-based Storage query
 * @param address   Address
 * @param layer     Layer
 */
+ (SGStorageQuery *)queryWithAddress:(NSString *)address
                               layer:(NSString *)layer;

/**
 * Construct an envelope-based Storage query
 * @param envelope  Envelope
 * @param layer     Layer
 */
+ (SGStorageQuery *)queryWithEnvelope:(SGEnvelope *)envelope
                                layer:(NSString *)layer;

/**
 * Construct a point-based Storage query
 * @param point     Point
 * @param layer     Layer
 */
- (id)initWithPoint:(SGPoint *)point
              layer:(NSString *)layer;

/**
 * Construct an address-based Storage query
 * @param address   Address
 * @param layer     Layer
 */
- (id)initWithAddress:(NSString *)address
                layer:(NSString *)layer;

/**
 * Construct an envelope-based Storage query
 * @param envelope  Envelope
 * @param layer     Layer
 */
- (id)initWithEnvelope:(SGEnvelope *)envelope
                 layer:(NSString *)layer;

#pragma mark -
#pragma mark Convenience

/**
 * Set a date range
 * @param startDate Start date
 * @param endDate   End date
 */
- (void)setDateRangeFrom:(NSDate *)startDate
                      to:(NSDate *)endDate;

@end
