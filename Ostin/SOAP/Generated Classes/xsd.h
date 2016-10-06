#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import <objc/runtime.h>

#import "USAdditions.h"
#import "USGlobals.h"

@class xsd_ENTITY;
@class xsd_ID;
@class xsd_IDREF;
@class xsd_NCName;
@class xsd_NMTOKEN;
@class xsd_Name;
@class xsd_QName;
@class xsd_anyType;
@class xsd_anyURI;
@class xsd_base64Binary;
@class xsd_boolean;
@class xsd_byte;
@class xsd_date;
@class xsd_dateTime;
@class xsd_decimal;
@class xsd_double;
@class xsd_duration;
@class xsd_float;
@class xsd_int;
@class xsd_integer;
@class xsd_language;
@class xsd_long;
@class xsd_nonNegativeInteger;
@class xsd_normalizedString;
@class xsd_positiveInteger;
@class xsd_short;
@class xsd_string;
@class xsd_time;
@class xsd_token;
@class xsd_unsignedByte;
@class xsd_unsignedInt;
@class xsd_unsignedLong;
@class xsd_unsignedShort;

@interface xsd_anyType : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_int : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_short : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_Name : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_anyURI : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_integer : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_duration : NSObject
+ (NSDate *)deserializeNode:(xmlNodePtr)node;
+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value;
@end
@interface xsd_string : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_double : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_NMTOKEN : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_float : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_decimal : NSObject
+ (NSDecimalNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSDecimalNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDecimalNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDecimalNumber *)value;
@end
@interface xsd_byte : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_ENTITY : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_unsignedByte : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_unsignedLong : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_positiveInteger : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_base64Binary : NSObject
+ (NSData *)deserializeNode:(xmlNodePtr)node;
+ (NSData *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSData *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSData *)value;
@end
@interface xsd_date : NSObject
+ (NSDate *)deserializeNode:(xmlNodePtr)node;
+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value;
@end
@interface xsd_unsignedShort : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_NCName : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_ID : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_nonNegativeInteger : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_QName : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_token : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_unsignedInt : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_dateTime : NSObject
+ (NSDate *)deserializeNode:(xmlNodePtr)node;
+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value;
@end
@interface xsd_long : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_IDREF : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_language : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface xsd_time : NSObject
+ (NSDate *)deserializeNode:(xmlNodePtr)node;
+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value;
@end
@interface xsd_boolean : NSObject
+ (NSNumber *)deserializeNode:(xmlNodePtr)node;
+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value;
@end
@interface xsd_normalizedString : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
