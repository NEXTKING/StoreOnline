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
#import "UserInformation.h"
#import "Item+CoreDataClass.h"
#import "Price+CoreDataProperties.h"
#import "Barcode+CoreDataClass.h"
#import "Price+CoreDataClass.h"
#import "Task+CoreDataClass.h"
#import "TaskItemBinding+CoreDataClass.h"
#import "User+CoreDataClass.h"
#import "Image+CoreDataClass.h"
#import "Group+CoreDataClass.h"
#import "Subgroup+CoreDataClass.h"
#import "SOAPWares.h"
#import "SOAPBarcodes.h"
#import "SOAPPrices.h"
#import "SOAPTasks.h"
#import "SOAPTaskWareBinding.h"
#import "SOAPSavePrintFact.h"
#import "SOAPSetTaskDone.h"
#import "SOAPUsers.h"
#import "DTDevices.h"
#import <CommonCrypto/CommonDigest.h>

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
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *authUser = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_user_preference"];
        NSString *authPassword = [[NSUserDefaults standardUserDefaults] valueForKey:@"auth_password_preference"];
        if (authUser != nil && authPassword != nil)
        {
            NSString *authStr = [NSString stringWithFormat:@"%@:%@", authUser, authPassword];
            NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
            
            authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodingWithLineLength:80]];
        }
        
        deviceID = @"305";
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

- (void) user:(id<UserDelegate>)delegate login:(NSString *)login password:(NSString *)password
{
    if (login != nil && password != nil)
    {
        NSString* (^md5)(NSString *) = ^(NSString *string) {
            
            const char * pointer = [string UTF8String];
            unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
            CC_MD5(pointer, (CC_LONG)strlen(pointer), md5Buffer);
            
            NSMutableString *hashString = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
            for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
                [hashString appendFormat:@"%02x",md5Buffer[i]];
            
            return hashString;
        };
        
        NSManagedObjectContext *moc = self.dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"login ==[c] %@ AND password ==[c] %@", login, md5(password)]];
        NSArray *results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            [delegate userComplete:1 user:nil];
            return;
        }
        User *userDB = results[0];
        
        UserInformation *userInfo = [UserInformation new];
        userInfo.key_user = userDB.key_user;
        userInfo.barcode = userDB.barcode;
        userInfo.login = userDB.login;
        userInfo.password = userDB.password;
        userInfo.name = userDB.name;
        
        [delegate userComplete:0 user:userInfo];
    }
    else
    {
        NSOperationQueue *usersQueue = [NSOperationQueue new];
        usersQueue.name = @"usersQueue";
        
        SOAPUsers *users = [SOAPUsers new];
        __weak SOAPUsers* _users = users;
        users.dataController = self.dataController;
        users.authValue = authValue;
        users.deviceID = deviceID;
        
        NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            BOOL success = _users.success;
            
            if (success)
                [delegate userComplete:0 user:nil];
            else
                [delegate userComplete:1 user:nil];
            
        }];
        
        [delegateCallOperation addDependency:users];
        
        [usersQueue addOperations:@[users] waitUntilFinished:NO];
        [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
    }
}

- (void) user:(id<UserDelegate>)delegate barcode:(NSString *)barcode
{
    NSManagedObjectContext *moc = self.dataController.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"barcode == %@", barcode]];
    NSArray *results = [moc executeFetchRequest:request error:nil];
    if (results.count < 1)
    {
        [delegate userComplete:1 user:nil];
        return;
    }
    User *userDB = results[0];
    
    UserInformation *userInfo = [UserInformation new];
    userInfo.key_user = userDB.key_user;
    userInfo.barcode = userDB.barcode;
    userInfo.login = userDB.login;
    userInfo.password = userDB.password;
    userInfo.name = userDB.name;
    
    [delegate userComplete:0 user:userInfo];
}

- (void) tasks:(id<TasksDelegate>)delegate userID:(NSString *)userID
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
        
        SOAPTaskWareBinding *taskWareBinding = [SOAPTaskWareBinding new];
        __weak SOAPTaskWareBinding* _taskWareBinding = taskWareBinding;
        taskWareBinding.dataController = self.dataController;
        taskWareBinding.authValue = authValue;
        taskWareBinding.deviceID  = deviceID;
        
        NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            BOOL success = _tasks.success && _taskWareBinding.success;
    
            if (success)
                [delegate tasksComplete:0 tasks:nil];
            else
                [delegate tasksComplete:1 tasks:nil];
            
        }];
        
        [delegateCallOperation addDependency:tasks];
        [delegateCallOperation addDependency:taskWareBinding];
        
        [waresQueue addOperations:@[tasks, taskWareBinding] waitUntilFinished:NO];
        [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
    }
}

- (void) tasks:(id<TasksDelegate>)delegate taskID:(NSNumber *)taskID
{
    NSManagedObjectContext *moc =self.dataController.managedObjectContext;
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TaskItemBinding" inManagedObjectContext:self.dataController.managedObjectContext]];
    
    [request setIncludesSubentities:NO];
    [request setPredicate:[NSPredicate predicateWithFormat:@"taskID == %ld", [taskID integerValue]]];
    
    NSError* error = nil;
    NSArray* results = [moc executeFetchRequest:request error:&error];
    
    NSMutableArray* predicates = [NSMutableArray new];
    
    
    for (TaskItemBinding* binding in results) {
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"itemID == %ld", [binding.itemID integerValue]];
        [predicates addObject:predicate];
    }
    
    NSPredicate *itemsPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    
    NSFetchRequest *itemsRequest = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"TaskItemBinding" inManagedObjectContext:self.dataController.managedObjectContext]];
    
    /*for (Task* taskDB in results)
    {
        TaskInformation* taskInfo = [TaskInformation new];
        taskInfo.name = taskDB.name;
        taskInfo.userID = taskDB.userID.integerValue;
        taskInfo.taskID = taskDB.taskID.integerValue;
        taskInfo.status = (taskDB.startDate != nil && taskDB.endDate != nil) ? TaskInformationStatusComplete : taskDB.startDate != nil ? TaskInformationStatusInProgress : TaskInformationStatusNotStarted;
        [exportTasks addObject:taskInfo];
    }
    
    if (!error)
        [delegate tasksComplete:0 tasks:exportTasks];
    else
        [delegate tasksComplete:1 tasks:nil];*/
}

- (void)saveTaskWithID:(NSInteger)taskID userID:(NSString *)userID status:(NSInteger)status date:(NSDate *)date completion:(void (^)(BOOL success, NSString *errorMessage))completion
{
    NSManagedObjectContext *moc = self.dataController.managedObjectContext;

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"taskID == %ld AND userID == %@", taskID, userID]];
    NSArray *results = [moc executeFetchRequest:request error:nil];
    if (results.count < 1)
    {
        completion(NO, nil);
        return;
    }
    Task *taskDB = results[0];
    
    if (status == TaskInformationStatusInProgress && taskDB.startDate == nil)
    {
        taskDB.startDate = date;
        [moc save:nil];
        completion(YES, nil);
    }
    else if (status == TaskInformationStatusComplete && taskDB.endDate == nil)
    {
        NSFetchRequest *taskItemRequest = [NSFetchRequest fetchRequestWithEntityName:@"TaskItemBinding"];
        [taskItemRequest setPredicate:[NSPredicate predicateWithFormat:@"taskID == %ld", taskDB.taskID.integerValue]];
        NSArray *results = [moc executeFetchRequest:taskItemRequest error:nil];
        NSArray *scannedResults = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"scanned > 0"]];
        
        NSMutableArray *wareCodes = [[NSMutableArray alloc] init];
        for (TaskItemBinding *taskItemDB in scannedResults)
        {
            NSFetchRequest *itemRequest = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
            [itemRequest setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", taskItemDB.itemID.integerValue]];
            NSArray *itemResults = [moc executeFetchRequest:itemRequest error:nil];
            if (itemResults.count > 0)
            {
                Item *item = itemResults[0];
                for (int i = 0; i<taskItemDB.scanned.integerValue; i++)
                    [wareCodes addObject:item.itemCode];
            }
        }
        
        NSOperationQueue *setTaskDoneQueue = [NSOperationQueue new];
        setTaskDoneQueue.name = @"setTaskDoneQueue";
        
        SOAPSavePrintFact *savePrintFact = [SOAPSavePrintFact new];
        __weak SOAPSavePrintFact *_savePrintFact = savePrintFact;
        savePrintFact.taskName = taskDB.name;
        savePrintFact.taskType = @"pasting";
        savePrintFact.wareCodes = wareCodes;
        savePrintFact.authValue = authValue;
        savePrintFact.deviceID  = deviceID;
        savePrintFact.userID = userID;
        
        SOAPSetTaskDone *setTaskDone = [SOAPSetTaskDone new];
        __weak SOAPSetTaskDone *_setTaskDone = setTaskDone;
        setTaskDone.taskName = taskDB.name;
        setTaskDone.taskType = @"pasting";
        setTaskDone.authValue = authValue;
        setTaskDone.deviceID  = deviceID;
        
        NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
            
            NSManagedObjectContext *privateManagedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
            [privateManagedObjectContext setParentContext:moc];
            Task *_taskDB = [privateManagedObjectContext objectWithID:taskDB.objectID];
            
            if (!_savePrintFact.success)
            {
                completion(NO, _savePrintFact.errorMessage);
            }
            else if (!_setTaskDone.success)
            {
                completion(NO, _setTaskDone.errorMessage);
            }
            else
            {
                _taskDB.endDate = date;
                [privateManagedObjectContext save:nil];
                completion(YES, nil);
            }
        }];
        
        [setTaskDone addDependency:savePrintFact];
        [delegateCallOperation addDependency:setTaskDone];
        [setTaskDoneQueue addOperations:@[savePrintFact, setTaskDone] waitUntilFinished:NO];
        [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
    }
}

- (void) saveTaskItem:(id<TasksDelegate>) delegate taskID:(NSInteger)taskID itemID:(NSInteger)itemID scanned:(NSUInteger)scanned
{
    NSManagedObjectContext *moc = self.dataController.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"TaskItemBinding"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"taskID == %ld AND itemID == %ld", taskID, itemID]];
    NSArray *results = [moc executeFetchRequest:request error:nil];
    if (results.count < 1)
    {
        return;
    }
    TaskItemBinding *taskItemDB = results[0];
    
    if (taskItemDB.scanned.integerValue != scanned)
    {
        taskItemDB.scanned = [NSNumber numberWithInteger:scanned];
        [moc save:nil];
    }
}

- (void) search:(id<SearchDelegate>)delegate forQuery:(NSString *)query withAttribute:(ItemSearchAttribute)searchAttribute
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        void (^returnBlock)(int result, ItemSearchAttribute searchAttribute, NSArray *items) = ^void(int result, ItemSearchAttribute attribute, NSArray *items)
        {
            if ([delegate respondsToSelector:@selector(searchComplete:attribute:items:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate searchComplete:result attribute:attribute items:items];
                });
            }
        };
        
        if ([query stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) // empty query
        {
            returnBlock(1, searchAttribute, nil);
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
            NSPredicate *articlePredicate = [NSPredicate predicateWithFormat:@"itemCode_2 ==[c] %@", query];
            [searchPredicates addObject:articlePredicate];
        }
        
        if ((searchAttribute & ItemSearchAttributeBarcode) != 0)
        {
            NSPredicate *barcodePredicate = [NSPredicate predicateWithFormat:@"barcode ==[c] %@", query];
            [searchPredicates addObject:barcodePredicate];
        }
        
        if ((searchAttribute & ItemSearchAttributeItemCode) != 0)
        {
            NSPredicate *itemCodePredicate = [NSPredicate predicateWithFormat:@"itemCode ==[c] %@", query];
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
                [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"imageURL" value:[self imageURLForItemID:item.itemID.integerValue]]];
                
                // itemInformation.price =
                // itemInformation.barcode =
                itemInformation.color = item.color;
                itemInformation.itemId = item.itemID.integerValue;
                itemInformation.name = item.name;
                itemInformation.additionalParameters = additionalParameters;
                
                [items addObject:itemInformation];
            }
            returnBlock(0, searchAttribute, items);
        }
        else
            returnBlock(0, searchAttribute, nil);
    });
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

- (void) tasksInternal:(id<TasksDelegate>)delegate userID:(NSString *)userID
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSManagedObjectContext *moc =self.dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"userID == %@", userID]];
        
        NSError* error = nil;
        NSArray* results = [moc executeFetchRequest:request error:&error];
        NSMutableArray *exportTasks = [NSMutableArray new];
        
        for (Task* taskDB in results)
        {
            TaskInformation* taskInfo = [TaskInformation new];
            taskInfo.name = taskDB.name;
            taskInfo.userID = taskDB.userID;
            taskInfo.taskID = taskDB.taskID.integerValue;
            taskInfo.startDate = taskDB.startDate;
            taskInfo.endDate = taskDB.endDate;
            taskInfo.status = (taskDB.startDate != nil && taskDB.endDate != nil) ? TaskInformationStatusComplete : taskDB.startDate != nil ? TaskInformationStatusInProgress : TaskInformationStatusNotStarted;
            
            NSFetchRequest *taskItemRequest = [NSFetchRequest fetchRequestWithEntityName:@"TaskItemBinding"];
            [taskItemRequest setPredicate:[NSPredicate predicateWithFormat:@"taskID == %ld", taskDB.taskID.integerValue]];
            NSArray *results = [moc executeFetchRequest:taskItemRequest error:nil];
            NSMutableArray *taskItems = [[NSMutableArray alloc] initWithCapacity:results.count + 1];
            for (TaskItemBinding *taskItemDB in results)
            {
                TaskItemInformation *taskItemInfo = [TaskItemInformation new];
                taskItemInfo.itemID = taskItemDB.itemID.integerValue;
                taskItemInfo.scanned = taskItemDB.scanned.integerValue;
                taskItemInfo.quantity = taskItemDB.quantity.integerValue;
                [taskItems addObject:taskItemInfo];
            }
            taskInfo.items = taskItems;
            [exportTasks addObject:taskInfo];
        }
        
        if ([delegate respondsToSelector:@selector(tasksComplete:tasks:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (!error)
                    [delegate tasksComplete:0 tasks:exportTasks];
                else
                    [delegate tasksComplete:1 tasks:nil];
            });
        }
    });
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code isoType:(int) type
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        void (^returnBlock)(int result, ItemInformation *item) = ^void(int result, ItemInformation *item)
        {
            if ([delegate respondsToSelector:@selector(itemDescriptionComplete:itemDescription:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate itemDescriptionComplete:result itemDescription:item];
                });
            }
        };
        
        NSManagedObjectContext *moc =self.dataController.managedObjectContext;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Barcode" inManagedObjectContext:self.dataController.managedObjectContext]];
        [request setIncludesSubentities:NO];

        if (type == BAR_CODE128)
            [request setPredicate:[NSPredicate predicateWithFormat:@"code128 LIKE[c] %@", code]];
        else if (type == BAR_UPC)
            [request setPredicate:[NSPredicate predicateWithFormat:@"code128 LIKE[c] %@", code]];
        else
            [request setPredicate:[NSPredicate predicateWithFormat:@"ean LIKE[c] %@", code]];
        
        
        NSArray* results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1 && type != BAR_CODE128 && type !=BAR_UPC && code.length > 8)
        {
            NSString *codeWithoutChecksum = [code substringToIndex:code.length - 1];
            [request setPredicate:[NSPredicate predicateWithFormat:@"ean LIKE[c] %@", codeWithoutChecksum]];
            results = [moc executeFetchRequest:request error:nil];
        }
            
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Barcode *barcodeDB = results[0];
        
        request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", barcodeDB.itemID]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Item *itemDB = results[0];
        
        [request setEntity:[NSEntityDescription entityForName:@"Price" inManagedObjectContext:self.dataController.managedObjectContext]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", barcodeDB.itemID]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Price *priceDB = results[0];
        
        ItemInformation *item = [self itemInfoFromDBEntities:itemDB barcode:barcodeDB price:priceDB];
    
        returnBlock(0, item);
    });
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemID:(NSUInteger)itemID
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        void (^returnBlock)(int result, ItemInformation *item) = ^void(int result, ItemInformation *item)
        {
            if ([delegate respondsToSelector:@selector(itemDescriptionComplete:itemDescription:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate itemDescriptionComplete:result itemDescription:item];
                });
            }
        };
        
        NSManagedObjectContext *moc = self.dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemID]];
        NSArray *results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Item *itemDB = results[0];
        
        request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemID]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Price *priceDB = results[0];
        
        request = [NSFetchRequest fetchRequestWithEntityName:@"Barcode"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemID]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Barcode *barcodeDB = results[0];
        
        ItemInformation *item = [self itemInfoFromDBEntities:itemDB barcode:barcodeDB price:priceDB];
        
        returnBlock(0, item);
    });
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate article:(NSString *)article
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        void (^returnBlock)(int result, ItemInformation *item) = ^void(int result, ItemInformation *item)
        {
            if ([delegate respondsToSelector:@selector(itemDescriptionComplete:itemDescription:)])
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate itemDescriptionComplete:result itemDescription:item];
                });
            }
        };
        
        NSManagedObjectContext *moc = self.dataController.managedObjectContext;
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemCode ==[c] %@", article]];
        NSArray *results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Item *itemDB = results[0];
        
        request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemDB.itemID.integerValue]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Price *priceDB = results[0];
        
        request = [NSFetchRequest fetchRequestWithEntityName:@"Barcode"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemDB.itemID.integerValue]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            returnBlock(1, nil);
            return;
        }
        Barcode *barcodeDB = results[0];
        
        ItemInformation *item = [self itemInfoFromDBEntities:itemDB barcode:barcodeDB price:priceDB];
        
        returnBlock(0, item);
    });
}

#pragma mark - Helpers

- (ItemInformation*) itemInfoFromDBEntities:(Item*) itemDB barcode:(Barcode*)barcodeDB price:(Price*) priceDB
{
    ItemInformation* itemInfo = [ItemInformation new];
    
    NSMutableArray *additionalParameters = [NSMutableArray new];
    
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"additionalInfo" value:itemDB.additionalInfo]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"additionalSize" value:itemDB.additionalSize]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"boxType" value:itemDB.boxType]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"certificationAuthorittyCode" value:itemDB.certificationAuthorittyCode]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"groupID" value:itemDB.groupID.stringValue]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"itemCode" value:itemDB.itemCode]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"itemCode_2" value:itemDB.itemCode_2]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"line1" value:itemDB.line1]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"line2" value:itemDB.line2]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"priceHeader" value:itemDB.priceHeader]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"size" value:itemDB.size]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"sizeHeader" value:itemDB.sizeHeader]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"storeNumber" value:itemDB.storeNumber]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"subgroupID" value:itemDB.subgroupID.stringValue]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"trademarkID" value:itemDB.trademarkID.stringValue]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"retailPrice" value:priceDB.retailPrice.stringValue]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"discount" value:[NSString stringWithFormat:@"%.0f", priceDB.discount.doubleValue]]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"imageURL" value:[self imageURLForItemID:itemDB.itemID.integerValue]]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"ean" value:barcodeDB.ean]];
    
    itemInfo.itemId     = itemDB.itemID.integerValue;
    itemInfo.barcode    = barcodeDB.code128;
    itemInfo.name       = itemDB.name;
    itemInfo.article    = itemDB.itemCode;
    itemInfo.price      = priceDB.catalogPrice.doubleValue;
    itemInfo.additionalParameters = additionalParameters;
    
    return itemInfo;
}

- (NSString *)imageURLForFileName:(NSString *)filename
{
    NSString* (^sha1)(NSString *) = ^(NSString *string) {
        
        NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
        uint8_t digest[CC_SHA1_DIGEST_LENGTH];
        CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
        
        NSMutableString *output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
        for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
            [output appendFormat:@"%02x", digest[i]];
        
        return output;
    };
    
    NSString *picDir = [sha1(filename) substringToIndex:3];
    NSString *width = @"400";
    NSString *height = @"400";
    NSString *algoritm = @"1";
    NSString *hash = [sha1([NSString stringWithFormat:@"%@%@%@%@sportmaster404", filename, width, height, algoritm]) substringToIndex:4];
    NSString *urlString = [NSString stringWithFormat:@"http://cdn.sportmaster.ru/upload/goods/%@/%@_%@_%@_%@/%@", picDir, width, height, algoritm, hash, filename];
    
    return urlString;
}

- (NSString *)imageURLForItemID:(NSUInteger)itemID
{
    return [NSString stringWithFormat:@"http://172.16.4.228:2080/MobileStick/api/Picture/%ld", itemID];
}

@end
