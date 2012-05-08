//
//  ESRestClient.h
//  RESTClient
//
//  Created by A. Ansari on 4/26/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ESRestDelegate.h"


@interface ESRestClient : NSObject <ESRestDelegate, NSURLConnectionDelegate>

// This is a little bit of overkill to have a object be a delegate and also 
// contain a delegate.  Sometimes it's useful, though.
@property (assign, nonatomic) id<ESRestDelegate> delegate;

@property (retain, nonatomic) NSString * userName;
@property (retain, nonatomic) NSString * password;

@property (retain, nonatomic) NSString * baseUrl;
@property (nonatomic, retain) NSMutableURLRequest *request;

// mutable because we'll be adding to this data as we receive packets from the server
@property (nonatomic, retain) NSMutableData *receivedData;

@property (assign, nonatomic) BOOL verbose;
@property (retain, nonatomic) NSDictionary * responseHeaders;
@property (assign, nonatomic) NSInteger responseStatus;

// I call the web services synchronously, but on their own dispatch queue.
// In my experience I've found that the order of web service calls is important.

-(void) syncCall: (NSString *) url withMethod :(NSString *)method content:(NSString *)content ;
-(void) asyncCall: (NSString *) url withMethod :(NSString *)method content:(NSString *)content connectionDelegate: (id<NSURLConnectionDelegate>) connDelegate ;


@end
