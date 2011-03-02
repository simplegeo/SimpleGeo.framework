//
//  SGStoredRecord.h
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

#import "SGFeature.h"


/*!
 * Representation of a record as exposed by the SimpleGeo Storage API.
 */
@interface SGStoredRecord : SGFeature
{
    NSTimeInterval created;
    NSString *layer;
}

//! Created at timestamp (Unix epoch)
@property (readonly)        NSTimeInterval created;

//! Layer name
@property (retain,readonly) NSString *layer;


/*!
 * Create a record with a created timestamp.
 *
 * @param created Created timestamp.
 */
+ (SGStoredRecord *)recordWithCreatedTimestamp:(NSTimeInterval)created;

/*!
 * Create a record associated with a layer.
 *
 * @param layer Associated layer.
 */
+ (SGStoredRecord *)recordWithLayer:(NSString *)layer;

/*!
 * Create a record with a created timestamp and an associated layer.
 *
 * @param created Created timestamp.
 * @param layer   Associated layer.
 */
+ (SGStoredRecord *)recordWithCreatedTimestamp:(NSTimeInterval)created
                                         layer:(NSString *)layer;

/*!
 * Create a record from a Feature with a created timestamp.
 *
 * @param feature Feature.
 * @param created Created timestamp.
 */
+ (SGStoredRecord *)recordWithFeature:(SGFeature *)feature
                     createdTimestamp:(NSTimeInterval)created;

/*!
 * Create a record from a Feature with an associated layer.
 *
 * @param feature Feature.
 * @param layer  Associated layer.
 */
+ (SGStoredRecord *)recordWithFeature:(SGFeature *)feature
                                layer:(NSString *)layer;

/*!
 * Create a record from a Feature with a created timestamp and an associated
 * layer.
 *
 * @param feature Feature.
 * @param created Created timestamp.
 * @param layer   Associated layer.
 */
+ (SGStoredRecord *)recordWithFeature:(SGFeature *)feature
                     createdTimestamp:(NSTimeInterval)created
                                layer:(NSString *)layer;

/*!
 * Construct a record with a created timestamp.
 *
 * @param created Created timestamp.
 */
- (id)initWithCreatedTimestamp:(NSTimeInterval)created;

/*!
 * Construct a record with an associated layer.
 *
 * @param layer Associated layer.
 */
- (id)initWithLayer:(NSString *)layer;

/*!
 * Construct a record with a created timestamp and an associated layer.
 *
 * @param created Created timestamp.
 * @param layer   Associated layer.
 */
- (id)initWithCreatedTimestamp:(NSTimeInterval)created
                         layer:(NSString *)layer;

/*!
 * Construct a record from a Feature with a created timestamp.
 *
 * @param feature Feature.
 * @param created Created timestamp.
 */
- (id)initWithFeature:(SGFeature *)feature
     createdTimestamp:(NSTimeInterval)created;

/*!
 * Construct a record from a Feature with an associated layer.
 *
 * @param feature Feature.
 * @param layer   Associated layer.
 */
- (id)initWithFeature:(SGFeature *)feature
                layer:(NSString *)layer;

/*!
 * Construct a record from a Feature with a created timestamp and an associated
 * layer.
 *
 * @param feature Feature.
 * @param created Created timestamp.
 * @param layer   Associated layer.
 */
- (id)initWithFeature:(SGFeature *)feature
     createdTimestamp:(NSTimeInterval)created
                layer:(NSString *)layer;

@end
