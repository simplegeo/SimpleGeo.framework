//
//  SimpleGeo+Context.h
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

#import "SimpleGeo.h"
@class SGContextQuery;
@class SGCallback;

/**
 * Client support for Context API
 */
@interface SimpleGeo (Context)

#pragma mark -
#pragma mark Requests

/**
 * Get Context matching an SGContextQuery
 * @param query         Query for the request
 * @param callback      Request callback
 */
- (void)getContextForQuery:(SGContextQuery *)query
                  callback:(SGCallback *)callback;

/**
 * Get a feature with a specific handle.
 * If requesting a place, please note: this method only works
 * for Places v1.0 (the old SimpleGeo dataset). To request a place
 * from the new Factual dataset, use getPlace:callback:
 * @param handle        Feature handle
 * @param zoom          Zoom (complexity of returned geometry) (optional)
 * @param callback      Request callback
 */
- (void)getFeatureWithHandle:(NSString *)handle
                        zoom:(NSNumber *)zoom
                    callback:(SGCallback *)callback;

/**
 * Get annotations attached to a feature
 * @param handle        Feature handle
 * @param callback      Request callback
 */
- (void)getAnnotationsForFeature:(NSString *)handle
                        callback:(SGCallback *)callback;

/**
 * Search ACS demographic tables
 * @param searchString  Search string
 * @param callback      Request callback
 */
- (void)searchDemographicsTables:(NSString *)searchString
                        callback:(SGCallback *)callback;

#pragma mark -
#pragma mark Manipulations

/**
 * Annotate a feature
 * @param handle        Feature handle
 * @param annotation    Annotation list
 * @param isPrivate     Annotation privacy
 * @param callback      Request callback
 */
- (void)annotateFeature:(NSString *)handle
         withAnnotation:(NSDictionary *)annotation
              isPrivate:(BOOL)isPrivate
               callback:(SGCallback *)callback;

@end
