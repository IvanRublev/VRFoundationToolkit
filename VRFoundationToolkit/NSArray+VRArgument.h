//
//  NSArray+VRArgument.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 10/3/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (VRArgument)
- (void)passTo:(id)aTarget selector:(SEL)aSelector;
- (void)passToClass:(Class)aClass selector:(SEL)aSelector;
@end
