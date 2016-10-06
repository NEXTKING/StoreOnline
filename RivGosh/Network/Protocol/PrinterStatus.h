//
//  PrinterStatus.h
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 01.06.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PrintingForm : NSObject
@property (nonatomic, copy) NSString* name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) BOOL isPrinting;
@property (nonatomic, strong) NSError* error;
@end

@interface PrinterStatus : NSObject

@property (nonatomic, assign) BOOL fiscalStatus;
@property (nonatomic, assign) BOOL queueStatus;
@property (nonatomic, copy) NSString* fiscalDescription;
@property (nonatomic, copy) NSString* queueDescription;
@property (nonatomic, strong) NSArray<PrintingForm*>* printingForms;

@end
