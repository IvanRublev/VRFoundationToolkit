//
//  RTProtocol+VRMethods.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/8/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "RTProtocol+VRMethods.h"
#import <MAObjCRuntime/RTMethod.h>


@implementation RTProtocol (VRMethods)
#pragma mark -
#pragma mark Class shortcuts
+ (NSSet*)classSelectorsNamesOfProtocol:(Protocol*)aProtocol
{
    return [[RTProtocol protocolWithObjCProtocol:aProtocol] classSelectorsNames];
}

+ (NSSet*)instanceSelectorsNamesOfProtocol:(Protocol*)aProtocol
{
    return [[RTProtocol protocolWithObjCProtocol:aProtocol] instanceSelectorsNames];
}

+ (NSSet*)requiredClassSelectorsNamesOfProtocol:(Protocol*)aProtocol
{
    return [[RTProtocol protocolWithObjCProtocol:aProtocol] requiredClassSelectorsNames];
}

+ (NSSet*)requiredInstanceSelectorsNamesOfProtocol:(Protocol*)aProtocol
{
    return [[RTProtocol protocolWithObjCProtocol:aProtocol] requiredInstanceSelectorsNames];
}


#pragma mark -
#pragma mark Selector names shared cache
static NSMutableDictionary* rtProtocolSelectorsNamesSharedCache = nil;
/**
 *  Resets the shared cache of protocols selectors names.
 */
+ (void)resetSelectorsNamesSharedCache
{
    rtProtocolSelectorsNamesSharedCache = nil;
}

- (NSMutableDictionary*)selectorsNamesSharedCache
{
    if (!rtProtocolSelectorsNamesSharedCache) {
        rtProtocolSelectorsNamesSharedCache = [NSMutableDictionary dictionary];
    }
    return rtProtocolSelectorsNamesSharedCache;
}

- (NSString*)cacheIdentifierWithKey:(NSString*)key
{
    return [NSString stringWithFormat:@"%@%@", self.name, key];
}

- (void)storeSelectorsNamesInCache:(NSSet*)selectorsNames withKey:(NSString*)key
{
    if (!selectorsNames) {
        return;
    }
    NSString* identifier = [self cacheIdentifierWithKey:key];
    [[self selectorsNamesSharedCache] setObject:selectorsNames forKey:identifier];
}

- (NSSet*)selectorsNamesFromCacheWithKey:(NSString*)key
{
    NSString* identifier = [self cacheIdentifierWithKey:key];
    return [[self selectorsNamesSharedCache] objectForKey:identifier];
}


#pragma mark -
#pragma mark Public instance methods
/**
 *  Returns all class selectors names described in the protocol and its adopted protocols (except NSObject protocol).
 *
 *  @return Set of class selectors names that could be performed on object conforming to the protocol.
 */
- (NSSet*)classSelectorsNames
{
    return [self classSelectorsNamesIncludingOptional:YES];
}

/**
 *  Returns all instance selectors names described in the protocol and its adopted protocols (except NSObject protocol).
 *
 *  @return Set of instance selectors names that could be performed on object conforming to the protocol.
 */
- (NSSet*)instanceSelectorsNames
{
    return [self instanceSelectorsNamesIncludingOptional:YES];
}

/**
 *  Returns class selectors names required by the protocol and its adopted protocols (except NSObject protocol).
 *
 *  @return Set of required class selectors names that could be performed on object conforming to the protocol.
 */
- (NSSet*)requiredClassSelectorsNames
{
    return [self classSelectorsNamesIncludingOptional:NO];
}

/**
 *  Returns instance selectors names required by the protocol and its adopted protocols (except NSObject protocol).
 *
 *  @return Set of required instance selectors names that could be performed on object conforming to the protocol.
 */
- (NSSet *)requiredInstanceSelectorsNames
{
    return [self instanceSelectorsNamesIncludingOptional:NO];
}


#pragma mark -
#pragma mark Private
- (NSString*)extendedKey:(NSString*)key withOptionalPostfix:(BOOL)optional
{
    NSString* extendedKey = [NSString stringWithFormat:@"%@%@", key, optional ? @"optional" : @""];
    return extendedKey;
}

- (NSSet*)classSelectorsNamesIncludingOptional:(BOOL)optional
{
    NSString* key = [self extendedKey:@"classRequiredAndOptionalSelectors" withOptionalPostfix:optional];
    NSSet* selectorsNames = [self selectorsNamesFromCacheWithKey:key];
    if (!selectorsNames) {
        selectorsNames = [self selectorsNamesFromSelfAndIncorporatedProtocolsOfClass:YES instance:NO includeOptional:optional];
        [self storeSelectorsNamesInCache:selectorsNames withKey:key];
    }
    return selectorsNames;
}

- (NSSet*)instanceSelectorsNamesIncludingOptional:(BOOL)optional
{
    NSString* key = [self extendedKey:@"instanceRequiredAndOptionalSelectors" withOptionalPostfix:optional];
    NSSet* selectorsNames = [self selectorsNamesFromCacheWithKey:key];
    if (!selectorsNames) {
        selectorsNames = [self selectorsNamesFromSelfAndIncorporatedProtocolsOfClass:NO instance:YES includeOptional:optional];
        [self storeSelectorsNamesInCache:selectorsNames withKey:key];
    }
    return selectorsNames;
}

- (void)appendIncorporatedProtocolsOf:(RTProtocol*)protocol toArray:(NSMutableArray*)allProtocols
{
    NSArray* incorporatedProtocols = [protocol incorporatedProtocols];
    if (incorporatedProtocols) {
        [allProtocols addObjectsFromArray:incorporatedProtocols];
        [incorporatedProtocols enumerateObjectsUsingBlock:^(RTProtocol* protocol, NSUInteger idx, BOOL *stop) {
            [self appendIncorporatedProtocolsOf:protocol toArray:allProtocols];
        }];
    }
}

- (NSSet*)selectorsNamesFromSelfAndIncorporatedProtocolsOfClass:(BOOL)includeClassMethods instance:(BOOL)includeInstanceMethods includeOptional:(BOOL)includeOptional
{
    NSMutableArray* allMethods = [NSMutableArray array];
    
    NSMutableArray* allProtocols = [NSMutableArray arrayWithObject:self];
    [self appendIncorporatedProtocolsOf:self toArray:allProtocols];
    // filter out NSObject protocol because all objects usually conforms to it.
    RTProtocol* nsobject = [RTProtocol protocolWithName:@"NSObject"];
    [allProtocols removeObject:nsobject];
    // iterate all protocols and collect methods
    [allProtocols enumerateObjectsUsingBlock:^(RTProtocol* protocol, NSUInteger idx, BOOL *stop) {
        for (int optionbits = 0; optionbits < (1 << 2); optionbits++) {
            BOOL required = (optionbits & 1); // Check required methods first, then optional
            BOOL instance = !(optionbits & (1 << 1)); // Check instance methods first, then class
            if ((!includeOptional && !required) || (!includeClassMethods && !instance) || (!includeInstanceMethods && instance)) { // skip
                continue;
            }
            NSArray* methods = [protocol methodsRequired:required instance:instance];
            if (methods) {
                [allMethods addObjectsFromArray:methods];
            }
        }
    }];
    // Make selectors table
    NSMutableSet* selectors = [NSMutableSet setWithCapacity:allMethods.count];
    [allMethods enumerateObjectsUsingBlock:^(RTMethod* methodObj, NSUInteger idx, BOOL *stop) {
        NSString* name = methodObj.selectorName;
        [selectors addObject:name];
    }];
    return selectors;
}

@end
