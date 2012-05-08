//
//  ESCalcClient.h
//  RESTClient
//
//  Created by A. Ansari on 4/26/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import "ESRestClient.h"
#import "ESProgressOwner.h"

@interface ESCalcClient : ESRestClient

@property (assign, nonatomic) BOOL showResult;
@property (assign, nonatomic) int clientId;
@property (assign, nonatomic) id<ESProgressOwner> progressDelegate;

@end
