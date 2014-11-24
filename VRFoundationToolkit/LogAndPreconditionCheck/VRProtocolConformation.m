//
//  VRProtocolConformation.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRProtocolConformation.h"
#import <VRLog.h>
#import <MAObjCRuntime/RTProtocol.h>
#import <MAObjCRuntime/RTMethod.h>

@implementation NSObject (VRProtocolConformation)

/**
 *  Returns YES if object responds to selectors of methods required by specified protocol (optional methods aren't checked). It's usefull to check wheither the object contain protocol method bodies.
 *  Can be used in delegate setter like following:
 * @code
 - (void)setDelegate:(id<MyProtocol>)delegate
 {
 VRPRECONDITION_LOG_ERROR_ASSERT_RETURN([delegate respondsToSelectorsRequiredByProtocol:@protocol(MyProtocol)]);
 _delegate = delegate;
 }
 * @endcode
 *  @param theProtocol - which required method selectors the object must response
 *
 *  @return YES if all methods required by protocol could be called on object.
 */
- (BOOL)respondsToSelectorsRequiredByProtocol:(Protocol *)theProtocol
{
    return VRObjectRespondsToSelectorsRequiredByProtocol(self, theProtocol);
}

/**
 *  Returns YES if class responds to selectors of methods required by specified protocol (optional methods aren't checked). It's usefull to check wheither the class contain protocol method bodies.
 *
 *  @param theProtocol - which required method selectors the object must response
 *
 *  @return YES if all methods required by protocol could be called on class.
 */
+ (BOOL)respondsToSelectorsRequiredByProtocol:(Protocol *)theProtocol
{
    return VRObjectRespondsToSelectorsRequiredByProtocol(self, theProtocol);
}
@end

/**
 *  VRObjectRespondsToSelectorsRequiredByProtocol - function returns YES if object responds to selectors of required methods of specified protocol (optional methods aren't checked). It's usefull to check wheither the object contain protocol method bodies.
 *  Can be used in delegate setter like following:
 * @code
    - (void)setDelegate:(id<MyProtocol>)delegate
    {
        VRPRECONDITION_LOG_ERROR_ASSERT_RETURN(VRObjectRespondsToSelectorsRequiredByProtocol(delegate, @protocol(MyProtocol)));
        _delegate = delegate;
    }
 * @endcode
 *  @param object   object to check for responding
 *  @param protocol protocol which required methods selectors the object must response
 *
 *  @return YES if all methods could be called on provided object.
 */
FOUNDATION_EXPORT BOOL VRObjectRespondsToSelectorsRequiredByProtocol(id theObject, Protocol *theProtocol)
{
    if (!theObject || !theProtocol ) {
        return NO;
    }
    BOOL pass = YES;
    if ([theObject conformsToProtocol:theProtocol]) {
        RTProtocol * protocolObj = [RTProtocol protocolWithObjCProtocol:theProtocol];
        NSArray *instanceMethods = [protocolObj methodsRequired:YES instance:YES];
        for (RTMethod *methodObj in instanceMethods) {
            pass &= [theObject respondsToSelector:methodObj.selector];
            if (!pass) {
                VRLOG_ERROR(@"Object: %@ doesn't respond to: %@ selector", theObject, methodObj.selectorName);
                break;
            }
        }
    } else {
        pass = NO;
    }
    return pass;
}

/* VRCanPerform - function returns YES if object responds to selector under protocol.
 * We assume that object is a valid pointer of object. If not then behaiviour is unexpected.
 */
FOUNDATION_EXPORT BOOL VRCanPerform(id theObject, SEL theSelector, Protocol *theProtocol)
{
    if (!theObject || !theSelector || !theProtocol ) {
        return NO;
    }
    
    if ([theObject conformsToProtocol:theProtocol] &&
        [theObject respondsToSelector:theSelector]) {
        return YES;
    }
    return NO;
}

