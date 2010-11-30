//
//  SGAPIClient+Places.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 11/29/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "SGAPIClient.h"


@interface SGAPIClient (Places)

- (void)getPlacesNear:(SGPoint *)point;
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query;
- (void)getPlacesNear:(SGPoint *)point
             matching:(NSString *)query
           inCategory:(NSString *)category;

@end
