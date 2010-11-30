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


extern NSString * const SIMPLEGEO_API_VERSION;
extern NSString * const SIMPLEGEO_URL_PREFIX;


@protocol SGAPIClientDelegate <NSObject>

@optional
- (void)requestDidFinish:(ASIHTTPRequest *)request;
- (void)requestDidFail:(ASIHTTPRequest *)request;

- (void)didLoadFeature:(SGFeature *)feature
                withId:(NSString *)featureId;

// TODO put this into a different protocol that subclasses this one (does that work)?
- (void)didLoadPlaces:(SGFeatureCollection *)places
                 near:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category;

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
