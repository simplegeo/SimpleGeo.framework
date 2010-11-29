//
//  SGAPIClient.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "SGFeature.h"
#import "SGFeatureCollection.h"
#import "SGPoint.h"


extern NSString * const SIMPLEGEO_URL_PREFIX;


@protocol SGAPIClientDelegate <NSObject>

@optional
- (void)requestDidFinish:(ASIHTTPRequest *)request;
- (void)requestDidFail:(ASIHTTPRequest *)request;

- (void)didLoadFeature:(SGFeature *)feature
                withId:(NSString *)featureId;
- (void)didLoadPlaces:(SGFeatureCollection *)places
                 near:(SGPoint *)point;
- (void)didLoadPlaces:(SGFeatureCollection *)places
                 near:(SGPoint *)point
             matching:(NSString *)query;

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

// TODO extract these into appropriate categories
- (void)getFeatureWithId:(NSString *)featureId;

- (void)getPlacesNear:(SGPoint *)point;
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query;
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category;

@end
