#import "PI_MOBILE_SERVICEService.h"

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
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_CSV_ROWS
+ (NSArray *)deserializeNode:(xmlNodePtr)cur {
    NSMutableArray *ret = [NSMutableArray new];
    for (xmlNodePtr child = cur->children; child; child = child->next) {
        if (false);
        else if (xmlStrEqual(child->name, (const xmlChar *)"TROW")) {
            Class elementClass = classForElement(child) ?: [PI_MOBILE_SERVICEService_TROW_IntType class];
            [ret addObject:[elementClass deserializeNode:child]];
        }
    }
    return ret;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSArray *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
    for (PI_MOBILE_SERVICEService_TROW_IntType * item in value)
        [PI_MOBILE_SERVICEService_TROW_IntType serializeToChildOf:child withName:"PI_MOBILE_SERVICEService:TROW" value:item];
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_CSV_ROWS)
        [PI_MOBILE_SERVICEService_SequenceElement_CSV_ROWS serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:CSV_ROWS" value:_CSV_ROWS];

}

+ (PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"CSV_ROWS")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_CSV_ROWS class];
            self.CSV_ROWS = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_RETURN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:RETURN" value:_RETURN];

}

+ (PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"RETURN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.RETURN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_VAL
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
@implementation PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_RETURN)
        [PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:RETURN" value:_RETURN];

}


- (PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType *)RETURN {
    if (!_RETURN) _RETURN = [PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType new];
    return _RETURN;
}
+ (PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"RETURN")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType class];
            self.RETURN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_INC_CODE
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
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_INC_CODEVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_INC_CODE-VARCHAR2-IN" value:_A_INC_CODEVARCHAR2IN];

    if (_A_ID_PORTIONNUMBERIN)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-IN" value:_A_ID_PORTIONNUMBERIN];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

}

+ (PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_INC_CODE-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_INC_CODEVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTIONNUMBERIN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_PORTIONS_INFO
+ (NSArray *)deserializeNode:(xmlNodePtr)cur {
    NSMutableArray *ret = [NSMutableArray new];
    for (xmlNodePtr child = cur->children; child; child = child->next) {
        if (false);
        else if (xmlStrEqual(child->name, (const xmlChar *)"TPORTIONINFO")) {
            Class elementClass = classForElement(child) ?: [PI_MOBILE_SERVICEService_TPORTIONINFO_IntType class];
            [ret addObject:[elementClass deserializeNode:child]];
        }
    }
    return ret;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSArray *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
    for (PI_MOBILE_SERVICEService_TPORTIONINFO_IntType * item in value)
        [PI_MOBILE_SERVICEService_TPORTIONINFO_IntType serializeToChildOf:child withName:"PI_MOBILE_SERVICEService:TPORTIONINFO" value:item];
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_PORTIONS_INFO)
        [PI_MOBILE_SERVICEService_SequenceElement_PORTIONS_INFO serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:PORTIONS_INFO" value:_PORTIONS_INFO];

}

+ (PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"PORTIONS_INFO")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_PORTIONS_INFO class];
            self.PORTIONS_INFO = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_TOTAL_SIZE_KBNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_TOTAL_SIZE_KB-NUMBER-OUT" value:_A_TOTAL_SIZE_KBNUMBEROUT];

    if (_A_STR_COUNTNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_STR_COUNT-NUMBER-OUT" value:_A_STR_COUNTNUMBEROUT];

    if (_A_INC_CODEVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_INC_CODE-VARCHAR2-IN" value:_A_INC_CODEVARCHAR2IN];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_A_COUNTNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_COUNT-NUMBER-OUT" value:_A_COUNTNUMBEROUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT *)A_TOTAL_SIZE_KBNUMBEROUT {
    if (!_A_TOTAL_SIZE_KBNUMBEROUT) _A_TOTAL_SIZE_KBNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT new];
    return _A_TOTAL_SIZE_KBNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT *)A_STR_COUNTNUMBEROUT {
    if (!_A_STR_COUNTNUMBEROUT) _A_STR_COUNTNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT new];
    return _A_STR_COUNTNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT *)A_COUNTNUMBEROUT {
    if (!_A_COUNTNUMBEROUT) _A_COUNTNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT new];
    return _A_COUNTNUMBEROUT;
}
+ (PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_TOTAL_SIZE_KB-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT class];
            self.A_TOTAL_SIZE_KBNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_STR_COUNT-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT class];
            self.A_STR_COUNTNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_INC_CODE-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_INC_CODEVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_COUNT-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT class];
            self.A_COUNTNUMBEROUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_WARE_INFO
+ (NSArray *)deserializeNode:(xmlNodePtr)cur {
    NSMutableArray *ret = [NSMutableArray new];
    for (xmlNodePtr child = cur->children; child; child = child->next) {
        if (false);
        else if (xmlStrEqual(child->name, (const xmlChar *)"PASTINGBILLPRINTWAREINFO")) {
            Class elementClass = classForElement(child) ?: [PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType class];
            [ret addObject:[elementClass deserializeNode:child]];
        }
    }
    return ret;
}

+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSArray *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
    for (PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType * item in value)
        [PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType serializeToChildOf:child withName:"PI_MOBILE_SERVICEService:PASTINGBILLPRINTWAREINFO" value:item];
}
@end
@implementation PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_PASTINGBILLPRINTINFO)
        [PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:PASTINGBILLPRINTINFO" value:_PASTINGBILLPRINTINFO];

}


- (PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO *)PASTINGBILLPRINTINFO {
    if (!_PASTINGBILLPRINTINFO) _PASTINGBILLPRINTINFO = [PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO new];
    return _PASTINGBILLPRINTINFO;
}
+ (PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"PASTINGBILLPRINTINFO")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO class];
            self.PASTINGBILLPRINTINFO = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_WARE_INFO)
        [PI_MOBILE_SERVICEService_SequenceElement_WARE_INFO serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:WARE_INFO" value:_WARE_INFO];

}

+ (PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"WARE_INFO")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_WARE_INFO class];
            self.WARE_INFO = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_TROW_IntType
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TROW_IntType *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_NUM)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:NUM" value:_NUM];

    if (_VAL)
        [PI_MOBILE_SERVICEService_SequenceElement_VAL serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:VAL" value:_VAL];

}

+ (PI_MOBILE_SERVICEService_TROW_IntType *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_TROW_IntType *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"NUM")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.NUM = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"VAL")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_VAL class];
            self.VAL = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_TOTAL_SIZE_KB)
        [xsd_double serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_TOTAL_SIZE_KB" value:_A_TOTAL_SIZE_KB];

    if (_A_STR_COUNT)
        [xsd_double serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_STR_COUNT" value:_A_STR_COUNT];

    if (_A_COUNT)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_COUNT" value:_A_COUNT];

}

+ (PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_TOTAL_SIZE_KB")) {
            Class elementClass = classForElement(cur) ?: [xsd_double class];
            self.A_TOTAL_SIZE_KB = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_STR_COUNT")) {
            Class elementClass = classForElement(cur) ?: [xsd_double class];
            self.A_STR_COUNT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_COUNT")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_COUNT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_MESSAGEVARCHAR2OUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_MESSAGE-VARCHAR2-OUT" value:_A_MESSAGEVARCHAR2OUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AT_PRINT_INFOPASTINGBILLPRINTINFOCIN)
        [PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AT_PRINT_INFO-PASTINGBILLPRINTINFO-CIN" value:_AT_PRINT_INFOPASTINGBILLPRINTINFOCIN];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 *)A_MESSAGEVARCHAR2OUT {
    if (!_A_MESSAGEVARCHAR2OUT) _A_MESSAGEVARCHAR2OUT = [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 new];
    return _A_MESSAGEVARCHAR2OUT;
}

- (PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType *)AT_PRINT_INFOPASTINGBILLPRINTINFOCIN {
    if (!_AT_PRINT_INFOPASTINGBILLPRINTINFOCIN) _AT_PRINT_INFOPASTINGBILLPRINTINFOCIN = [PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType new];
    return _AT_PRINT_INFOPASTINGBILLPRINTINFOCIN;
}
+ (PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_MESSAGE-VARCHAR2-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 class];
            self.A_MESSAGEVARCHAR2OUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AT_PRINT_INFO-PASTINGBILLPRINTINFO-CIN")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType class];
            self.AT_PRINT_INFOPASTINGBILLPRINTINFOCIN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_TASK_NUM
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
@implementation PI_MOBILE_SERVICEService_SequenceElement_WARE_CODE
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
@implementation PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_TASK_NUM)
        [PI_MOBILE_SERVICEService_SequenceElement_TASK_NUM serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:TASK_NUM" value:_TASK_NUM];

    if (_WARE_CODE)
        [PI_MOBILE_SERVICEService_SequenceElement_WARE_CODE serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:WARE_CODE" value:_WARE_CODE];

}

+ (PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"TASK_NUM")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_TASK_NUM class];
            self.TASK_NUM = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"WARE_CODE")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_WARE_CODE class];
            self.WARE_CODE = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_INC_CODEVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_INC_CODE-VARCHAR2-IN" value:_A_INC_CODEVARCHAR2IN];

    if (_A_ID_PORTIONNUMBERIN)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-IN" value:_A_ID_PORTIONNUMBERIN];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

}

+ (PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_INC_CODE-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_INC_CODEVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTIONNUMBERIN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_RETURN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:RETURN" value:_RETURN];

}

+ (PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"RETURN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.RETURN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_RETURN)
        [xsd_double serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:RETURN" value:_RETURN];

    if (_A_MESSAGE)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_MESSAGE" value:_A_MESSAGE];

}

+ (PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"RETURN")) {
            Class elementClass = classForElement(cur) ?: [xsd_double class];
            self.RETURN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_MESSAGE")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_MESSAGE = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementUSER_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementUSER_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementUSER_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementUSER_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_TASK_NUMVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_TASK_NUM-VARCHAR2-IN" value:_A_TASK_NUMVARCHAR2IN];

    if (_A_MESSAGEVARCHAR2OUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_MESSAGE-VARCHAR2-OUT" value:_A_MESSAGEVARCHAR2OUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT *)A_MESSAGEVARCHAR2OUT {
    if (!_A_MESSAGEVARCHAR2OUT) _A_MESSAGEVARCHAR2OUT = [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT new];
    return _A_MESSAGEVARCHAR2OUT;
}
+ (PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_TASK_NUM-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_TASK_NUMVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_MESSAGE-VARCHAR2-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT class];
            self.A_MESSAGEVARCHAR2OUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTION)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION" value:_A_ID_PORTION];

    if (_AO_DATA)
        [PI_MOBILE_SERVICEService_TROWARRAYType serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA" value:_AO_DATA];

}


- (PI_MOBILE_SERVICEService_TROWARRAYType *)AO_DATA {
    if (!_AO_DATA) _AO_DATA = [PI_MOBILE_SERVICEService_TROWARRAYType new];
    return _AO_DATA;
}
+ (PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.A_ID_PORTION = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_TROWARRAYType class];
            self.AO_DATA = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_TPORTIONINFOARRAY)
        [PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:TPORTIONINFOARRAY" value:_TPORTIONINFOARRAY];

}


- (PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY *)TPORTIONINFOARRAY {
    if (!_TPORTIONINFOARRAY) _TPORTIONINFOARRAY = [PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY new];
    return _TPORTIONINFOARRAY;
}
+ (PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"TPORTIONINFOARRAY")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY class];
            self.TPORTIONINFOARRAY = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementUSER_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_ID_PORTIONNUMBEROUT)
        [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_ID_PORTION-NUMBER-OUT" value:_A_ID_PORTIONNUMBEROUT];

    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

    if (_AO_DATATROWARRAYCOUT)
        [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:AO_DATA-TROWARRAY-COUT" value:_AO_DATATROWARRAYCOUT];

}


- (PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 *)A_ID_PORTIONNUMBEROUT {
    if (!_A_ID_PORTIONNUMBEROUT) _A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 new];
    return _A_ID_PORTIONNUMBEROUT;
}

- (PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 *)AO_DATATROWARRAYCOUT {
    if (!_AO_DATATROWARRAYCOUT) _AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 new];
    return _AO_DATATROWARRAYCOUT;
}
+ (PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementUSER_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_ID_PORTION-NUMBER-OUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 class];
            self.A_ID_PORTIONNUMBEROUT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"AO_DATA-TROWARRAY-COUT")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 class];
            self.AO_DATATROWARRAYCOUT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT *)value {
    xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);
}
+ (PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT *newObject = [self new];


    return newObject;
}
@end
@implementation PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_A_DEVICE_UIDVARCHAR2IN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_DEVICE_UID-VARCHAR2-IN" value:_A_DEVICE_UIDVARCHAR2IN];

}

+ (PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_DEVICE_UID-VARCHAR2-IN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_DEVICE_UIDVARCHAR2IN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_RETURN)
        [xsd_double serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:RETURN" value:_RETURN];

    if (_A_MESSAGE)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:A_MESSAGE" value:_A_MESSAGE];

}

+ (PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"RETURN")) {
            Class elementClass = classForElement(cur) ?: [xsd_double class];
            self.RETURN = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"A_MESSAGE")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.A_MESSAGE = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_RETURN)
        [xsd_string serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:RETURN" value:_RETURN];

}

+ (PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"RETURN")) {
            Class elementClass = classForElement(cur) ?: [xsd_string class];
            self.RETURN = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_TPORTIONINFO_IntType
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TPORTIONINFO_IntType *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_INC_CODE)
        [PI_MOBILE_SERVICEService_SequenceElement_INC_CODE serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:INC_CODE" value:_INC_CODE];

    if (_SIZE_KB)
        [xsd_double serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:SIZE_KB" value:_SIZE_KB];

    if (_STR_COUNT)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:STR_COUNT" value:_STR_COUNT];

    if (_PORTIONS_COUNT)
        [xsd_integer serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:PORTIONS_COUNT" value:_PORTIONS_COUNT];

}

+ (PI_MOBILE_SERVICEService_TPORTIONINFO_IntType *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_TPORTIONINFO_IntType *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"INC_CODE")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_INC_CODE class];
            self.INC_CODE = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"SIZE_KB")) {
            Class elementClass = classForElement(cur) ?: [xsd_double class];
            self.SIZE_KB = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"STR_COUNT")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.STR_COUNT = [elementClass deserializeNode:cur];
        }
        else if (xmlStrEqual(cur->name, (const xmlChar *)"PORTIONS_COUNT")) {
            Class elementClass = classForElement(cur) ?: [xsd_integer class];
            self.PORTIONS_COUNT = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService_TROWARRAYType
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TROWARRAYType *)value {
    xmlNodePtr child = xmlNewChild(node, NULL, (const xmlChar *)childName, NULL);

    [value addElementsToNode:child];
}

- (void)addElementsToNode:(xmlNodePtr)node {
    if (_TROWARRAY)
        [PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY serializeToChildOf:node withName:"PI_MOBILE_SERVICEService:TROWARRAY" value:_TROWARRAY];

}


- (PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY *)TROWARRAY {
    if (!_TROWARRAY) _TROWARRAY = [PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY new];
    return _TROWARRAY;
}
+ (PI_MOBILE_SERVICEService_TROWARRAYType *)deserializeNode:(xmlNodePtr)cur {
    PI_MOBILE_SERVICEService_TROWARRAYType *newObject = [self new];

    [newObject deserializeElementsFromNode:cur];

    return newObject;
}

- (void)deserializeElementsFromNode:(xmlNodePtr)cur {
    for (cur = cur->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        else if (xmlStrEqual(cur->name, (const xmlChar *)"TROWARRAY")) {
            Class elementClass = classForElement(cur) ?: [PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY class];
            self.TROWARRAY = [elementClass deserializeNode:cur];
        }
    }
}
@end
@implementation PI_MOBILE_SERVICEService

+ (void)initialize {
    [USGlobals sharedInstance].wsdlStandardNamespaces[@"http://www.w3.org/2001/XMLSchema"] = @"xsd";
    [USGlobals sharedInstance].wsdlStandardNamespaces[@"http://www.w3.org/XML/1998/namespace"] = @"xml";
    [USGlobals sharedInstance].wsdlStandardNamespaces[@"http://xmlns.oracle.com/orawsv/MAA_WEB/PI_MOBILE_SERVICE"] = @"PI_MOBILE_SERVICEService";
}

+ (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)PI_MOBILE_SERVICEBinding {
    return [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding alloc] initWithAddress:@"http://172.16.0.124:8080/orawsv/TEST0_WEB/PI_MOBILE_SERVICE"];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding

+ (NSTimeInterval)defaultTimeout {
    return 10;
}

- (id)init {
    if ((self = [super init])) {
        _customHeaders = [NSMutableDictionary new];
        _timeout = [[self class] defaultTimeout];
    }

    return self;
}

- (id)initWithAddress:(NSString *)anAddress {
    if ((self = [self init]))
        self.address = [NSURL URLWithString:anAddress];

    return self;
}

- (NSString *)MIMEType {
    return @"text/xml";
}

- (void)addCookie:(NSHTTPCookie *)toAdd {
    if (toAdd) {
        if (!self.cookies) self.cookies = [NSMutableArray new];
        [self.cookies addObject:toAdd];
    }
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)performSynchronousOperation:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation *)operation {
    [operation start];

    // Now wait for response
    NSRunLoop *theRL = [NSRunLoop currentRunLoop];

    while (![operation isFinished] && [theRL runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);

    return operation.response;
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)CVS_VERSIONUsingSVARCHAR2_CVS_VERSIONInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)aSVARCHAR2_CVS_VERSIONInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION alloc] initWithBinding:self success:nil error:nil
        SVARCHAR2_CVS_VERSIONInput:aSVARCHAR2_CVS_VERSIONInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION*)CVS_VERSIONUsingSVARCHAR2_CVS_VERSIONInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)aSVARCHAR2_CVS_VERSIONInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION alloc] initWithBinding:self success:success error:error
        SVARCHAR2_CVS_VERSIONInput:aSVARCHAR2_CVS_VERSIONInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)GET_PORTIONS_INFOUsingCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)aCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO alloc] initWithBinding:self success:nil error:nil
        CTPORTIONINFOARRAY_GET_PORTIONS_INFOInput:aCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO*)GET_PORTIONS_INFOUsingCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)aCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO alloc] initWithBinding:self success:success error:error
        CTPORTIONINFOARRAY_GET_PORTIONS_INFOInput:aCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)GET_PORTION_INFOUsingGET_PORTION_INFOInput:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)aGET_PORTION_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO alloc] initWithBinding:self success:nil error:nil
        GET_PORTION_INFOInput:aGET_PORTION_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO*)GET_PORTION_INFOUsingGET_PORTION_INFOInput:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)aGET_PORTION_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO alloc] initWithBinding:self success:success error:error
        GET_PORTION_INFOInput:aGET_PORTION_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_SAVE_PRINT_FACTUsingSNUMBER_PASTING_SAVE_PRINT_FACTInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)aSNUMBER_PASTING_SAVE_PRINT_FACTInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT alloc] initWithBinding:self success:nil error:nil
        SNUMBER_PASTING_SAVE_PRINT_FACTInput:aSNUMBER_PASTING_SAVE_PRINT_FACTInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT*)PASTING_SAVE_PRINT_FACTUsingSNUMBER_PASTING_SAVE_PRINT_FACTInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)aSNUMBER_PASTING_SAVE_PRINT_FACTInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT alloc] initWithBinding:self success:success error:error
        SNUMBER_PASTING_SAVE_PRINT_FACTInput:aSNUMBER_PASTING_SAVE_PRINT_FACTInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_SET_TASK_DONEUsingSNUMBER_PASTING_SET_TASK_DONEInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)aSNUMBER_PASTING_SET_TASK_DONEInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE alloc] initWithBinding:self success:nil error:nil
        SNUMBER_PASTING_SET_TASK_DONEInput:aSNUMBER_PASTING_SET_TASK_DONEInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE*)PASTING_SET_TASK_DONEUsingSNUMBER_PASTING_SET_TASK_DONEInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)aSNUMBER_PASTING_SET_TASK_DONEInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE alloc] initWithBinding:self success:success error:error
        SNUMBER_PASTING_SET_TASK_DONEInput:aSNUMBER_PASTING_SET_TASK_DONEInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_TASK_INFOUsingPASTING_TASK_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)aPASTING_TASK_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO alloc] initWithBinding:self success:nil error:nil
        PASTING_TASK_INFOInput:aPASTING_TASK_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO*)PASTING_TASK_INFOUsingPASTING_TASK_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)aPASTING_TASK_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO alloc] initWithBinding:self success:success error:error
        PASTING_TASK_INFOInput:aPASTING_TASK_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_WARES_INFOUsingPASTING_WARES_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)aPASTING_WARES_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO alloc] initWithBinding:self success:nil error:nil
        PASTING_WARES_INFOInput:aPASTING_WARES_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO*)PASTING_WARES_INFOUsingPASTING_WARES_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)aPASTING_WARES_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO alloc] initWithBinding:self success:success error:error
        PASTING_WARES_INFOInput:aPASTING_WARES_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)RESET_INC_DONEUsingSVARCHAR2_RESET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)aSVARCHAR2_RESET_INC_DONEInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE alloc] initWithBinding:self success:nil error:nil
        SVARCHAR2_RESET_INC_DONEInput:aSVARCHAR2_RESET_INC_DONEInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE*)RESET_INC_DONEUsingSVARCHAR2_RESET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)aSVARCHAR2_RESET_INC_DONEInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE alloc] initWithBinding:self success:success error:error
        SVARCHAR2_RESET_INC_DONEInput:aSVARCHAR2_RESET_INC_DONEInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)SET_INC_DONEUsingSVARCHAR2_SET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)aSVARCHAR2_SET_INC_DONEInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE alloc] initWithBinding:self success:nil error:nil
        SVARCHAR2_SET_INC_DONEInput:aSVARCHAR2_SET_INC_DONEInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE*)SET_INC_DONEUsingSVARCHAR2_SET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)aSVARCHAR2_SET_INC_DONEInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE alloc] initWithBinding:self success:success error:error
        SVARCHAR2_SET_INC_DONEInput:aSVARCHAR2_SET_INC_DONEInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)TRADEMARK_INFOUsingTRADEMARK_INFOInput:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)aTRADEMARK_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO alloc] initWithBinding:self success:nil error:nil
        TRADEMARK_INFOInput:aTRADEMARK_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO*)TRADEMARK_INFOUsingTRADEMARK_INFOInput:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)aTRADEMARK_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO alloc] initWithBinding:self success:success error:error
        TRADEMARK_INFOInput:aTRADEMARK_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)USER_INFOUsingUSER_INFOInput:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)aUSER_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO alloc] initWithBinding:self success:nil error:nil
        USER_INFOInput:aUSER_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO*)USER_INFOUsingUSER_INFOInput:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)aUSER_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO alloc] initWithBinding:self success:success error:error
        USER_INFOInput:aUSER_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_BARCODE_INFOUsingWARE_BARCODE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)aWARE_BARCODE_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO alloc] initWithBinding:self success:nil error:nil
        WARE_BARCODE_INFOInput:aWARE_BARCODE_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO*)WARE_BARCODE_INFOUsingWARE_BARCODE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)aWARE_BARCODE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO alloc] initWithBinding:self success:success error:error
        WARE_BARCODE_INFOInput:aWARE_BARCODE_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_GROUP_INFOUsingWARE_GROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)aWARE_GROUP_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO alloc] initWithBinding:self success:nil error:nil
        WARE_GROUP_INFOInput:aWARE_GROUP_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO*)WARE_GROUP_INFOUsingWARE_GROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)aWARE_GROUP_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO alloc] initWithBinding:self success:success error:error
        WARE_GROUP_INFOInput:aWARE_GROUP_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_IMAGE_INFOUsingWARE_IMAGE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)aWARE_IMAGE_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO alloc] initWithBinding:self success:nil error:nil
        WARE_IMAGE_INFOInput:aWARE_IMAGE_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO*)WARE_IMAGE_INFOUsingWARE_IMAGE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)aWARE_IMAGE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO alloc] initWithBinding:self success:success error:error
        WARE_IMAGE_INFOInput:aWARE_IMAGE_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_INFOUsingWARE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)aWARE_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO alloc] initWithBinding:self success:nil error:nil
        WARE_INFOInput:aWARE_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO*)WARE_INFOUsingWARE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)aWARE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO alloc] initWithBinding:self success:success error:error
        WARE_INFOInput:aWARE_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_PRICE_INFOUsingWARE_PRICE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)aWARE_PRICE_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO alloc] initWithBinding:self success:nil error:nil
        WARE_PRICE_INFOInput:aWARE_PRICE_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO*)WARE_PRICE_INFOUsingWARE_PRICE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)aWARE_PRICE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO alloc] initWithBinding:self success:success error:error
        WARE_PRICE_INFOInput:aWARE_PRICE_INFOInput
    ];
    [op start];
    return op;
}
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_SUBGROUP_INFOUsingWARE_SUBGROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)aWARE_SUBGROUP_INFOInput {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO alloc] initWithBinding:self success:nil error:nil
        WARE_SUBGROUP_INFOInput:aWARE_SUBGROUP_INFOInput
    ];

    return [self performSynchronousOperation:op];
}

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO*)WARE_SUBGROUP_INFOUsingWARE_SUBGROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)aWARE_SUBGROUP_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO *op = [[PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO alloc] initWithBinding:self success:success error:error
        WARE_SUBGROUP_INFOInput:aWARE_SUBGROUP_INFOInput
    ];
    [op start];
    return op;
}

- (void)sendHTTPCallUsingBody:(NSString *)outputBody soapAction:(NSString *)soapAction forOperation:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation *)operation {
    if (!outputBody) {
        NSError *err = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingNULLRequestException" code:0 userInfo:nil];
        [operation connection:nil didFailWithError:err];
        return;
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.address 
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                       timeoutInterval:self.timeout];
    NSData *bodyData = [outputBody dataUsingEncoding:NSUTF8StringEncoding];

    if (self.cookies)
        [request setAllHTTPHeaderFields:[NSHTTPCookie requestHeaderFieldsWithCookies:self.cookies]];
    [request setValue:@"wsdl2objc" forHTTPHeaderField:@"User-Agent"];
    [request setValue:soapAction forHTTPHeaderField:@"SOAPAction"];
    [request setValue:[[self MIMEType] stringByAppendingString:@"; charset=utf-8"] forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[bodyData length]] forHTTPHeaderField:@"Content-Length"];
    [request setValue:self.address.host forHTTPHeaderField:@"Host"];
    for (NSString *eachHeaderField in self.customHeaders)
        [request setValue:[self.customHeaders objectForKey:eachHeaderField] forHTTPHeaderField:eachHeaderField];
    [request setHTTPMethod:@"POST"];
    // set version 1.1 - how?
    [request setHTTPBody: bodyData];

    if (self.logXMLInOut) {
        NSLog(@"OutputHeaders:\n%@", [request allHTTPHeaderFields]);
        NSLog(@"OutputBody:\n%@", outputBody);
    }

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:operation];

    operation.urlConnection = connection;
}

@end

@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation ()
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
@property(nonatomic, strong) PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response;
@property(nonatomic, strong) PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock success;
@property(nonatomic, strong) PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock error;
@property(nonatomic) BOOL isFinished;
@end

@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error {
    if ((self = [super init])) {
        self.binding = aBinding;
        self.success = success;
        self.error = error;
    }

    return self;
}

- (void)cancel {
    NSError *cancelError = [NSError errorWithDomain:(__bridge NSString *)kCFErrorDomainCFNetwork code:kCFURLErrorCancelled userInfo:nil];

    [self.urlConnection cancel];
    [super cancel];
    [self connection:self.urlConnection didFailWithError:cancelError];
}

- (void)completedWithResponse:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)aResponse {
    if (aResponse.error) {
        if (self.error)
            self.error(aResponse.error);
    }
    else if (self.success)
        self.success(aResponse.headers, aResponse.bodyParts);
    self.success = nil;
    self.error = nil;
    self.isFinished = YES;
}

- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    return [self.binding.sslManager canAuthenticateForAuthenticationMethod:protectionSpace.authenticationMethod];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    if (![self.binding.sslManager authenticateForChallenge:challenge]) {
        [[challenge sender] cancelAuthenticationChallenge:challenge];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)urlResponse {
    if (![urlResponse isKindOfClass:[NSHTTPURLResponse class]]) {
        NSLog(@"Unexpected url response: %@", urlResponse);
        return;
    }

    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)urlResponse;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseStatus: %ld\n", (long)[httpResponse statusCode]);
        NSLog(@"ResponseHeaders:\n%@", [httpResponse allHeaderFields]);
    }

    self.binding.cookies = [[NSHTTPCookie cookiesWithResponseHeaderFields:[httpResponse allHeaderFields] forURL:self.binding.address] mutableCopy];

    if ([urlResponse.MIMEType rangeOfString:[self.binding MIMEType]].length != 0)
        return;

    NSInteger contentLength = [httpResponse.allHeaderFields[@"Content-Length"] integerValue];

    if (contentLength == 0 && self.binding.ignoreEmptyResponse) {
        [self completedWithResponse:self.response];
        return;
    }

    NSError *error = nil;
    [connection cancel];
    if ([httpResponse statusCode] >= 400) {
        NSDictionary *userInfo =  @{NSURLErrorKey: httpResponse.URL ?: @"",
                                    NSLocalizedDescriptionKey: [NSHTTPURLResponse localizedStringForStatusCode:[httpResponse statusCode]]};
        error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseHTTP" code:[httpResponse statusCode] userInfo:userInfo];
    } else {
        NSDictionary *userInfo =  @{NSURLErrorKey: httpResponse.URL ?: @"",
                                    NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Unexpected response MIME type to SOAP call:%@", urlResponse.MIMEType]};
        error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseHTTP" code:1 userInfo:userInfo];
    }

    [self connection:connection didFailWithError:error];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (!self.responseData)
        self.responseData = [data mutableCopy];
    else
        [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.binding.logXMLInOut && (![[error domain] isEqualToString:(__bridge NSString *)kCFErrorDomainCFNetwork] || [error code] != kCFURLErrorCancelled)) {
        NSLog(@"ResponseError:\n%@", error);
    }
    self.response.error = error;
    [self completedWithResponse:self.response];
}

@end

@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
SVARCHAR2_CVS_VERSIONInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)aSVARCHAR2_CVS_VERSIONInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.SVARCHAR2_CVS_VERSIONInput = aSVARCHAR2_CVS_VERSIONInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"CVS_VERSION"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_SVARCHAR2_CVS_VERSIONInput)
        [PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:SVARCHAR2-CVS_VERSIONInput" value:_SVARCHAR2_CVS_VERSIONInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"CVS_VERSIONOutput": [PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
CTPORTIONINFOARRAY_GET_PORTIONS_INFOInput:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)aCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.CTPORTIONINFOARRAY_GET_PORTIONS_INFOInput = aCTPORTIONINFOARRAY_GET_PORTIONS_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"GET_PORTIONS_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_CTPORTIONINFOARRAY_GET_PORTIONS_INFOInput)
        [PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:CTPORTIONINFOARRAY-GET_PORTIONS_INFOInput" value:_CTPORTIONINFOARRAY_GET_PORTIONS_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"GET_PORTIONS_INFOOutput": [PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
GET_PORTION_INFOInput:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)aGET_PORTION_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.GET_PORTION_INFOInput = aGET_PORTION_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"GET_PORTION_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_GET_PORTION_INFOInput)
        [PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:GET_PORTION_INFOInput" value:_GET_PORTION_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"GET_PORTION_INFOOutput": [PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
SNUMBER_PASTING_SAVE_PRINT_FACTInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)aSNUMBER_PASTING_SAVE_PRINT_FACTInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.SNUMBER_PASTING_SAVE_PRINT_FACTInput = aSNUMBER_PASTING_SAVE_PRINT_FACTInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"PASTING_SAVE_PRINT_FACT"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_SNUMBER_PASTING_SAVE_PRINT_FACTInput)
        [PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:SNUMBER-PASTING_SAVE_PRINT_FACTInput" value:_SNUMBER_PASTING_SAVE_PRINT_FACTInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"PASTING_SAVE_PRINT_FACTOutput": [PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
SNUMBER_PASTING_SET_TASK_DONEInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)aSNUMBER_PASTING_SET_TASK_DONEInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.SNUMBER_PASTING_SET_TASK_DONEInput = aSNUMBER_PASTING_SET_TASK_DONEInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"PASTING_SET_TASK_DONE"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_SNUMBER_PASTING_SET_TASK_DONEInput)
        [PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:SNUMBER-PASTING_SET_TASK_DONEInput" value:_SNUMBER_PASTING_SET_TASK_DONEInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"PASTING_SET_TASK_DONEOutput": [PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
PASTING_TASK_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)aPASTING_TASK_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.PASTING_TASK_INFOInput = aPASTING_TASK_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"PASTING_TASK_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_PASTING_TASK_INFOInput)
        [PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:PASTING_TASK_INFOInput" value:_PASTING_TASK_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"PASTING_TASK_INFOOutput": [PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
PASTING_WARES_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)aPASTING_WARES_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.PASTING_WARES_INFOInput = aPASTING_WARES_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"PASTING_WARES_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_PASTING_WARES_INFOInput)
        [PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:PASTING_WARES_INFOInput" value:_PASTING_WARES_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"PASTING_WARES_INFOOutput": [PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
SVARCHAR2_RESET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)aSVARCHAR2_RESET_INC_DONEInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.SVARCHAR2_RESET_INC_DONEInput = aSVARCHAR2_RESET_INC_DONEInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"RESET_INC_DONE"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_SVARCHAR2_RESET_INC_DONEInput)
        [PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:SVARCHAR2-RESET_INC_DONEInput" value:_SVARCHAR2_RESET_INC_DONEInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"RESET_INC_DONEOutput": [PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
SVARCHAR2_SET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)aSVARCHAR2_SET_INC_DONEInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.SVARCHAR2_SET_INC_DONEInput = aSVARCHAR2_SET_INC_DONEInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"SET_INC_DONE"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_SVARCHAR2_SET_INC_DONEInput)
        [PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:SVARCHAR2-SET_INC_DONEInput" value:_SVARCHAR2_SET_INC_DONEInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"SET_INC_DONEOutput": [PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
TRADEMARK_INFOInput:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)aTRADEMARK_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.TRADEMARK_INFOInput = aTRADEMARK_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"TRADEMARK_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_TRADEMARK_INFOInput)
        [PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:TRADEMARK_INFOInput" value:_TRADEMARK_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"TRADEMARK_INFOOutput": [PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
USER_INFOInput:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)aUSER_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.USER_INFOInput = aUSER_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"USER_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_USER_INFOInput)
        [PI_MOBILE_SERVICEService_ElementUSER_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:USER_INFOInput" value:_USER_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"USER_INFOOutput": [PI_MOBILE_SERVICEService_ElementUSER_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
WARE_BARCODE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)aWARE_BARCODE_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.WARE_BARCODE_INFOInput = aWARE_BARCODE_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"WARE_BARCODE_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_WARE_BARCODE_INFOInput)
        [PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:WARE_BARCODE_INFOInput" value:_WARE_BARCODE_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"WARE_BARCODE_INFOOutput": [PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
WARE_GROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)aWARE_GROUP_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.WARE_GROUP_INFOInput = aWARE_GROUP_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"WARE_GROUP_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_WARE_GROUP_INFOInput)
        [PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:WARE_GROUP_INFOInput" value:_WARE_GROUP_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"WARE_GROUP_INFOOutput": [PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
WARE_IMAGE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)aWARE_IMAGE_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.WARE_IMAGE_INFOInput = aWARE_IMAGE_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"WARE_IMAGE_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_WARE_IMAGE_INFOInput)
        [PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:WARE_IMAGE_INFOInput" value:_WARE_IMAGE_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"WARE_IMAGE_INFOOutput": [PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
WARE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)aWARE_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.WARE_INFOInput = aWARE_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"WARE_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_WARE_INFOInput)
        [PI_MOBILE_SERVICEService_ElementWARE_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:WARE_INFOInput" value:_WARE_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"WARE_INFOOutput": [PI_MOBILE_SERVICEService_ElementWARE_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
WARE_PRICE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)aWARE_PRICE_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.WARE_PRICE_INFOInput = aWARE_PRICE_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"WARE_PRICE_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_WARE_PRICE_INFOInput)
        [PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:WARE_PRICE_INFOInput" value:_WARE_PRICE_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"WARE_PRICE_INFOOutput": [PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end
@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
WARE_SUBGROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)aWARE_SUBGROUP_INFOInput
{
    if ((self = [super initWithBinding:aBinding success:success error:error])) {
        self.WARE_SUBGROUP_INFOInput = aWARE_SUBGROUP_INFOInput;
    }

    return self;
}

- (void)main {
    self.response = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse new];

    NSString *operationXMLString = [PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope serializedFormUsingDelegate:self];
    operationXMLString = self.binding.soapSigner ? [self.binding.soapSigner signRequest:operationXMLString] : operationXMLString;

    [self.binding sendHTTPCallUsingBody:operationXMLString
                             soapAction:@"WARE_SUBGROUP_INFO"
                           forOperation:self];
}

- (void)addSoapBody:(xmlNodePtr)root {
    xmlNodePtr headerNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Header", NULL);
    xmlAddChild(root, headerNode);

    xmlSetNs(headerNode, root->ns);
    xmlNodePtr bodyNode = xmlNewDocNode(root->doc, NULL, (const xmlChar *)"Body", NULL);
    xmlAddChild(root, bodyNode);

    if (_WARE_SUBGROUP_INFOInput)
        [PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput serializeToChildOf:bodyNode withName:"PI_MOBILE_SERVICEService:WARE_SUBGROUP_INFOInput" value:_WARE_SUBGROUP_INFOInput];

    xmlSetNs(bodyNode, root->ns);
}

- (void)processResponseNode:(xmlNodePtr)node classes:(NSDictionary *)classes result:(NSMutableArray *)result {
    if (node->type != XML_ELEMENT_NODE) return;
    NSString *name = [NSString stringWithXmlString:(xmlChar *)node->name free:NO];
    id object = [classes[name] deserializeNode:node];
    if (object)
        [result addObject:object];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (!self.responseData) return;

    if (self.binding.logXMLInOut) {
        NSLog(@"ResponseBody:\n%@", [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding]);
    }

    xmlDocPtr doc = xmlReadMemory([self.responseData bytes], (int)[self.responseData length], NULL, NULL, XML_PARSE_COMPACT | XML_PARSE_NOBLANKS);
    if (doc == NULL) {
        NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"Errors while parsing returned XML"};
        self.response.error = [NSError errorWithDomain:@"PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponseXML" code:1 userInfo:userInfo];
        goto done;
    }

    for (xmlNodePtr cur = xmlDocGetRootElement(doc)->children; cur; cur = cur->next) {
        if (cur->type != XML_ELEMENT_NODE) continue;

        if (xmlStrEqual(cur->name, (const xmlChar *) "Body")) {
            NSMutableArray *responseBodyParts = [NSMutableArray array];
            NSDictionary *bodyParts = @{
                @"WARE_SUBGROUP_INFOOutput": [PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput class],
            };
            for (xmlNodePtr bodyNode = cur->children; bodyNode; bodyNode = bodyNode->next) {
                [self processResponseNode:bodyNode classes:bodyParts result:responseBodyParts];

                if (cur->type != XML_ELEMENT_NODE) continue;
                if ((bodyNode->ns && xmlStrEqual(bodyNode->ns->prefix, cur->ns->prefix)) &&
                    xmlStrEqual(bodyNode->name, (const xmlChar *)"Fault")) {
                    SOAPFault *bodyObject = [SOAPFault deserializeNode:bodyNode expectedExceptions:@{}];
                    if (bodyObject) [responseBodyParts addObject:bodyObject];
                }
            }

            self.response.bodyParts = responseBodyParts;
        }
    }

    xmlFreeDoc(doc);

done:
    xmlCleanupParser();
    [self completedWithResponse:self.response];
}

@end

@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope
+ (NSString *)serializedFormUsingDelegate:(id)delegate {
    xmlDocPtr doc = xmlNewDoc((const xmlChar *)XML_DEFAULT_VERSION);

    if (doc == NULL) {
        NSLog(@"Error creating the xml document tree");
        return @"";
    }

    xmlNodePtr root = xmlNewDocNode(doc, NULL, (const xmlChar *)"Envelope", NULL);
    xmlDocSetRootElement(doc, root);

    xmlNsPtr soapEnvelopeNs = xmlNewNs(root, (const xmlChar *)"http://schemas.xmlsoap.org/soap/envelope/", (const xmlChar *)"soap");

    xmlSetNs(root, soapEnvelopeNs);

    xmlNsPtr xslNs = xmlNewNs(root, (const xmlChar *)"http://www.w3.org/1999/XSL/Transform", (const xmlChar *)"xsl");
    xmlNewNsProp(root, xslNs, (const xmlChar *)"version", (const xmlChar *)"1.0");
    xmlNewNs(root, (const xmlChar *)"http://www.w3.org/2001/XMLSchema", (const xmlChar *)"xsd");
    xmlNewNs(root, (const xmlChar *)"http://www.w3.org/XML/1998/namespace", (const xmlChar *)"xml");
    xmlNewNs(root, (const xmlChar *)"http://xmlns.oracle.com/orawsv/MAA_WEB/PI_MOBILE_SERVICE", (const xmlChar *)"PI_MOBILE_SERVICEService");

    [delegate addSoapBody:root];

    xmlChar *buf;
    int size;
    xmlDocDumpFormatMemory(doc, &buf, &size, 1);

    NSString *serializedForm = [NSString stringWithXmlString:buf free:YES];

    xmlFreeDoc(doc);
    return serializedForm;
}

@end

@implementation PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse
@end
