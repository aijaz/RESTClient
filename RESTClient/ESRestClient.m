//
//  ESRestClient.m
//  RESTClient
//
//  Created by A. Ansari on 4/26/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import "ESRestClient.h"

@implementation ESRestClient

@synthesize userName;
@synthesize password;
@synthesize delegate;
@synthesize baseUrl;
@synthesize request;
@synthesize receivedData;
@synthesize verbose;
@synthesize responseHeaders;
@synthesize responseStatus;

- (id)init {
    self = [super init];
    if (self) {
        
        [self setBaseUrl: @"http://www.example.com/"];
        [self setUserName:@"username"];
        [self setPassword:@"password"];
    }
    return self;
}


-(void) syncCall: (NSString *) url withMethod: (NSString *)method content:(NSString *)content   {
    
    // construct the URL
    NSURL * fullUrl = [NSURL URLWithString:[baseUrl stringByAppendingString:url]];
    
    // Create an HTTP request using that URL.  Mutable because we're gonna set the data
    request = [NSMutableURLRequest requestWithURL:fullUrl];
    
    // encode the data
    NSData * requestContent = [content dataUsingEncoding:NSUTF8StringEncoding];
    
    // and add it the request as the HTTP body
    [request setHTTPBody:requestContent];
    
    // use the appropriate METHOD
    [request setHTTPMethod:method];
    
    
    NSError * reqError;        
    
    // Create a synchronous HTTP reqeust
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:NULL error:&reqError];
    if (reqError) { 
        NSLog(@"Connection failed!! Error - %@ %@",
              [reqError localizedDescription],
              [[reqError userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
        
        if (self.delegate) { 
            // call custom error code
            [self.delegate connection:nil customDidFailWithError:reqError];
        }
        
        return;
    }
    
    // there was no nerror
    if (self.delegate) { 
        [self.delegate connection:nil customDidCompleteWithData:data];
    }
    
}

-(void) asyncCall: (NSString *) url withMethod :(NSString *)method content:(NSString *)content connectionDelegate: (id<NSURLConnectionDelegate>) connDelegate  {
    
    NSURL * fullUrl = [NSURL URLWithString:[baseUrl stringByAppendingString:url]];
    request = [NSMutableURLRequest requestWithURL:fullUrl];
    NSData * requestContent = [content dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:requestContent];
    [request setHTTPMethod:method];
    
    NSURLConnection *theConnection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (theConnection) {
        // Create the NSMutableData to hold the received data.
        // receivedData is an instance variable declared elsewhere.
        receivedData = [NSMutableData data];
    } else {
        // Inform the user that the connection failed.
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSHTTPURLResponse *)response
{
    // This method is called when the server has determined that it
    // has enough information to create the NSURLResponse.
    
    // It can be called multiple times, for example in the case of a
    // redirect, so each time we reset the data.
    if (self.verbose) { 
        NSLog(@"Did receive response");
    }
    
    [receivedData setLength:0];
    [self setResponseStatus:[response statusCode]];
    [self setResponseHeaders:[response allHeaderFields]];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.

    if (self.verbose) { 
        NSLog(@"Received %d bytes of data!", [data length]);
        NSLog(@"Content is '%@'", [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding]);
    };
    
    // this is whay it's mutable
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [receivedData setLength:0];
    receivedData = nil;
    
    // inform the user
    if (self.verbose) {
        NSLog(@"Connection failed! Error - %@ %@",
              [error localizedDescription],
              [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    }
    
    if (self.delegate) { 
        [self.delegate connection:connection customDidFailWithError:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    // do something with the data
    // receivedData is declared as a method instance elsewhere
    if (self.verbose) { 
        NSLog(@"Succeeded! Received %d bytes of data",[receivedData length]);
        NSLog(@"Content is '%@'", [[NSString alloc] initWithData:receivedData encoding: NSUTF8StringEncoding]);
        NSLog(@"Response status is %d",[self responseStatus]);
    }
    
    // release the connection, and the data object
    if (self.delegate) { 
        [self.delegate connection:connection customDidCompleteWithData:receivedData];
    }
    
}

-(void) connection:(NSURLConnection *) connection customDidCompleteWithData: (NSData *) data {
    // nothing to do in the base class
}

-(void) connection:(NSURLConnection *) connection customDidFailWithError:    (NSError *) error {
    // nothing to do in the base class
    NSLog(@"Failed With Error");
}





// This is called if we get an auth challenge 
// Normally you DONT send the user name and password the first time.
// Then you get an auth challenge
// THEN you send the user name and password
// It's a security risk to send a user name and password every time even if you're not asked for it.
//
-(void) connection:(NSURLConnection *) connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    if (self.verbose) { 
        NSLog(@"Got authentication challenge");
    }
    
    // Have I already failed at least once?
    // Multiple failures usually mean the password was incorrect
    
    if ([challenge previousFailureCount] > 0)  {
        
        // Why did I fail?
        
        NSError * failure = [challenge error];        
        NSLog(@"Can't authenticate: %@", [failure localizedDescription]);
        
        // Give up
        [[challenge sender] cancelAuthenticationChallenge:challenge];
        [self setResponseStatus:401];  // UNAUTHORIZED
        return;
        
    }
    
    // Create a credential
    NSURLCredential * newCred = [NSURLCredential credentialWithUser:self.userName 
                                                           password:self.password 
                                                        persistence:NSURLCredentialPersistenceNone];
    
    // supply the credential to the sender of the challenge
    [[challenge sender] useCredential:newCred forAuthenticationChallenge:challenge];
}



@end
