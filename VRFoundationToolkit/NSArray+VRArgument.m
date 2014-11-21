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

- (void)passTo:(id)aTarget selector:(SEL)aSelector signature:(NSMethodSignature *)aSignature
{
    if ([aTarget respondsToSelector:aSelector]) {
        NSInvocation *anInvocation;
        if ([aSignature numberOfArguments] >= 3) {
            anInvocation = [NSInvocation invocationWithMethodSignature:aSignature];
            [anInvocation setSelector:aSelector];
            [anInvocation setTarget:aTarget];
            for (id __unsafe_unretained obj in self) {
                [anInvocation setArgument:&obj atIndex:2];
                [anInvocation invoke];
            }
        } else {
            VRLOG_ERROR_ASSERT(@"No where to pass an argument! selector: %@ must have one parameter at least!", NSStringFromSelector(aSelector));
        }
    } else {
        VRLOG_ERROR_ASSERT(@"target: %@ can't perform selector: %@", aTarget, NSStringFromSelector(aSelector));
    }
}

- (void)passTo:(id)aTarget selector:(SEL)aSelector
{
    NSMethodSignature *aSignature;
    aSignature = [[aTarget class] instanceMethodSignatureForSelector:aSelector];
    [self passTo:aTarget selector:aSelector signature:aSignature];
}

- (void)passToClass:(Class)aClass selector:(SEL)aSelector
{
    NSMethodSignature *aSignature;
    aSignature = [aClass methodSignatureForSelector:aSelector];
    [self passTo:aClass selector:aSelector signature:aSignature];
}

@end
