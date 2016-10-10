//
//  MCPOfflineInmpl+Ostin.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 29/09/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MCPOfflineInmpl+Ostin.h"
#import "PI_MOBILE_SERVICEService.h"
#import "NSData+Base64.h"
#import "MCPServer.h"
#import "Item+CoreDataClass.h"
#import "Price+CoreDataProperties.h"
#import "Barcode+CoreDataClass.h"

@interface MCPOfflineInmpl_Ostin ()
{
    NSString* authValue;
}

@end

@implementation MCPOfflineInmpl_Ostin

- (id) init
{
    self = [super init];
    
    if (self)
    {
        NSString *authStr = [NSString stringWithFormat:@"%@:%@", @"TEST0_WEB", @"q1w2e3r4t5@web"];
        NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
        authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
    }
    
    return self;
}


- (void) groups:(id<GroupsDelegate>)delegate uid:(NSString *)uid
{
    if (delegate)
        [delegate groupsComplete:0 groups:nil];
}

- (void) subgroups:(id<GroupsDelegate>)delegate uid:(NSString *)uid
{
    if (delegate)
        [delegate subgroupsComplete:0 subgroups:nil];
}

- (void) brands:(id<GroupsDelegate>)delegate uid:(NSString *)uid
{
    
}

- (void) search:(id<SearchDelegate>)delegate forQuery:(NSString *)query withAttribute:(ItemSearchAttribute)searchAttribute
{
    if ([query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) // empty query
    {
        if ([delegate respondsToSelector:@selector(searchComplete:attribute:items:)])
            [delegate searchComplete:0 attribute:searchAttribute items:nil];
        
        return;
    }
    
    NSMutableArray *searchPredicates = [[NSMutableArray alloc] init];
    
    if ((searchAttribute & ItemSearchAttributeName) != 0)
    {
        // name contains all substrings
        NSArray *querySubstrings = [query componentsSeparatedByString:@" "];
        NSMutableArray *substringPredicates = [[NSMutableArray alloc] initWithCapacity:querySubstrings.count];
        for (NSString *substring in querySubstrings)
        {
            if (substring.length > 0)
                [substringPredicates addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", substring]];
        }
        NSPredicate *namePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:substringPredicates];
        [searchPredicates addObject:namePredicate];
    }
    
    if ((searchAttribute & ItemSearchAttributeArticle) != 0)
    {
        NSPredicate *articlePredicate = [NSPredicate predicateWithFormat:@"itemCode_2 == %@", query];
        [searchPredicates addObject:articlePredicate];
    }
    
    if ((searchAttribute & ItemSearchAttributeBarcode) != 0)
    {
        NSPredicate *barcodePredicate = [NSPredicate predicateWithFormat:@"barcode == %@", query];
        [searchPredicates addObject:barcodePredicate];
    }
    
    if ((searchAttribute & ItemSearchAttributeItemCode) != 0)
    {
        NSPredicate *itemCodePredicate = [NSPredicate predicateWithFormat:@"itemCode == %@", query];
        [searchPredicates addObject:itemCodePredicate];
    }
    
    NSManagedObjectContext *moc = self.dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    NSPredicate *compoundPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:searchPredicates];
    [request setPredicate:compoundPredicate];
    NSArray* results = [moc executeFetchRequest:request error:nil];
    
    if (results.count > 0)
    {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (Item *item in results)
        {
            ItemInformation *itemInformation = [ItemInformation new];
            NSMutableArray *additionalParameters = [NSMutableArray new];
            
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"additionalInfo" value:item.additionalInfo]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"additionalSize" value:item.additionalSize]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"boxType" value:item.boxType]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"certificationAuthorittyCode" value:item.certificationAuthorittyCode]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"groupID" value:item.groupID.stringValue]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"itemCode" value:item.itemCode]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"itemCode_2" value:item.itemCode_2]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"line1" value:item.line1]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"line2" value:item.line2]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"priceHeader" value:item.priceHeader]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"size" value:item.size]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"sizeHeader" value:item.sizeHeader]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"storeNumber" value:item.storeNumber]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"subgroupID" value:item.subgroupID.stringValue]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"trademarkID" value:item.trademarkID.stringValue]];
            [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"price" value:[NSString stringWithFormat:@"%f", item.price.retailPrice]]];

            itemInformation.barcode = item.barcode;
            itemInformation.color = item.color;
            itemInformation.itemId = item.itemID.integerValue;
            itemInformation.name = item.name;
            itemInformation.additionalParameters = additionalParameters;
            
            [items addObject:itemInformation];
        }
        if ([delegate respondsToSelector:@selector(searchComplete:attribute:items:)])
            [delegate searchComplete:1 attribute:searchAttribute items:items];
    }
    else
    {
        if ([delegate respondsToSelector:@selector(searchComplete:attribute:items:)])
            [delegate searchComplete:1 attribute:searchAttribute items:nil];
    }
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode
{
    if (code)
    {
        [self itemDescription:delegate itemCode:code];
    }
    else
    {
        
        //[self itemBarcodes:delegate];
        [self itemsDownload:delegate];
       /* PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
        binding.logXMLInOut = YES;
        binding.timeout = 300;
        
        PI_MOBILE_SERVICEService_ElementWARE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_INFOInput new];
        request.A_DEVICE_UIDVARCHAR2IN = @"300";
        request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 new];
        request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 new];
        
        [binding.customHeaders setObject:authValue forKey:@"Authorization"];
        
        [binding WARE_INFOUsingWARE_INFOInput:request success:^(NSArray* headers,NSArray* body)
         {
             if ([body[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_INFOOutput class]])
             {
                 PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *output = body[0];
                 PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
                 [self saveItems:data.TROWARRAY.CSV_ROWS];
                 [self itemBarcodes:delegate];
             }
         } error:^(NSError* error)
         {
             if (delegate)
                 [delegate allItemsDescription:1 items:nil];
         }]; */
    }
}

- (void) itemsDownload:(id<ItemDescriptionDelegate>)delegate
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = YES;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementWARE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = @"300";
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT3 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT3 new];
    
    [binding.customHeaders setObject:authValue forKey:@"Authorization"];
    
    [binding WARE_INFOUsingWARE_INFOInput:request success:^(NSArray* headers,NSArray* body)
     {
         if ([body[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_INFOOutput class]])
         {
             PI_MOBILE_SERVICEService_ElementWARE_INFOOutput *output = body[0];
             PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
             [self saveItems:data.TROWARRAY.CSV_ROWS];
             
             [delegate allItemsDescription:0 items:nil];
         }
     } error:^(NSError* error)
     {
         if (delegate)
             [delegate allItemsDescription:1 items:nil];
     }];
}

- (void) itemBarcodes:(id<ItemDescriptionDelegate>)delegate
{
    PI_MOBILE_SERVICEService_PI_MOBILE_SERVICEBinding *binding = [PI_MOBILE_SERVICEService PI_MOBILE_SERVICEBinding];
    binding.logXMLInOut = YES;
    binding.timeout = 300;
    
    PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput* request = [PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOInput new];
    request.A_DEVICE_UIDVARCHAR2IN = @"300";
    request.A_ID_PORTIONNUMBEROUT = [PI_MOBILE_SERVICEService_SequenceElement_A_ID_PORTIONNUMBEROUT6 new];
    request.AO_DATATROWARRAYCOUT = [PI_MOBILE_SERVICEService_SequenceElement_AO_DATATROWARRAYCOUT6 new];
    
    [binding.customHeaders setObject:authValue forKey:@"Authorization"];
    
    [binding WARE_BARCODE_INFOUsingWARE_BARCODE_INFOInput:request success:^(NSArray* headers,NSArray* body)
     {
         if ([body[0] isKindOfClass:[PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput class]])
         {
             PI_MOBILE_SERVICEService_ElementWARE_BARCODE_INFOOutput *output = body[0];
             PI_MOBILE_SERVICEService_TROWARRAYType* data = output.AO_DATA;
             [self updateBarcodes:data.TROWARRAY.CSV_ROWS];
             
             [self itemsDownload:delegate];
             
         }
     } error:^(NSError* error)
     {
         
     }];

}

#pragma mark Internal Metdods

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code
{
    NSManagedObjectContext *moc =self.dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"barcode == %@", code]];
    NSArray* results = [moc executeFetchRequest:request error:nil];
    
    if (results.count > 0)
    {
        Item* itemDB = results[0];
        ItemInformation* itemInfo = [ItemInformation new];
        
        itemInfo.barcode = code;
        itemInfo.name = itemDB.name;
        
        [delegate itemDescriptionComplete:0 itemDescription:itemInfo];
    }
    else
        [delegate itemDescriptionComplete:1 itemDescription:nil];
}

#pragma mark Core Data

- (void) saveItems:(NSArray*) items
{
    [self.dataController recreatePersistentStore];
    NSInteger found = 0;
    
    for (PI_MOBILE_SERVICEService_TROW_IntType *throw in items)
    {
        NSArray *csvSourse = [throw.VAL componentsSeparatedByString:@";"];
        NSArray *csv       = [self removeQuotes:csvSourse];
        Item *itemDB = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext];

        itemDB.itemID       = @([csv[1] integerValue]);
        itemDB.itemCode     = csv[1];
        itemDB.groupID      = @([csv[2] intValue]);
        itemDB.subgroupID   = @([csv[3] intValue]);
        itemDB.trademarkID  = @([csv[4] intValue]);
        itemDB.color        = csv[5];
        itemDB.certificationType    = csv[6];
        itemDB.certificationAuthorittyCode  = csv[7];
        itemDB.itemCode_2   = csv[8];
        itemDB.line1        = csv[9];
        itemDB.line2        = csv[10];
        itemDB.storeNumber  = csv[11];
        itemDB.name         = csv[12];
        itemDB.priceHeader  = csv[14];
        itemDB.sizeHeader   = csv[15];
        itemDB.size         = csv[16];
        itemDB.additionalInfo = csv[17];
        itemDB.additionalInfo = csv[18];
        

        
        NSManagedObjectContext *moc =self.dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Barcode"];
        
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", itemDB.itemID]];
        NSArray* results = [moc executeFetchRequest:request error:nil];
        
        for (Barcode *barcodeDB in results) {
            found++;
            barcodeDB.item = itemDB;
        }
        
    }
    
    NSLog(@"%ld", (long)found);
    [self.dataController.managedObjectContext save:nil];
}

- (void) updateBarcodes:(NSArray*) barcodes
{
    NSMutableArray* foundBarcodes = [NSMutableArray new];
    
    for (PI_MOBILE_SERVICEService_TROW_IntType *throw in barcodes)
    {
        NSArray *csvSourse = [throw.VAL componentsSeparatedByString:@";"];
        NSArray *csv       = [self removeQuotes:csvSourse];
        
        /*NSInteger itemId = [csv[1] integerValue];
    
        NSManagedObjectContext *moc =self.dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %d", itemId]];
        NSArray* results = [moc executeFetchRequest:request error:nil];
        Item *itemDB = nil;
        
        if (results.count > 0)
            itemDB = results[0]; */
        
        Barcode *barcodeDB = [NSEntityDescription insertNewObjectForEntityForName:@"Barcode" inManagedObjectContext:self.dataController.managedObjectContext];
        
        barcodeDB.itemID  = @([csv[1] integerValue]);
        barcodeDB.code128 = csv[2];
        barcodeDB.ean     = csv[3];
        
        NSLog(@"%d", barcodeDB.itemID.integerValue);
        
        
    }
    [self.dataController.managedObjectContext save:nil];
}

- (void) updatePrices:(NSArray*) prices
{
    
}


- (NSArray*) removeQuotes:(NSArray*) values
{
    NSMutableArray* noQuotes = [NSMutableArray new];
    
    for (int i = 0; i < values.count; ++i) {
        NSString* sourceString = values[i];
        NSString* cleanString  = [sourceString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        [noQuotes addObject:cleanString];
    }
    
    return noQuotes;
}

@end
