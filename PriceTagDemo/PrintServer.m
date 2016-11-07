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

@interface PrintServer() <PrinterControllerDelegate>
{
    PrintViewController *_printVC;
    NSMutableArray *_queue;
    BOOL _isPrinting;
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
    }
    return self;
}

- (void)addItemToPrintQueue:(ItemInformation *)item printFormat:(id)format
{
    [_queue addObject:@{@"item": item, @"format": format}];
    [self print];
}

- (void)print
{
    if (!_isPrinting)
    {
        if (_queue.count > 0)
        {
            ItemInformation *item = _queue[0][@"item"];
            id format = _queue[0][@"format"];
            
            if ([format isKindOfClass:[NSString class]])
            {
                // zpl
                NSData *data = [ZPLGenerator generateZPLWithItem:item patternPath:format];
                [_printVC printZPL:data copies:1];
            }
            else if ([format isKindOfClass:[UIView class]])
            {
                // priceTag
            }
            
            _isPrinting = YES;
            [self showPrintView];
        }
    }
}

- (void)printerDidFinishPrinting
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrinterDidFinishPrinting" object:_queue[0][@"item"]];
    
    [_queue removeObjectAtIndex:0];
    
    if (_queue.count > 0)
        [self print];
    else
    {
        _isPrinting = NO;
        [self hidePrintView];
    }
}

- (void)printerDidFailPrinting:(NSError *)error
{
    _isPrinting = NO;
    [self hidePrintView];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PrinterDidFailPrinting" object:_queue[0][@"item"]];
    
    [_queue removeObjectAtIndex:0];
}

- (void)showPrintView
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:_printVC.view];
}

- (void)hidePrintView
{
    [_printVC.view removeFromSuperview];
}

@end
