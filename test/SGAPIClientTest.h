//
//  SGAPIClientTest.h
//  SimpleGeo
//
//  Created by Seth Fitzsimmons on 12/2/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <GHUnit/GHUnit.h>
#import "SGAPIClient.h"


@interface SGAPIClientTest : GHAsyncTestCase

- (SGAPIClient *)createClient;
- (SGPoint *)point;

@end
