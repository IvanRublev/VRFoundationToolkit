//
//  NSOperationQueue+VRNamedBlock.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/23/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSOperationQueue+VRNamedBlock.h"

#ifndef NSFoundationVersionNumber_iOS_8_0
#define NSFoundationVersionNumber_iOS_8_0 1134.10 //extracted with NSLog(@"%f", NSFoundationVersionNumber)
#endif

#ifndef NSFoundationVersionNumber10_10
#define NSFoundationVersionNumber10_10 1151.16
#endif

@implementation NSOperationQueue (VRNamedBlock)
- (void)putOperationWithName:(NSString*)operationName andBlock:(void (^)(void))block;
{
    if (!block) {
        return;
    }
    NSOperation* blockOperation = [NSBlockOperation blockOperationWithBlock:block];
    if (operationName.length &&
        (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_8_0 ||
         NSFoundationVersionNumber >= NSFoundationVersionNumber10_10)) {
        blockOperation.name = operationName;
    }
    [self addOperation:blockOperation];
}
@end

