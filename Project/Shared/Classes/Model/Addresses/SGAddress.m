//
//  SGAddress.m
//  SimpleGeo
//
//  Copyright (c) 2010-2011, SimpleGeo Inc.
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

#import "SGAddress.h"

@implementation SGAddress

@synthesize street, city, county, province, postalCode, ISOcountryCode;

#pragma mark -
#pragma mark Instantiation

+ (SGAddress *)addressWithDictionary:(NSDictionary *)dictionary
{
    return [[[SGAddress alloc] initWithDictionary:dictionary] autorelease];
}

- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        // street
        NSString *component = [dictionary objectForKey:@"address"];
        if (component && [component isKindOfClass:[NSString class]])
            street = [component retain];
        // locality
        component = [dictionary objectForKey:@"city"];
        if (component && [component isKindOfClass:[NSString class]])
            city = [component retain];
        // administraive area
        component = [dictionary objectForKey:@"province"];
        if (component && [component isKindOfClass:[NSString class]])
            province = [component retain];
        // subadministrative area
        component = [dictionary objectForKey:@"county"];
        if (component && [component isKindOfClass:[NSString class]])
            county = [component retain];
        // postalcode
        component = [dictionary objectForKey:@"postcode"];
        if (component && [component isKindOfClass:[NSString class]])
            postalCode = [component retain];
        // iso country code
        component = [dictionary objectForKey:@"country"];
        if (component && [component isKindOfClass:[NSString class]])
            ISOcountryCode = [component retain];
    }
    return self;
}

#pragma mark -
#pragma mark Convenience

- (NSString *)formattedAddress:(SGAddressFormat)addressFormat
                    withStreet:(BOOL)includeStreet
{
    NSMutableArray *components = [NSMutableArray array];
    if (includeStreet && street) [components addObject:street];
    if (city) [components addObject:city];
    NSMutableArray *localityComponents = [NSMutableArray array];
    if (addressFormat == SGAddressFormatUSFull && county)
        [localityComponents addObject:county];
    if (province) [localityComponents addObject:province];
    if ((addressFormat == SGAddressFormatUSNormal || addressFormat == SGAddressFormatUSFull) && postalCode)
        [localityComponents addObject:postalCode];
    [components addObject:[localityComponents componentsJoinedByString:@" "]];
    if ((addressFormat == SGAddressFormatUSNormal || addressFormat == SGAddressFormatUSFull) && ISOcountryCode)
        [components addObject:ISOcountryCode];
    return [components componentsJoinedByString:@", "];
}

- (NSDictionary *)asDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:street forKey:@"address"];
    [dictionary setValue:city forKey:@"city"];
    [dictionary setValue:county forKey:@"county"];
    [dictionary setValue:province forKey:@"province"];
    [dictionary setValue:postalCode forKey:@"postcode"];
    [dictionary setValue:ISOcountryCode forKey:@"country"];
    return dictionary;
}

#pragma mark -
#pragma mark Internal

+ (SGAddress *)addressStrippedFromDictionary:(NSMutableDictionary *)dictionary
{
    SGAddress *address = [SGAddress addressWithDictionary:dictionary];
    [dictionary removeObjectsForKeys:[NSMutableArray arrayWithObjects:
                                      @"address",
                                      @"city",
                                      @"county",
                                      @"province",
                                      @"postcode",
                                      @"country",
                                      nil]];
    return address;
}

- (void)dealloc
{
    [street release];
    [city release];
    [county release];
    [province release];
    [postalCode release];
    [ISOcountryCode release];
    [super dealloc];
}

@end
