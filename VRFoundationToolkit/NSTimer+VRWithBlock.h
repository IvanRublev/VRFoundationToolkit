//
//  NSTimer+VRWithBlock.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/28/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Creates timer with block, as suggested at http://stackoverflow.com/a/6587117/2924596
 */
@interface NSTimer (VRWithBlock)
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)theSeconds repeats:(BOOL)repeats block:(void (^)(void))block;
@end
