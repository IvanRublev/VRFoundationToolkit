//
//  VRPPMyClassConditionalProperties.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/14/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRPPMyClassConditionalProperties.h"
#import <NSObject+VRPropertiesProcessing.h>

@implementation VRPPMyClassConditionalProperties

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if (self.constArchiveConditionalTitle) {
        [aCoder encodeObject:self.conditionalTitle forKey:@"conditionalTitle"];
    }
    [self encodePropertiesWithCoder:aCoder conditionally:[NSSet setWithObject:@"conditionalTitle"] skip:[NSSet setWithObject:@"skippyTitle"]];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self = [self initPropertiesWithCoder:aDecoder];
    }
    return self;
}

@end
