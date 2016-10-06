//
//  ZebraLibrary.h
//  ZebraLibrary
//
//  Created by Denis Kurochkin on 13.04.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CardItem : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, copy) NSString* number;
@property (nonatomic, assign) double amount;
@end

@interface PurchaseItem : NSObject

@property (nonatomic, strong) NSArray<NSString*>* header;

//Body

@property (nonatomic, copy) NSString* fiscalPositionTitle;
@property (nonatomic, assign) double fiscalPositionAmount;
@property (nonatomic, strong) NSArray<NSString*>* nonFiscalPositions;

//Total
@property (nonatomic, assign) double totalDiscount;
@property (nonatomic, assign) double totalCash;
@property (nonatomic, strong) NSArray<CardItem*>* totalCards;
@property (nonatomic, strong) NSArray<CardItem*>* totalDocuments;

//Ads

@property (nonatomic, strong) NSArray<NSString*>* footer;

@end

@class ZebraLibrary;

@protocol ZebraLibraryDelegate <NSObject>

- (void) zebraLibraryDidFinishBindingPrinter:(NSString*) printerID;
- (void) zebraLibraryDidPrintReceipt;
- (void) zebraLibraryDidFailedPrintingWithError:(NSError*) error;
- (void) zebraLibraryDidFailedBindingWithError:(NSError*) error;
- (void) zebraLibraryDidReturnShiftData: (BOOL) status;

@end

@interface ZebraLibrary : NSObject

@property (nonatomic, assign) id<ZebraLibraryDelegate> delegate;

+ (instancetype) instance;

- (void) bindPrinterWithId:(NSString*) printerId;
- (void) purchase:(PurchaseItem*) purchaseItem;
- (void) reversal:(PurchaseItem*) purchaseItem;
- (void) xReport;
- (void) zReport;
- (void) openShift: (NSString*) name;
- (void) arbitraryText: (NSArray<NSString*>*) textArray;
- (void) getShiftData;
- (void) getCommonData;
- (void) stopActivities;

@end
