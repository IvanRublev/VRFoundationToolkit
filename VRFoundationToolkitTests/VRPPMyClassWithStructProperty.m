//
//  VRPPMyClassWithStructProperty.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/14/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRPPMyClassWithStructProperty.h"
#import "NSObject+VRPropertiesProcessing.h"

@implementation VRPPMyClassWithStructProperty

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [self encodePropertiesWithCoder:aCoder encodeStructuresProperties:^(NSCoder *aCoder, NSArray *structurePropertiesNames) {
        [aCoder encodeInteger:self.structure.a forKey:@"the a"];
        [aCoder encodeDouble:self.structure.b forKey:@"the b"];
    }];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [self init];
    if (self) {
        self = [self initPropertiesWithCoder:aDecoder decodeStructuresProperties:^(NSCoder *aDecoder, NSArray *structurePropertiesNames) {
            MyStruct theStruct = {
                [aDecoder decodeIntegerForKey:@"the a"],
                [aDecoder decodeDoubleForKey:@"the b"]
            };
            self.structure = theStruct;
        }];
    }
    return self;
}

- (void)dealloc
{
    NSLog(@"=D=");
}

@end
