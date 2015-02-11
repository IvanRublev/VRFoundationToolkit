//
//  NSArray+VRIndexes.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/11/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSArray+VRIndexes.h"

@implementation NSArray (VRIndexes)

- (NSIndexSet*)indexesOfObjectsFromArray:(NSArray*)theArray
{
    if (!self.count) {
        return [NSIndexSet indexSet];
    }
    NSIndexSet* indexes = [self indexesOfObjectsPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
        NSUInteger indexOfObj = [theArray indexOfObject:obj];
        return indexOfObj != NSNotFound;
    }];
    return indexes;
}

@end
