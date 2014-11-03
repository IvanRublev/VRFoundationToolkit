//
//  VRComparison.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 11/3/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRComparison.h"

NSComparisonResult NSComparisonInvertedResult(NSComparisonResult result)
{
    NSComparisonResult newResult = result;
    if (newResult == NSOrderedAscending) {
        newResult = NSOrderedDescending;
    } else if (newResult == NSOrderedDescending) {
        newResult = NSOrderedAscending;
    }
    return newResult;
}