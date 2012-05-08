//
//  ESViewController.m
//  RESTClient
//
//  Created by A. Ansari on 4/26/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import "ESViewController.h"
#import "ESCalcClient.h"

@interface ESViewController () {
    int maxPings;
    int currentPings;
}

@end

@implementation ESViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    maxPings = 201;
    currentPings = 0;
    [progressView setHidden:YES];
    [progressView setProgress:0.0f];
    [textView setText:@""];


    webServicesQueue = dispatch_queue_create("com.euclidsoftware.webServicesQueue", NULL);

}

- (void)viewDidUnload
{
    progressView = nil;
    textView = nil;
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)buttonClicked:(id)sender {

    ESCalcClient * client = [[ESCalcClient alloc] init];
    [client setVerbose:NO];
    [client setDelegate: client];
    [client setShowResult:NO];
    [client setProgressDelegate:self];
    [textView setText:@""];
    [progressView setProgress:0.0f];
    [progressView setHidden:NO];
    
    maxPings = 21;
    currentPings = 0;
    
    NSString * urlStr;
    
    dispatch_async(webServicesQueue, ^{     
        [client syncCall:@"/rest/calc" withMethod:@"DELETE" content:@""];
    });
    
    
    int i;
    for (i = 1; i <= 10; i++) { 
        urlStr = [NSString stringWithFormat:@"/rest/calc/1/%d", i];
        dispatch_async(webServicesQueue, ^{     
            [client syncCall:urlStr withMethod:@"PUT" content:@""];
        });
    }

    dispatch_async(webServicesQueue, ^{     
        [client syncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@""];
    });
    dispatch_async(webServicesQueue, ^{     
        [client syncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@""];
    });
    dispatch_async(webServicesQueue, ^{     
        [client syncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@""];
    });
    dispatch_async(webServicesQueue, ^{     
        [client syncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@""];
        [client syncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@""];
        [client syncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@""];
        [client syncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@""];
        [client syncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@""];
        [client syncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@""];

        [client setClientId:1];
        [client setShowResult:YES];
        [client syncCall:@"/rest/calc/1" withMethod:@"GET" content:@""];
    });
        

}

- (IBAction)sendAsync:(id)sender {
    ESCalcClient * client = [[ESCalcClient alloc] init];
    [client setVerbose:NO];
    [client setDelegate: client];
    [client setShowResult:NO];
    [client setProgressDelegate:self];    
    [progressView setProgress:0.0f];
    [progressView setHidden:NO];
    [textView setText:@""];
    
    currentPings = 0;
    maxPings = 20;

    NSString * urlStr;

    [client asyncCall:@"/rest/calc" withMethod:@"DELETE" content:@"" connectionDelegate:client];
    int i;
    for (i = 1; i <= 10; i++) { 
        urlStr = [NSString stringWithFormat:@"/rest/calc/1/%d", i];
        [client asyncCall:urlStr withMethod:@"PUT" content:@"" connectionDelegate:client];
    }
    
    [client asyncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/*" withMethod:@"PUT" content:@"" connectionDelegate:client];
    [client asyncCall:@"/rest/calc/1/-" withMethod:@"PUT" content:@"" connectionDelegate:client];
    
    [client setClientId:2];
    [client setShowResult:YES];
    [client asyncCall:@"/rest/calc/1" withMethod:@"GET" content:@"" connectionDelegate:client];
   


    
}



-(void) ping { 
    currentPings++;
    double pct = 1.0*currentPings/maxPings;
   // NSLog(@"Ping! %d/%d %f", currentPings, maxPings, pct);
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressView setProgress:pct];
        [progressView setNeedsDisplay];
    });
}

-(void) dump:(NSString *)string { 
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressView setHidden:YES];
        [textView setText:string];
    });
}







- (IBAction)sendAsyncOperators:(id)sender {
    
    // not called any more
}


@end
