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
#import "NwobjAcceptanes.h"
#import "NwobjSendAcceptanes.h"
#import "Item.h"
#import "AdditionalParameter.h"
#import "AcceptItem+CoreDataClass.h"

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

- (void) acceptanes:(id<AcceptanesDelegate>)delegate shopID:(NSString*)shopID
{
    if (shopID)
    {
        NwobjAcceptanes *nwobjAcceptanes = [NwobjAcceptanes new];
        nwobjAcceptanes.delegate = delegate;
        nwobjAcceptanes.shopId = shopID;
        nwobjAcceptanes.completionHandler = ^(NSArray* items){
            [self saveAcceptanesToCoreData:items];
        };
        
        [nwobjAcceptanes run:_serverAddress];
    }
    else
    {
        [self acceptanesOffline:delegate];
    }
}

- (void)acceptanes:(id<AcceptanesDelegate>)delegate date:(NSDate*)date containerBarcode:(NSString*)containerBarcode
{
    NSManagedObjectContext *moc =_dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AcceptItem"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ AND containerBarcode == %@", date, containerBarcode]];
    NSArray* results = [moc executeFetchRequest:request error:nil];
    
    if (results.count < 1)
    {
        [delegate acceptanesComplete:1 items:nil];
        return;
    }
    
    NSMutableArray *itemsToReturn = [[NSMutableArray alloc] initWithCapacity:results.count];
    for (AcceptItem *acceptItemDB in results)
    {
        AcceptanesInformation *acceptInfo = [[AcceptanesInformation alloc] init];
        acceptInfo.barcode = acceptItemDB.barcode;
        acceptInfo.containerBarcode = acceptItemDB.containerBarcode;
        acceptInfo.quantity = acceptItemDB.quantity;
        acceptInfo.scanned = acceptItemDB.scanned;
        acceptInfo.date = acceptItemDB.date;
        acceptInfo.manually = acceptItemDB.manually.boolValue;
        
        acceptInfo.isComplete = acceptItemDB.isComplete.boolValue;
        acceptInfo.ID = acceptItemDB.iD;
        acceptInfo.shopName = acceptItemDB.shopName;
        
        if ([acceptItemDB.type isEqualToString:@"B"])
            acceptInfo.type = AcceptanesInformationItemTypeBox;
        else if ([acceptItemDB.type isEqualToString:@"S"])
            acceptInfo.type = AcceptanesInformationItemTypeSet;
        else
            acceptInfo.type = AcceptanesInformationItemTypeItem;
        
        if (acceptInfo.type == AcceptanesInformationItemTypeItem)
        {
            NSManagedObjectContext *moc =_dataController.managedObjectContext;
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"barcode == %@", acceptItemDB.barcode]];
            NSArray* results = [moc executeFetchRequest:request error:nil];
            
            ItemInformation *itemInfo = nil;
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
            acceptInfo.itemInformation = itemInfo;
        }
        [itemsToReturn addObject:acceptInfo];
    }
    
    NSSortDescriptor *sorter = [[NSSortDescriptor alloc] initWithKey:@"type" ascending:YES];
    [itemsToReturn sortUsingDescriptors:@[sorter]];
    [delegate acceptanesComplete:0 items:itemsToReturn];
}

- (void) addItem:(ItemInformation*)item toAcceptionWithDate:(NSDate*)date containerBarcode:(NSString*)containerBarcode scannedCount:(NSUInteger)scannedCount manually:(BOOL)manually;
{
    NSManagedObjectContext *moc =_dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AcceptItem"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ AND barcode == %@ AND containerBarcode == %@", date, item.barcode, containerBarcode]];
    NSArray* results = [moc executeFetchRequest:request error:nil];
    
    if (results.count < 1)
    {
        AcceptItem *acceptItemDB = [NSEntityDescription insertNewObjectForEntityForName:@"AcceptItem" inManagedObjectContext:_dataController.managedObjectContext];
        
        acceptItemDB.barcode = item.barcode;
        acceptItemDB.containerBarcode = containerBarcode;
        acceptItemDB.type = @"";
        acceptItemDB.date = date;
        acceptItemDB.quantity = @(0);
        acceptItemDB.scanned = @(scannedCount);
        acceptItemDB.manually = @(manually);
        #warning need to rewrite
        acceptItemDB.shopName = [[NSUserDefaults standardUserDefaults] valueForKey:@"shopID"];
    }
    else
    {
        AcceptItem *acceptItemDB = results[0];
        acceptItemDB.scanned = @(scannedCount);
        acceptItemDB.manually = @(manually);
    }
    
    [moc save:nil];
}

- (void) acceptanesHierarchy:(id<AcceptanesDelegate>)delegate date:(NSDate*)date barcode:(NSString*)barcode
{
    NSManagedObjectContext *moc =_dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AcceptItem"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ AND barcode == %@ AND type == %@", date, barcode, @"B"]];
    
    AcceptanesInformation* (^generateAcceptInfo)(AcceptItem *item) = ^(AcceptItem *acceptItemDB)
    {
        AcceptanesInformation *acceptInfo = [[AcceptanesInformation alloc] init];
        acceptInfo.barcode = acceptItemDB.barcode;
        acceptInfo.containerBarcode = acceptItemDB.containerBarcode;
        acceptInfo.quantity = acceptItemDB.quantity;
        acceptInfo.scanned = acceptItemDB.scanned;
        acceptInfo.date = acceptItemDB.date;
        acceptInfo.manually = acceptItemDB.manually.boolValue;
        
        acceptInfo.isComplete = acceptItemDB.isComplete.boolValue;
        acceptInfo.ID = acceptItemDB.iD;
        acceptInfo.shopName = acceptItemDB.shopName;
        
        if ([acceptItemDB.type isEqualToString:@"B"])
            acceptInfo.type = AcceptanesInformationItemTypeBox;
        else if ([acceptItemDB.type isEqualToString:@"S"])
            acceptInfo.type = AcceptanesInformationItemTypeSet;
        else
            acceptInfo.type = AcceptanesInformationItemTypeItem;
        
        return acceptInfo;
    };
    
    NSMutableArray *hierarchy = [NSMutableArray new];
    NSArray* results = [moc executeFetchRequest:request error:nil];
    while (results.count > 0)
    {
        AcceptItem *acceptItemDB = results[0];
        AcceptanesInformation *acceptInfo = generateAcceptInfo(acceptItemDB);
        [hierarchy insertObject:acceptInfo atIndex:0];
        
        if (acceptInfo.containerBarcode)
        {
            [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ AND barcode == %@", date, acceptInfo.containerBarcode]];
            results = [moc executeFetchRequest:request error:nil];
        }
        else
            break;
    }
    
    if (hierarchy.count > 0)
        [delegate acceptanesHierarchyComplete:0 items:hierarchy];
    else
        [delegate acceptanesHierarchyComplete:1 items:nil];
}

- (void) sendAcceptanes:(id<AcceptanesDelegate>)delegate date:(NSDate *)date shopID:(NSString *)shopID
{
    NSManagedObjectContext *moc =_dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AcceptItem"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"date == %@ AND type == %@", date, @""]];
    NSArray* results = [moc executeFetchRequest:request error:nil];
    
    if (results.count < 1)
    {
        if ([delegate respondsToSelector:@selector(sendAcceptanesComplete:)])
            [delegate sendAcceptanesComplete:1];
        
        return;
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    [dateFormatter setLocale:enUSPOSIXLocale];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZZZ"];
    
    NSMutableArray *acceptanes = [NSMutableArray new];
    for (AcceptItem *acceptItemDB in results)
    {
        NSMutableDictionary *itemDictionary = [NSMutableDictionary new];
        itemDictionary[@"ContainerBarCode"] = acceptItemDB.containerBarcode ? acceptItemDB.containerBarcode : [NSNull null];
        itemDictionary[@"DateOfOperation"] = [dateFormatter stringFromDate:acceptItemDB.date];
        itemDictionary[@"IsScannedByHand"] = acceptItemDB.manually;
        itemDictionary[@"ItemBarCode"] = acceptItemDB.barcode;
        itemDictionary[@"QuantityCount"] = acceptItemDB.quantity;
        itemDictionary[@"QuantityScanned"] = acceptItemDB.scanned;
        itemDictionary[@"ShopName"] = acceptItemDB.shopName;
        itemDictionary[@"TypeOfPacage"] = acceptItemDB.type;
        itemDictionary[@"isComplete"] = acceptItemDB.isComplete;
        
        if (acceptItemDB.iD.integerValue > 0)
            itemDictionary[@"ID"] = acceptItemDB.iD;
        
        [acceptanes addObject:itemDictionary];
    }
    
    NwobjSendAcceptanes *nwobjSendAcceptanes = [NwobjSendAcceptanes new];
    nwobjSendAcceptanes.delegate = delegate;
    nwobjSendAcceptanes.acceptanesData = @{@"All_AcceptanceS":acceptanes};
    nwobjSendAcceptanes.shopId = shopID;
    [nwobjSendAcceptanes run:_serverAddress];
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

- (void)acceptanesOffline:(id<AcceptanesDelegate>)delegate
{
    NSManagedObjectContext *moc =_dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"AcceptItem"];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"AcceptItem" inManagedObjectContext:moc];
    
    // Unless you set the resultType to NSDictionaryResultType, distinct can't work.
    request.resultType = NSDictionaryResultType;
    request.propertiesToFetch = [NSArray arrayWithObject:[[entity propertiesByName] objectForKey:@"date"]];
    request.returnsDistinctResults = YES;
    
    NSError *error = nil;
    NSArray *dictionaries = [moc executeFetchRequest:request error:&error];
    NSMutableArray *dates = [NSMutableArray new];
    
    for (NSDictionary *dic in dictionaries)
        [dates addObject:dic[@"date"]];
    
    if (!error)
        [delegate acceptanesComplete:0 items:dates];
    else
        [delegate acceptanesComplete:1 items:nil];
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

- (void) saveAcceptanesToCoreData:(NSArray *)items
{
    for (AcceptanesInformation *acceptInfo in items)
    {
        AcceptItem *acceptItemDB = [NSEntityDescription insertNewObjectForEntityForName:@"AcceptItem" inManagedObjectContext:_dataController.managedObjectContext];
        
        acceptItemDB.barcode = acceptInfo.barcode;
        acceptItemDB.containerBarcode = acceptInfo.containerBarcode;
        acceptItemDB.type = acceptInfo.type == AcceptanesInformationItemTypeBox ? @"B" : (acceptInfo.type == AcceptanesInformationItemTypeSet ? @"S" : @"");
        acceptItemDB.date = acceptInfo.date;
        acceptItemDB.quantity = acceptInfo.quantity;
        acceptItemDB.scanned = acceptInfo.scanned;
        acceptItemDB.manually = @(acceptInfo.manually);
        
        acceptItemDB.isComplete = @(acceptInfo.isComplete);
        acceptItemDB.iD = acceptInfo.ID;
        acceptItemDB.shopName = acceptInfo.shopName;
        
        #warning need to remove
        if (acceptInfo.type == AcceptanesInformationItemTypeItem)
        {
            Item *item = [NSEntityDescription insertNewObjectForEntityForName:@"Item" inManagedObjectContext:_dataController.managedObjectContext];
            item.name = @"Товар";
            item.barcode = acceptInfo.barcode;
        }
    }
    
    [_dataController.managedObjectContext save:nil];
}

- (void) deleteOldObjects
{
    
    [_dataController recreatePersistentStore];
    
    NSLog(@"Done");
    
}

@end
