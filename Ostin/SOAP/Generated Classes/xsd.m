#import "xsd.h"

#import "NSDate+ISO8601Parsing.h"
#import "NSDate+ISO8601Unparsing.h"
#import "xsd.h"

#import <libxml/xmlstring.h>
#if TARGET_OS_IPHONE
#import <CFNetwork/CFNetwork.h>
#endif

#ifndef ADVANCED_AUTHENTICATION
#define ADVANCED_AUTHENTICATION 0
#endif

#if ADVANCED_AUTHENTICATION && TARGET_OS_IPHONE
#import <Security/Security.h>
#endif

static Class classForElement(xmlNodePtr cur) {
    NSString *instanceType = [NSString stringWithXmlString:xmlGetNsProp(cur, (const xmlChar *)"type", (const xmlChar *)"http://www.w3.org/2001/XMLSchema-instance")
                                                     free:YES];
    if (!instanceType) return nil;

    NSArray *elementTypeArray = [instanceType componentsSeparatedByString:@":"];
    if ([elementTypeArray count] > 1) {
        NSString *prefix = elementTypeArray[0];
        NSString *localName = elementTypeArray[1];
        xmlNsPtr elementNamespace = xmlSearchNs(cur->doc, cur, [prefix xmlString]);
        NSString *standardPrefix = USGlobals.sharedInstance.wsdlStandardNamespaces[[NSString stringWithXmlString:(xmlChar*)elementNamespace->href free:NO]];

        return NSClassFromString([NSString stringWithFormat:@"%@_%@", standardPrefix, localName]);
    }

    return NSClassFromString([instanceType stringByReplacingOccurrencesOfString:@":" withString:@"_"]);
}
@implementation xsd_anyType
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_int
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_short
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_Name
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_anyURI
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_integer
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_duration
+ (NSDate *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return [NSDate dateWithISO8601String:str];
}

+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return [NSDate dateWithISO8601String:attrString];
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_string
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_double
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str doubleValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString doubleValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_NMTOKEN
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_float
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str doubleValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString doubleValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_decimal
+ (NSDecimalNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return [NSDecimalNumber decimalNumberWithString:str];
}

+ (NSDecimalNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return [NSDecimalNumber decimalNumberWithString:attrString];
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDecimalNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDecimalNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_byte
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_ENTITY
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_unsignedByte
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_unsignedLong
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_positiveInteger
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_base64Binary
+ (NSData *)deserializeNode:(xmlNodePtr)node {
    xmlChar *str = xmlNodeListGetString(node->doc, node->children, 1);
    NSData *data = [NSData dataWithBase64EncodedString:(const char *)str];
    xmlFree(str);
    return data;
}

+ (NSData *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    xmlChar *str = xmlGetProp(node, (const xmlChar *)attrName);
    NSData *data = [NSData dataWithBase64EncodedString:(const char *)str ?: ""];
    xmlFree(str);
    return data;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSData *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value base64Encoding] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSData *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_date
+ (NSDate *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return [NSDate dateWithISO8601String:str];
}

+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return [NSDate dateWithISO8601String:attrString];
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_unsignedShort
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_NCName
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_ID
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_nonNegativeInteger
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_QName
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_token
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_unsignedInt
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str intValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString intValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_dateTime
+ (NSDate *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return [NSDate dateWithISO8601String:str];
}

+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return [NSDate dateWithISO8601String:attrString];
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_long
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str longLongValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString longLongValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_IDREF
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_language
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_time
+ (NSDate *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return [NSDate dateWithISO8601String:str];
}

+ (NSDate *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return [NSDate dateWithISO8601String:attrString];
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSDate *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSDate *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_boolean
+ (NSNumber *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return @([str boolValue]);
}

+ (NSNumber *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return @([attrString boolValue]);
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSNumber *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSNumber *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
@implementation xsd_normalizedString
+ (NSString *)deserializeNode:(xmlNodePtr)node {
    NSString *str = [NSString stringWithXmlString:xmlNodeListGetString(node->doc, node->children, 1) free:YES];
    return str;
}

+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node {
    NSString *attrString = [NSString stringWithXmlString:xmlGetProp(node, (const xmlChar *)attrName) free:YES];
    if (!attrString) return nil;
    return attrString;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value {
    if (value)
        xmlNewChild(node, NULL, (const xmlChar *)childName, [[value description] xmlString]);
}

+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value
{
    if (value)
        xmlSetProp(node, (const xmlChar *)property, [[value description] xmlString]);
}
@end
