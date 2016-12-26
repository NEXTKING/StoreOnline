//
//  PrintServer.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 03/11/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "PrintServer.h"
#import "PrintViewController.h"
#import "ZPLGenerator.h"
#import "AppSuspendingBlocker.h"

@interface PrintServer() <PrinterControllerDelegate>
{
    PrintViewController *_printVC;
    NSMutableArray *_queue;
    BOOL _isPrinting;
    UIWindow *_window;
    NSTimer *_controlQueueTimer;
    AppSuspendingBlocker *_suspendingBlocker;
}
@end

@implementation PrintServer

+ (instancetype)instance
{
    static PrintServer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PrintServer alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _printVC = [PrintViewController new];
        _printVC.delegate = self;
        _printVC.view.frame = CGRectMake(20, 214, 280, 140);
        _queue = [NSMutableArray new];
        _isPrinting = false;
        _window = [[UIWindow alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.frame];
        _window.windowLevel = [[[[UIApplication sharedApplication] delegate] window] windowLevel] + 1;
        [_window addSubview:_printVC.view];
        _suspendingBlocker = [AppSuspendingBlocker new];
    }
    return self;
}

- (void)addItemToPrintQueue:(ItemInformation *)item printFormat:(id)format
{
    [_queue addObject:@{@"item": item, @"format": format}];
    
    if (!_isPrinting)
        [self print];
}

- (void)print
{
    if (_queue.count > 0)
    {
        ItemInformation *item = _queue[0][@"item"];
        id format = _queue[0][@"format"];
        
        if (_controlQueueTimer != nil)
        {
            [_controlQueueTimer invalidate];
            _controlQueueTimer = nil;
        }
        
        _isPrinting = YES;
        [self showPrintView];
        [self initializeControlQueueTimer];
        [_suspendingBlocker startBlock];
        
        if ([format isKindOfClass:[NSString class]])
        {
            // zpl
            NSData *data = nil;
            if ([format isEqualToString:@"mainZPL"])
            {
                NSString *str = [[NSBundle mainBundle] pathForResource:@"label" ofType:@"zpl"];
                data = [ZPLGenerator generateZPLWithItem:item patternPath:str];
            }
            else if ([format isEqualToString:@"additionalZPL"])
            {
                NSString *addStr = [[NSBundle mainBundle] pathForResource:@"producer_label" ofType:@"zpl"];
                data = [ZPLGenerator generateEanZPLWithItem:item patternPath:addStr];
            }
            
            [_printVC printZPL:data copies:1];
        }
        else if ([format isKindOfClass:[UIView class]])
        {
            // priceTag
        }
    }
}

- (void)printerDidFinishPrinting
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrinterDidFinishPrinting" object:_queue[0]];
    
    [_queue removeObjectAtIndex:0];
    _isPrinting = NO;
    
    if (_queue.count > 0)
    {
        [self print];
    }
    else
    {
        if (_controlQueueTimer != nil)
        {
            [_controlQueueTimer invalidate];
            _controlQueueTimer = nil;
        }
        
        [self hidePrintView];
        [_suspendingBlocker stopBlock];
    }
}

- (void)printerDidFailPrinting:(NSError *)error
{
    _isPrinting = NO;
    [self hidePrintView];
    [_suspendingBlocker stopBlock];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrinterDidFailPrinting" object:_queue[0]];
    
    [_queue removeObjectAtIndex:0];
    
    if (_queue.count > 0)
        [self print];
}

- (void)showPrintView
{
    [_window makeKeyAndVisible];
    [_window setHidden:NO];
}

- (void)hidePrintView
{
    [_window setHidden:YES];
    [[[[UIApplication sharedApplication] delegate] window] makeKeyAndVisible];
}

- (void)initializeControlQueueTimer
{
    if (![NSThread isMainThread])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            _controlQueueTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(reset:) userInfo:nil repeats:NO];
        });
    }
    else
        _controlQueueTimer = [NSTimer scheduledTimerWithTimeInterval:40 target:self selector:@selector(reset:) userInfo:nil repeats:NO];
}

- (void)reset:(NSTimer *)timer
{
    _isPrinting = NO;
    [_queue removeAllObjects];
    [self hidePrintView];
    [_suspendingBlocker stopBlock];
}

@end
