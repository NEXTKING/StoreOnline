#import <Foundation/Foundation.h>
#import <libxml/tree.h>
#import <objc/runtime.h>

#import "USAdditions.h"
#import "USGlobals.h"

@class PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput;
@class PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput;
@class PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput;
@class PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput;
@class PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput;
@class PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput;
@class PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput;
@class PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput;
@class PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput;
@class PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput;
@class PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput;
@class PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput;
@class PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput;
@class PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput;
@class PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput;
@class PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementUSER_INFOInput;
@class PI_MOBILE_SERVICEService_ElementUSER_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput;
@class PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput;
@class PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput;
@class PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementWARE_INFOInput;
@class PI_MOBILE_SERVICEService_ElementWARE_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput;
@class PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput;
@class PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput;
@class PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput;
@class PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType;
@class PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8;
@class PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9;
@class PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8;
@class PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9;
@class PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT;
@class PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2;
@class PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT;
@class PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT;
@class PI_MOBILE_SERVICEService_SequenceElement_CSV_ROWS;
@class PI_MOBILE_SERVICEService_SequenceElement_INC_CODE;
@class PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO;
@class PI_MOBILE_SERVICEService_SequenceElement_PORTIONS_INFO;
@class PI_MOBILE_SERVICEService_SequenceElement_TASK_NUM;
@class PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY;
@class PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY;
@class PI_MOBILE_SERVICEService_SequenceElement_VAL;
@class PI_MOBILE_SERVICEService_SequenceElement_WARE_CODE;
@class PI_MOBILE_SERVICEService_SequenceElement_WARE_INFO;
@class PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType;
@class PI_MOBILE_SERVICEService_TPORTIONINFO_IntType;
@class PI_MOBILE_SERVICEService_TROWARRAYType;
@class PI_MOBILE_SERVICEService_TROW_IntType;

@interface PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_CSV_ROWS : NSObject
+ (NSArray *)deserializeNode:(xmlNodePtr)cur;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSArray *)value;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSArray * CSV_ROWS;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSET_INC_DONEOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * RETURN;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_VAL : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementGET_PORTIONS_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType * RETURN;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_INC_CODE : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * A_INC_CODEVARCHAR2IN;
@property (nonatomic, strong) NSNumber * A_ID_PORTIONNUMBERIN;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@end
@interface PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_PORTIONS_INFO : NSObject
+ (NSArray *)deserializeNode:(xmlNodePtr)cur;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSArray *)value;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSArray * PORTIONS_INFO;
@end
@interface PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT * A_TOTAL_SIZE_KBNUMBEROUT;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_STR_COUNTNUMBEROUT * A_STR_COUNTNUMBEROUT;
@property (nonatomic, strong) NSString * A_INC_CODEVARCHAR2IN;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_COUNTNUMBEROUT * A_COUNTNUMBEROUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_WARE_INFO : NSObject
+ (NSArray *)deserializeNode:(xmlNodePtr)cur;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSArray *)value;
@end
@interface PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT8 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_ElementWARE_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO * PASTINGBILLPRINTINFO;
@end
@interface PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT10 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT10 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_PASTINGBILLPRINTINFO *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSArray * WARE_INFO;
@end
@interface PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT2 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT2 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_TROW_IntType : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TROW_IntType *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * NUM;
@property (nonatomic, strong) NSString * VAL;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_TOTAL_SIZE_KB;
@property (nonatomic, strong) NSNumber * A_STR_COUNT;
@property (nonatomic, strong) NSNumber * A_COUNT;
@end
@interface PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT2 * A_MESSAGEVARCHAR2OUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_PASTINGBILLPRINTINFOType * AT_PRINT_INFOPASTINGBILLPRINTINFOCIN;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT8 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT9 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_TASK_NUM : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_WARE_CODE : NSObject
+ (NSString *)deserializeNode:(xmlNodePtr)node;
+ (NSString *)deserializeAttribute:(const char *)attrName ofNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(NSString *)value;
+ (void)serializeToProperty:(const char *)property onNode:(xmlNodePtr)node
                      value:(NSString *)value;
@end
@interface PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_PASTINGBILLPRINTWAREINFO_IntType *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * TASK_NUM;
@property (nonatomic, strong) NSString * WARE_CODE;
@end
@interface PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * A_INC_CODEVARCHAR2IN;
@property (nonatomic, strong) NSNumber * A_ID_PORTIONNUMBERIN;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@end
@interface PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementCVS_VERSIONOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * RETURN;
@end
@interface PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT4 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT4 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_SAVE_PRINT_FACTOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * RETURN;
@property (nonatomic, strong) NSString * A_MESSAGE;
@end
@interface PI_MOBILE_SERVICEService_ElementUSER_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementUSER_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * A_TASK_NUMVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_MESSAGEVARCHAR2OUT * A_MESSAGEVARCHAR2OUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@end
@interface PI_MOBILE_SERVICEService_ElementWARE_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * A_ID_PORTION;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_TROWARRAYType * AO_DATA;
@end
@interface PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TPORTIONINFOARRAYType *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_TPORTIONINFOARRAY * TPORTIONINFOARRAY;
@end
@interface PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT5 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT5 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT9 *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementUSER_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT7 * A_ID_PORTIONNUMBEROUT;
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT7 * AO_DATATROWARRAYCOUT;
@end
@interface PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT : NSObject
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_SequenceElement_A_TOTAL_SIZE_KBNUMBEROUT *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

@end
@interface PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * A_DEVICE_UIDVARCHAR2IN;
@end
@interface PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementPASTING_SET_TASK_DONEOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSNumber * RETURN;
@property (nonatomic, strong) NSString * A_MESSAGE;
@end
@interface PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_ElementRESET_INC_DONEOutput *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * RETURN;
@end
@interface PI_MOBILE_SERVICEService_TPORTIONINFO_IntType : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TPORTIONINFO_IntType *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) NSString * INC_CODE;
@property (nonatomic, strong) NSNumber * SIZE_KB;
@property (nonatomic, strong) NSNumber * STR_COUNT;
@property (nonatomic, strong) NSNumber * PORTIONS_COUNT;
@end
@interface PI_MOBILE_SERVICEService_TROWARRAYType : NSObject
- (void)addElementsToNode:(xmlNodePtr)node;
+ (void)serializeToChildOf:(xmlNodePtr)node withName:(const char *)childName value:(PI_MOBILE_SERVICEService_TROWARRAYType *)value;
+ (instancetype)deserializeNode:(xmlNodePtr)cur;

/* elements */
@property (nonatomic, strong) PI_MOBILE_SERVICEService_SequenceElement_TROWARRAY * TROWARRAY;
@end
/* Cookies handling provided by http://en.wikibooks.org/wiki/Programming:WebObjects/Web_Services/Web_Service_Provider */

#import <libxml/parser.h>
#import "xsd.h"
#import "PI_MOBILE_SERVICEService.h"

@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding;

@interface PI_MOBILE_SERVICEService : NSObject

+ (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)PI_MOBILE_SERVICEBinding;

@end

@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO;
@class PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO;

typedef void (^PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)(NSArray *headers, NSArray *bodyParts);
typedef void (^PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)(NSError *error);

@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding : NSObject
@property (nonatomic, copy) NSURL *address;
@property (nonatomic) BOOL logXMLInOut;
@property (nonatomic) BOOL ignoreEmptyResponse;
@property (nonatomic) NSTimeInterval timeout;
@property (nonatomic, strong) NSMutableArray *cookies;
@property (nonatomic, strong) NSMutableDictionary *customHeaders;
@property (nonatomic, strong) id <SSLCredentialsManaging> sslManager;
@property (nonatomic, strong) SOAPSigner *soapSigner;


+ (NSTimeInterval) defaultTimeout;

- (id)initWithAddress:(NSString *)anAddress;
- (void)sendHTTPCallUsingBody:(NSString *)body soapAction:(NSString *)soapAction forOperation:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation *)operation;
- (void)addCookie:(NSHTTPCookie *)toAdd;
- (NSString *)MIMEType;

- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)CVS_VERSIONUsingSVARCHAR2-CVS_VERSIONInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)aSVARCHAR2-CVS_VERSIONInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION*)CVS_VERSIONUsingSVARCHAR2-CVS_VERSIONInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)aSVARCHAR2-CVS_VERSIONInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)GET_PORTIONS_INFOUsingCTPORTIONINFOARRAY-GET_PORTIONS_INFOInput:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)aCTPORTIONINFOARRAY-GET_PORTIONS_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO*)GET_PORTIONS_INFOUsingCTPORTIONINFOARRAY-GET_PORTIONS_INFOInput:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)aCTPORTIONINFOARRAY-GET_PORTIONS_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)GET_PORTION_INFOUsingGET_PORTION_INFOInput:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)aGET_PORTION_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO*)GET_PORTION_INFOUsingGET_PORTION_INFOInput:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)aGET_PORTION_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_SAVE_PRINT_FACTUsingSNUMBER-PASTING_SAVE_PRINT_FACTInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)aSNUMBER-PASTING_SAVE_PRINT_FACTInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT*)PASTING_SAVE_PRINT_FACTUsingSNUMBER-PASTING_SAVE_PRINT_FACTInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)aSNUMBER-PASTING_SAVE_PRINT_FACTInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_SET_TASK_DONEUsingSNUMBER-PASTING_SET_TASK_DONEInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)aSNUMBER-PASTING_SET_TASK_DONEInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE*)PASTING_SET_TASK_DONEUsingSNUMBER-PASTING_SET_TASK_DONEInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)aSNUMBER-PASTING_SET_TASK_DONEInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_TASK_INFOUsingPASTING_TASK_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)aPASTING_TASK_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO*)PASTING_TASK_INFOUsingPASTING_TASK_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)aPASTING_TASK_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)PASTING_WARES_INFOUsingPASTING_WARES_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)aPASTING_WARES_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO*)PASTING_WARES_INFOUsingPASTING_WARES_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)aPASTING_WARES_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)RESET_INC_DONEUsingSVARCHAR2-RESET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)aSVARCHAR2-RESET_INC_DONEInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE*)RESET_INC_DONEUsingSVARCHAR2-RESET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)aSVARCHAR2-RESET_INC_DONEInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)SET_INC_DONEUsingSVARCHAR2-SET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)aSVARCHAR2-SET_INC_DONEInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE*)SET_INC_DONEUsingSVARCHAR2-SET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)aSVARCHAR2-SET_INC_DONEInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)TRADEMARK_INFOUsingTRADEMARK_INFOInput:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)aTRADEMARK_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO*)TRADEMARK_INFOUsingTRADEMARK_INFOInput:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)aTRADEMARK_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)USER_INFOUsingUSER_INFOInput:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)aUSER_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO*)USER_INFOUsingUSER_INFOInput:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)aUSER_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_BARCODE_INFOUsingWARE_BARCODE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)aWARE_BARCODE_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO*)WARE_BARCODE_INFOUsingWARE_BARCODE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)aWARE_BARCODE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_GROUP_INFOUsingWARE_GROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)aWARE_GROUP_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO*)WARE_GROUP_INFOUsingWARE_GROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)aWARE_GROUP_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_IMAGE_INFOUsingWARE_IMAGE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)aWARE_IMAGE_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO*)WARE_IMAGE_INFOUsingWARE_IMAGE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)aWARE_IMAGE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_INFOUsingWARE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)aWARE_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO*)WARE_INFOUsingWARE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)aWARE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_PRICE_INFOUsingWARE_PRICE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)aWARE_PRICE_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO*)WARE_PRICE_INFOUsingWARE_PRICE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)aWARE_PRICE_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *)WARE_SUBGROUP_INFOUsingWARE_SUBGROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)aWARE_SUBGROUP_INFOInput;
- (PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO*)WARE_SUBGROUP_INFOUsingWARE_SUBGROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)aWARE_SUBGROUP_INFOInput success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;
@end

@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation : NSOperation <NSURLConnectionDelegate>
@property(nonatomic, strong) PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding;
@property(nonatomic, strong, readonly) PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse *response;
@property(nonatomic, strong) NSMutableData *responseData;
@property(nonatomic, strong) NSURLConnection *urlConnection;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error;

/**
 * Cancels connection. Response has error with code kCFURLErrorCancelled in domain kCFErrorDomainCFNetwork.
 */
- (void)cancel;

@end

@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_CVS_VERSION : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput * SVARCHAR2-CVS_VERSIONInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	SVARCHAR2-CVS_VERSIONInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2CVS_VERSIONInput *)aSVARCHAR2-CVS_VERSIONInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTIONS_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput * CTPORTIONINFOARRAY-GET_PORTIONS_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	CTPORTIONINFOARRAY-GET_PORTIONS_INFOInput:(PI_MOBILE_SERVICEService_ElementCTPORTIONINFOARRAYGET_PORTIONS_INFOInput *)aCTPORTIONINFOARRAY-GET_PORTIONS_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_GET_PORTION_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput * GET_PORTION_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	GET_PORTION_INFOInput:(PI_MOBILE_SERVICEService_ElementGET_PORTION_INFOInput *)aGET_PORTION_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SAVE_PRINT_FACT : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput * SNUMBER-PASTING_SAVE_PRINT_FACTInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	SNUMBER-PASTING_SAVE_PRINT_FACTInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SAVE_PRINT_FACTInput *)aSNUMBER-PASTING_SAVE_PRINT_FACTInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_SET_TASK_DONE : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput * SNUMBER-PASTING_SET_TASK_DONEInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	SNUMBER-PASTING_SET_TASK_DONEInput:(PI_MOBILE_SERVICEService_ElementSNUMBERPASTING_SET_TASK_DONEInput *)aSNUMBER-PASTING_SET_TASK_DONEInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_TASK_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput * PASTING_TASK_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	PASTING_TASK_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_TASK_INFOInput *)aPASTING_TASK_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_PASTING_WARES_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput * PASTING_WARES_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	PASTING_WARES_INFOInput:(PI_MOBILE_SERVICEService_ElementPASTING_WARES_INFOInput *)aPASTING_WARES_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_RESET_INC_DONE : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput * SVARCHAR2-RESET_INC_DONEInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	SVARCHAR2-RESET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2RESET_INC_DONEInput *)aSVARCHAR2-RESET_INC_DONEInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_SET_INC_DONE : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput * SVARCHAR2-SET_INC_DONEInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	SVARCHAR2-SET_INC_DONEInput:(PI_MOBILE_SERVICEService_ElementSVARCHAR2SET_INC_DONEInput *)aSVARCHAR2-SET_INC_DONEInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_TRADEMARK_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput * TRADEMARK_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	TRADEMARK_INFOInput:(PI_MOBILE_SERVICEService_ElementTRADEMARK_INFOInput *)aTRADEMARK_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_USER_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementUSER_INFOInput * USER_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	USER_INFOInput:(PI_MOBILE_SERVICEService_ElementUSER_INFOInput *)aUSER_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_BARCODE_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput * WARE_BARCODE_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	WARE_BARCODE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput *)aWARE_BARCODE_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_GROUP_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput * WARE_GROUP_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	WARE_GROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_GROUP_INFOInput *)aWARE_GROUP_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_IMAGE_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput * WARE_IMAGE_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	WARE_IMAGE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_IMAGE_INFOInput *)aWARE_IMAGE_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementWARE_INFOInput * WARE_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	WARE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_INFOInput *)aWARE_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_PRICE_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput * WARE_PRICE_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	WARE_PRICE_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_PRICE_INFOInput *)aWARE_PRICE_INFOInput
;
@end
@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_WARE_SUBGROUP_INFO : PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingOperation
@property(nonatomic, strong) PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput * WARE_SUBGROUP_INFOInput;

- (id)initWithBinding:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *)aBinding success:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingSuccessBlock)success error:(PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingErrorBlock)error
	WARE_SUBGROUP_INFOInput:(PI_MOBILE_SERVICEService_ElementWARE_SUBGROUP_INFOInput *)aWARE_SUBGROUP_INFOInput
;
@end

@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding_envelope : NSObject
+ (NSString *)serializedFormUsingDelegate:(id)delegate;
@end

@interface PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBindingResponse : NSObject
@property(nonatomic, strong) NSArray *headers;
@property(nonatomic, strong) NSArray *bodyParts;
@property(nonatomic, strong) NSError *error;
@end
