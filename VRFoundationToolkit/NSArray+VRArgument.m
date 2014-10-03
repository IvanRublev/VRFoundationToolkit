//
//  NSArray+VRArgument.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 10/3/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSArray+VRArgument.h"
#import "VRLog.h"

@implementation NSArray (VRArgument)

- (void)passTo:(id)target selector:(SEL)selector
{
    if ([target respondsToSelector:selector]) {
        NSMethodSignature *aSignature;
        NSInvocation *anInvocation;
        aSignature = [[target class] instanceMethodSignatureForSelector:selector];
        if ([aSignature numberOfArguments] >= 3) {
            anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
            [anInvocation setSelector:selector];
            [anInvocation setTarget:target];
            for (id __unsafe_unretained obj in self) {
                [anInvocation setArgument:&obj atIndex:2];
                [anInvocation invoke];
            }
        } else {
            VRLOG_ERROR_ASSERT(@"No where to pass an argument! selector: %@ must have one parameter at least!", NSStringFromSelector(selector));
        }
    } else {
        VRLOG_ERROR_ASSERT(@"target: %@ can't perform selector: %@", target, NSStringFromSelector(selector));
    }
}

@end
