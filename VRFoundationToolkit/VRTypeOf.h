//
//  VRTypeOf.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 5/14/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VRTypeOf_h
#define VRFoundationToolkit_VRTypeOf_h

/* Returns Objective-C type string representation of the passed variable (or type).
 */
#define VROBJCTYPE_OF(VAR) @encode(__typeof__(VAR))


#define VRIS_OBJCTYPE_EQUAL_TO_OBJCTYPE(T1, T2) !strcmp(T1, T2)

/* VRIS_TYPE_EQUAL_TO_TYPE macro.
 * You can pass types or variables for types comparison
 */
#define VRIS_TYPE_EQUAL_TO_TYPE(V1, V2) VRIS_OBJCTYPE_EQUAL_TO_OBJCTYPE(VROBJCTYPE_OF(V1), VROBJCTYPE_OF(V2))

#endif
