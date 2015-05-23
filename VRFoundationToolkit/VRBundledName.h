//
//  VRBundledName.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 4/30/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VRBundledName_h
#define VRFoundationToolkit_VRBundledName_h
#import <Foundation/Foundation.h>

/**
 *  Macro returns NSString with reverse dns bundle name followed by NAME at the end of the string.
 */
#define VRBUNDLED_NAME(NAME) [NSString stringWithFormat:@"%@.%@", [[NSBundle mainBundle] bundleIdentifier], NAME]
#define VRBUNDLED_NAME_UTF8(NAME) [VRBUNDLED_NAME(NAME) UTF8String]

#endif
