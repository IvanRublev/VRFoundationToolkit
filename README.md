VRFoundationToolkit
===================

[![CI Status](http://img.shields.io/travis/IvanRublev/VRFoundationToolkit.svg?style=flat)](https://travis-ci.org/IvanRublev/VRFoundationToolkit)
[![Version](https://img.shields.io/cocoapods/v/VRFoundationToolkit.svg?style=flat)](http://cocoadocs.org/docsets/VRFoundationToolkit)
[![License](https://img.shields.io/cocoapods/l/VRFoundationToolkit.svg?style=flat)](http://cocoadocs.org/docsets/VRFoundationToolkit)


This library extends [NSFoundation](https://developer.apple.com/library/ios/documentation/cocoa/reference/foundation/) with categories, macros & classes. Effective Obj-C developer's mini-toolkit) It can be used in iOS or OS X projects for faster coding.


What's inside
-------------

### Categories

* __NSArray+VRArgument__ - sequentially passes each element of array to provided selector of target object or class.
* __NSArray+VRCheckMembers__ - checks if all members of array are of specified class.
* __NSBundle+VRDisplayName__ - obtains localized display name of bundle with fallback to non-nil string precompiler constant if name is not accessible.
* __NSDate+VRDurations__ - calculates how much days, hours, minutes between two dates. Returns end of day. Compare two dates by specified NSCalendarUnit units. Return NSDateComponents for specified NSCalendarUnit units. Returns default NSCalendar.
* __NSFileManager+VRDocumentsDirectory__ - quick access for Documents directory and Temporary directory paths. Random file names generation. etc.
* __NSMutableDictionary+VRExchangeKeys__ - exchanges keys in dictionary.
* __NSObject+VRPropertiesProcessing__ - process object properties with blocks. Hash, equality & encode/decode by properties for any object.
* __NSObject+VRProtocolConformation__ - checks if object/class responds to all selectors required by protocol. Useful as precondition check of object in delegate setter.
* __NSString+VRmd5__ - MD5 hash on string.
* __NSTimer+VRWithBlock__ - timer that executes block instead of selector.

### Macros

* __VREnumXXX__ - generates enums with utility functions. NSStringFromXXX returns enum constant by value. isValidXXX checks range of enum value.
* __VRLOGxxx__ - multilevel logging & assertion macros. Could be connected to preferable logging system. VRPRECONDITIONxxx macros to implement light design by contract.
* __VRKeyName__ - stringifyes expression to key for `-[NSCoder encodeObject:withKey:]`. Useful to make names via help of XCode autocompletion.
* __VRSingleton__ - return singleton.
* __VROBJCTYPExxx__ - returns Objective-C type string representation of the passed variable (or type). VRIS_TYPE_EQUAL_TO_TYPE(V1, V2) compares Objective-C types of two passed values/types.

### Classes
* __VRURLConnectionChecker__ - checks if default site or specified URL is accessible with completion and error blocks.

### Functions
* __NSComparisonInvertedResult__ - inverts the comparison result.
* __VRCanPerform__ - checks if object conforms to protocol & responds to selector. Usefull for precondition check in delegate setters.


Requirements
------------

iOS SDK 6.0+ and OSX SDK 10.8+ are required respectively. 

[libextobjc](https://github.com/jspahrsummers/libextobjc.git) is required for metamacros in `VRLog.h` and `VREnum.h`.
[MAObjCRuntime](https://github.com/mikeash/MAObjCRuntime.git) is required for VRProtocolConformation category of NSObject.


Installation
------------

### Using CocoaPods

VRFoundationToolkit is available through [CocoaPods](http://cocoapods.org). Simply add the following line to your Podfile:

    pod "VRFoundationToolkit"

and run `pods update` or `pods install`.


### Manually

- Make Workspace for your project, if you havent do so, via Xcode menu File -> New -> Workspace. Make sure that your .xcworkspace file is on the same level as .xcodeproj of your project and that the last one is added to the Workspace.
- Open the Workspace within Xcode.
- Subtree this repository, for example to `Requirements` subdirectory in your project.
```
git subtree add --prefix=Requirements/VRFoundationToolkit --squash https://github.com/IvanRublev/VRFoundationToolkit.git master
```

- Subtree dependencies there as also.

```
git subtree add --prefix=Requirements/libextobjc --squash https://github.com/jspahrsummers/libextobjc.git master

git subtree add --prefix=Requirements/MAObjCRuntime --squash https://github.com/mikeash/MAObjCRuntime.git master
```

- Drag & drop `VRFoundationToolkit.xcodeproj`, `extobjc.xcodeproj` & `MAObjCRuntime.xcodeproj` in to your workspace. 
- Make sure that settings of `libextobjc (iOS)` and `MAObjCRuntime_iOS` targets of `extobjc` and `MAObjCRuntime.xcodeproj` projects respectively, are following: Architectures is set to `Standard architectures` and Base SDK is set to `Lastest iOS`.
- Add `-ObjC` to Other Linker Flags in your project's Build Settings. And add `./Requirements/**` to Header Search Paths.
- Add `libVRFoundationToolkit.a`, `libextobjc_iOS.a` & `libMAObjCRuntime_iOS.a` (or `VRFoundationToolkitOSX`, `libextobjc_OSX.a` & `libMAObjCRuntime.a` for OS X) in "Link Binary With Libraries" section of "Build phases" tab of your project's target.
- Add `#import <VRFoundationToolkit/VRFoundationToolkit.h>` to YourProject-Prefix.pch or where you want to use it.

Now it's ready to use, build & run!


Author
------

Ivan Rublev, ivan@ivanrublev.me


License
-------

VRFoundationToolkit is available under the MIT license. See the LICENSE file for more info.

