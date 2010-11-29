//
//  NSString+URLEncoding.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLEncoding.h"


@implementation NSString (URLEncoding)

- (NSString *)URLEncodedString 
{
    
    NSString *result = (NSString *) NSMakeCollectable(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                              (CFStringRef)self,
                                                                                              NULL,
                                                                                              CFSTR("!*'();:@&=+$,/?#[]"),
                                                                                              kCFStringEncodingUTF8));
    return [result autorelease];
}

- (NSString *)URLDecodedString
{
    NSString *result = (NSString *) NSMakeCollectable(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                              (CFStringRef)self,
                                                                                                              CFSTR(""),
                                                                                                              kCFStringEncodingUTF8));
    return [result autorelease];
}

@end
