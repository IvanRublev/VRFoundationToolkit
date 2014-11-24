//
//  VRPPMyClassConditionalProperties.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/14/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRPPMyClassConditionalProperties : NSObject
@property (nonatomic, assign) BOOL constArchiveConditionalTitle;
@property (nonatomic, assign) NSUInteger value;
@property (nonatomic, readwrite) NSString * title;
@property (nonatomic, readwrite) NSString * conditionalTitle;
@property (nonatomic, readwrite) NSString * skippyTitle;
@property (nonatomic, readwrite) NSString * constInvisible;
@end
