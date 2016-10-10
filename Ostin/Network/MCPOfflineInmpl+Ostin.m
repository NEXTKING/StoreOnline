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
#import "Barcode+CoreDataClass.h"
#import "Price+CoreDataClass.h"
#import "SOAPWares.h"
#import "SOAPBarcodes.h"
#import "SOAPPrices.h"
#import "DTDevices.h"

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

- (void) tasks:(id<TasksDelegate>)delegate userID:(NSNumber *)userID
{
    if (userID)
    {
        
    }
    else
    {
        
    }
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode isoType:(int)type
{
    if (code)
    {
        [self itemDescription:delegate itemCode:code isoType:type];
    }
    else
    {
        
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Barcode" inManagedObjectContext:self.dataController.managedObjectContext]];
        [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
        
        NSArray* barcodesq = [self.dataController.managedObjectContext executeFetchRequest:request error:nil];
        
        [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext]];
        NSArray* itemsq = [self.dataController.managedObjectContext executeFetchRequest:request error:nil];
        
        
       /* NSInteger count = 0;
        for (Barcode *barcode in barcodesq) {
            for (Item *item in itemsq) {
                if (item.itemID.integerValue == barcode.itemID.integerValue)
                {
                    NSLog(@"%@", barcode.code128);
                    count++;
                }
            }
        }*/
       
        NSOperationQueue *waresQueue = [NSOperationQueue new];
        NSDate *startDate = [NSDate date];
        waresQueue.name = @"waresQueue";
    
        SOAPWares *wares = [SOAPWares new];
        __weak SOAPWares* _wares = wares;
        wares.dataController = self.dataController;
        wares.authValue = authValue;
        
        SOAPBarcodes *barcodes = [SOAPBarcodes new];
        __weak SOAPBarcodes* _barcodes = barcodes;
        barcodes.dataController = self.dataController;
        barcodes.authValue = authValue;
        
        SOAPPrices *prices     = [SOAPPrices new];
        __weak SOAPPrices* _prices = prices;
        prices.dataController = self.dataController;
        prices.authValue      = authValue;
        
        NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            BOOL success = _wares.success && _barcodes.success && _prices.success;
            NSDate *endDate = [NSDate date];
            NSLog(@"%f s", [endDate timeIntervalSince1970] - [startDate timeIntervalSince1970]);
            
            if (success)
                [delegate allItemsDescription:0 items:nil];
            else
                [delegate allItemsDescription:1 items:nil];
            
        }];
        
        [delegateCallOperation addDependency:wares];
        [delegateCallOperation addDependency:barcodes];
        [delegateCallOperation addDependency:prices];
        
        [waresQueue addOperations:@[wares,barcodes, prices] waitUntilFinished:NO];
        [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
        
      
    }
}

- (void) itemBarcodes:(id<ItemDescriptionDelegate>)delegate
{
    
}


#pragma mark Internal Metdods

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code isoType:(int) type
{
    NSManagedObjectContext *moc =self.dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Barcode"];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Offline barcode" message:[NSString stringWithFormat:@"%@", code] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
    
    type = BAR_UPC;
    
    if (type == BAR_CODE128)
        [request setPredicate:[NSPredicate predicateWithFormat:@"code128 LIKE[c] %@", code]];
    else if (type == BAR_UPC)
    {
        NSString *string = [NSString stringWithFormat:@"0%@", code];
        [request setPredicate:[NSPredicate predicateWithFormat:@"ean LIKE[c] %@", string]];
    }
    else
        [request setPredicate:[NSPredicate predicateWithFormat:@"ean == %@", code]];
    
    
    NSArray* results = [moc executeFetchRequest:request error:nil];
    
    
    if (results.count < 1)
    {
        [delegate itemDescriptionComplete:1 itemDescription:nil];
        return;
    }
    
    
    Barcode *barcodeDB = results[0];
    request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", barcodeDB.itemID]];
    results = [moc executeFetchRequest:request error:nil];
    
    if (results.count < 1)
    {
        [delegate itemDescriptionComplete:1 itemDescription:nil];
        return;
    }
    
    
    Item *itemDB = results[0];
    request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", barcodeDB.itemID]];
    results = [moc executeFetchRequest:request error:nil];
    
    if (results.count < 1)
    {
        [delegate itemDescriptionComplete:1 itemDescription:nil];
        return;
    }
    
    Price *priceDB = results[0];
    
    ItemInformation* item = [ItemInformation new];
    item.barcode    = code;
    item.name       = itemDB.name;
    item.article    = itemDB.itemCode;
    item.price      = priceDB.catalogPrice.doubleValue;
    
    [delegate itemDescriptionComplete:0 itemDescription:item];
}

#pragma mark Core Data


@end
