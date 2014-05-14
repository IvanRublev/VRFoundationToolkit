//
//  VRTypeOfTests.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/14/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRTypeOf.h"

@interface VRTypeOfTests : XCTestCase

@end

@implementation VRTypeOfTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testVRIS_TYPE_EQUAL_TO_TYPE
{
    typedef struct sMYStruct {
        int a;
        double b;
    } MYStruct;
    typedef struct sMYOtherStruct {
        double m;
    } MYOtherStruct;
    
    MYStruct struct1;
    MYStruct struct2;
    MYOtherStruct struct3;
    id strObj = [NSString stringWithFormat:@"hello there %d", 2];
    id numObj = [NSNumber numberWithInt:1233];
    NSNumber * numObj2 = [NSNumber numberWithFloat:0.4566];
    NSString * strObj2 = @"eehaaa";
    int theInt = 2323;
    double theDouble = 0.12341;
    float theFloat = 0.789789;
    
    XCTAssertTrue(VRIS_TYPE_EQUAL_TO_TYPE(struct1, struct2), @"MYStruct must be equal MYStruct");
    XCTAssertTrue(VRIS_TYPE_EQUAL_TO_TYPE(struct3, struct3), @"MYOtherStruct must be equal itself");
    XCTAssertTrue(VRIS_TYPE_EQUAL_TO_TYPE(strObj, strObj2), @"id (NSString) must be equal NSString");
    XCTAssertTrue(VRIS_TYPE_EQUAL_TO_TYPE(numObj, numObj2), @"id (NSNumber) must be equal NSNumber");
    XCTAssertTrue(VRIS_TYPE_EQUAL_TO_TYPE(struct1.a, theInt), @"int must be equal int");
    XCTAssertTrue(VRIS_TYPE_EQUAL_TO_TYPE(struct1.b, theDouble), @"double must be equal double");
    XCTAssertTrue(VRIS_TYPE_EQUAL_TO_TYPE(long long int, long long int), @"long long int must be equal long long int");
    
    XCTAssertFalse(VRIS_TYPE_EQUAL_TO_TYPE(struct2, struct3), @"MYStruct must NOT be equal MYOtherStruct");
    XCTAssertFalse(VRIS_TYPE_EQUAL_TO_TYPE(struct1, strObj), @"MYStruct must NOT be equal to id (NSString)");
    XCTAssertFalse(VRIS_TYPE_EQUAL_TO_TYPE(struct1, numObj), @"MYStruct must NOT be equal to NSNumber");
    XCTAssertFalse(VRIS_TYPE_EQUAL_TO_TYPE(struct1, strObj2), @"MYStruct must NOT be equal to NSString");
    XCTAssertFalse(VRIS_TYPE_EQUAL_TO_TYPE(struct3.m, theFloat), @"double must NOT be equal float");
    
}

@end
