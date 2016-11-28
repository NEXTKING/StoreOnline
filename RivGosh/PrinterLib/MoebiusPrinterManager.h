//
//  MoebiusPrinterManager.h
//  BluetoothPrinterSDK
//
//  Created by Denis Kurochkin on 15/10/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MoebiusPrinterManager;

@interface PrintItem : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* itemCode;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) double discount;
@property (nonatomic, assign) NSInteger quantiny;

@end

@protocol MoebiusPrinterManagerProtocol <NSObject>

- (void) moebiusPrinterDidFinishPrinting:(MoebiusPrinterManager*) printer;

@end

@interface MoebiusPrinterManager : NSObject

@property (nonatomic, assign) id<MoebiusPrinterManagerProtocol> delegate;

//Printing interface

- (NSInteger) mbsPut;
- (NSInteger) mbsReceipt;
- (NSInteger) mbsReturnReceipt;
- (NSInteger) openShift:(NSString*) name;
- (NSInteger) printCommonData;
- (NSInteger) mbsOut;
- (NSInteger) xReport;
- (NSInteger) zReport;
- (NSInteger) sampleReceipt:(double) amount;
- (NSInteger) realReceipt:(NSArray<PrintItem*>*)items footer:(NSString *)footer orderAmount:(double)orderAmount giftAmount:(double)giftAmount shouldPrintVarFooter:(BOOL) varFooter;
-(BOOL)isShiftOpen;

@end
