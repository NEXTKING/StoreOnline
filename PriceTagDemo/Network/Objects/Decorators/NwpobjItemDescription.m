//
//  NwpobjItemDescription.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 23/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "NwpobjItemDescription.h"
#import "Logger.h"
#import "AppDelegate.h"
#import "WarehouseInformation.h"

@interface NwpobjItemDescription () <ItemDescriptionDelegate>
{
    NSUInteger _page;
    NSUInteger _totalCount;
    NSUInteger _completeCount;
    
    NSString*  _url;
}
@property (nonatomic, strong) NwobjItemDescription* nwobjItemDescription;
@end

@implementation NwpobjItemDescription

@synthesize progress = _progress;
@synthesize error    = _error;

- (id)init
{
    self = [super init];
    if (self)
    {
#ifdef DEBUG
        [Logger log:self method:@"init" format:@""];
#endif
        self.progress = [[NSProgress alloc] init];
        
        _resultCode = -1;
        _delegate = nil;
    }
    return self;
}

- (void)dealloc
{
#ifdef DEBUG
    [Logger log:self method:@"dealloc" format:@""];
#endif
}

- (void) setDelegate:(id<ItemDescriptionDelegate>)delegate
{
    if (_delegate == delegate)
        return;
    
    _delegate = nil;
    
    if ([delegate conformsToProtocol:@protocol(ItemDescriptionDelegate)])
    {
        [Logger log:self method:@"setDelegate" format: @"\n\t Set new delegate"];
        
        _delegate = delegate;
        if ([delegate respondsToSelector:@selector(progress)] && [delegate.progress isKindOfClass:[NSProgress class]])
            [delegate.progress addChild:self.progress withPendingUnitCount:1];
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (void)run:(NSString*)url
{
    _url = url;
    _page = 0;
    
    [self runNext];
}

- (void) cancel
{
    
}

- (void) complete:(BOOL)isSuccessfull
{
    
}

- (void)runNext
{
    self.nwobjItemDescription = [NwobjItemDescription new];
    _nwobjItemDescription.page = [NSString stringWithFormat:@"%ld", _page];
    _nwobjItemDescription.barcode = self.barcode;
    _nwobjItemDescription.shopId = self.shopId;
    _nwobjItemDescription.delegate = self;
    _nwobjItemDescription.completionHandler = self.completionHandler;
    [_nwobjItemDescription run:_url];
}

- (void)itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription
{
    if (_nwobjItemDescription.result)
    {
        id obj = [_nwobjItemDescription.result objectForKey:@"itemcount"];
        if (obj && [obj isKindOfClass:[NSNumber class]])
        {
            _totalCount = [obj unsignedIntegerValue];
            self.progress.totalUnitCount = _totalCount;
        }
        
        obj = [_nwobjItemDescription.result objectForKey:@"All_Items"];
        if (obj && [obj isKindOfClass:[NSArray class]])
        {
            _completeCount = _completeCount + [obj count];
            self.progress.completedUnitCount = _completeCount;
        }
        
        if (_completeCount < _totalCount)
        {
            _page = _page + 1;
            [self runNext];
        }
        else if (_delegate)
        {
            [_delegate itemDescriptionComplete:result itemDescription:nil];
        }
    }
    else if (_delegate)
        [_delegate itemDescriptionComplete:result itemDescription:nil];
}

- (void) allItemsDescription:(int)result items:(NSArray<ItemInformation *> *)items
{
    
}

@end
