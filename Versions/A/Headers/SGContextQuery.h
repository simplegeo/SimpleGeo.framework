//
//  SGContextQuery.h
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

#import "SGQuery.h"

/**
 * An SGContextQuery object stores query information for a SimpleGeo Context API request.
 * To make a Context request, create an SGContextQuery object and call [SimpleGeo getContextForQuery:callback:].
 *
 * - Specify *filters* to request only specific parts of a full Context response.
 * - Specify *feature categories* to limit the types of polygons returned in the response.
 */
@interface SGContextQuery : SGQuery
{
    @private
    NSArray *featureCategories;
    NSArray *featureSubcategories;
    NSArray *filters;
    NSArray *acsTableIDs;
}

/// Feature categories to include in the Context response
@property (nonatomic, retain) NSArray *featureCategories;

/// Feature subcategories to include in the Context response
@property (nonatomic, retain) NSArray *featureSubcategories;

/// Filters for returning only part of a Context response
@property (nonatomic, retain) NSArray *filters;

/// ACS [demographics tables](https://simplegeo.com/docs/api-endpoints/simplegeo-context#demographics) to include in the Context response;
@property (nonatomic, retain) NSArray *acsTableIDs;

@end
