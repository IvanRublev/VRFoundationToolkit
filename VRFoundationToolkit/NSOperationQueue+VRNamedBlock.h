//
//  NSOperationQueue+VRNamedBlock.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/23/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (VRNamedBlock)
- (void)putOperationWithName:(NSString*)operationName andBlock:(void (^)(void))block;
@end
