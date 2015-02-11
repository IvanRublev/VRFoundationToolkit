//
//  RTProtocol+VRMethodsTests.m
//  VRFoundationToolkitTests
//
//  Created by Ivan Rublev on 2/11/15.
//
//

#import <XCTest/XCTest.h>
#import <RTProtocol+VRMethods.h>

@protocol protocolA <NSObject>
+ (void)classMethodA;
- (void)instanceMethodA;
@optional
+ (void)optionalClassMethodA;
- (void)optionalInstanceMethodA;
@end

@protocol protocolB <protocolA>
+ (void)classMethodB;
- (void)instanceMethodB;
@optional
+ (void)optionalClassMethodB;
- (void)optionalInstanceMethodB;
@end


@interface RTProtocol_VRMethodsTests : XCTestCase <protocolB> {
    RTProtocol* aProtocol;
    RTProtocol* bProtocol;
}

@end

@implementation RTProtocol_VRMethodsTests

- (void)setUp
{
    [super setUp];
    aProtocol = [RTProtocol protocolWithName:@"protocolA"];
    bProtocol = [RTProtocol protocolWithName:@"protocolB"];
}

- (void)tearDown
{
    aProtocol = nil;
    bProtocol = nil;
    [super tearDown];
}

- (void)testClassSelectorsNames {
    NSSet* classSelectorsNamesOfA = [aProtocol classSelectorsNames];
    NSSet* classSelectorsNamesOfB = [bProtocol classSelectorsNames];
    
    NSSet* aNames = [NSSet setWithArray:@[@"classMethodA", @"optionalClassMethodA"]];
    XCTAssertTrue([classSelectorsNamesOfA isEqualToSet:aNames]);
    XCTAssertTrue([classSelectorsNamesOfA isSubsetOfSet:classSelectorsNamesOfB]);
    XCTAssertFalse([classSelectorsNamesOfB isSubsetOfSet:classSelectorsNamesOfA], @"there are less methods in A protocol then in B. B can't be subset of A.");
}

- (void)testInstanceSelectorsNames {
    NSSet* instanceSelectorsNamesOfA = [aProtocol instanceSelectorsNames];
    NSSet* instanceSelectorsNamesOfB = [bProtocol instanceSelectorsNames];
    
    NSSet* aNames = [NSSet setWithArray:@[@"instanceMethodA", @"optionalInstanceMethodA"]];
    XCTAssertTrue([instanceSelectorsNamesOfA isEqualToSet:aNames]);
    XCTAssertTrue([instanceSelectorsNamesOfA isSubsetOfSet:instanceSelectorsNamesOfB]);
    XCTAssertFalse([instanceSelectorsNamesOfB isSubsetOfSet:instanceSelectorsNamesOfA], @"there are less methods in A protocol then in B. B can't be subset of A.");
}

- (void)testRequiredClassSelectorsNames {
    NSSet* classSelectorsNamesOfA = [aProtocol requiredClassSelectorsNames];
    NSSet* classSelectorsNamesOfB = [bProtocol requiredClassSelectorsNames];
    
    NSSet* aNames = [NSSet setWithArray:@[@"classMethodA"]];
    XCTAssertTrue([classSelectorsNamesOfA isEqualToSet:aNames]);
    XCTAssertTrue([classSelectorsNamesOfA isSubsetOfSet:classSelectorsNamesOfB]);
    XCTAssertFalse([classSelectorsNamesOfB isSubsetOfSet:classSelectorsNamesOfA], @"there are less methods in A protocol then in B. B can't be subset of A.");
}

- (void)testRequiredInstanceSelectorsNames {
    NSSet* instanceSelectorsNamesOfA = [aProtocol requiredInstanceSelectorsNames];
    NSSet* instanceSelectorsNamesOfB = [bProtocol requiredInstanceSelectorsNames];
    
    NSSet* aNames = [NSSet setWithArray:@[@"instanceMethodA"]];
    XCTAssertTrue([instanceSelectorsNamesOfA isEqualToSet:aNames]);
    XCTAssertTrue([instanceSelectorsNamesOfA isSubsetOfSet:instanceSelectorsNamesOfB]);
    XCTAssertFalse([instanceSelectorsNamesOfB isSubsetOfSet:instanceSelectorsNamesOfA], @"there are less methods in A protocol then in B. B can't be subset of A.");
}

@end
