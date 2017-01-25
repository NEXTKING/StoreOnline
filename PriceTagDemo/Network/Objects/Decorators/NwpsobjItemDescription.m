//
//  NwpsobjItemDescription.m
//  PriceTagDemo
//
//  Created by Denis Kurochkin on 25/01/2017.
//  Copyright © 2017 Dataphone. All rights reserved.
//

#import "NwpsobjItemDescription.h"
#import "Logger.h"

@interface ItemsDelegateHelper : NSObject  <ItemDescriptionDelegate>
@property (strong, nonatomic) NwobjItemDescription* nwObj;
@property (copy, nonatomic) void (^completionHandler)(NwobjItemDescription *obj, int result, ItemInformation* itemDescription);
@end

@implementation ItemsDelegateHelper
- (void) itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription{
    self.completionHandler(_nwObj, result,itemDescription);
    self.nwObj = nil;
};
- (void) allItemsDescription:(int)result items:(NSArray<ItemInformation *> *)items{};
@end



@interface NwpsobjItemDescription ()
{
    NSUInteger _page;
    NSUInteger _totalCount;
    NSUInteger _completeCount;
    NSString*  _url;
    
    BOOL isFisrtRequest;
    NSMutableArray* helpers;
}
@end

@implementation NwpsobjItemDescription

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
        _resultCode = -1;
        _delegate = nil;
        helpers = [NSMutableArray new];
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
    }
    else
        [Logger log:self method:@"setDelegate" format: @"\n\t New delegate doesn't conform to protocol"];
}

- (void)run:(NSString*)url
{
    _url = url;
    _page = 0;
    
    [helpers removeAllObjects];
    isFisrtRequest = YES;
    //keepAliveReference = self;
    [self runPage:0];
}

- (void) cancel
{
    
}

- (void) complete:(BOOL)isSuccessfull
{
    
}

- (void)runPage:(NSInteger) page
{
    ItemsDelegateHelper *helper = [ItemsDelegateHelper new];
    
    NwobjItemDescription* nwobj = [NwobjItemDescription new];
    nwobj.page = [NSString stringWithFormat:@"%ld", page];
    nwobj.barcode = self.barcode;
    nwobj.shopId = self.shopId;
    nwobj.delegate = helper;
    nwobj.completionHandler = self.completionHandler;
    helper.nwObj = nwobj;
    helper.completionHandler = ^(NwobjItemDescription *obj, int result, ItemInformation* itemDescription){
        [self itemDescriptionComplete:result itemDescription:itemDescription obj:obj];
    };
    [helpers addObject:helper];
    [nwobj run:_url];
}

- (void) runAllRest
{
    NSInteger restPortions = (_totalCount+_completeCount-1)/_completeCount;
    for (int i = 1; i < restPortions; ++i) {
        [self runPage:i];
    }
}

- (void)itemDescriptionComplete:(int)result itemDescription:(ItemInformation *)itemDescription obj:(NwobjItemDescription*) nwobjItemDescription
{
    if (nwobjItemDescription.result)
    {
        id obj = [nwobjItemDescription.result objectForKey:@"itemcount"];
        if (obj && [obj isKindOfClass:[NSNumber class]])
        {
            _totalCount = [obj unsignedIntegerValue];
            if (self.progress)
                self.progress.totalUnitCount = _totalCount;
        }
        
        obj = [nwobjItemDescription.result objectForKey:@"All_Items"];
        if (obj && [obj isKindOfClass:[NSArray class]])
        {
            _completeCount = _completeCount + [obj count];
            if (self.progress)
                self.progress.completedUnitCount = _completeCount;
        }
        
        if (_completeCount < _totalCount && isFisrtRequest)
        {
            isFisrtRequest = NO;
            [self runAllRest];
        }
        else if (_delegate && _completeCount >= _totalCount)
        {
            [_delegate itemDescriptionComplete:result itemDescription:nil];
            [self finishLoading];
        }
    }
    else if (_delegate)
    {
        [_delegate itemDescriptionComplete:result itemDescription:nil];
        [self finishLoading];
    }
}

- (void) allItemsDescription:(int)result items:(NSArray<ItemInformation *> *)items{
}

- (void) finishLoading
{
    self.delegate = nil;
    [helpers removeAllObjects];
}

@end
