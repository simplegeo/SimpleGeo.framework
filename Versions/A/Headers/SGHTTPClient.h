//
//  SGHTTPClient.h
//  SGObjCHTTP
//
//  Created by Derek Smith on 8/2/11.
//  Copyright 2011 SimpleGeo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SGCallback.h"

@interface SGHTTPClient : NSObject {
    
    NSString *consumerKey;
    NSString *consumerSecret;
    NSString *accessToken;
    NSString *accessTokenSecret;
    NSString *verifier;
}

@property (nonatomic, retain) NSString *consumerKey;
@property (nonatomic, retain) NSString *consumerSecret;
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) NSString *accessTokenSecret;
@property (nonatomic, retain) NSString *verifier;

- (id)initWithConsumerKey:(NSString *)key consumerSecret:(NSString *)secret;
- (id)initWithConsumerKey:(NSString *)key
           consumerSecret:(NSString *)secret 
              accessToken:(NSString *)accessToken 
             accessTokenSecret:(NSString *)accessTokenSecret;
- (id)initWithAccessToken:(NSString *)accessToken;

- (void)sendHTTPRequest:(NSString *)type
                  toURL:(NSURL *)url
             withParams:(id)params 
               callback:(SGCallback *)callback;

@end
