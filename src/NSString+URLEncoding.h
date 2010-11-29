//
//  NSString+URLEncoding.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/24/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URLEncoding)

- (NSString *)URLEncodedString;
- (NSString *)URLDecodedString;

@end
