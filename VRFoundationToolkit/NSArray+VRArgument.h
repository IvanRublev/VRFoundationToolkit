//
//  NSArray+VRArgument.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 10/3/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (VRArgument)
- (void)passTo:(id)target selector:(SEL)selector;
- (void)passToClass:(Class)class selector:(SEL)selector;
@end
