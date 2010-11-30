//
//  SGAPIClient+Places.m
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGAPIClient+Places.h"


@implementation SGAPIClient (Places)

- (void)getPlacesNear:(SGPoint *)point
{
    [self getPlacesNear:point matching:nil];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
{
    [self getPlacesNear:point matching:query inCategory:nil];
}

- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category
{
    NSMutableString *endpoint = [NSMutableString stringWithFormat:@"/%@/places/%f,%f/search.json",
                                 SIMPLEGEO_API_VERSION, [point latitude], [point longitude]
                                 ];

    // this is ugly because NSURL doesn't handle setting query parameters well
    if (query && category) {
        [endpoint appendFormat:@"?q=%@&category=%@",
         [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
         [category stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
         ];
    } else if (category) {
        [endpoint appendFormat:@"?category=%@",
         [category stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
         ];
    } else if (query) {
        [endpoint appendFormat:@"?q=%@",
         [query stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]
         ];
    }

    NSURL *endpointURL = [self endpointForString:endpoint];
    NSLog(@"Endpoint: %@", endpoint);

    ASIHTTPRequest *request = [self requestWithURL:endpointURL];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          @"didLoadPlacesJSON:", @"targetSelector",
                          point, @"point",
                          query, @"matching",
                          category, @"category",
                          nil
                          ]];
    [request startAsynchronous];
}

@end
