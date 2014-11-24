//
//  VRProtocolConformationTests.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/27/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRProtocolConformation.h"
#import <objc/runtime.h>

#pragma mark -
#pragma mark Protocols for test
@protocol VRPCMyParentProtocol <NSObject>
- (NSString *)tellString:(NSString *)str;
+ (NSString *)makeString;
@end

@protocol VRPCMyChildProtocol <NSObject, VRPCMyParentProtocol>
- (NSUInteger)justReturnInput:(NSUInteger)input;
+ (NSNumber *)generateNumber;
@end

#pragma mark -
#pragma mark Classes for test
@interface VRPCParentClass : NSObject <VRPCMyParentProtocol>
@end

@implementation VRPCParentClass
- (NSString *)tellString:(NSString *)str
{
    return str;
}

+ (NSString *)makeString
{
    return @"maked string";
}
@end

@interface VRPCMyChildClass : VRPCParentClass <VRPCMyChildProtocol>
@end

@implementation VRPCMyChildClass
- (NSUInteger)justReturnInput:(NSUInteger)input
{
    return input;
}

+ (NSNumber *)generateNumber
{
    return @1;
}
@end

#pragma mark -
#pragma mark Partialy implemented class for test
@interface VRPCMyPartialImplementedClass : NSObject <VRPCMyChildProtocol>
@end

@implementation VRPCMyPartialImplementedClass
- (NSUInteger)justReturnInput:(NSUInteger)input
{
    return input;
}

+ (NSNumber *)generateNumber
{
    return @1;
}
@end


#pragma mark -
#pragma mark Tests
@interface VRProtocolConformationTests : XCTestCase {
    VRPCMyChildClass *fullyImplementedObject;
    VRPCMyPartialImplementedClass *partialyImplementedObject;
}

@end

@implementation VRProtocolConformationTests

- (void)setUp
{
    [super setUp];
    fullyImplementedObject = [VRPCMyChildClass new];
    partialyImplementedObject = [VRPCMyPartialImplementedClass new];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)checkVRCanPerformWithObject:(id)theObject selector:(SEL)theSelector protocol:(Protocol *)theProtocol returns:(BOOL)expectedAnswer
{
    XCTAssertFalse(VRCanPerform(nil, nil, nil),                     @"Must return NO");
    XCTAssertFalse(VRCanPerform(theObject, nil, nil),               @"Must return NO");
    XCTAssertFalse(VRCanPerform(nil, theSelector, nil),             @"Must return NO");
    XCTAssertFalse(VRCanPerform(nil, nil, theProtocol),             @"Must return NO");
    XCTAssertFalse(VRCanPerform(nil, theSelector, theProtocol),     @"Must return NO");
    XCTAssertFalse(VRCanPerform(theObject, nil, theProtocol),       @"Must return NO");
    XCTAssertFalse(VRCanPerform(theObject, theSelector, nil),       @"Must return NO");

    XCTAssert(VRCanPerform(theObject, theSelector, theProtocol) == expectedAnswer,    @"Must return %d!", expectedAnswer);
}

- (void)testVRCanPerform
{
    // Test selector declared in protocol against object
    [self checkVRCanPerformWithObject:fullyImplementedObject selector:@selector(justReturnInput:) protocol:@protocol(VRPCMyChildProtocol) returns:YES];
    XCTAssert([fullyImplementedObject justReturnInput:42] == 42, @"Input must match output.");
    // Test selector inherited in protocol from parent protocol against object
    [self checkVRCanPerformWithObject:fullyImplementedObject selector:@selector(tellString:) protocol:@protocol(VRPCMyChildProtocol) returns:YES];
    // Wrong object
    [self checkVRCanPerformWithObject:@1 selector:@selector(justReturnInput:) protocol:@protocol(VRPCMyChildProtocol) returns:NO];
    [self checkVRCanPerformWithObject:@1 selector:@selector(tellString:) protocol:@protocol(VRPCMyChildProtocol) returns:NO];
    // Test wrong protocol
    [self checkVRCanPerformWithObject:fullyImplementedObject selector:@selector(justReturnInput:) protocol:@protocol(NSCopying) returns:NO];
    [self checkVRCanPerformWithObject:fullyImplementedObject selector:@selector(tellString:) protocol:@protocol(NSCopying) returns:NO];

    
    // Test selector declared in protocol against Class
    [self checkVRCanPerformWithObject:[VRPCMyChildClass class] selector:@selector(generateNumber) protocol:@protocol(VRPCMyChildProtocol) returns:YES];
    // Test selector inherited in protocol from parent against Class
    [self checkVRCanPerformWithObject:[VRPCMyChildClass class] selector:@selector(makeString) protocol:@protocol(VRPCMyChildProtocol) returns:YES];
    // Wrong class
    [self checkVRCanPerformWithObject:[NSNumber class] selector:@selector(generateNumber) protocol:@protocol(VRPCMyChildProtocol) returns:NO];
    [self checkVRCanPerformWithObject:[NSNumber class] selector:@selector(makeString) protocol:@protocol(VRPCMyChildProtocol) returns:NO];
    // Test wrong protocol
    [self checkVRCanPerformWithObject:[VRPCMyChildClass class] selector:@selector(generateNumber) protocol:@protocol(NSCopying) returns:NO];
    [self checkVRCanPerformWithObject:[VRPCMyChildClass class] selector:@selector(makeString) protocol:@protocol(NSCopying) returns:NO];


    // Partially implemented object
    [self checkVRCanPerformWithObject:partialyImplementedObject selector:@selector(justReturnInput:) protocol:@protocol(VRPCMyChildProtocol) returns:YES];
    [self checkVRCanPerformWithObject:partialyImplementedObject selector:@selector(tellString:) protocol:@protocol(VRPCMyChildProtocol) returns:NO];
    // Partially implemented class
    [self checkVRCanPerformWithObject:[VRPCMyPartialImplementedClass class] selector:@selector(generateNumber) protocol:@protocol(VRPCMyChildProtocol) returns:YES];
    [self checkVRCanPerformWithObject:[VRPCMyPartialImplementedClass class] selector:@selector(makeString) protocol:@protocol(VRPCMyChildProtocol) returns:NO];
}

- (void)testVRObjectConformsToProtocol
{
    XCTAssertFalse([fullyImplementedObject respondsToSelectorsRequiredByProtocol:nil],          @"Must return NO");
    XCTAssertFalse([[fullyImplementedObject class] respondsToSelectorsRequiredByProtocol:nil],  @"Must return NO");
    
    XCTAssertTrue([fullyImplementedObject respondsToSelectorsRequiredByProtocol:@protocol(VRPCMyParentProtocol)],       @"Must return YES");
    XCTAssertTrue([fullyImplementedObject respondsToSelectorsRequiredByProtocol:@protocol(VRPCMyChildProtocol)],        @"Must return YES");

    XCTAssertFalse([partialyImplementedObject respondsToSelectorsRequiredByProtocol:@protocol(VRPCMyParentProtocol)],   @"Must return NO");
    XCTAssertTrue([partialyImplementedObject respondsToSelectorsRequiredByProtocol:@protocol(VRPCMyChildProtocol)],     @"Must return YES");
}

@end
