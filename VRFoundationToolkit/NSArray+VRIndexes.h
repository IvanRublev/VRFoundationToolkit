//
//  NSArray+VRIndexes.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/11/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (VRIndexes)
- (NSIndexSet*)indexesOfObjectsFromArray:(NSArray*)theArray; // the count of returned indexes may be not equal to theArray objects count because some objects may not exists in receiver.
@end
