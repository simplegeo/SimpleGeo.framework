//
//  ASIHTTPRequest+OAuth.h
//
//  Created by Scott James Remnant on 6/1/11.
//  Copyright 2011 Scott James Remnant <scott@netsplit.com>. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"


typedef enum _ASIOAuthSignatureMethod {
    ASIOAuthPlaintextSignatureMethod,
    ASIOAuthHMAC_SHA1SignatureMethod,
} ASIOAuthSignatureMethod;


@interface ASIHTTPRequest (ASIHTTPRequest_OAuth)

- (void)signRequestWithClientIdentifier:(NSString *)clientIdentifier
                                 secret:(NSString *)clientSecret
                        tokenIdentifier:(NSString *)tokenIdentifier
                                 secret:(NSString *)tokenSecret
                            usingMethod:(ASIOAuthSignatureMethod)signatureMethod;

- (void)signRequestWithClientIdentifier:(NSString *)clientIdentifier
                                 secret:(NSString *)clientSecret
                        tokenIdentifier:(NSString *)tokenIdentifier
                                 secret:(NSString *)tokenSecret
                               verifier:(NSString *)verifier
                            usingMethod:(ASIOAuthSignatureMethod)signatureMethod;

@end
