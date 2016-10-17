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
#import "TaskInformation.h"
#import "Item+CoreDataClass.h"
#import "Price+CoreDataProperties.h"
#import "Barcode+CoreDataClass.h"
#import "Price+CoreDataClass.h"
#import "Task+CoreDataClass.h"
#import "SOAPWares.h"
#import "SOAPBarcodes.h"
#import "SOAPPrices.h"
#import "SOAPTasks.h"
#import "DTDevices.h"

@interface MCPOfflineInmpl_Ostin ()
{
    NSString* authValue;
    NSString* deviceID;
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
        
        deviceID = @"302";
        //990023135202
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
        [self tasksInternal:delegate userID:userID];
    }
    else
    {
        NSOperationQueue *waresQueue = [NSOperationQueue new];
        waresQueue.name = @"tasksQueue";
        
        SOAPTasks *tasks = [SOAPTasks new];
        __weak SOAPTasks* _tasks = tasks;
        tasks.dataController = self.dataController;
        tasks.authValue = authValue;
        tasks.deviceID  = deviceID;
        
        NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            BOOL success = _tasks.success;
    
            if (success)
                [delegate tasksComplete:0 tasks:nil];
            else
                [delegate tasksComplete:1 tasks:nil];
            
        }];
        
        [delegateCallOperation addDependency:tasks];
        
        [waresQueue addOperations:@[tasks] waitUntilFinished:NO];
        [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
    }
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
            //[additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"price" value:[NSString stringWithFormat:@"%f", item.price.retailPrice]]];

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

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode isoType:(int)type
{
    if (code)
    {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Price" inManagedObjectContext:self.dataController.managedObjectContext]];
        
        [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
        
        NSError *err;
        NSUInteger priceCount = [self.dataController.managedObjectContext countForFetchRequest:request error:&err];
         [request setEntity:[NSEntityDescription entityForName:@"Barcode" inManagedObjectContext:self.dataController.managedObjectContext]];
        NSUInteger barcodeCount = [self.dataController.managedObjectContext countForFetchRequest:request error:&err];
        [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext]];
        NSUInteger itemCount = [self.dataController.managedObjectContext countForFetchRequest:request error:&err];
        
        NSLog(@"%lu, %lu, %lu", (unsigned long)priceCount, (unsigned long)barcodeCount, (unsigned long)itemCount);
        
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
        wares.deviceID  = deviceID;
        
        SOAPBarcodes *barcodes = [SOAPBarcodes new];
        __weak SOAPBarcodes* _barcodes = barcodes;
        barcodes.dataController = self.dataController;
        barcodes.authValue = authValue;
        barcodes.deviceID  = deviceID;
        
        SOAPPrices *prices     = [SOAPPrices new];
        __weak SOAPPrices* _prices = prices;
        prices.dataController = self.dataController;
        prices.authValue      = authValue;
        prices.deviceID       = deviceID;
        
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

- (void) tasksInternal:(id<TasksDelegate>)delegate userID:(NSNumber*)userID
{
    NSManagedObjectContext *moc =self.dataController.managedObjectContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    
    NSError* error = nil;
    NSArray* results = [moc executeFetchRequest:request error:&error];
    NSMutableArray *exportTasks = [NSMutableArray new];
    
    for (Task* taskDB in results)
    {
        TaskInformation* taskInfo = [TaskInformation new];
        taskInfo.name = taskDB.name;
        taskInfo.userID = taskDB.userID.integerValue;
        taskInfo.taskID = taskDB.taskID.integerValue;
    }
    
    if (!error)
        [delegate tasksComplete:0 tasks:exportTasks];
    else
        [delegate tasksComplete:1 tasks:nil];
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code isoType:(int) type
{
    NSManagedObjectContext *moc =self.dataController.managedObjectContext;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Barcode" inManagedObjectContext:self.dataController.managedObjectContext]];
    
    [request setIncludesSubentities:NO];
    
    type = BAR_UPC;
    
    if (type == BAR_CODE128)
        [request setPredicate:[NSPredicate predicateWithFormat:@"code128 LIKE[c] %@", code]];
    else if (type == BAR_UPC)
    {
        
        NSString *string = [NSString stringWithFormat:@"0%@", code];
        
        if ([string hasPrefix:@"09900"])
        {
            NSString* substring     = [string substringFromIndex:5];
            NSString* substring1    = [substring substringToIndex:substring.length-1];
            [request setPredicate:[NSPredicate predicateWithFormat:@"code128 LIKE[c] %@", substring1]];
        }
        else
        {
            NSString* substring = [string substringToIndex:11];
            [request setPredicate:[NSPredicate predicateWithFormat:@"ean LIKE[c] %@", substring]];
        }
        
        
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
    request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext]];
    
    [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", barcodeDB.itemID]];
    results = [moc executeFetchRequest:request error:nil];
    
    if (results.count < 1)
    {
        [delegate itemDescriptionComplete:1 itemDescription:nil];
        return;
    }
    
    
    Item *itemDB = results[0];
    [request setEntity:[NSEntityDescription entityForName:@"Price" inManagedObjectContext:self.dataController.managedObjectContext]];
    
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
