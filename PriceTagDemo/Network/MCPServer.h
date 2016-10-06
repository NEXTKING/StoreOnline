//
//  MCPServer.h
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MCProtocol+RivGosh.h"
#import "MCProtocol+Ostin.h"

#define ACCESS_TOKEN_AUTO Nil

@interface MCPServer : NSObject
{
}

#if defined(RIVGOSH) || defined(MELON)
+ (id<MCProtocolRivGosh>) instance;
#elif defined (OSTIN)
+ (id<MCProtocolOstin>) instance;
#else
+ (id<MCProtocol>) instance;
#endif

@end
