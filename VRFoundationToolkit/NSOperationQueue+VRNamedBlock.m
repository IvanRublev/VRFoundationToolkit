//
//  NSOperationQueue+VRNamedBlock.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/23/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSOperationQueue+VRNamedBlock.h"

@implementation NSOperationQueue (VRNamedBlock)
- (void)putOperationWithName:(NSString*)operationName andBlock:(void (^)(void))block;
{
    if (!block) {
        return;
    }
    NSOperation* blockOperation = [NSBlockOperation blockOperationWithBlock:block];
    if (operationName.length) {
        blockOperation.name = operationName;
    }
    [self addOperation:blockOperation];
}
@end

