//
//  VRRandom.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 7/4/15.
//  Copyright (c) 2015 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VRRandom_h
#define VRFoundationToolkit_VRRandom_h
#import <Foundation/Foundation.h>

/**
 *  Macros that returns random double and float values based on result from rand().
 */
// initializes random generator with current time
#define vr_fsrand() srand((unsigned)(time(0)))
// returns from minVal to maxVal inclusive
#define vr_frandf_minmax(minVal, maxVal) ( minVal+((float)(rand()))/((float)(RAND_MAX/(maxVal-minVal))) )
// returns from 0.0 to maxVal inclusive
#define vr_frandf_max(maxVal) vr_frandf_minmax(0.0, maxVal)
// returns from 0.0 to 1.0 inclusive
#define vr_frandf() vr_frandf_minmax(0.0, 0.1)
#endif
