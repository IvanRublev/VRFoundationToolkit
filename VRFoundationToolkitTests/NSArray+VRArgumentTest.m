//
//  NSArray+VRArgumentTest.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 10/3/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+VRArgument.h"

@interface NSArray_VRArgumentTest : XCTestCase

@end

@implementation NSArray_VRArgumentTest

NSUInteger summ;

- (void)summator:(NSNumber *)num
{
    summ += [num unsignedIntegerValue];
}

- (void)noParamMethod
{
    
}

- (void)testFailures
{
    NSArray * myArr = @[@(1), @(2), @(3)];
    XCTAssertThrows([myArr passTo:self selector:@selector(noSelector)], @"Must throw exception because of nonexistent selector");
    XCTAssertThrows([myArr passTo:self selector:@selector(noParamMethod)], @"Must throw exception because of no parameter in selector");
    summ = 0;
    [myArr passTo:self selector:@selector(summator:)];
    NSUInteger expected = 6;
    XCTAssertTrue(summ == expected, @"Summator function was not called? Returned: %d expected: %d", summ, expected);
}

@end
