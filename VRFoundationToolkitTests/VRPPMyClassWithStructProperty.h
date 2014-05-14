//
//  VRPPMyClassWithStructProperty.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/14/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRPPMyClass.h"

typedef struct sMyStruct {
    int a;
    double b;
} MyStruct;

@interface VRPPMyClassWithStructProperty : NSObject <NSCoding>
@property (nonatomic, readwrite) NSString * title;
@property (nonatomic, assign) MyStruct structure;
@end
