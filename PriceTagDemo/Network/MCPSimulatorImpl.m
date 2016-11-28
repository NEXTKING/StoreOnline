//
//  MCPSimulatorImpl.m
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "MCPSimulatorImpl.h"
#import "Logger.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "ItemInformation.h"


#ifndef DEBUG
static const double _network_delay = 1.0;
#else
static const double _network_delay = 1.0;
#endif
static const double _distance_in_one_degree = 111000.0;
static const double _longitude_scale_factor = 0.55;
//static double __points_param_latitude = 0.0;
//static double __points_param_longitude = 0.0;



@interface MCPSimulatorImpl()
{
    NSMutableArray *_discountsArray;
    
    NSString *_currentTaskId;
}

@property (nonatomic, copy) NSString* currentBarcode;
@property (nonatomic, copy) NSString* currentLogin;
@property (nonatomic, copy) NSString* currentClientCard;

- (void) generateData;
- (void) destroyData;

@end

@implementation MCPSimulatorImpl

@synthesize accessToken = _accessToken;
@synthesize lastResult = _lastResult;

- (id) init
{
    self = [super init];
    
    if ( self )
    {
        [self clearSession];
        srand((int)self);
        [self generateData];
    }
    
    return self;
}

- (void) dealloc
{
    [self destroyData];
}

- (void) enableNetworkActivityIndicator:(BOOL)enable
{
    if ( [[[UIApplication sharedApplication] delegate] isKindOfClass:[AppDelegate class]] )
    {
        AppDelegate* appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
        if ( enable )
        {   // enable network activity indicator
            [appDelegate enableNetworkIndicator];
        }
        else
        {   // disable network activity indicator
            [appDelegate disableNetworkIndicator];
        }
    }
}

- (CLLocationCoordinate2D) generateCoordinate:(CLLocationCoordinate2D)baseCoord page:(NSInteger)pageNum record:(NSInteger)recNum
{
    CLLocationCoordinate2D f_ret = {.latitude = baseCoord.latitude, .longitude = baseCoord.longitude};
    
    double point_distance = 300*pageNum+100*recNum;
    double point_angle = (double)rand()/(double)RAND_MAX*2*3.1415926535;
    double lat_offs = cos(point_angle)*(point_distance/_distance_in_one_degree);
    double long_offs = sin(point_angle)*(point_distance/(_distance_in_one_degree*_longitude_scale_factor));
    
    f_ret.latitude += lat_offs;
    f_ret.longitude += long_offs;
    
    return f_ret;
}

- (double) distanceOf:(CLLocationCoordinate2D)pointA from:(CLLocationCoordinate2D)pointB
{
    double lat_offs = (pointB.latitude - pointA.latitude)*_distance_in_one_degree;
    double long_offs = (pointB.longitude - pointA.longitude)*(_distance_in_one_degree*_longitude_scale_factor);

    double f_ret = sqrt(lat_offs*lat_offs+long_offs*long_offs);
    
    return f_ret;
}

- (NSString*) generateTimestamp:(NSInteger)page record:(NSInteger)num
{
    struct tm base_timestamp;
    memset(&base_timestamp, 0, sizeof(base_timestamp));
    base_timestamp.tm_year = 2013 - 1900;
    base_timestamp.tm_mon = 5 - 1;
    base_timestamp.tm_mday = 30;
    base_timestamp.tm_hour = 15;
    base_timestamp.tm_min = 30;
    base_timestamp.tm_sec = 45;
    
    time_t base_time = mktime(&base_timestamp);
    // base time modification
    base_time -= page * 3600 * 33 + num*12345+15;
    struct tm *gen_timestamp = gmtime(&base_time);
    
    return [NSString stringWithFormat:@"%04d-%02d-%02d %02d:%02d:%02d+00:00",
            gen_timestamp->tm_year + 1900,
            gen_timestamp->tm_mon + 1,
            gen_timestamp->tm_mday,
            gen_timestamp->tm_hour,
            gen_timestamp->tm_min,
            gen_timestamp->tm_sec
            ];
}

- (NSString*) generateTid:(NSInteger)page record:(NSInteger)num
{
    return [NSString stringWithFormat:@"%d", 19234567-page*100-num];
}

- (NSDate*) dateFromString:(NSString*)string
{
    // string format: YYYYMMDDHHMISS
    struct tm timestamp;
    memset(&timestamp, 0, sizeof(timestamp));
    timestamp.tm_year = [[string substringWithRange:NSMakeRange(0, 4)] intValue] - 1900;
    timestamp.tm_mon = [[string substringWithRange:NSMakeRange(4, 2)] intValue] - 1;
    timestamp.tm_mday = [[string substringWithRange:NSMakeRange(6, 2)] intValue];
    timestamp.tm_hour = [[string substringWithRange:NSMakeRange(8, 2)] intValue];
    timestamp.tm_min = [[string substringWithRange:NSMakeRange(10, 2)] intValue];
    timestamp.tm_sec = [[string substringWithRange:NSMakeRange(12, 2)] intValue];
    //timestamp.tm_gmtoff = 0;
    //timestamp.tm_isdst = 0;
    //timestamp.tm_wday = -1;
    //timestamp.tm_yday = -1;
    
    return [NSDate dateWithTimeIntervalSince1970:mktime(&timestamp)];
}

- (void) generateData
{
    _itemsDictionary = [[NSMutableDictionary alloc] init];
    
    {
        ItemInformation *itemInfo = [ItemInformation new];
        itemInfo.name       = @"Чай зеленый Просто Азбука Молочный улун";
        itemInfo.article    = @"812472";
        itemInfo.barcode    = @"9900000206178";
        itemInfo.price      = 460.00;
        
        {
            NSMutableArray *additional = [NSMutableArray new];
            
            {
                ParameterInformation *paramInfo = [ParameterInformation new];
                paramInfo.name = @"Материал";
                paramInfo.value = @"ХлопокХлопокХлопокХлопокХлопокХлопокХлопокХлопокХлопокХлопокХлопок ХлопокХлопокХлопокм  Хлопок Хлопок м м v v Хлопок vХлопок ХлопокХлопок Хлопок Хлопок Хлопок Хлопок Хлопок ";
                [additional addObject:paramInfo];
            }
            {
                ParameterInformation *paramInfo = [ParameterInformation new];
                paramInfo.name = @"Размер";
                paramInfo.value = @"42";
                [additional addObject:paramInfo];
            }
            {
                ParameterInformation *paramInfo = [ParameterInformation new];
                paramInfo.name = @"Вонючесть";
                paramInfo.value = @"кХлопокХлопокХлопокХлопокХлопокХлопокХлопок ХлопокХлопокХлопокм  Хлопок Хлопок м м v v Хлопок vХлопок ХлопокХлопок Хлопок Хлопок Хлопок Хлопок Хлопок";
                [additional addObject:paramInfo];
            }
            
            itemInfo.additionalParameters = additional;
        }
        
        [_itemsDictionary setObject:itemInfo forKey:@"9900000206178"];
    }
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"items" ofType:@"csv"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSString *fileString = [[NSString alloc] initWithData:fileData encoding:NSUTF8StringEncoding];
    NSArray* csvRows = [fileString componentsSeparatedByString:@"\r\n"];
    
    for (NSString* csvRow in csvRows) {
        
        NSArray* parsedCSV = [csvRow componentsSeparatedByString:@";"];
        
        if (parsedCSV.count < 7)
            continue;
        
        ItemInformation *itemInfo = [ItemInformation new];
        itemInfo.itemId         = [parsedCSV[0] integerValue];
        itemInfo.barcode        = parsedCSV[1];
        itemInfo.article        = parsedCSV[2];
        itemInfo.name           = parsedCSV[3];
        itemInfo.price          = [parsedCSV[6] doubleValue];
        itemInfo.imageName      = parsedCSV[7];
        
        
        ParameterInformation *sizeInfo = [ParameterInformation new];
        sizeInfo.name = @"Размер";
        sizeInfo.value = parsedCSV[4];
        
        ParameterInformation *paramInfo = [ParameterInformation new];
        paramInfo.name = @"stock";
        paramInfo.value = parsedCSV[5];
        itemInfo.additionalParameters = @[sizeInfo,paramInfo];
        
        [_itemsDictionary setObject:itemInfo forKey:parsedCSV[1]];
        
    }
    
    
  
    
    //Filling discounts array with sample stuff
    
    _discountsArray = [NSMutableArray new];
    
    {
        DiscountInformation* discount = [DiscountInformation new];
        discount.name = @"Birthday";
        discount.enabled = YES;
        discount.count = 5;
        [_discountsArray addObject:discount];
    }
    
    {
        DiscountInformation* discount = [DiscountInformation new];
        discount.name = @"Loyality";
        discount.enabled = YES;
        discount.count = 5;
        [_discountsArray addObject:discount];
    }
    
    {
        DiscountInformation* discount = [DiscountInformation new];
        discount.name = @"Only today";
        discount.enabled = NO;
        discount.count = 5;
        [_discountsArray addObject:discount];
    }
    
}

- (void) destroyData
{
}

- (void) clearSession
{
    self.accessToken = @"";
    self.lastResult = 0;
}

- (void) hello:(id<HelloDelegate>) delegate;
{
    
}

- (void) helloWithMessage:(NSString *)msg
{
    
}

#pragma mark - Login & Registration

/*- (void) login:(id<LoginDelegate>)delegate phone:(NSString *)phone password:(NSString *)password
{
    [self enableNetworkActivityIndicator:YES];
    [self performSelector:@selector(delayedLogin:) withObject:delegate afterDelay:_network_delay];
}

- (void) delayedLogin:(id<LoginDelegate>)delegate
{
    [self enableNetworkActivityIndicator:NO];
    if (delegate)
        [delegate loginComplete:0 userId:@"userID" sessionId:@"0123456789"];
}
*/

- (void) inventoryItemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(_network_delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [delegate itemDescriptionComplete:1 itemDescription:nil];
    });
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode isoType:(int)type
{
    self.currentBarcode = code;
    [self enableNetworkActivityIndicator:YES];
    [self performSelector:@selector(delayedItemDescription:) withObject:delegate afterDelay:_network_delay];
}

- (void) delayedItemDescription: (id<ItemDescriptionDelegate>) delegate
{
    [self enableNetworkActivityIndicator:NO];
    ItemInformation *itemInfo = [_itemsDictionary objectForKey:_currentBarcode];
    int result = itemInfo ? 0:1;
    
    if (!delegate)
        return;
    
    if (!_currentBarcode)
        [delegate allItemsDescription:0 items:_itemsDictionary.allValues];
    else
        [delegate itemDescriptionComplete:result itemDescription:itemInfo];
}

- (void) authorization:(id<AuthorizationDelegate>)delegate code:(NSString *)code
{
    self.currentLogin = code;
     [self performSelector:@selector(delayedAuthorization:) withObject:delegate afterDelay:_network_delay];
}

- (void) delayedAuthorization:(id<AuthorizationDelegate>) delegate
{
    if (  [self.currentLogin isEqualToString:@"111111"]
        ||[self.currentLogin isEqualToString:@"222222"]
        ||[self.currentLogin isEqualToString:@"333333"])
    {
        [delegate authorizationComplete:0 rights:nil];
    }
    else
        [delegate authorizationComplete:1 rights:nil];
}

- (void) clinetCard:(id<ClientCardDelegate>)delegate cardNumber:(NSString *)card
{
    self.currentClientCard = card;
    [self performSelector:@selector(delayedClentCard:) withObject:delegate afterDelay:_network_delay];
}

- (void) delayedClentCard:(id<ClientCardDelegate>)delegate
{
    if ([self.currentClientCard isEqualToString:@"123456789"])
        [delegate clientCardComplete:0 description:@"Smbd" hint:nil receiptID:nil];
    else if ([self.currentClientCard isEqualToString:@"987654321"])
        [delegate clientCardComplete:0 description:@"Moron" hint:@"That's the sample hint" receiptID:nil];
    else
        [delegate clientCardComplete:1 description:nil hint:nil receiptID:nil];
        
}

- (void) discounts:(id<DiscountsDelegate>)delegate receiptId:(NSString *)receiptID
{
    [self performSelector:@selector(delayedDiscounts:) withObject:delegate afterDelay:_network_delay];
}

- (void) delayedDiscounts: (id<DiscountsDelegate>)delegate
{
    if (delegate)
        [delegate discountsComplete:0 discounts:_discountsArray];
}


@end
