//
//  NSTimer+VRWithBlock.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/28/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSTimer+VRWithBlock.h"

@implementation NSTimer (VRWithBlock)

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)theSeconds repeats:(BOOL)repeats block:(void (^)(void))block
{
    if (!block) {
        return nil;
    }
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:[self instanceMethodSignatureForSelector:@selector(runBlock:)]];
    NSTimer * timer = [NSTimer scheduledTimerWithTimeInterval:theSeconds
                                                   invocation:invocation
                                                      repeats:repeats];
    [invocation setTarget:timer];
    [invocation setSelector:@selector(runBlock:)];
    
    [invocation setArgument:&block atIndex:2];
    [invocation retainArguments];
    
    return timer;
}

- (void)runBlock:(void (^)(void))block {
    if (block) {
        block();
    }
}

@end
