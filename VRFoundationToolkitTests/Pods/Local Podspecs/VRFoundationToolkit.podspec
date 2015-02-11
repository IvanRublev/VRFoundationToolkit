#
# Be sure to run `pod lib lint VRFoundationToolkit.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VRFoundationToolkit"
  s.version          = "0.1.1"
  s.summary          = "Extends NSFoundation with categories, macros & classes. Effective Obj-C developer's mini-toolkit)"
  s.description      = <<-DESC
                       Extends NSFoundation with categories, macros & classes.

                       ## Categories
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

                       ## Macros
                       * __VREnumXXX__ - generates enums with utility functions. NSStringFromXXX returns enum constant by value. isValidXXX checks range of enum value.
                       * __VRLOGxxx__ - multilevel logging & assertion macros. Could be connected to preferable logging system. VRPRECONDITIONxxx macros to implement light design by contract.
                       * __VRKeyName__ - stringifyes expression to key for `-[NSCoder encodeObject:withKey:]`. Useful to make names via help of XCode autocompletion.
                       * __VRSingleton__ - return singleton.
                       * __VROBJCTYPExxx__ - returns Objective-C type string representation of the passed variable (or type). VRIS_TYPE_EQUAL_TO_TYPE(V1, V2) compares Objective-C types of two passed values/types.                       
                       
                       ## Classes
                       * __VRURLConnectionChecker__ - checks if default site or specified URL is accessible with completion and error blocks.
                       
                       ## Functions
                       * __NSComparisonInvertedResult__ - inverts the comparison result.
                       * __VRCanPerform__ - checks if object conforms to protocol & responds to selector. Usefull for precondition check in delegate setters.
                       DESC
  s.homepage         = "https://github.com/IvanRublev/VRFoundationToolkit"
  s.license          = 'MIT'
  s.author           = { "Ivan Rublev" => "ivan@ivanrublev.me" }
  s.source           = { :git => "https://github.com/IvanRublev/VRFoundationToolkit.git", :tag => s.version.to_s }

  s.requires_arc = true
  s.ios.deployment_target = "6.0"
  s.osx.deployment_target = "10.8"

  s.source_files   = 'VRFoundationToolkit'

  s.frameworks = 'Foundation'
  s.dependency 'libextobjc', '~> 0.4'
  s.dependency 'MAObjCRuntime'
  
  s.subspec 'LogAndPreconditionCheck' do |ss|
    ss.source_files = 'VRFoundationToolkit/LogAndPreconditionCheck/*.{h,m}'
  end
  s.subspec 'PropertiesProcessing' do |ss|
    ss.source_files = 'VRFoundationToolkit/NSObject+VRPropertiesProcessing/*.{h,m}'
    ss.dependency 'VRFoundationToolkit/LogAndPreconditionCheck'
  end
  s.subspec 'ConnectionChecker' do |ss|
    ss.source_files = 'VRFoundationToolkit/VRURLConnectionChecker/*.{h,m}'
    ss.dependency 'VRFoundationToolkit/LogAndPreconditionCheck'
  end
  s.subspec 'NSArray+VRArgument' do |ss|
    ss.source_files = 'VRFoundationToolkit/NSArray+VRArgument/*.{h,m}'
    ss.dependency 'VRFoundationToolkit/LogAndPreconditionCheck'
  end
end
