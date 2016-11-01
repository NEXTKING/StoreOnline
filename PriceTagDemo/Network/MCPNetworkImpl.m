//
//  MCPNetworkImpl.m
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "MCPNetworkImpl.h"
#import "NwobjAuthorization.h"
#import "NwobjItemDescription.h"
#import "NwobjClientCard.h"
#import "NwobjSendCart.h"
#import "NwobjInventoryItemDescription.h"
#import "NwobjDiscounts.h"

@implementation MCPNetworkImpl

@synthesize userId = _userId;
@synthesize accessToken = _accessToken;
@synthesize lastResult = _lastResult;

- (id) init
{
    self = [super init];
    
    if ( self )
    {
        [self clearSession];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingsDidChange) name:NSUserDefaultsDidChangeNotification object:nil];
        [self settingsDidChange];
    }
    
    return self;
}

- (void) settingsDidChange
{
#ifdef DESONDO
    self.serverAddress = @"http://185.36.157.150:7755/storeService/Service1.svc/json";
#else
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *protocol = [[NSUserDefaults standardUserDefaults] valueForKey:@"protocol_preference"];
    NSString *host     = [[NSUserDefaults standardUserDefaults] valueForKey:@"host_preference"];
    NSString *port     = [[NSUserDefaults standardUserDefaults] valueForKey:@"port_preference"];
    NSString *path     = [[NSUserDefaults standardUserDefaults] valueForKey:@"path_preference"];
    NSMutableString *mutableString = [NSMutableString stringWithFormat:@"%@://%@%@",protocol, host, port.length > 0?[NSString stringWithFormat:@":%@", port]:@""];
    if (path.length > 0)
        [mutableString appendFormat:@"/%@", path];
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"qwe" message:mutableString delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //[alert show];
        
    self.serverAddress = mutableString;
#endif
}


- (void) clearSession
{
    self.userId = @"";
    self.accessToken = @"";
    self.lastResult = 0;
}

- (void) hello:(id<HelloDelegate>)delegate
{
    
}

- (void) itemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code shopCode:(NSString *)shopCode isoType:(int)type
{
    NwobjItemDescription *nwobjItemDescription = [NwobjItemDescription new];
    nwobjItemDescription.barcode = code;
    nwobjItemDescription.shopId = shopCode;
    nwobjItemDescription.delegate = delegate;
    [nwobjItemDescription run:_serverAddress];
}

- (void) authorization:(id<AuthorizationDelegate>)delegate code:(NSString *)code
{
    NwobjAuthorization *nwobjAuth = [NwobjAuthorization new];
    nwobjAuth.barcode = code;
    nwobjAuth.delegate = delegate;
    [nwobjAuth run:_serverAddress];
}

- (void) clinetCard:(id<ClientCardDelegate>)delegate cardNumber:(NSString *)card
{
    NwobjClientCard *nwobjClient = [NwobjClientCard new];
    nwobjClient.cardNumber = card;
    nwobjClient.delegate = delegate;
    [nwobjClient run:_serverAddress];
}

- (void) sendCart:(id<SendCartDelegate>)delegate cartData:(NSDictionary *)cartData
{
    NwobjSendCart *nwobjSendCart = [NwobjSendCart new];
    nwobjSendCart.delegate = delegate;
    nwobjSendCart.cartData = cartData;
    [nwobjSendCart run:_serverAddress];
}

- (void) inventoryItemDescription:(id<ItemDescriptionDelegate>)delegate itemCode:(NSString *)code
{
    NwobjInventoryItemDescription *nwobjItemDescription = [NwobjInventoryItemDescription new];
    nwobjItemDescription.barcode = code;
    nwobjItemDescription.delegate = delegate;
    [nwobjItemDescription run:_serverAddress];
}

- (void) discounts:(id<DiscountsDelegate>)delegate receiptId:(NSString *)receiptID
{
    NwobjDiscounts *nwobjDiscounts = [NwobjDiscounts new];
    nwobjDiscounts.receiptID = receiptID;
    nwobjDiscounts.delegate = delegate;
    [nwobjDiscounts run:_serverAddress];
}

- (void) endOfInvent:(id<SendCartDelegate>)delegate shopID:(NSString *)shopID password:(NSString *)pwd
{
    
}

- (void) zones:(id<ZonesDelegate>)delegate shopID:(NSString *)shopID
{
    
}

@end
