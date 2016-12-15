//
//  ObtainAmountOperation.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 14/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ObtainAmountOperation.h"
#import "PLManager.h"

@interface ObtainAmountOperation () <PrinterDelegate, PLManagerDelegate>
{
    BOOL lastRequest;
    BOOL zReportComplete;
    BOOL reconcoliationComplete;
    BOOL zReportSuccess;
    BOOL reconciliationSuccess;
    
    BOOL executing;
    BOOL finished;
}

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSError* error;
@property (nonatomic, strong) ZReport* zReport;
@property (nonatomic, copy) NSNumber* bankAmount;


@end

@implementation ObtainAmountOperation


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
    
    [[MCPServer instance] zReport:self receiptID:nil amount:nil reqID:nil];
    PLManager *plManager = [PLManager instance];
    plManager.delegate = self;
    NSError* error = nil;
    [plManager reconciliation:_terminalAmount error:&error];
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
    self.success = zReportSuccess && reconciliationSuccess;
    
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    executing = NO;
    finished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


- (void) signalIfFinished
{
    if (!zReportComplete || !reconcoliationComplete)
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

- (void) zReportComplete:(int)result zReport:(ZReport *)report reqID:(id)reqID
{
    if (result == 0)
    {
        if (!lastRequest)
        {
            lastRequest = YES;
            [[MCPServer instance] zReport:self receiptID:report.receiptID amount:nil reqID:nil];
        }
        else
        {
            lastRequest = NO;
            self.zReport = report;
            zReportSuccess = YES;
            zReportComplete = YES;
            [self signalIfFinished];
        }
    }
    else
    {
        lastRequest = NO;
        
        NSString* errorDescription = [[NSUserDefaults standardUserDefaults] objectForKey:@"NetworkErrorDescription"];
        NSString* message = errorDescription?errorDescription:@"Ошибка снятия Z отчета";
        [self commitError:message];
        zReportComplete = YES;
        [self signalIfFinished];
        
    }
}

- (void) paymentManagerDidFinishOperation:(PLOperationType)operation result:(PLOperationResult *)result
{
    reconciliationSuccess = (result.resultCode == 0 || result.resultCode == 506);
    
    if (!result.success)
    {
        [self commitError:result.errorLocalizedDescription];
        self.bankAmount = @(result.reconciliationAmount);
    }
    else
         self.bankAmount = @(_terminalAmount);
        
    
    reconcoliationComplete = YES;
    [self signalIfFinished];
}


@end
