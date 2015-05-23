//
//  NSOperationQueue+VRNamedBlockTest.m
//  VRFoundationToolkitTests
//
//  Created by Ivan Rublev on 5/23/15.
//
//

#import <XCTest/XCTest.h>
#import <NSOperationQueue+VRNamedBlock.h>


@interface ObjectWithQueue : NSObject
@property id someExternalObj;
@property NSOperationQueue* queue;
@end

@implementation ObjectWithQueue
- (void)addOperationWithObjectToRetain:(id)obj
{
    [self.queue putOperationWithName:@"cycled operation" andBlock:^{
        self.someExternalObj = obj;
    }];
}
@end


@interface NSOperationQueue_VRNamedBlockTest : XCTestCase
@end

@implementation NSOperationQueue_VRNamedBlockTest

- (void)testBreakingOfRetainCycle {
    ObjectWithQueue* obj = [ObjectWithQueue new];
    ObjectWithQueue* __weak objWeak = obj;
    
    @autoreleasepool {
        obj.queue = [NSOperationQueue new];
        obj.queue.maxConcurrentOperationCount = 1;
        
        [obj addOperationWithObjectToRetain:obj.queue];
        [obj.queue waitUntilAllOperationsAreFinished];
        obj = nil;
    }
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
    
    XCTAssertNil(objWeak); // we must be nil
}

- (void)testAliveOfRetainCycle {
    NSOperationQueue* myQueue = [NSOperationQueue new];
    myQueue.maxConcurrentOperationCount = 1;
    myQueue.suspended = YES;
    NSOperationQueue* __weak myQueue_weak = myQueue;
    
    ObjectWithQueue* obj = [ObjectWithQueue new];
    ObjectWithQueue* __weak objWeak = obj;
    
    @autoreleasepool {
        obj.queue = [NSOperationQueue new];
        obj.queue.maxConcurrentOperationCount = 1;
        obj.queue.suspended = YES;
        
        [obj addOperationWithObjectToRetain:obj.queue];
        obj = nil;
        
        [myQueue addOperationWithBlock:^{
            NSLog(@"tough me");
        }];
        myQueue = nil;
    }
    CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.01, YES);
    
    XCTAssertNotNil(objWeak);
    XCTAssertNotNil(myQueue_weak);
}


@end
