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

#import "SGPreprocessorMacros.h"

@implementation SGAddress

@synthesize addressDictionary;

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
        addressDictionary = [[NSMutableDictionary dictionary] retain];
        for (NSString *key in [SGAddress candidateKeys]) {
            NSObject *value = [dictionary objectForKey:key];
            if ([value isKindOfClass:[NSString class]])
                [addressDictionary setValue:value forKey:key];
        }
    }
    return self;
}

#pragma mark -
#pragma mark Getters

+ (NSArray *)candidateKeys
{
    return [NSArray arrayWithObjects:
            @"address",
            @"city",
            @"locality",
            @"province",
            @"region",
            @"county",
            @"postcode",
            @"country",
            nil];
}

- (NSString *)street
{
    return [self.addressDictionary objectForKey:@"address"];
}

- (NSString *)city
{
    NSString *city = [self.addressDictionary objectForKey:@"city"];
    if (!city) city = [self.addressDictionary objectForKey:@"locality"];
    return city;
}

- (NSString *)county
{
    return [self.addressDictionary objectForKey:@"county"];
}

- (NSString *)province
{
    NSString *province = [self.addressDictionary objectForKey:@"province"];
    if (!province) province = [self.addressDictionary objectForKey:@"region"];
    return province;
}

- (NSString *)postalCode
{
    return [self.addressDictionary objectForKey:@"postcode"];
}

- (NSString *)country
{
    return [self.addressDictionary objectForKey:@"country"];
}

#pragma mark -
#pragma mark Convenience

- (NSString *)formattedAddress:(SGAddressFormat)addressFormat
                    withStreet:(BOOL)includeStreet
{
    NSMutableArray *components = [NSMutableArray array];
    if (includeStreet && self.street) [components addObject:self.street];
    if (self.city) [components addObject:self.city];
    NSMutableArray *localityComponents = [NSMutableArray array];
    if (addressFormat == SGAddressFormatUSFull && self.county)
        [localityComponents addObject:self.county];
    if (self.province) [localityComponents addObject:self.province];
    if ((addressFormat == SGAddressFormatUSNormal || addressFormat == SGAddressFormatUSFull) && self.postalCode)
        [localityComponents addObject:self.postalCode];
    [components addObject:[localityComponents componentsJoinedByString:@" "]];
    if ((addressFormat == SGAddressFormatUSNormal || addressFormat == SGAddressFormatUSFull) && self.country)
        [components addObject:self.country];
    return [components componentsJoinedByString:@", "];
}

#pragma mark -
#pragma mark Internal

+ (SGAddress *)addressStrippedFromDictionary:(NSMutableDictionary *)dictionary
{
    SGAddress *address = [SGAddress addressWithDictionary:dictionary];
    [dictionary removeObjectsForKeys:[SGAddress candidateKeys]];
    return address;
}

- (void)dealloc
{
    SG_RELEASE(addressDictionary);
    [super dealloc];
}

@end
