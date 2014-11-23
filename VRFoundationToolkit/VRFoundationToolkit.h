//
//  VRFoundationToolkit.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

/* VRFoundationToolkit 
 * Extends NSFoundation with categories, macros & classes. Effective Obj-C developer's mini-toolkit).
 * 
 * The https://github.com/jspahrsummers/libextobjc v4.0.x is required for metamacros in VREnum.h. Besides, that lib is very usefull for @weakify @strongify and other usefulness.
 * Project where you include the VRFoundationToolkit needs -ObjC linker flag to link categories properly.
 */

#import <Foundation/Foundation.h>

// Import Requirements
#import <extobjc.h>

// Routines
#import "VRLog.h"
#import "VREnum.h"
#import "VRTypeOf.h"
#import "NSCoder+VRKeyName.h"
#import "VRSingleton.h"
#import "VRProtocolConformation.h"

#import "NSFileManager+VRDocumentsDirectory.h"
#import "NSDate+VRDurations.h"
#import "NSString+VRmd5.h"
#import "NSObject+VRPropertiesProcessing.h"
#import "NSArray+VRCheckMembers.h"
#import "NSArray+VRArgument.h"
#import "NSMutableDictionary+VRExchangeKeys.h"
#import "NSBundle+VRDisplayName.h"
#import "VRURLConnectionChecker.h"
#import "NSTimer+VRWithBlock.h"
#import "VRComparison.h"