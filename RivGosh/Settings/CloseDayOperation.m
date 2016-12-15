//
//  CloseDayOperation.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 12/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "CloseDayOperation.h"
#import "PLManager.h"
#import "MCPServer.h"

@interface CloseDayOperation () <PrinterDelegate, PLManagerDelegate>
{
    BOOL zReportComplete;
    BOOL cutoverComplete;
    BOOL zReportSuccess;
    BOOL cutoverSuccess;
    
    BOOL executing;
    BOOL finished;
}

@end


@implementation CloseDayOperation

- (void) start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start)
                               withObject:nil waitUntilDone:NO];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    [[MCPServer instance] zReport:self receiptID:nil amount:_dbAmount reqID:[NSNull null]];
    PLManager *plManager = [PLManager instance];
    plManager.delegate = self;
    NSError* error = nil;
    [plManager endOfDay:&error];
    if (error)
    {
        self.error = error;
        self.success = NO;
        [self finish];
        return;
    }
}

- (BOOL) isConcurrent
{
    return YES;
}

- (BOOL) isExecuting
{
    return executing;
}

- (BOOL) isFinished
{
    return finished;
}

- (void) finish
{
    self.success = zReportSuccess && cutoverSuccess;
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


- (void) signalIfFinished
{
    if (!zReportComplete || !cutoverComplete)
        return;
    
    
    [self finish];
}

- (void) commitError:(NSString*) description
{
    
    if (description.length < 1)
        return;
    
    NSString* currentDescription = _error.localizedDescription;
    NSMutableString* mutableString = [NSMutableString new];
    if (currentDescription)
        [mutableString appendString:currentDescription];
    if (currentDescription.length > 0)
        [mutableString appendString:@"\n\n"];
    [mutableString appendString:description];
    
    self.error = [NSError errorWithDomain:@"CloseDay" code:1 userInfo:@{NSLocalizedDescriptionKey:mutableString}];
}

#pragma mark Network Delegates

- (void) zReportComplete:(int)result zReport:(ZReport *)report reqID:(id)reqID
{
    zReportComplete = YES;
    if (result == 0)
    {
        zReportSuccess = YES;
    }
    else
    {
        NSString* errorDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkErrorDescription"];
        
        NSString* message = errorDescription?errorDescription:@"Ошибка снятия Z отчета";
        [self commitError:message];
        
    }
    
    [self signalIfFinished];
    
}

- (void) paymentManagerDidFinishOperation:(PLOperationType)operation result:(PLOperationResult *)result
{
    cutoverComplete = YES;
    cutoverSuccess = result.success;
    if (!result.success)
    {
        [self commitError:result.errorLocalizedDescription];
    }
    
    [self signalIfFinished];
    
}

@end
