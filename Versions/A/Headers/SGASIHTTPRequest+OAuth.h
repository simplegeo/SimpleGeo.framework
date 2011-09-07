//
//  SGASIHTTPRequest+OAuth.h
//
//  Created by Scott James Remnant on 6/1/11.
//  Copyright 2011 Scott James Remnant <scott@netsplit.com>. All rights reserved.
//

// !!! NOTE !!!
//
// The content has been modified in order to address
// namespacing issues.
//
// !!! NOTE !!!

#import <Foundation/Foundation.h>

#import "SGASIHTTPRequest.h"


typedef enum _SGASIOAuthSignatureMethod {
    SGASIOAuthPlaintextSignatureMethod,
    SGASIOAuthHMAC_SHA1SignatureMethod,
} SGASIOAuthSignatureMethod;


@interface SGASIHTTPRequest (SGASIHTTPRequest_OAuth)

- (void)signRequestWithClientIdentifier:(NSString *)clientIdentifier
                                 secret:(NSString *)clientSecret
                        tokenIdentifier:(NSString *)tokenIdentifier
                                 secret:(NSString *)tokenSecret
                            usingMethod:(SGASIOAuthSignatureMethod)signatureMethod;

- (void)signRequestWithClientIdentifier:(NSString *)clientIdentifier
                                 secret:(NSString *)clientSecret
                        tokenIdentifier:(NSString *)tokenIdentifier
                                 secret:(NSString *)tokenSecret
                               verifier:(NSString *)verifier
                            usingMethod:(SGASIOAuthSignatureMethod)signatureMethod;

@end
