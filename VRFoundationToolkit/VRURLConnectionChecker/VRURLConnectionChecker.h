//
//  VRURLConnectionChecker.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 3/12/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VRLog.h"

/** VRURLConnectionChecker checks for acessibility of URL without downloading data via blocks syntax.
 */
extern NSString*const VRURLConnectionCheckStartedNotification;
extern NSString*const VRURLConnectionCheckEndedWithSuccessNotification;
extern NSString*const VRURLConnectionCheckEndedWithFailureNotification;

typedef void(^VRURLConnectionCheckerAccessibleBlock)(void);
typedef void(^VRURLConnectionCheckerFailureBlock)(NSError * error);

@interface VRURLConnectionChecker : NSURLConnection

+ (void)checkURLWithRequest:(NSURLRequest*)request
                 accessible:(VRURLConnectionCheckerAccessibleBlock)accessible
                    failure:(VRURLConnectionCheckerFailureBlock)failure;

+ (void)checkURLWithString:(NSString*)urlString andTimeout:(NSTimeInterval)timeout
                accessible:(VRURLConnectionCheckerAccessibleBlock)accessible
                   failure:(VRURLConnectionCheckerFailureBlock)failure;

+ (void)checkURLWithString:(NSString*)urlString
                accessible:(VRURLConnectionCheckerAccessibleBlock)accessible
                   failure:(VRURLConnectionCheckerFailureBlock)failure;

+ (NSTimeInterval)defaultFailureTimeout;
+ (NSString*)defaultSiteToCheck;

+ (void)checkDefaultSiteIsAccessible:(VRURLConnectionCheckerAccessibleBlock)accessible
                             failure:(VRURLConnectionCheckerFailureBlock)failure;

/**
 *  Returns the URL that was checked.
 */
@property (nonatomic, readonly) NSURL* checkedURL;

@end
