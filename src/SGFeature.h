//
//  SGFeature.h
//  SimpleGeo.framework
//
//  Copyright (c) 2010, SimpleGeo Inc.
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

#import "SGGeometry.h"


@interface SGFeature : NSObject
{
    NSString* featureId;
    SGGeometry* geometry;
    NSDictionary* properties;
}

@property (retain,readonly) NSString* featureId;
@property (retain,readonly) SGGeometry* geometry;
@property (retain,readonly) NSDictionary* properties;

+ (SGFeature *)featureWithId:(NSString *)id;
+ (SGFeature *)featureWithId:(NSString *)id
                  dictionary:(NSDictionary *)data;
+ (SGFeature *)featureWithDictionary:(NSDictionary *)data;
+ (SGFeature *)featureWithId:(NSString *)id
                  properties:(NSDictionary *)properties;
+ (SGFeature *)featureWithId:(NSString *)id
                    geometry:(SGGeometry *)geometry;
+ (SGFeature *)featureWithId:(NSString *)id
                    geometry:(SGGeometry *)geometry
                  properties:(NSDictionary *)properties;
+ (SGFeature *)featureWithGeometry:(SGGeometry *)geometry
                        properties:(NSDictionary *)properties;
- (id)initWithId:(NSString *)id;
- (id)initWithId:(NSString *)id
      dictionary:(NSDictionary *)data;
- (id)initWithId:(NSString *)id
      properties:(NSDictionary *)properties;
- (id)initWithId:(NSString *)id
        geometry:(SGGeometry *)geometry;
- (id)initWithId:(NSString *)id
        geometry:(SGGeometry *)geometry
      properties:(NSDictionary *)properties;
- (id)initWithGeometry:(SGGeometry *)geometry
            properties:(NSDictionary *)properties;

@end
