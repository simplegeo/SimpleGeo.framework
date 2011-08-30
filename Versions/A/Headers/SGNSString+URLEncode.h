//
//  NSString+URLEncode.h
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


@interface NSString (SGNSString_URLEncode)

- (NSString *)encodeForURL;
- (NSString *)encodeForURLReplacingSpacesWithPlus;
- (NSString *)decodeFromURL;

@end
