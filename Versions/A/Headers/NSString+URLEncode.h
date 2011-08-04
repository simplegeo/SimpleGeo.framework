//
//  NSString+URLEncode.h
//
//  Created by Scott James Remnant on 6/1/11.
//  Copyright 2011 Scott James Remnant <scott@netsplit.com>. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (NSString_URLEncode)

- (NSString *)encodeForURL;
- (NSString *)encodeForURLReplacingSpacesWithPlus;
- (NSString *)decodeFromURL;

@end
