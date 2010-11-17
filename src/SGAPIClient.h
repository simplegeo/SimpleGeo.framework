//
//  SGAPIClient.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/14/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "ASIHTTPRequest.h"
#import "SGFeature.h"
#import "SGPoint.h"
#import "NSArray+SGFeature.h"


extern NSString * const SIMPLEGEO_URL_PREFIX;


@protocol SGAPIClientDelegate <NSObject>

- (NSString *)consumerKey;
- (NSString *)consumerSecret;

@optional
- (void)requestDidFinish:(ASIHTTPRequest *)request;
- (void)requestDidFail:(ASIHTTPRequest *)request;
- (void)didLoadFeature:(SGFeature *)feature withId:(NSString *)featureId;
- (void)didLoadPlaces:(NSArray *)places near:(SGPoint *)point;

@end


@interface SGAPIClient : NSObject
{
    id<SGAPIClientDelegate> delegate;
    NSURL* url;
}

@property (retain) id<SGAPIClientDelegate> delegate;
@property (retain) NSURL* url;

+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate;
+ (SGAPIClient *)clientWithDelegate:(id<SGAPIClientDelegate>)delegate URL:(NSURL *)url;

// TODO extract these into appropriate categories
- (void)getFeatureWithId:(NSString *)featureId;

- (void)getPlacesNear:(SGPoint *)point;
- (void)getPlacesNear:(SGPoint *)point matching:(NSString *)query;
- (void)getPlacesNear:(SGPoint *)point matching:(NSString *)query inCategory:(NSString *)category;

@end
