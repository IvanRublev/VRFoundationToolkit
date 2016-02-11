//
//  VRLog.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/21/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#ifndef VRFoundationToolkit_VRLog_h
#define VRFoundationToolkit_VRLog_h

#import <libextobjc/metamacros.h>

#define VRYN(expr) ((expr)? @"YES" : @"NO") // For output bool value as string in console

// Logging macros to use in projects.
//
// If you want to use your custom logging function, for example Crashlytics CLSLog() or CLSNSLog(), then write '#define iVRLOG YOURLOGGER' _before_ importing this header.
// By default all log levels are enabled, to specify your log level write '#define VRLOG_LEVEL VR_...' _before_ importing this header.

// Possible log levels
#define VR_TRACE 40
#define VR_DEBUG 30
#define VR_ERROR 20
#define VR_INFO  10
#define VR_NOLOG 0
#ifndef VRLOG_LEVEL
#define VRLOG_LEVEL VR_TRACE
#endif
#define VRLOG_CANPRINT_AT_LEVEL(LEVEL) (VRLOG_LEVEL >= LEVEL)


#define iVR_NOLOG(...)
#define tVRLOG(FMT, PSFX, ...) iVRLOG([[[@"" stringByAppendingString:PSFX] stringByAppendingString:@" "] stringByAppendingString:FMT], ##__VA_ARGS__)
#ifndef iVRLOG
#define iVRLOG(FMT, ...) NSLog([@"%s:%d %s " stringByAppendingString:FMT], strrchr(__FILE__, '/') == 0 ? __FILE__ : strrchr(__FILE__, '/')+1, __LINE__, __PRETTY_FUNCTION__, ##__VA_ARGS__)
#endif

#if VRLOG_CANPRINT_AT_LEVEL(VR_TRACE)
#ifndef VRLOG_TRACE
#define VRLOG_TRACE(FMT, ...) tVRLOG(FMT, @"(t)", ##__VA_ARGS__)
#endif
#else
#undef VRLOG_TRACE
#define VRLOG_TRACE(FMT, ...)
#endif

#if VRLOG_CANPRINT_AT_LEVEL(VR_DEBUG)
#ifndef VRLOG_DEBUG
#define VRLOG_DEBUG(FMT, ...) tVRLOG(FMT, @"", ##__VA_ARGS__)
#endif
#else
#undef VRLOG_DEBUG
#define VRLOG_DEBUG(FMT, ...)
#endif

#if VRLOG_CANPRINT_AT_LEVEL(VR_ERROR)
#ifndef VRLOG_ERROR
#define VRLOG_ERROR(FMT, ...) tVRLOG(FMT, @"ERROR:", ##__VA_ARGS__)
#endif
#else
#undef VRLOG_ERROR
#define VRLOG_ERROR(FMT, ...)
#endif

#if VRLOG_CANPRINT_AT_LEVEL(VR_INFO)
#ifndef VRLOG_INFO
#define VRLOG_INFO(FMT, ...) tVRLOG(FMT, @"(i)", ##__VA_ARGS__)
#endif
#else
#undef VRLOG_INFO
#define VRLOG_INFO(FMT, ...)
#endif

#if (VRLOG_LEVEL > VR_NOLOG)
#ifndef VRLOG_ALWAYS
#define VRLOG_ALWAYS(FMT, ...) tVRLOG(FMT, @"", ##__VA_ARGS__)
#endif
#else
#undef VRLOG_ALWAYS
#define VRLOG_ALWAYS(FMT, ...)
#endif

#ifndef VRLOG_NONE
#define VRLOG_NONE iVR_NOLOG
#endif

// Macros for log error then assert with same message then return.
#define VRLOG_ERROR_ASSERT_LASTINSTRUCTION(LASTINSTRUCTION, FMT, ...) do { VRLOG_ERROR(FMT,  ##__VA_ARGS__); \
NSAssert(FALSE, FMT,  ##__VA_ARGS__); \
LASTINSTRUCTION; } while(0)
#define VRLOG_ERROR_ASSERT(FMT, ...) VRLOG_ERROR_ASSERT_LASTINSTRUCTION(, FMT,  ##__VA_ARGS__)
#define VRLOG_ERROR_ASSERT_RETURN_VALUE(VALUE, FMT, ...) VRLOG_ERROR_ASSERT_LASTINSTRUCTION(return VALUE, FMT,  ##__VA_ARGS__)
#define VRLOG_ERROR_ASSERT_RETURN(FMT, ...) VRLOG_ERROR_ASSERT_RETURN_VALUE(, FMT,  ##__VA_ARGS__)
#define VRLOG_ERROR_ASSERT_RETURN_NIL(FMT, ...) VRLOG_ERROR_ASSERT_RETURN_VALUE(nil, FMT,  ##__VA_ARGS__)

// Macros for log trace then assert with same message then return.
#define VRLOG_TRACE_ASSERT_LASTINSTRUCTION(LASTINSTRUCTION, FMT, ...) do { VRLOG_TRACE(FMT,  ##__VA_ARGS__); \
NSAssert(FALSE, FMT,  ##__VA_ARGS__); \
LASTINSTRUCTION; } while(0)
#define VRLOG_TRACE_ASSERT(FMT, ...) VRLOG_TRACE_ASSERT_LASTINSTRUCTION(, FMT,  ##__VA_ARGS__)
#define VRLOG_TRACE_ASSERT_RETURN_VALUE(VALUE, FMT, ...) VRLOG_TRACE_ASSERT_LASTINSTRUCTION(return VALUE, FMT,  ##__VA_ARGS__)
#define VRLOG_TRACE_ASSERT_RETURN(FMT, ...) VRLOG_TRACE_ASSERT_RETURN_VALUE(, FMT,  ##__VA_ARGS__)
#define VRLOG_TRACE_ASSERT_RETURN_NIL(FMT, ...) VRLOG_TRACE_ASSERT_RETURN_VALUE(nil, FMT,  ##__VA_ARGS__)

// Macros to no log but assert with message then return.
#define VRLOG_NONE_ASSERT_LASTINSTRUCTION(LASTINSTRUCTION, FMT, ...) do { VRLOG_NONE(FMT,  ##__VA_ARGS__); \
NSAssert(FALSE, FMT,  ##__VA_ARGS__); \
LASTINSTRUCTION; } while(0)
#define VRLOG_NONE_ASSERT(FMT, ...) VRLOG_NONE_ASSERT_LASTINSTRUCTION(, FMT,  ##__VA_ARGS__)
#define VRLOG_NONE_ASSERT_RETURN_VALUE(VALUE, FMT, ...) VRLOG_NONE_ASSERT_LASTINSTRUCTION(return VALUE, FMT,  ##__VA_ARGS__)
#define VRLOG_NONE_ASSERT_RETURN(FMT, ...) VRLOG_NONE_ASSERT_RETURN_VALUE(, FMT,  ##__VA_ARGS__)
#define VRLOG_NONE_ASSERT_RETURN_NIL(FMT, ...) VRLOG_NONE_ASSERT_RETURN_VALUE(nil, FMT,  ##__VA_ARGS__)

// Custom assertion with only one argument for checking condition
#define VRASSERT(CONDITION) NSAssert(CONDITION, @#CONDITION@" is false")
#define VRASSERT_LOG_ERROR(CONDITION, FMT, ...) if (!CONDITION) { VRLOG_ERROR_ASSERT(FMT, ##__VA_ARGS__); }

// Some Design By Contract goodies
/** VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN(condition1, condition2, ...) checks if all conditions are met, otherwithe logs, asserts and returns according to macro name.
    Others the same.
 */
#define __VRROUNDBRACKETSARGUMENT(IDX, ARGUMENT) (ARGUMENT)
#define __VRSTRINGIFY_FALSE_ARGUMENT_VIA_PRECOND(IDX, ARGUMENT) !(ARGUMENT) ? @"#"@metamacro_stringify(IDX)@" => ("@metamacro_stringify(ARGUMENT)@")"

#define VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_NIL(...) VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(nil, ##__VA_ARGS__)
#define VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN(...) VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(, ##__VA_ARGS__)
#define VRPRECONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(VALUE, ...) VRCONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(VALUE, "pre", ##__VA_ARGS__)
#define VRCONDITIONS_LOG_ERROR_ASSERT_RETURN_VALUE(VALUE, LOG_PREFIX, ...) \
do { \
if(!( metamacro_foreach(__VRROUNDBRACKETSARGUMENT, &&, __VA_ARGS__) )) { \
VRLOG_ERROR_ASSERT(@"One of the following "@LOG_PREFIX@"conditions fails: [%@]. Check %@", @#__VA_ARGS__, metamacro_foreach(__VRSTRINGIFY_FALSE_ARGUMENT_VIA_PRECOND, :, __VA_ARGS__) : @""); \
return VALUE; \
} \
} while (0)

#endif
