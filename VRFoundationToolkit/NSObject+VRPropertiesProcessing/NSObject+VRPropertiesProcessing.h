//
//  NSObject+VRPropertiesProcessing.h
//
//  Created by Ivan Rublev on 6/3/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import <Foundation/Foundation.h>

/* NSObject+VRPropertiesProcessing category.
 *
 * Following methods walk through object instance's properties and run specified routine.
 * Properties that are declared in empty category of class within appropriate .m file are processed also.
 *
 * Processing runs with following restrictions:
 * - No ivars are processed.
 * - Only properties declared DIRECTLY IN CLASS are taken in account, no superclass properties!
 * - Properties with const* prefix will be ignored. For example constMyVar.
 * - in [-enumeratePropertiesUsingBlock:] valuesClass is nil when propertyValue is nil obviously.
 *
 * To check for equality or to copy properties they must conform to NSObject and NSCoding protocols correspondingly.
 * In case of equality check properties classes must realise address independent verion of [-isEqual]
 *
 * Run NSObject_VRPropertiesProcessingTests, to see examples of usage.
 *
 */

typedef BOOL(^VRCheckStructuresEqualityBlock)(id obj1, id obj2, NSSet* structurePropertiesNames);
typedef NSArray*(^VRHashStructuresBlock)(id object, NSSet* structurePropertiesNames);
typedef void (^VREncodeStructuresBlock)(NSCoder * aCoder, NSSet * structurePropertiesNames);
typedef void (^VRDecodeStructuresBlock)(NSCoder * aDecoder, NSSet * structurePropertiesNames);

NSUInteger VRCombinedHash(NSUInteger previousHash, NSUInteger hash); // this function is used to combine hashes of object properties.

@interface NSObject (VRPropertiesProcessing)
- (void)enumeratePropertiesUsingBlock:(void (^)(NSString * propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop))block;

- (NSString *)descriptionWithProperties;
- (NSString *)descriptionWithPropertiesTypes;

- (BOOL)isEqualByProperties:(id)object; // If object is of different class then returns NO. It's faster then [-hashByProperties]
- (BOOL)isEqualByProperties:(id)object checkStructuresEqualityBlock:(VRCheckStructuresEqualityBlock)checkStructuresEqualityBlock;
- (NSUInteger)hashByProperties;
- (NSUInteger)hashByPropertiesWithHashStructuresBlock:(VRHashStructuresBlock)calculateHashesOfStructures;

- (id)deepCopyPropertiesToNewInstanceWithZone:(NSZone *)zone;
- (void)deepCopyPropertiesTo:(id)targetObject;

- (NSString *)keyForPropertyName:(NSString *)propertyName;
- (void)encodePropertiesWithCoder:(NSCoder *)aCoder; // For fast implementing of NSCoding protocol in subclass of NSObject.
- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
                    conditionally:(NSSet *)namesOfPropertiesForConditionalEncoding
                             skip:(NSSet *)namesOfPropertiesToSkip;
- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
       encodeStructuresProperties:(VREncodeStructuresBlock)encodeStructuresBlock;
- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
                    conditionally:(NSSet *)namesOfPropertiesForConditionalEncoding
                             skip:(NSSet *)namesOfPropertiesToSkip
       encodeStructuresProperties:(VREncodeStructuresBlock)encodeStructuresBlock; // Allows to encode structures manually in block. structurePropertiesNames are provided to debug purposes.
- (id)initPropertiesWithCoder:(NSCoder *)aDecoder;
- (id)initPropertiesWithCoder:(NSCoder *)aDecoder decodeStructuresProperties:(VRDecodeStructuresBlock)decodeStructuresBlock; // Allows to decode structures in block and set them to theSelf.
@end
