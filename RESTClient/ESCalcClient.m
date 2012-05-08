//
//  ESCalcMDGetClient.m
//  RESTClient
//
//  Created by A. Ansari on 4/26/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import "ESCalcClient.h"

@implementation ESCalcClient
@synthesize showResult;
@synthesize clientId;
@synthesize progressDelegate;

- (id)init {
    self = [super init];
    if (self) {
        
        [super setBaseUrl: @"http://localhost:8080"];
        [super setUserName:@"cawug"];
        [super setPassword:@"cawugpass"];
        showResult = NO;
        clientId = 1; // default ClientId
    }
    return self;
}

-(void) connection:(NSURLConnection *) connection customDidCompleteWithData: (NSData *) data { 

    [self.progressDelegate ping];
    
    if (showResult) { 

        NSError * error;
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            // TODO:  Handle the error
        }
        
        if ([json respondsToSelector:@selector(objectAtIndex:)]) {
            NSArray * a = (NSArray *) json;
            NSNumber * i = [a objectAtIndex:[a count] - 1];
            [self.progressDelegate dump:[NSString stringWithFormat:@"Client %d: %d", self.clientId, [i intValue]]];
        }
    }    
    
}


@end
