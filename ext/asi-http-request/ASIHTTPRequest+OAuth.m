//
//  ASIHTTPRequest+OAuth.m
//
//  Copyright (c) 2011, SimpleGeo Inc.
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

#import <CommonCrypto/CommonHMAC.h>
#import "ASIHTTPRequest+OAuth.h"
#import "ASIBase64Transcoder.h"


@interface ASIHTTPRequest ()

- (NSString *)generateNonce;
- (NSString *)generateTimestamp;
- (NSString *)normalizeRequestParameters:(NSArray *)params;
- (NSString *)signClearText:(NSString *)text
                 withSecret:(NSString *)secret
                     method:(NSString *)method;
- (NSString *)signatureBaseStringWithParameters:(NSArray *)params;
- (NSString *)URLEncodedString:(NSString *)string;
- (NSString *)URLDecodedString:(NSString *)string;

@end

@implementation ASIHTTPRequest (OAuth)

+ (id)requestWithURL:(NSURL *)newURL
         consumerKey:(NSString *)consumerKey
      consumerSecret:(NSString *)consumerSecret
               token:(NSString *)token
         tokenSecret:(NSString *)tokenSecret
{
    return [[[self alloc] initWithURL:newURL
                          consumerKey:consumerKey
                       consumerSecret:consumerSecret
                                token:token
                          tokenSecret:tokenSecret] autorelease];
}

- (id)initWithURL:(NSURL *)newURL
      consumerKey:(NSString *)consumerKey
   consumerSecret:(NSString *)consumerSecret
            token:(NSString *)token
      tokenSecret:(NSString *)tokenSecret
{
    self = [self initWithURL:newURL];

    if (self) {
        // convert nil parameters to empty strings
        if (! consumerKey) {
            consumerKey = @"";
        }

        if (! consumerSecret) {
            consumerSecret = @"";
        }

        if (! token) {
            token = @"";
        }

        if (! tokenSecret) {
            tokenSecret = @"";
        }

        // use request credentials, as this request won't be using Basic/Digest
        // Auth or NTLM and these *are* request credentials
        [self setRequestCredentials:[NSDictionary dictionaryWithObjectsAndKeys:
                                     consumerKey, @"consumerKey",
                                     consumerSecret, @"consumerSecret",
                                     token, @"token",
                                     tokenSecret, @"tokenSecret",
                                     @"HMAC-SHA1", @"signatureMethod",
                                     nil
                                     ]];
    }

    return self;
}

- (void)setOAuthSignatureMethod:(NSString *)signatureMethod
{
    NSMutableDictionary *newCredentials = [NSMutableDictionary dictionaryWithDictionary:[self requestCredentials]];
    [newCredentials setObject:signatureMethod forKey:@"signatureMethod"];
    [self setRequestCredentials:newCredentials];
}

- (NSString *)oauthSignatureMethod
{
    return [[self requestCredentials] objectForKey:@"signatureMethod"];
}

- (void)addOAuthHeaderWithConsumerKey:(NSString *)consumerKey
                       consumerSecret:(NSString *)consumerSecret
                                token:(NSString *)token
                          tokenSecret:(NSString *)tokenSecret
                      signatureMethod:(NSString *)signatureMethod
{
    // convert nil parameters to empty strings (params may be nil if this method is called
    // abnormally; i.e. without having been initialized using
    // initWithURL:consumerKey:consumerSecret:token:tokenSecret)
    if (! consumerKey) {
        consumerKey = @"";
    }

    if (! consumerSecret) {
        consumerSecret = @"";
    }

    if (! token) {
        token = @"";
    }

    if (! tokenSecret) {
        tokenSecret = @"";
    }

    // basic OAuth parameters
    NSMutableDictionary *oauthParams = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        consumerKey, @"oauth_consumer_key",
                                        token, @"oauth_token",
                                        [self generateTimestamp], @"oauth_timestamp",
                                        [self generateNonce], @"oauth_nonce",
                                        signatureMethod, @"oauth_signature_method",
                                        @"1.0", @"oauth_version",
                                        nil
                                        ];

    // this is an NSArray containing parameter pairs as NSArrays; this is *different*
    // from ASIFormDataRequest's implementation of postData
    NSMutableArray *params = [NSMutableArray array];
    
    // copy OAuth parameters, since they need to be included in the signature
    // base string
    for (id key in oauthParams) {
        [params addObject:[NSArray arrayWithObjects:
                           key,
                           [self URLEncodedString:[oauthParams objectForKey:key]],
                           nil]];
    }
    
    // add in params from the query string
    for (NSString *pair in [[url query] componentsSeparatedByString:@"&"]) {
        [params addObject:[pair componentsSeparatedByString:@"="]];
    }
    
    // the post body should have already been assembled at this stage; if it's present,
    // we may want to include its contents in the signature
    if ([self postBody]) {
        // find the header containing the content-type (in case it's capitalized randomly)
        NSString *contentTypeKey = [[[self requestHeaders] keysOfEntriesPassingTest:^ BOOL (id key, id obj, BOOL *stop) {
            if ([[((NSString *)key) lowercaseString] isEqualToString:@"content-type"]) {
                *stop = YES;
                return true;
            }
            
            return false;
        }] anyObject];
        
        // strip out any charset variants; we only care about the raw content type
        NSString *contentType = [[[[self requestHeaders] objectForKey:contentTypeKey] componentsSeparatedByString:@";"] objectAtIndex:0];

        // if this is an application/x-www-form-urlencoded body, we should use
        // its contents for signing
        if ([contentType isEqualToString:@"application/x-www-form-urlencoded"]) {
            NSString *requestBody = [[NSString alloc] initWithData:[self postBody]
                                                          encoding:NSUTF8StringEncoding];
            
            for (NSString *pair in [requestBody componentsSeparatedByString:@"&"]) {
                [params addObject:[pair componentsSeparatedByString:@"="]];
            }
            
            [requestBody release];
        }
    }
    
    NSString *sbs = [self signatureBaseStringWithParameters:params];
    // the assembly of the signature base string is almost always the problem
    // NSLog(@"Signature base string: %@", sbs);

    // generate the OAuth signature

    NSString *secret = [NSString stringWithFormat:@"%@&%@",
                        consumerSecret, tokenSecret];

    NSString *signature = [self signClearText:sbs
                                   withSecret:secret
                                       method:signatureMethod];

    [oauthParams setObject:signature
                    forKey:@"oauth_signature"];

    // prepare to assemble an Authorization header
    NSMutableArray *pairs = [NSMutableArray arrayWithCapacity:[oauthParams count]];
    for (NSString *key in oauthParams) {
        [pairs addObject:[NSString stringWithFormat:@"%@=\"%@\"",
                          key, [self URLEncodedString:[oauthParams objectForKey:key]]]];
    }
    NSString *components = [[NSArray arrayWithArray:pairs] componentsJoinedByString:@", "];

    [self addRequestHeader:@"Authorization"
                     value:[NSString stringWithFormat:@"OAuth realm=\"\", %@", components]];
}

- (NSString *)generateNonce
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    [NSMakeCollectable(theUUID) release];

    return [(NSString *) string autorelease];
}

- (NSString *)generateTimestamp
{
    return [NSString stringWithFormat:@"%d", time(NULL)];
}

- (NSString *)normalizeRequestParameters:(NSArray *)params
{
    NSMutableArray *parameterPairs = [NSMutableArray arrayWithCapacity:([params count])];

    for (NSArray *kv in params) {
        [parameterPairs addObject:[kv componentsJoinedByString:@"="]];
    }

    NSArray *sortedPairs = [parameterPairs sortedArrayUsingSelector:@selector(compare:)];
    return [sortedPairs componentsJoinedByString:@"&"];
}

- (NSString *)signatureBaseStringWithParameters:(NSArray *)params
{
    return [NSString stringWithFormat:@"%@&%@&%@",
            requestMethod,
            [self URLEncodedString:[[[url absoluteString] componentsSeparatedByString:@"?"] objectAtIndex:0]],
            [self URLEncodedString:[self normalizeRequestParameters:params]]];
}

// Adapted from OAuthConsumer/OAHMAC_SHA1SignatureProvider.m
- (NSString *)signClearText:(NSString *)text
                 withSecret:(NSString *)secret
                     method:(NSString *)method
{
    if ([method isEqual:@"PLAINTEXT"]) {
        return [NSString stringWithFormat:@"%@&%@", text, secret];
    } else if ([method isEqual:@"HMAC-SHA1"]) {
        NSData *secretData = [secret dataUsingEncoding:NSUTF8StringEncoding];
        NSData *clearTextData = [text dataUsingEncoding:NSUTF8StringEncoding];
        unsigned char result[20];
        CCHmac(kCCHmacAlgSHA1,
               [secretData bytes],
               [secretData length],
               [clearTextData bytes],
               [clearTextData length],
               result);

        // Base64 Encoding
        char base64Result[32];
        size_t theResultLength = 32;
        ASIBase64EncodeData(result, 20, base64Result, &theResultLength, Base64Flags_Default);
        return [NSString stringWithFormat:@"%s", base64Result];
    } else {
        return nil;
    }
}

- (NSString *)URLEncodedString:(NSString *)string
{

    NSString *result = (NSString *) NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)string,
                                                                                              NULL,
                                                                                              CFSTR("!*'();:@&=+$,/?#[]"),
                                                                                              kCFStringEncodingUTF8));
    return [result autorelease];
}

- (NSString *)URLDecodedString:(NSString *)string
{
    NSString *result = (NSString *) NSMakeCollectable(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                              (CFStringRef)string,
                                                                                                              CFSTR(""),
                                                                                                              kCFStringEncodingUTF8));
    return [result autorelease];
}

@end
