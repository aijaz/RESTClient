//
//  ESProgressOwner.h
//  RESTClient
//
//  Created by Aijaz Ansari on 5/6/12.
//  Copyright (c) 2012 Aijaz Ansari. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ESProgressOwner <NSObject>

-(void) ping;
-(void) dump: (NSString *) string;

@end
