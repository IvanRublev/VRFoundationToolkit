//
//  VRProtocolConformation.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/* These allows one to prevent "message no implemented" crashes when working with delegates.
 * VRCanPerform allows to make check if method IS implemented by delegate before sending message to it.
 */

@interface NSObject (VRProtocolConformation)
- (BOOL)respondsToSelectorsRequiredByProtocol:(Protocol *)theProtocol;
+ (BOOL)respondsToSelectorsRequiredByProtocol:(Protocol *)theProtocol;
@end

FOUNDATION_EXPORT BOOL VRObjectRespondsToSelectorsRequiredByProtocol(id theObject, Protocol *theProtocol);
FOUNDATION_EXPORT BOOL VRCanPerform(id theObject, SEL theSelector, Protocol *theProtocol);

#define VRPerformSelectorUnderProtocolIfPossible(aObject, aSelector, aProtocol) do { if(VRCanPerform(aObject, aSelector, aProtocol)) [aObject performSelector:aSelector]; } while(0)
