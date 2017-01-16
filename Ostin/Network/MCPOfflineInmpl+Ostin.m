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
#import "ItemPrintFact+CoreDataClass.h"
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
#import "SOAPResetIncDone.h"
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
        
        NSString *ID = [[NSUserDefaults standardUserDefaults] valueForKey:@"DeviceID"];
        if (ID == nil)
        {
            ID = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
            [[NSUserDefaults standardUserDefaults] setValue:ID forKey:@"DeviceID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        deviceID = ID;
    }
    
    return self;
}

- (void)resetDatabaseAndPortionsCount:(id<ItemDescriptionDelegate_Ostin>)delegate
{
    NSOperationQueue *resetQueue = [NSOperationQueue new];
    resetQueue.name = @"resetQueue";
    
    SOAPResetIncDone *resetIncDone = [SOAPResetIncDone new];
    __weak SOAPResetIncDone* _resetIncDone = resetIncDone;
    resetIncDone.authValue = authValue;
    resetIncDone.deviceID = deviceID;
    
    __weak typeof(self) wself = self;
    NSBlockOperation* delegateCallOperation = [NSBlockOperation blockOperationWithBlock:^{
        
        BOOL success = _resetIncDone.success;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success)
            {
                [wself.dataController recreatePersistentStore];
                [delegate resetDatabaseAndPortionsCountComplete:0];
            }
            else
                [delegate resetDatabaseAndPortionsCountComplete:1];
        });
    }];
    
    [delegateCallOperation addDependency:resetIncDone];
    
    [resetQueue addOperations:@[resetIncDone] waitUntilFinished:NO];
    [[NSOperationQueue mainQueue] addOperation:delegateCallOperation];
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
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
             
            NSString* (^hash)(NSString *) = ^(NSString *string) {
                
                NSUInteger len = [string length];
                unichar buffer[len+1];
                
                [string getCharacters:buffer range:NSMakeRange(0, len)];
                NSMutableData *data = [NSMutableData new];
                for (int i = 0; i < len; i++)
                    [data appendBytes:&buffer[i] length:sizeof(unichar)];

                unsigned char result[CC_MD5_DIGEST_LENGTH];
                CC_MD5(data.bytes, (CC_LONG)data.length, result);
                NSMutableString *hash = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
                for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++)
                    [hash appendFormat:@"%02x",result[i]];
                
                return hash;
            };
            
            NSManagedObjectContext *moc = self.dataController.managedObjectContext;
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"login ==[c] %@ AND password ==[c] %@", login, hash(password)]];
            NSArray *results = [moc executeFetchRequest:request error:nil];
            if (results.count < 1)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [delegate userComplete:1 user:nil];
                });
                return;
            }
            User *userDB = results[0];
            
            UserInformation *userInfo = [UserInformation new];
            userInfo.key_user = userDB.key_user;
            userInfo.barcode = userDB.barcode;
            userInfo.login = userDB.login;
            userInfo.password = userDB.password;
            userInfo.name = userDB.name;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate userComplete:0 user:userInfo];
            });
        });
    }
    else
    {
        NSProgress *usersProgress = [NSProgress progressWithTotalUnitCount:1 parent:delegate.progress pendingUnitCount:1];
        
        NSOperationQueue *usersQueue = [NSOperationQueue new];
        usersQueue.name = @"usersQueue";
        
        SOAPUsers *users = [SOAPUsers new];
        __weak SOAPUsers* _users = users;
        users.dataController = self.dataController;
        users.authValue = authValue;
        users.deviceID = deviceID;
        
        [usersProgress addChild:users.progress withPendingUnitCount:1];
        
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

        NSManagedObjectContext *moc = self.dataController.managedObjectContext;
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"User"];
        [request setPredicate:[NSPredicate predicateWithFormat:@"barcode == %@", barcode]];
        NSArray *results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate userComplete:1 user:nil];
            });
            return;
        }
        User *userDB = results[0];
        
        UserInformation *userInfo = [UserInformation new];
        userInfo.key_user = userDB.key_user;
        userInfo.barcode = userDB.barcode;
        userInfo.login = userDB.login;
        userInfo.password = userDB.password;
        userInfo.name = userDB.name;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [delegate userComplete:0 user:userInfo];
        });
    });
}

- (void) tasks:(id<TasksDelegate>)delegate userID:(NSString *)userID
{    
    if (userID)
    {
        [self tasksInternal:delegate userID:userID];
    }
    else
    {
        NSProgress *tasksProgress = [NSProgress progressWithTotalUnitCount:2 parent:delegate.progress pendingUnitCount:1];
        
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
        
        [tasksProgress addChild:tasks.progress withPendingUnitCount:1];
        [tasksProgress addChild:taskWareBinding.progress withPendingUnitCount:1];
        
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
        NSFetchRequest *taskItemRequest = [NSFetchRequest fetchRequestWithEntityName:@"ItemPrintFact"];
        [taskItemRequest setPredicate:[NSPredicate predicateWithFormat:@"taskName == %@ AND wasUploaded == %@", taskDB.name, @NO]];
        NSArray *results = [moc executeFetchRequest:taskItemRequest error:nil];
        
        NSMutableArray *wareCodes = [[NSMutableArray alloc] init];
        for (ItemPrintFact *itemPrintFactDB in results)
            [wareCodes addObject:itemPrintFactDB.itemCode];
        
        __block NSOperationQueue *setTaskDoneQueue = [NSOperationQueue new];
        setTaskDoneQueue.name = @"setTaskDoneQueue";

        SOAPSavePrintFact *savePrintFact = [SOAPSavePrintFact new];
        __weak SOAPSavePrintFact *_savePrintFact = savePrintFact;
        savePrintFact.taskName = taskDB.name;
        savePrintFact.taskType = @"pasting";
        savePrintFact.wareCodes = wareCodes;
        savePrintFact.authValue = authValue;
        savePrintFact.deviceID  = deviceID;
        savePrintFact.userID = userID;
        
        __block BOOL savePrintFactLocalSuccess = NO;
        
        NSBlockOperation *savePrintFactLocal = [NSBlockOperation blockOperationWithBlock:^{
            
            if (_savePrintFact.success)
            {
                NSManagedObjectContext *privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                [privateMoc setParentContext:moc];
                
                NSFetchRequest *taskItemRequest = [NSFetchRequest fetchRequestWithEntityName:@"ItemPrintFact"];
                [taskItemRequest setPredicate:[NSPredicate predicateWithFormat:@"taskName == %@ AND wasUploaded == %@", taskDB.name, @NO]];
                NSArray *results = [privateMoc executeFetchRequest:taskItemRequest error:nil];
                
                for (ItemPrintFact *itemPrintFactDB in results)
                    itemPrintFactDB.wasUploaded = @YES;
                
                __block NSError *error = nil;
                
                [privateMoc performBlockAndWait:^{
                    [privateMoc save:&error];
                }];
                
                if (!error)
                {
                    [moc performBlockAndWait:^{
                        [moc save:&error];
                    }];
                    
                    savePrintFactLocalSuccess = YES;
                }
            }
        }];
        
        SOAPSetTaskDone *setTaskDone = [SOAPSetTaskDone new];
        __weak SOAPSetTaskDone *_setTaskDone = setTaskDone;
        setTaskDone.taskName = taskDB.name;
        setTaskDone.taskType = @"pasting";
        setTaskDone.authValue = authValue;
        setTaskDone.deviceID  = deviceID;
        setTaskDone.userID = userID;
        
        __block BOOL setTaskDoneLocalSuccess = NO;
        
        NSBlockOperation* setTaskDoneLocal = [NSBlockOperation blockOperationWithBlock:^{
            
            if (_setTaskDone.success)
            {
                NSManagedObjectContext *privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                [privateMoc setParentContext:moc];
                Task *_taskDB = [privateMoc objectWithID:taskDB.objectID];
                
                _taskDB.endDate = date;
                [privateMoc performBlockAndWait:^{
                    [privateMoc save:nil];
                }];

                [moc performBlockAndWait:^{
                    [moc save:nil];
                }];
                
                setTaskDoneLocalSuccess = YES;
            }
        }];
        
        // if wareCodes > 0
        // [save print fact]->[save to core data]->[set task done]->[save to core data]->(completion)
        
        // if wareCodes = 0
        // [set task done]->[save to core data]->(completion)
        
        if (wareCodes.count > 0)
        {
            [savePrintFactLocal addDependency:savePrintFact];
            
            NSBlockOperation *controlOperation = [NSBlockOperation blockOperationWithBlock:^{
                
                if (savePrintFactLocalSuccess)
                {
                    NSBlockOperation *delegateOperation = [NSBlockOperation blockOperationWithBlock:^{
                        
                        if (_setTaskDone.success && setTaskDoneLocal)
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(YES, nil);
                            });
                        else
                        {
                            NSString *msg = [NSString stringWithString:_setTaskDone.errorMessage];
                            dispatch_async(dispatch_get_main_queue(), ^{
                                completion(NO, msg);
                            });
                        }
                    }];
                    
                    [setTaskDoneLocal addDependency:setTaskDone];
                    [setTaskDoneQueue addOperations:@[setTaskDone, setTaskDoneLocal] waitUntilFinished:NO];
                    
                    [delegateOperation addDependency:setTaskDoneLocal];
                    [[NSOperationQueue mainQueue] addOperation:delegateOperation];
                }
                else
                {
                    NSString *msg = [NSString stringWithString:_savePrintFact.errorMessage];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion(NO, msg);
                    });
                }
            }];
            
            [controlOperation addDependency:savePrintFactLocal];
            [setTaskDoneQueue addOperations:@[savePrintFact, savePrintFactLocal] waitUntilFinished:NO];
            [[NSOperationQueue mainQueue] addOperation:controlOperation];
        }
        else
        {
            
            NSBlockOperation *delegateOperation = [NSBlockOperation blockOperationWithBlock:^{
                
                    if (_setTaskDone.success && setTaskDoneLocal)
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(YES, nil);
                        });
                    else
                    {
                        NSString *msg = [NSString stringWithString:_setTaskDone.errorMessage];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            completion(NO, msg);
                        });
                    }
            }];
            
            [setTaskDoneLocal addDependency:setTaskDone];
            [delegateOperation addDependency:setTaskDoneLocal];
            [setTaskDoneQueue addOperations:@[setTaskDone, setTaskDoneLocal] waitUntilFinished:NO];
            
            [[NSOperationQueue mainQueue] addOperation:delegateOperation];
        }
    }
    else
        completion(NO, nil);
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

- (void) savePrintItemFactForItemCode:(NSString *)itemCode taskName:(NSString *)taskName userID:(NSString *)userID
{
    NSManagedObjectContext *moc = self.dataController.managedObjectContext;
    
    ItemPrintFact *itemPrintFactDB = [NSEntityDescription insertNewObjectForEntityForName:@"ItemPrintFact" inManagedObjectContext:moc];
    
    itemPrintFactDB.taskName = taskName;
    itemPrintFactDB.itemCode = itemCode;
    itemPrintFactDB.wasUploaded = @NO;
    
    __block NSError *err = nil;
    
    [moc performBlockAndWait:^{
        [moc save:&err];
    }];
    
    if (!err)
    {
        NSOperationQueue *setPrintFactQueue = [NSOperationQueue new];
        
        SOAPSavePrintFact *savePrintFact = [SOAPSavePrintFact new];
        __weak SOAPSavePrintFact *_savePrintFact = savePrintFact;
        savePrintFact.taskName = taskName;
        savePrintFact.taskType = @"pasting";
        savePrintFact.wareCodes = @[itemCode];
        savePrintFact.authValue = authValue;
        savePrintFact.deviceID  = deviceID;
        savePrintFact.userID = userID;
        
        NSBlockOperation *savePrintFactLocal = [NSBlockOperation blockOperationWithBlock:^{
            
            if (_savePrintFact.success)
            {
                NSManagedObjectContext *privateMoc = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
                [privateMoc setParentContext:moc];
                
                NSFetchRequest *taskItemRequest = [NSFetchRequest fetchRequestWithEntityName:@"ItemPrintFact"];
                [taskItemRequest setPredicate:[NSPredicate predicateWithFormat:@"taskName == %@ AND wasUploaded == %@", taskName, @NO]];
                NSArray *results = [privateMoc executeFetchRequest:taskItemRequest error:nil];
                
                if (results.count > 0)
                {
                    ItemPrintFact *itemPrintFactDB = results[0];
                    itemPrintFactDB.wasUploaded = @YES;
                    
                    __block NSError *error = nil;
                    
                    [privateMoc performBlockAndWait:^{
                        [privateMoc save:&error];
                    }];
                    
                    if (!error)
                    {
                        [moc performBlockAndWait:^{
                            [moc save:&error];
                        }];
                    }
                }
            }
        }];
        
        [savePrintFactLocal addDependency:savePrintFact];
        [setPrintFactQueue addOperations:@[savePrintFact, savePrintFactLocal] waitUntilFinished:NO];
    }
}

- (void) savePrintItemsCount:(NSInteger)count inTaskWithID:(NSInteger)taskID
{
    NSManagedObjectContext *moc = self.dataController.managedObjectContext;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    [request setPredicate:[NSPredicate predicateWithFormat:@"taskID == %ld", taskID]];
    NSArray *results = [moc executeFetchRequest:request error:nil];
    if (results.count < 1)
    {
        return;
    }
    Task *taskDB = results[0];
    taskDB.totalPrintedCount = @(count);
    [moc save:nil];
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
                    [substringPredicates addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[c] %@", substring]];
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

- (void) itemDescription:(id<ItemDescriptionDelegate_Ostin>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode isoType:(int)type
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
        
        /*
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Barcode" inManagedObjectContext:self.dataController.managedObjectContext]];
        [request setIncludesSubentities:NO]; //Omit subentities. Default is YES (i.e. include subentities)
        
        NSArray* barcodesq = [self.dataController.managedObjectContext executeFetchRequest:request error:nil];
        
        [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext]];
        NSArray* itemsq = [self.dataController.managedObjectContext executeFetchRequest:request error:nil];
        
        
       NSInteger count = 0;
        for (Barcode *barcode in barcodesq) {
            for (Item *item in itemsq) {
                if (item.itemID.integerValue == barcode.itemID.integerValue)
                {
                    NSLog(@"%@", barcode.code128);
                    count++;
                }
            }
        }*/
        
        NSProgress *itemsProgress = [NSProgress progressWithTotalUnitCount:3 parent:delegate.progress pendingUnitCount:3];
        
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
        
        [itemsProgress addChild:wares.progress withPendingUnitCount:1];
        [itemsProgress addChild:barcodes.progress withPendingUnitCount:1];
        [itemsProgress addChild:prices.progress withPendingUnitCount:1];
        
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
            taskInfo.totalPrintedCount = taskDB.totalPrintedCount.integerValue;
            
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
        else if (results.count < 1 && type == BAR_CODE128 && code.length > 8)
        {
            [request setPredicate:[NSPredicate predicateWithFormat:@"ean LIKE[c] %@", code]];
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

- (void) itemsDescription:(id<ItemDescriptionDelegate>)delegate itemIDs:(NSArray<NSNumber *>*)itemIDs
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSManagedObjectContext *moc = self.dataController.managedObjectContext;
        NSMutableArray *items = [NSMutableArray new];
        
        for (NSNumber *itemID in itemIDs)
        {
            NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Item"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemID.integerValue]];
            NSArray *results = [moc executeFetchRequest:request error:nil];
            if (results.count < 1)
                continue;

            Item *itemDB = results[0];
            
            request = [NSFetchRequest fetchRequestWithEntityName:@"Price"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemID.integerValue]];
            results = [moc executeFetchRequest:request error:nil];
            if (results.count < 1)
                continue;

            Price *priceDB = results[0];
            
            request = [NSFetchRequest fetchRequestWithEntityName:@"Barcode"];
            [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %ld", itemID.integerValue]];
            results = [moc executeFetchRequest:request error:nil];
            if (results.count < 1)
                continue;

            Barcode *barcodeDB = results[0];
            
            ItemInformation *item = [self itemInfoFromDBEntities:itemDB barcode:barcodeDB price:priceDB];
            [items addObject:item];
        }
        
        if ([delegate respondsToSelector:@selector(allItemsDescription:items:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [delegate allItemsDescription:0 items:items];
            });
        }
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

- (void) itemDescriptionWithItemCode:(NSString *)code isoType:(int)type completion:(void (^)(BOOL success, ItemInformation *item))completion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{

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
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
            return;
        }
        Barcode *barcodeDB = results[0];
        
        request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.dataController.managedObjectContext]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", barcodeDB.itemID]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
            return;
        }
        Item *itemDB = results[0];
        
        [request setEntity:[NSEntityDescription entityForName:@"Price" inManagedObjectContext:self.dataController.managedObjectContext]];
        [request setPredicate:[NSPredicate predicateWithFormat:@"itemID == %@", barcodeDB.itemID]];
        results = [moc executeFetchRequest:request error:nil];
        if (results.count < 1)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(NO, nil);
            });
            return;
        }
        Price *priceDB = results[0];
        
        ItemInformation *item = [self itemInfoFromDBEntities:itemDB barcode:barcodeDB price:priceDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(YES, item);
        });
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
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"certificationType" value:itemDB.certificationType]];
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
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"drop" value:itemDB.drop]];
    [additionalParameters addObject:[[ParameterInformation alloc] initWithName:@"collection" value:itemDB.collection]];
    
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
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *protocol = [[NSUserDefaults standardUserDefaults] valueForKey:@"protocol_image_preference"];
    NSString *host     = [[NSUserDefaults standardUserDefaults] valueForKey:@"host_image_preference"];
    NSString *port     = [[NSUserDefaults standardUserDefaults] valueForKey:@"port_image_preference"];
    NSString *path     = [[NSUserDefaults standardUserDefaults] valueForKey:@"path_image_preference"];
    NSMutableString *address = [NSMutableString stringWithFormat:@"%@://%@%@",protocol, host, port.length > 0?[NSString stringWithFormat:@":%@", port]:@""];
    if (path.length > 0)
        [address appendFormat:@"/%@", path];
    return [NSString stringWithFormat:@"%@/%ld", address, itemID];
}

@end
