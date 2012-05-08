//
//  ESViewController.h
//  RESTClient
//
//  Created by A. Ansari on 4/26/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESProgressOwner.h"

@interface ESViewController : UIViewController <ESProgressOwner> {

    dispatch_queue_t webServicesQueue;

    __weak IBOutlet UIProgressView *progressView;
    __weak IBOutlet UITextView *textView;
}

- (IBAction)buttonClicked:(id)sender;
- (IBAction)sendAsync:(id)sender;
- (IBAction)sendAsyncOperators:(id)sender;

@end
