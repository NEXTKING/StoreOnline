//
//  MCPOfflineInmpl.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 17.05.16.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "MCPOfflineInmpl.h"
#import "NwobjItemDescription.h"
#import "NwobjInventoryItemDescription.h"
#import "ItemInformation.h"
#import "NwobjZones.h"
#import "NwobjSendCart.h"
#import "NwobjStock.h"
#import "Item.h"
#import "AdditionalParameter.h"

@interface MCPOfflineInmpl()
@property (nonatomic, strong) NSDictionary* itemsDictionary;
@property (nonatomic, strong) NSDictionary* inventoryItemsDictionary;
@end

@implementation MCPOfflineInmpl

- (id) init
{
    self = [super init];
    
    if ( self )
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
        [self settingsDidChange];
        _dataController = [CoreDataController new];
    }
    
    return self;
}

- (void) settingsDidChange
{
#ifdef DESONDO
    self.serverAddress = @"http://185.36.157.150:7755/storeService/Service1.svc/json";
#else
    NSString *protocol = [[NSUserDefaults standardUserDefaults] valueForKey:@"protocol_preference"];
    NSString *host     = [[NSUserDefaults standardUserDefaults] valueForKey:@"host_preference"];
    NSString *port     = [[NSUserDefaults standardUserDefaults] valueForKey:@"port_preference"];
    NSString *path     = [[NSUserDefaults standardUserDefaults] valueForKey:@"path_preference"];
    if (!protocol)
        protocol = @"http";
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@://%@%@",protocol, host, port.length > 0?[NSString stringWithFormat:@":%@", port]:@""];
    if (path.length > 0)
        [mutableString appendFormat:@"/%@", path];
    
    self.serverAddress = mutableString;
#endif
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode isoType:(int)type
{
    if (code)
        [self itemDescriptionOffline:delegate itemCode:code];
    else
    {
        self.itemsDictionary = nil;
        NwobjItemDescription *nwobjItemDescription = [NwobjItemDescription new];
        nwobjItemDescription.barcode = code;
        nwobjItemDescription.shopId = shopCode;
        nwobjItemDescription.delegate = delegate;
        nwobjItemDescription.completionHandler = ^(NSArray* items){
            [self saveItemsToCoreData:items];
        };
        [nwobjItemDescription run:_serverAddress];
    }
}

- (void) inventoryItemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code
{
    if (code)
        [self inventoryItemDescriptionOffline:delegate itemCode:code];
    else
    {
        NwobjInventoryItemDescription *nwobjItemDescription = [NwobjInventoryItemDescription new];
        nwobjItemDescription.barcode = code;
        nwobjItemDescription.delegate = delegate;
        [nwobjItemDescription run:_serverAddress];
    }
}

- (void) zones:(id<ZonesDelegate>)delegate shopID:(NSString *)shopID
{
    NwobjZones *nwobjSendCart = [NwobjZones new];
    nwobjSendCart.delegate = delegate;
    nwobjSendCart.shopID = shopID;
    [nwobjSendCart run:_serverAddress];
}

- (void) sendCart:(id<SendCartDelegate>)delegate cartData:(NSDictionary *)cartData
{
    NwobjSendCart *nwobjSendCart = [NwobjSendCart new];
    nwobjSendCart.delegate = delegate;
    nwobjSendCart.cartData = cartData;
    [nwobjSendCart run:_serverAddress];
}

- (void) endOfInvent:(id<SendCartDelegate>)delegate shopID:(NSString *)shopID password:(NSString *)pwd
{
    NwobjEndOfInvent* eoi = [NwobjEndOfInvent new];
    eoi.delegate = delegate;
    eoi.shopId = shopID;
    [eoi run:_serverAddress];
}

- (void) stock:(id<StockDelegate>)delegate itemCode:(NSString *)code shopID:(NSString *)shopID
{
    if (code)
        [self stockOffline:delegate itemCode:code];
    else
    {
        NwobjStock *nwobjStock = [NwobjStock new];
        nwobjStock.delegate = delegate;
        nwobjStock.shopId = shopID;
        nwobjStock.barcode = code;
        nwobjStock.completionHandler = ^(NSArray* items){
            [self saveStockToCoreData:items];
        };
        
        [nwobjStock run:_serverAddress];
    }
}

#pragma mark - Internal Methods

- (void) itemDescriptionOffline:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
       /* if (!self.itemsDictionary)
        {
            NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSString*path = [[NSString alloc] initWithFormat:@"%@/items.arch", docDir];
            self.itemsDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        } */
        
        NSManagedObjectContext *moc =_dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"barcode == %@", code]];
        NSArray* results = [moc executeFetchRequest:request error:nil];
        
        __block ItemInformation *itemInfo = nil;
        if (results.count > 0)
        {
            Item *itemDB = results[0];
            itemInfo = [ItemInformation new];
            itemInfo.name       = itemDB.name;
            itemInfo.article    = itemDB.article;
            itemInfo.barcode    = itemDB.barcode;
            itemInfo.price      = itemDB.price.doubleValue;
            itemInfo.stock      = [itemDB.stock integerValue];
            
            NSMutableArray* addParams = [NSMutableArray new];
            for (AdditionalParameter* paramDB in itemDB.additionalParams)
            {
                ParameterInformation* paramInfo = [ParameterInformation new];
                paramInfo.name = paramDB.name;
                paramInfo.value = paramDB.value;
                [addParams addObject:paramInfo];
            }
            
            itemInfo.additionalParameters = addParams;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (delegate)
            {
                if (itemInfo)
                    [delegate itemDescriptionComplete:0 itemDescription:itemInfo];
                else
                {
                    itemInfo = [ItemInformation new];
                    itemInfo.barcode = code;
                    [delegate itemDescriptionComplete:1 itemDescription:itemInfo];
                }
            }
        });
    });
}

- (void) inventoryItemDescriptionOffline:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
    
    if (!self.inventoryItemsDictionary)
    {
        NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString*path = [[NSString alloc] initWithFormat:@"%@/inventoryItems.arch", docDir];
        self.inventoryItemsDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
    ItemInformation *itemInfo = [_inventoryItemsDictionary objectForKey:code];
    if (delegate)
    {
        if (itemInfo)
            [delegate itemDescriptionComplete:0 itemDescription:itemInfo];
        else
        {
            itemInfo = [ItemInformation new];
            itemInfo.barcode = code;
            [delegate itemDescriptionComplete:1 itemDescription:itemInfo];
        }
    }
        
        });
    });
}

- (void) stockOffline:(id<StockDelegate>)delegate itemCode:(NSString *)code
{
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        /* if (!self.itemsDictionary)
         {
         NSString *docDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
         NSString*path = [[NSString alloc] initWithFormat:@"%@/items.arch", docDir];
         self.itemsDictionary = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
         } */
        
        NSMutableArray<ItemInformation*>* itemsToReturn = nil;
        
        NSManagedObjectContext *moc =_dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"barcode == %@", code]];
        NSArray* results = [moc executeFetchRequest:request error:nil];
        
        __block ItemInformation *itemInfo = nil;
        if (results.count > 0)
        {
            
            itemsToReturn = [NSMutableArray new];
            
            for (Item* itemDB in results) {
                itemInfo = [ItemInformation new];
                itemInfo.name       = itemDB.name;
                itemInfo.article    = itemDB.article;
                itemInfo.barcode    = itemDB.barcode;
                itemInfo.price      = itemDB.price.doubleValue;
                itemInfo.stock      = [itemDB.stock integerValue];
                
                NSMutableArray* addParams = [NSMutableArray new];
                for (AdditionalParameter* paramDB in itemDB.additionalParams)
                {
                    ParameterInformation* paramInfo = [ParameterInformation new];
                    paramInfo.name = paramDB.name;
                    paramInfo.value = paramDB.value;
                    [addParams addObject:paramInfo];
                }
                
                itemInfo.additionalParameters = addParams;
                [itemsToReturn addObject:itemInfo];
            }
            
        
        }
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            if (delegate)
            {
                if (itemInfo)
                    [delegate stockComplete:0 items:itemsToReturn];
                else
                {
                    //itemInfo = [ItemInformation new];
                    //itemInfo.barcode = code;
                    [delegate stockComplete:1 items:nil];
                }
            }
        });
    });

}

#pragma mark Saving methods

- (void) saveItemsToCoreData:(NSArray*) items
{
    [self deleteOldObjects];
    
    for (ItemInformation* currentItem in items) {
        Item *itemDB = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_dataController.managedObjectContext];
        
        itemDB.name     = currentItem.name;
        itemDB.article  = currentItem.article;
        itemDB.price    = [NSNumber numberWithDouble:currentItem.price];
        itemDB.itemId   = [NSNumber numberWithInteger:currentItem.itemId];
        itemDB.barcode  = currentItem.barcode;
        itemDB.stock    = @(currentItem.stock);
        [itemDB setAdditionalParameters:currentItem.additionalParameters];
        
    }
    
    [_dataController.managedObjectContext save:nil];
    
}

- (void) saveStockToCoreData:(NSArray*)items
{
    for (ItemInformation* currentItem in items) {
        NSManagedObjectContext *moc =_dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"barcode == %@", currentItem.barcode]];
        NSArray* results = [moc executeFetchRequest:request error:nil];
        
        if (results.count < 1)
            continue;
        
        Item* itemDB = results[0];
        itemDB.stock = @(currentItem.stock);
    }
    
    [_dataController.managedObjectContext save:nil];
}

- (void) deleteOldObjects
{
    
    [_dataController recreatePersistentStore];
    
    NSLog(@"Done");
    
}

@end
