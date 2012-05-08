//
//  ESRestDelegate.h
//  RESTClient
//
//  Created by A. Ansari on 4/26/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ESRestDelegate <NSObject>

-(void) connection:(NSURLConnection *) connection customDidCompleteWithData: (NSData *) data;
-(void) connection:(NSURLConnection *) connection customDidFailWithError:    (NSError *) error;

@end
