//
//  NSArray+VRIndexesTest.m
//  VRFoundationToolkitTests
//
//  Created by Ivan Rublev on 2/11/15.
//
//

#import <XCTest/XCTest.h>
#import <NSArray+VRIndexes.h>

@interface NSArray_VRIndexesTest : XCTestCase
@end

@implementation NSArray_VRIndexesTest

//- (void)setUp {
//    [super setUp];
//}
//
//- (void)tearDown {
//    [super tearDown];
//}

- (void)testIndexesOfObjectsFromArray {
    NSArray* severalObjects = @[@"a", @1, @"b", @7, @5];

    NSArray* foundObjects = @[@"a", @7];
    NSMutableIndexSet* foundIndexes = [NSMutableIndexSet indexSet];
    [foundIndexes addIndex:0];
    [foundIndexes addIndex:3];
    
    NSArray* notFoundObjects = @[@"c", @10];
    NSIndexSet* notFoundIndexes = [NSIndexSet indexSet];
    
    // testing
    NSIndexSet* indexesOfFound = [severalObjects indexesOfObjectsFromArray:foundObjects];
    XCTAssertTrue([indexesOfFound isEqualToIndexSet:foundIndexes], @"result index set (%@) must be equal to set (%@)", indexesOfFound, foundIndexes);
    NSIndexSet* indexesOfNotFound = [severalObjects indexesOfObjectsFromArray:notFoundObjects];
    XCTAssertTrue([indexesOfNotFound isEqualToIndexSet:notFoundIndexes], @"result index set (%@) must be equal to set (%@)", indexesOfNotFound, notFoundIndexes);
}


@end
