//
//  NSObject+VRPropertiesProcessingTests.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/26/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "VRPPMyClass.h"
#import "VRPPMyClassWithStructProperty.h"
#import <NSObject+VRPropertiesProcessing.h>
#import "VRPPMyClassConditionalProperties.h"

@interface NSObject_VRPropertiesProcessingTests : XCTestCase {
    VRPPMyClass * obj1, * obj2, * obj3;
}

@end

#define VRPPSrtMatchesRegexp(str,rexp) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", rexp] evaluateWithObject:str]
#define VRPPAssertRegexp(str, pattern) do { BOOL tr = VRPPSrtMatchesRegexp(str, pattern);\
XCTAssertTrue(tr, @"Value %@ does not matches pattern %@!", str, pattern);} while(0)

@implementation NSObject_VRPropertiesProcessingTests

- (void)setUp
{
    [super setUp];
    obj1 = [VRPPMyClass new];
    obj2 = [VRPPMyClass new];
    obj3 = [VRPPMyClass new];
}

- (void)tearDown
{
    obj3 = nil;
    obj2 = nil;
    obj1 = nil;
    [super tearDown];
}

- (void)testDescriptionWithPropertiesTypes
{
    NSString * value = [obj1 descriptionWithPropertiesTypes];
    NSLog(@"====");
    NSLog(@"Properties types of an obj1: %@", value);
    NSLog(@"====");
    
    VRPPAssertRegexp(value, @"<VRPPMyClass:[a-zA-Z0-9]+ \\.value:__NSCFNumber \\.title:\\(null\\) \\.value2:__NSCFNumber>");
}

- (void)testDescriptionWithProperties
{
    NSString * value = [obj1 descriptionWithProperties];
    NSLog(@"====");
    NSLog(@"Properties of an empty obj1: %@", value);
    NSLog(@"====");

    VRPPAssertRegexp(value, @"<VRPPMyClass:[a-zA-Z0-9]+ \\.value=0 \\.title=\\(null\\) \\.value2=0>");
}


// ↓↓↓
- (void)fillObj:(VRPPMyClass *)obj
{
    obj.value = 100;
    obj.title = @"Hello";
    obj.constInvisible = @"You will not see this"; // because property begins with const
    obj.superTitle = @"And this also"; // because the property is inherited from super class
    [obj setValue:@(200) forKey:@"value2"]; // do in such way because declaration is hidden
}

- (void)testEnumeratePropertiesUsingBlock
{
    [self fillObj:obj1];
    
    NSMutableString * values = [NSMutableString stringWithString:@""];
    [obj1 enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        [values appendFormat:@".%@ = %@; ", propertyName, propertyValue];
    }];
    NSLog(@"====");
    NSLog(@"Values of properties of the filled obj1: %@", values);
    NSLog(@"====");

    VRPPAssertRegexp(values, @"\\.value = 100; \\.title = Hello; \\.value2 = 200; ");
}
// ↑↑↑


- (void)testIsEqualByProperties
{
    [self fillObj:obj1];
    [self fillObj:obj2];
    XCTAssertTrue([obj1 isEqualByProperties:obj1], @"obj must be equal self!");
    XCTAssertTrue([obj1 isEqualByProperties:obj2], @"obj must be equal to object filled with same values!");
    XCTAssertTrue([obj2 isEqualByProperties:obj1], @"obj must be equal to object filled with same values!"); // vice versa
    XCTAssertFalse([obj1 isEqualByProperties:obj3], @"obj must not be equal empty object!");
    XCTAssertFalse([obj3 isEqualByProperties:obj1], @"obj must not be equal empty object!");
    obj1.title = nil;
    obj2.title = nil;
    XCTAssertTrue([obj1 isEqualByProperties:obj2], @"obj must be equal to object filled with same values!");
    obj2.value = 0;
    XCTAssertFalse([obj1 isEqualByProperties:obj2], @"objects must be different!");
}

- (void)testEqualByPropertiesWithStructures
{
    VRPPMyClassWithStructProperty * structObj1 = [VRPPMyClassWithStructProperty new];
    VRPPMyClassWithStructProperty * structObj2 = [VRPPMyClassWithStructProperty new];
    VRPPMyClassWithStructProperty * structObj3 = [VRPPMyClassWithStructProperty new];
    NSString * commonTitle = @"Hello";
    MyStruct commonStruct = (MyStruct){123, 1.02};
    NSRange commonRange = NSMakeRange(7, 268);
    structObj1.title = commonTitle;
    structObj1.structure = commonStruct;
    structObj1.range = commonRange;
    structObj2.title = commonTitle;
    structObj2.structure = commonStruct;
    structObj2.range = commonRange;

    XCTAssertThrows([structObj1 isEqualByProperties:structObj1], @"Must throw exception because of structures");
    
    VRCheckStructuresEqualityBlock checkerBlock = ^BOOL(id objFirst, id objSecond, NSSet *structurePropertiesNames) {
        VRPPMyClassWithStructProperty * structObjFirst = objFirst;
        VRPPMyClassWithStructProperty * structObjSecond = objSecond;
        return
        structObjFirst.structure.a == structObjSecond.structure.a &&
        structObjFirst.structure.b == structObjSecond.structure.b &&
        structObjFirst.range.location == structObjSecond.range.location &&
        structObjFirst.range.length == structObjSecond.range.length;
    };
    XCTAssertTrue([structObj1 isEqualByProperties:structObj1 checkStructuresEqualityBlock:checkerBlock], @"obj must be equal self!");
    XCTAssertTrue([structObj1 isEqualByProperties:structObj2 checkStructuresEqualityBlock:checkerBlock], @"obj must be equal to object filled with same values!");
    XCTAssertTrue([structObj2 isEqualByProperties:structObj1 checkStructuresEqualityBlock:checkerBlock], @"obj must be equal to object filled with same values!"); // vice versa
    XCTAssertFalse([structObj1 isEqualByProperties:structObj3 checkStructuresEqualityBlock:checkerBlock], @"obj must not be equal empty object!");
    XCTAssertFalse([structObj3 isEqualByProperties:structObj1 checkStructuresEqualityBlock:checkerBlock], @"obj must not be equal empty object!");
    structObj1.title = nil;
    structObj2.title = nil;
    XCTAssertTrue([structObj1 isEqualByProperties:structObj2 checkStructuresEqualityBlock:checkerBlock], @"obj must be equal to object filled with same values!");
    structObj2.structure = (MyStruct){900, 123.133};
    XCTAssertFalse([structObj1 isEqualByProperties:structObj2 checkStructuresEqualityBlock:checkerBlock], @"objects must be different!");
}

- (void)testDeepCopyPropertiesToNewInstanceWithZone
{
    [self fillObj:obj1];
    VRPPMyClass * objNew = [obj1 deepCopyPropertiesToNewInstanceWithZone:nil];

    BOOL tr = [obj1 isEqualByProperties:objNew];
    NSLog(@"====");
    NSLog(@"objNew created as proprerty by property copy of obj1, and they are equal by properties = %d", tr);
    NSLog(@"====");
    
    XCTAssertTrue(tr, @"Objects must be equal after copying.");
}

- (void)testDeepCopyPropertiesTo
{
    [self fillObj:obj1];
    [obj1 deepCopyPropertiesTo:obj2];
    
    BOOL tr = [obj1 isEqualByProperties:obj2];
    NSLog(@"====");
    NSLog(@"obj2 filled property by property from obj1, and they are equal by properties = %d", tr);
    NSLog(@"====");
    
    XCTAssertTrue(tr, @"Objects must be equal after copying.");
}

- (void)testHashByProperties
{
    [self fillObj:obj1];
    
    NSUInteger obj1HashByProps = [obj1 hashByProperties];
    NSUInteger obj1UsuallHash  = [obj1 hash];
    VRPPMyClass * objNew = [obj1 deepCopyPropertiesToNewInstanceWithZone:nil];
    NSUInteger objNewHashByProps = [objNew hashByProperties];
    NSUInteger objNewUsuallHash  = [objNew hash];
    
    NSLog(@"====");
    NSLog(@"For obj1   hash by properties: %lu, usuall hash: %lu", (unsigned long)obj1HashByProps, (unsigned long)obj1UsuallHash);
    NSLog(@"For objNew hash by properties: %lu, usuall hash: %lu", (unsigned long)objNewHashByProps, (unsigned long)objNewUsuallHash);
    NSLog(@"Usuall hashes differs because VRPPMyClass itsefl doesn't contains address independent version of [-hash].");
    NSLog(@"====");

#if __LP64__
    NSUInteger etalon = 762917443134592889;
#else
    NSUInteger etalon = 1004900858;
#endif

    XCTAssertTrue(obj1HashByProps   == etalon, @"Hash must be equal to etalon!");
    XCTAssertTrue(objNewHashByProps == etalon, @"Hash must be equal to etalon!");
}

- (void)testHashByPropertiesWithStructures
{
    VRPPMyClassWithStructProperty * objStr = [VRPPMyClassWithStructProperty new];
    objStr.title = @"Hello";
    objStr.structure = (MyStruct){123, 1.02};
    objStr.range = NSMakeRange(7, 268);
    XCTAssertThrows([objStr hashByProperties], @"hashByProperties must trow exception with point to structure aware method.");

    NSUInteger theHash = [objStr hashByPropertiesWithHashStructuresBlock:^NSArray *(id object, NSSet *structurePropertiesNames) {
        return @[@(objStr.range.location*objStr.range.length), @((NSUInteger)(objStr.structure.a*objStr.structure.b))];
    }];

#if __LP64__
    NSUInteger etalon = 12373978410340;
#else
    NSUInteger etalon = 230845796;
#endif
    XCTAssertTrue(theHash == etalon, @"Hash (%lu) mustbe equal to etalon (%lu).", (unsigned long)theHash, (unsigned long)etalon);
    
}

- (void)testEncodePropertiesWithCoderAndInitPropertiesWithCoder
{
    [self fillObj:obj1];
    VRPPMyClass * unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:obj1]];
    BOOL tr = [obj1 isEqualByProperties:unarchivedObj];
    
    NSLog(@"==== Test fast implementing of NSCoding, see realisation of protocol in VRPPMyClass ====");
    NSLog(@"obj1:          %@", [obj1 descriptionWithProperties]);
    NSLog(@"unarchivedObj: %@", [unarchivedObj descriptionWithProperties]);
    NSLog(@"====");
    
    XCTAssertTrue(tr, @"unarchived object must have same values.");
}

- (void)testEncodePropertiesWithCoderEncodeStructuresAndInitPropertiesWithCoderDecodeStructures
{
    VRPPMyClassWithStructProperty * objWithStructProperty = [VRPPMyClassWithStructProperty new];
    NSString * title = @"The title";
    MyStruct filledStruct = {12, 0.4556989};
    objWithStructProperty.structure = filledStruct;
    objWithStructProperty.title = [NSString stringWithString:title];
    
    VRPPMyClassWithStructProperty * unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:objWithStructProperty]];
    BOOL tr =
    (objWithStructProperty.structure.a == unarchivedObj.structure.a) &&
    (objWithStructProperty.structure.b == unarchivedObj.structure.b) &&
    [objWithStructProperty.title isEqualToString:unarchivedObj.title];
    
    NSLog(@"==== Test fast implementing of NSCoding, see realisation of protocol in VRPPMyClass ====");
    NSLog(@"objWithStructProperty:          %@", [objWithStructProperty descriptionWithProperties]);
    NSLog(@"unarchivedObj: %@", [unarchivedObj descriptionWithProperties]);
    NSLog(@"====");
    
    @autoreleasepool {
        objWithStructProperty = nil;
    }
    
    XCTAssertTrue(tr, @"unarchived object must have same values.");
}

- (void)testEncodePropertiesWithCoderAndInitPropertiesWithCoderConditionalAndSkipNames
{
    VRPPMyClassConditionalProperties * myObject = [VRPPMyClassConditionalProperties new];
    myObject.value = 1234;
    myObject.title = @"Hello";
    myObject.conditionalTitle = @"This should be archived separetely.";
    myObject.skippyTitle = @"That will not survive.";
    myObject.constInvisible = @"This also.";

    NSLog(@"==== Test fast implementing of NSCoding, see realisation of protocol in VRPPMyClass ====");
    NSLog(@"myObject:      %@", [myObject descriptionWithProperties]);
    
    VRPPMyClassConditionalProperties * unarchivedObj = nil;
#define requiredPropsAreEqual ((myObject.value == unarchivedObj.value) && ([myObject.title isEqualToString: unarchivedObj.title]))

    myObject.constArchiveConditionalTitle = NO;
    unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:myObject]];
    NSLog(@"constArchiveConditionalTitle: %d", myObject.constArchiveConditionalTitle);
    NSLog(@"unarchivedObj: %@", [unarchivedObj descriptionWithProperties]);
    XCTAssertTrue(requiredPropsAreEqual, @"unarchived object must have same required values.");
    XCTAssertNil(unarchivedObj.conditionalTitle, @"conditionalTitle must be empty after unarchive.");

    myObject.constArchiveConditionalTitle = YES;
    unarchivedObj = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:myObject]];
    NSLog(@"constArchiveConditionalTitle: %d", myObject.constArchiveConditionalTitle);
    NSLog(@"unarchivedObj: %@", [unarchivedObj descriptionWithProperties]);
    XCTAssertTrue(requiredPropsAreEqual, @"unarchived object must have same required values.");
    XCTAssertNotNil(unarchivedObj.conditionalTitle, @"conditionalTitle must NOT be empty after unarchive.");
    
    NSLog(@"====");
   
}

@end
