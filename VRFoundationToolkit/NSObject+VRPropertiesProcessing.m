//
//  NSObject+VRPropertiesProcessing.m
//
//  Created by Ivan Rublev on 6/3/13.
//  Copyright (c) 2013 Ivan Rublev http://ivanrublev.me . All rights reserved.
//

#import "NSObject+VRPropertiesProcessing.h"
#import "VRProtocolConformation.h"
#import "VRLog.h"
#import <objc/runtime.h>

#define VREPLogLevel 0 // 0 - no console log, 1 - errors, 2 - trace

#ifdef DEBUG
#if VREPLogLevel>0
#define VREPLOG_ERROR NSLog
#endif
#if VREPLogLevel>1
#define VREPLOG_TRACE NSLog
#endif
#endif

#ifndef VREPLOG_TRACE
#define VREPLOG_TRACE(FMT, ...)
#endif
#ifndef VREPLOG_ERROR
#define VREPLOG_ERROR(FMT, ...)
#endif

FOUNDATION_STATIC_INLINE BOOL isStructInValue(id value);

#define kNSObjectVRPropertiesProcessingIgnorePrefix @"const"
@implementation NSObject (VRPropertiesProcessing)

- (void)enumeratePropertiesUsingBlock:(void (^)(NSString * propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop))block
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    if (properties == nil || count == 0) {
        VREPLOG_ERROR(@"No properties in object!");
        return;
    }
    unsigned i;
    for (i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        NSString *name = [NSString stringWithUTF8String:property_getName(property)];
        if ([name hasPrefix:kNSObjectVRPropertiesProcessingIgnorePrefix]) {
            continue;
        }
        id propertyObject = [self valueForKey:name];
        BOOL shouldStop = NO;
        block(name, propertyObject, [propertyObject class], &shouldStop);
        if (shouldStop) {
            break;
        }
    }
    free(properties);
    return;
}

- (NSString *)descriptionWithPropertiesTypes
{
    NSMutableArray * propertiesDescriptions = [NSMutableArray array];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        [propertiesDescriptions addObject:[NSString stringWithFormat:@".%@:%@", propertyName, NSStringFromClass(valuesClass)]];
    }];
    NSString * myDesc = [NSString stringWithFormat:@"<%@:%p %@>",
                         NSStringFromClass([self class]),
                         self,
                         [propertiesDescriptions componentsJoinedByString:@" "]];
    return myDesc;
}

- (NSString *)descriptionWithProperties
{
    NSMutableArray * propertiesDescriptions = [NSMutableArray array];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        [propertiesDescriptions addObject:[NSString stringWithFormat:@".%@=%@", propertyName, propertyValue]];
    }];
    NSString * myDesc = [NSString stringWithFormat:@"<%@:%p %@>",
                         NSStringFromClass([self class]),
                         self,
                         [propertiesDescriptions componentsJoinedByString:@" "]];
    return myDesc;
}

- (BOOL)isEqualByProperties:(id)object
{
    return [self isEqualByProperties:object checkStructuresEqualityBlock:nil];
}

- (BOOL)isEqualByProperties:(id)object checkStructuresEqualityBlock:(VRCheckStructuresEqualityBlock)checkStructuresEqualityBlock
{
    __block BOOL equal = YES;
    if (![object isKindOfClass:[self class]]) {
        return NO;
    }
    BOOL processStructures = (checkStructuresEqualityBlock != nil);
    NSMutableSet * structuresPropertiesNames = [NSMutableSet set];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        if (propertyValue == nil) {
            equal = ([object valueForKey:propertyName] == nil);
        } else {
            BOOL propertyValueSupportsCompare = [[propertyValue class] instancesRespondToSelector:@selector(isEqual:)];
            BOOL propertyValueIsStructure = isStructInValue(propertyValue);
            if (propertyValueSupportsCompare && !propertyValueIsStructure) {
                if (![propertyValue isEqual:[object valueForKey:propertyName]]) {
                    equal = NO;
                }
            } else {
                if (propertyValueIsStructure) {
                    if (processStructures) {
                        [structuresPropertiesNames addObject:propertyName];
                    } else {
#ifndef VRPREVENT_STRUCT_NOT_COMPARED_ERROR_LOG
                        VRLOG_ERROR_ASSERT(@"Can't check equality for class (%@) because it contains structure property. Check equality of structures manually in block passed to -[isEqualByProperties:structuresEqualBlock:]", NSStringFromClass([self class]));
#endif
                        equal = NO;
                    }
                } else {
                    VREPLOG_ERROR(@"Class of property .%@ value doesn't realize [-isEqual:]. So instances of class (%@) can't be compared!", propertyName, NSStringFromClass([self class]));
                    equal = NO;
                }
            }
        }
        *stop = !equal;
    }];
    if (equal && processStructures && [structuresPropertiesNames count]) {
        BOOL structureaAreEqual = checkStructuresEqualityBlock(self, object, structuresPropertiesNames);
        equal = structureaAreEqual;
    }
    return equal;
}

// As suggested by Mike Ash in http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
#define NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (NSUINT_BIT - howmuch)))

NSUInteger VRCombinedHash(NSUInteger previousHash, NSUInteger hash)
{
    return NSUINTROTATE(previousHash, NSUINT_BIT / 2) ^ hash;
}

// Use this to count hashes for structures in block manually.
// You can return common hash for structures in first element of array or, one by one.
- (NSUInteger)hashByPropertiesWithHashStructuresBlock:(VRHashStructuresBlock)calculateHashesOfStructures
{
    __block NSUInteger hash = 0;
    BOOL processStructures = (calculateHashesOfStructures != nil);
    NSMutableSet * structuresPropertiesNames = [NSMutableSet set];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        if (!isStructInValue(propertyValue)) {
            hash = VRCombinedHash(hash, [propertyValue hash]);
        } else {
            if (processStructures) {
                [structuresPropertiesNames addObject:propertyName];
            } else {
                VRLOG_ERROR_ASSERT(@"Can't count hash automatically for %@ class because it has properties of structure type. Property \"%@\" is of structure type! Please count hash for structures manually in block passed to -[hashByPropertiesWithHashStructuresBlock:]",
                                   NSStringFromClass([self class]), propertyName);
            }
        }
    }];
    if (processStructures && [structuresPropertiesNames count]) {
        VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(hash, calculateHashesOfStructures);
        NSArray * hashesOfStructures = calculateHashesOfStructures(self, structuresPropertiesNames);
        if ([hashesOfStructures count]) {
            [hashesOfStructures enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSUInteger structureHash = [obj unsignedIntegerValue];
                hash = VRCombinedHash(hash, structureHash);
            }];
        } else {
            VRLOG_ERROR_ASSERT(@"No hashes were returned from block!");
        }
    }
    return hash;
}

- (NSUInteger)hashByProperties
{
    return [self hashByPropertiesWithHashStructuresBlock:nil];
}

- (id)deepCopyPropertiesToNewInstanceWithZone:(NSZone *)zone
{
    id selfCopy = [[[self class] allocWithZone:zone] init];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        [selfCopy setValue:propertyValue forKey:propertyName];
    }];
    return selfCopy;
}

- (void)deepCopyPropertiesTo:(id)targetObject
{
    if (![targetObject isMemberOfClass:[self class]]) {
        VREPLOG_ERROR(@"Can't deep copy propeties. targetObject class (%@) differs from self's class (%@).", NSStringFromClass([targetObject class]), NSStringFromClass([self class]));
        return;
    }
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        id propertyValueDeepCopy = deepCopyOfObj(propertyValue);
        if (propertyValue != nil && propertyValueDeepCopy == nil) {
            VREPLOG_ERROR(@"Error occured on copying of .%@ property value.", propertyName);
        } else {
            [targetObject setValue:propertyValueDeepCopy forKey:propertyName];
        }
    }];
}

- (NSString *)keyForPropertyName:(NSString *)propertyName
{
    return [NSString stringWithFormat:@"prop.%@", propertyName];
}

- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
{
    [self encodePropertiesWithCoder:aCoder conditionally:nil skip:nil encodeStructuresProperties:nil];
}

- (void)encodePropertiesWithCoder:(NSCoder *)aCoder conditionally:(NSSet *)namesOfPropertiesForConditionalEncoding skip:(NSSet *)namesOfPropertiesToSkip
{
    [self encodePropertiesWithCoder:aCoder conditionally:namesOfPropertiesForConditionalEncoding skip:namesOfPropertiesToSkip encodeStructuresProperties:nil];
}

- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
       encodeStructuresProperties:(VREncodeStructuresBlock)encodeStructuresBlock
{
    [self encodePropertiesWithCoder:aCoder conditionally:nil skip:nil encodeStructuresProperties:encodeStructuresBlock];
}

- (void)encodePropertiesWithCoder:(NSCoder *)aCoder
                    conditionally:(NSSet *)namesOfPropertiesForConditionalEncoding
                             skip:(NSSet *)namesOfPropertiesToSkip
       encodeStructuresProperties:(VREncodeStructuresBlock)encodeStructuresBlock
{
    NSMutableSet * structurePropertiesNames = [NSMutableSet set];
    [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
        BOOL skip = [namesOfPropertiesToSkip containsObject:propertyName];
        if (propertyValue != nil && !skip) {
            __block BOOL propertySupportsNSCoding = YES;
            if ([valuesClass isSubclassOfClass:[NSArray class]]) {
                [((NSArray *)propertyValue) enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    if (!VRCanPerform(obj, @selector(encodeWithCoder:), @protocol(NSCoding))) {
                        propertySupportsNSCoding = NO;
                        *stop = YES;
                    }
                }];
            } else if ([valuesClass isSubclassOfClass:[NSDictionary class]]) {
                [((NSDictionary *)propertyValue) enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                    if (!VRCanPerform(key, @selector(encodeWithCoder:), @protocol(NSCoding)) ||
                        !VRCanPerform(obj, @selector(encodeWithCoder:), @protocol(NSCoding))) {
                        propertySupportsNSCoding = NO;
                        *stop = YES;
                    }
                }];
            } else if ([valuesClass isSubclassOfClass:[NSSet class]]) {
                [((NSSet *)propertyValue) enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
                    if (!VRCanPerform(obj, @selector(encodeWithCoder:), @protocol(NSCoding))) {
                        propertySupportsNSCoding = NO;
                        *stop = YES;
                    }
                }];
            } else {
                propertySupportsNSCoding = [propertyValue conformsToProtocol:@protocol(NSCoding)];
            }
            BOOL isStructureInValue = isStructInValue(propertyValue);
            if (propertySupportsNSCoding && !isStructureInValue) {
                BOOL encodeConditionally = [namesOfPropertiesForConditionalEncoding containsObject:propertyName];
                @try {
                    if (encodeConditionally) {
                        [aCoder encodeConditionalObject:propertyValue forKey:[self keyForPropertyName:propertyName]];
                    } else {
                        [aCoder encodeObject:propertyValue forKey:[self keyForPropertyName:propertyName]];
                    }
                }
                @catch (NSException *exception) {
                    VREPLOG_ERROR(@"Exeption on coding property .%@. %@: %@.", propertyName, exception.name, exception.reason);
                }
                VREPLOG_TRACE(@"Encoded [%@]%@: %@", valuesClass, propertyName, propertyValue);
            } else {
                if (isStructureInValue) {
                    [structurePropertiesNames addObject:propertyName];
                } else {
#ifdef DEBUG
                VREPLOG_ERROR(@"Property %@ of class %@ is not encoded! It or its members doesn't support NSCoding protocol!", propertyName, NSStringFromClass(valuesClass));
#endif
                }
            }
        } else {
            VREPLOG_TRACE(@"Value of .%@ is nil, not encoded.", propertyName);
        }
    }];
    if ([structurePropertiesNames count]) {
        if (encodeStructuresBlock) {
            encodeStructuresBlock(aCoder, structurePropertiesNames);
        } else {
#ifndef VRPREVENT_STRUCT_NOT_ENCODED_ERROR_LOG
            VRLOG_ERROR(@"Following properties are of structure types & were not encoded: %@ Please, use -encodePropertiesWithCoder:encodeStructuresProperties: with block set or define VRPREVENT_STRUCT_NOT_ENCODED_ERROR_LOG", structurePropertiesNames);
#endif
        }
    }
}

- (id)initPropertiesWithCoder:(NSCoder *)aDecoder
{
    return [self initPropertiesWithCoder:aDecoder decodeStructuresProperties:nil];
}

- (id)initPropertiesWithCoder:(NSCoder *)aDecoder decodeStructuresProperties:(VRDecodeStructuresBlock)decodeStructuresBlock
{
    NSMutableSet * structurePropertiesNames = [NSMutableSet set];
    if (self) {
        [self enumeratePropertiesUsingBlock:^(NSString *propertyName, id propertyValue, __unsafe_unretained Class valuesClass, BOOL * stop) {
            if (propertyName != nil) {
                if (isStructInValue(propertyValue)) {
                    [structurePropertiesNames addObject:propertyName];
                } else if ([aDecoder containsValueForKey:[self keyForPropertyName:propertyName]]) {
                    VREPLOG_TRACE(@"Decoding [%@]%@", valuesClass, propertyName);
                    id value = nil;
                    @try {
                        value = [aDecoder decodeObjectForKey:[self keyForPropertyName:propertyName]];
                    }
                    @catch (NSException *exception) {
                        VREPLOG_ERROR(@"Exeption on decoding property .%@. %@: %@.", propertyName, exception.name, exception.reason);
                        value = nil;
                    }
                    Class propertyClass = [self classOfPropertyNamed:propertyName];
                    if (propertyClass == nil ||
                        [value isKindOfClass:propertyClass] ||
                        ([propertyClass isSubclassOfClass:valuesClass] && class_getSuperclass(valuesClass) != Nil))
                    {
                        [self setValue:value forKey:propertyName];
                    } else {
                        VREPLOG_ERROR(@"Can't set value becuse of classes type mismatch.");
                    }
                } else {
                    VREPLOG_TRACE(@"Property %@ is not restored! No data were saved for it.", propertyName);
                }
            } else {
                VREPLOG_ERROR(@"Can't decode value for nil property name!");
            }
        }];
    }
    if ([structurePropertiesNames count]) {
        if (decodeStructuresBlock) {
            decodeStructuresBlock(aDecoder, structurePropertiesNames);
        } else {
#ifndef VRPREVENT_STRUCT_NOT_DECODED_ERROR_LOG
            VRLOG_ERROR(@"Following properties are of structure types & were not decoded: %@ Please, use -initPropertiesWithCoder:decodeStructuresProperties: with block set or define VRPREVENT_STRUCT_NOT_DECODED_ERROR_LOG", structurePropertiesNames);
#endif
        }
    }
    return self;
}

- (Class)classOfPropertyNamed:(NSString*)propertyName
{
    if (![propertyName length]) {
        return nil;
    }

    Class propertyClass = nil;
    objc_property_t property = class_getProperty([self class], [propertyName UTF8String]);
    if (property == NULL) {
        return nil;
    }
    
    char *typeEncoding = nil;
    typeEncoding = property_copyAttributeValue(property, "T");
    if (!typeEncoding) {
        return nil;
    }
    switch (typeEncoding[0])
    {
        case '@':
        {
            if (strlen(typeEncoding) >= 3)
            {
                char *className = strndup(typeEncoding + 2, strlen(typeEncoding) - 3);
                __autoreleasing NSString *name = @(className);
                NSRange range = [name rangeOfString:@"<"];
                if (range.location != NSNotFound)
                {
                    name = [name substringToIndex:range.location];
                }
                propertyClass = NSClassFromString(name); // may be nil.
                free(className);
            }
            break;
        }
        case 'c':
        case 'i':
        case 's':
        case 'l':
        case 'q':
        case 'C':
        case 'I':
        case 'S':
        case 'L':
        case 'Q':
        case 'f':
        case 'd':
        case 'B':
        {
            propertyClass = [NSNumber class];
            break;
        }
        case '{':
        {
            propertyClass = [NSValue class];
            break;
        }
    }
    free(typeEncoding);
    
    return propertyClass;
}

#pragma mark -
#pragma mark Helpers
FOUNDATION_STATIC_INLINE BOOL isStructInValue(id value)
{
    if ([value isKindOfClass:[NSValue class]]) {
        const char * objCType = [value objCType];
        return objCType[0] == '{';
    }
    return NO;
}

FOUNDATION_STATIC_INLINE id deepCopyOfObj(id value)
{
    if (!value) {
        return nil;
    }
    id newValue = nil;
    if (VRCanPerform(value, @selector(encodeWithCoder:), @protocol(NSCoding)) &&
        VRCanPerform(value, @selector(initWithCoder:), @protocol(NSCoding))) {
        newValue = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:value]];
    } else {
        VREPLOG_ERROR(@"Can't make deepCopy of object %@, it not supporting NSCoding protocol.", value);
    }
    return newValue;
}

@end
