//
//  SGAPIClient.h
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


extern NSString * const SIMPLEGEO_API_VERSION;
extern NSString * const SIMPLEGEO_URL_PREFIX;


@protocol SGAPIClientDelegate <NSObject>

@optional
- (void)requestDidFinish:(ASIHTTPRequest *)request;
- (void)requestDidFail:(ASIHTTPRequest *)request;

- (void)didLoadFeature:(SGFeature *)feature
                withId:(NSString *)featureId;

// TODO put this into a different protocol that subclasses this one (does that work)?
// http://stackoverflow.com/questions/732701/how-to-extend-protocols-delegates-in-objective-c
- (void)didLoadPlaces:(SGFeatureCollection *)places
                 near:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category;
- (void)didUpdatePlace:(NSString *)handle
                 token:(NSString *)token;

@end


@interface SGAPIClient : NSObject
{
    id<SGAPIClientDelegate> delegate;
    NSString* consumerKey;
    NSString* consumerSecret;
    NSURL* url;
}

@property (retain,readonly) id<SGAPIClientDelegate> delegate;
@property (retain,readonly) NSString* consumerKey;
@property (retain,readonly) NSString* consumerSecret;
@property (retain,readonly) NSURL* url;

+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate
                        consumerKey:(NSString *)consumerKey
                     consumerSecret:(NSString *)consumerSecret;
+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate
                        consumerKey:(NSString *)consumerKey
                     consumerSecret:(NSString *)consumerSecret
                                URL:(NSURL *)url;

- (id)initWithDelegate:(id<SGAPIClientDelegate>)delegate
           consumerKey:(NSString *)consumerKey
        consumerSecret:(NSString *)consumerSecret;
- (id)initWithDelegate:(id<SGAPIClientDelegate>)delegate
           consumerKey:(NSString *)consumerKey
        consumerSecret:(NSString *)consumerSecret
                   URL:(NSURL *)url;

- (void)getFeatureWithId:(NSString *)featureId;

@end
