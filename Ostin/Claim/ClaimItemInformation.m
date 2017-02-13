//
//  ClaimItemInformation.m
//  PriceTagDemo
//
//  Created by Evgeny Seliverstov on 27/12/2016.
//  Copyright © 2016 Dataphone. All rights reserved.
//

#import "ClaimItemInformation.h"
#import "MCPServer.h"

@interface ClaimItemInformation ()
@property (nonatomic, strong) NSNumber *claimBindingID;
@property (nonatomic, strong) ItemInformation *itemInformation;
@property (nonatomic, strong) NSNumber *total;
@property (nonatomic, strong) NSNumber *scanned;
@property (nonatomic, strong) NSString *cancelReason;
@end

@implementation ClaimItemInformation

- (instancetype)initWithClaimBindingID:(NSNumber *)claimBindingID itemInformation:(ItemInformation *)itemInformation totalCount:(NSNumber *)total scannedCount:(NSNumber *)scanned cancelReason:(NSString *)cancelReason
{
    self = [super init];
    if (self)
    {
        _claimBindingID = claimBindingID;
        _itemInformation = itemInformation;
        _total = total;
        _scanned = scanned;
        _cancelReason = cancelReason;
    }
    return self;
}

- (NSUInteger)totalCount
{
    return _total.unsignedIntegerValue;
}

- (NSUInteger)scannedCount
{
    return _scanned.unsignedIntegerValue;
}

- (NSString *)barcode
{
    return _itemInformation.barcode;
}

- (NSString *)descriptionForKey:(NSString *)key
{
    NSArray *descriptions = @[@"title", @"articleDescription", @"priceDescription", @"countDescription", @"cancelReasonDescription", @"pictureURLString", @"ean"];
    
    if ([descriptions containsObject:key])
    {
        return [self performSelector:NSSelectorFromString(key)];
    }
    else
        return nil;
}

- (void)setScannedCount:(NSUInteger)scannedCount
{
    _scanned = @(scannedCount);
    [[MCPServer instance] saveClaimBindingWithID:_claimBindingID scanned:_scanned cancelReason:_cancelReason completion:nil];
}

- (void)setCancelReason:(NSString *)cancelReason
{
    _cancelReason = cancelReason;
    [[MCPServer instance] saveClaimBindingWithID:_claimBindingID scanned:_scanned cancelReason:_cancelReason completion:nil];
}

#pragma mark descriptions

- (NSString *)title
{
    return _itemInformation.name;
}

- (NSString *)articleDescription
{
    return _itemInformation.article;
}

- (NSString *)priceDescription
{
    double retailPrice = [[_itemInformation additionalParameterValueForName:@"retailPrice"] doubleValue];
    double catalogPrice = _itemInformation.price;
    return [NSString stringWithFormat:@"%.2f ₽", MIN(retailPrice, catalogPrice)];
}

- (NSString *)countDescription
{
    return [NSString stringWithFormat:@"Количество: %ld из %ld", _scanned.integerValue, _total.integerValue];
}

- (NSString *)cancelReasonDescription
{
    if (_scanned.unsignedIntegerValue < _total.unsignedIntegerValue)
        return [NSString stringWithFormat:@"Причина отклонения: %@", [self cancelReasonDescriptionForID:_cancelReason]];
    else
        return @"";
}

- (NSString *)pictureURLString
{
    return [_itemInformation additionalParameterValueForName:@"imageURL"];
}

- (NSString *)cancelReasonDescriptionForID:(NSString *)reasonID
{
    if (!reasonID)
        return @"не указана";
    else if ([reasonID isEqualToString:@"12430299"])
        return @"витринный экземпляр";
    else if ([reasonID isEqualToString:@"14820299"])
        return @"комплект";
    else if ([reasonID isEqualToString:@"14030299"])
        return @"не найдено в РМ / не хватает количества";
    else if ([reasonID isEqualToString:@"14050299"])
        return @"нет в наличии на ФРЦ/РРЦ";
    else if ([reasonID isEqualToString:@"14060299"])
        return @"недостатки /потертости /не хватает комплектующих";
    else if ([reasonID isEqualToString:@"14070299"])
        return @"на остатках \"0\"";
    else if ([reasonID isEqualToString:@"15420299"])
        return @"инвентаризация";
    else if ([reasonID isEqualToString:@"15670299"])
        return @"товар упакован к отправке";
    else
        return @"";
}

- (NSString *)ean
{
    return [_itemInformation additionalParameterValueForName:@"ean"];
}

@end
