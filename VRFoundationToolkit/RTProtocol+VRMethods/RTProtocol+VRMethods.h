//
//  RTProtocol+VRMethods.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/8/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <MAObjCRuntime/RTProtocol.h>

/**
 *  These allows to receive all class or instance required+optional protocol methods names. All methods from adopted protocols are recursively included except the NSObject protocol ones. Usefull to check if method belongs to protocol. Returned results are cached.
 */
@interface RTProtocol (VRMethods)
+ (void)resetSelectorsNamesSharedCache;
+ (NSSet*)classSelectorsNamesOfProtocol:(Protocol*)aProtocol;
+ (NSSet*)instanceSelectorsNamesOfProtocol:(Protocol*)aProtocol;
+ (NSSet*)requiredClassSelectorsNamesOfProtocol:(Protocol*)aProtocol;
+ (NSSet*)requiredInstanceSelectorsNamesOfProtocol:(Protocol*)aProtocol;

- (NSSet*)classSelectorsNames;
- (NSSet*)instanceSelectorsNames;
- (NSSet*)requiredClassSelectorsNames;
- (NSSet*)requiredInstanceSelectorsNames;

@end
