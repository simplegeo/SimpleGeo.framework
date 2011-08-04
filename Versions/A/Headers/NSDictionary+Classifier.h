//
//  NSDictionary+Classifier.h
//  SimpleGeo.framework
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

#import "SGCategories.h"

/**
 * This category on NSDictionary allows you to easily create a SimpleGeo classifier -
 * a dictionary with *"type,"* *"category,"* and *"subcategory"* top-level keys.
 * More importantly, accessor methods allow for easier access to key values,
 * returning nil if no key exists or if the value is null.
 */
@interface NSDictionary (Classifier)

/**
 * Create a dictionary that conforms to the SimpleGeo
 * classifier protocol for Features
 * @param type          Feature type
 * @param category      Feature category
 * @param subcategory   Feature subcategory
 */
+ (NSDictionary *)classifierWithType:(SGFeatureType)type
                            category:(SGFeatureCategory)category
                         subcategory:(SGFeatureSubcategory)subcategory;

/**
 * Retreive the feature type
 */
- (SGFeatureType)classifierType;

/**
 * Retreive the feature category
 */
- (SGFeatureCategory)classifierCategory;

/**
 * Retreive the feature subcategory
 */
- (SGFeatureSubcategory)classifierSubcategory;

@end
