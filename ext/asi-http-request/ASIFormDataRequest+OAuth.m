//
//  ASIFormDataRequest+OAuth.m
//

#import "ASIFormDataRequest+OAuth.h"
#import "ASIHTTPRequest+OAuth.h"


@implementation ASIFormDataRequest (OAuth)

- (id)initWithURL:(NSURL *)newURL
      consumerKey:(NSString *)consumerKey
   consumerSecret:(NSString *)consumerSecret
            token:(NSString *)token
      tokenSecret:(NSString *)tokenSecret
{
    self = [super initWithURL:newURL
                  consumerKey:consumerKey
               consumerSecret:consumerSecret
                        token:token
                  tokenSecret:tokenSecret];
    
    if (self) {
        [self setPostFormat:ASIURLEncodedPostFormat];
        [self setStringEncoding:NSUTF8StringEncoding];
    }
    
    return self;
}

@end
