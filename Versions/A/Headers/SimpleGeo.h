//
//  SimpleGeo.h
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

#import "ASIHTTPRequest.h"
#import "SGFeature.h"
#import "SGFeatureCollection.h"
#import "SGPoint.h"

/*!
 * \mainpage
 *
 * \section intro_sec Introduction
 *
 * Hi, you've reached the documentation for SimpleGeo's Objective-C client.
 *
 * For more information, please look at the Class documentation.
 *
 * You can also
 * <a href="https://github.com/simplegeo/SimpleGeo.framework/downloads">download
 * an Xcode docset</a>.
 */

extern NSString * const SIMPLEGEO_API_VERSION;
extern NSString * const SIMPLEGEO_URL_PREFIX;


/*!
 * Informal delegate protocol for core functionality.
 */
@interface NSObject (SimpleGeoDelegate)

/*!
 * Called when a feature has been loaded. feature will be nil if it could not
 * be found.
 * @param feature Feature that was loaded.
 * @param handle  Handle used to request this feature.
 */
- (void)didLoadFeature:(SGFeature *)feature
                handle:(NSString *)handle;

/*!
 * Called when a request has finished. (optional)
 * @param request Request instance.
 */
- (void)requestDidFinish:(ASIHTTPRequest *)request;

/*!
 * Called when a request has failed. (optional)
 * @param request Request instance.
 */
- (void)requestDidFail:(ASIHTTPRequest *)request;

/*!
 * Called when categories have been loaded.
 * @param categories An array of categories.
 */
- (void)didLoadCategories:(NSArray *)categories;

@end


/*!
 * SimpleGeo client interface.
 */
@interface SimpleGeo : NSObject
{
  @private
    id delegate;
    NSString* consumerKey;
    NSString* consumerSecret;
    NSURL* url;
}

@property (assign)          id delegate;
@property (retain,readonly) NSString* consumerKey;
@property (retain,readonly) NSString* consumerSecret;
@property (retain,readonly) NSURL* url;

/*!
 * Create a client.
 * @param delegate       Delegate. Must conform to SimpleGeoDelegate and other
 *                       variants as appropriate.
 * @param consumerKey    OAuth consumer key.
 * @param consumerSecret OAuth consumer secret.
 */
+ (SimpleGeo *)clientWithDelegate:(id)delegate
                      consumerKey:(NSString *)consumerKey
                   consumerSecret:(NSString *)consumerSecret;
+ (SimpleGeo *)clientWithDelegate:(id)delegate
                      consumerKey:(NSString *)consumerKey
                   consumerSecret:(NSString *)consumerSecret
                              URL:(NSURL *)url;

/*!
 * Construct a client.
 * @param delegate       Delegate. Must conform to SimpleGeoDelegate and other
 *                       variants as appropriate.
 * @param consumerKey    OAuth consumer key.
 * @param consumerSecret OAuth consumer secret.
 */
- (id)initWithDelegate:(id)delegate
           consumerKey:(NSString *)consumerKey
        consumerSecret:(NSString *)consumerSecret;
- (id)initWithDelegate:(id)delegate
           consumerKey:(NSString *)consumerKey
        consumerSecret:(NSString *)consumerSecret
                   URL:(NSURL *)url;

/*!
 * Get a feature with a specific handle.
 * @param handle Handle of feature being queried for.
 */
- (void)getFeatureWithHandle:(NSString *)handle;

/*!
 * Get a feature with a specific handle.
 * @param handle Handle of feature being queried for.
 * @param zoom   Zoom level to determine complexity of returned feature.
 */
- (void)getFeatureWithHandle:(NSString *)handle
                        zoom:(int)zoom;

/*!
 * Get the overall list of categories.
 */
- (void)getCategories;

@end

#import "SimpleGeo+Context.h"
#import "SimpleGeo+Places.h"
