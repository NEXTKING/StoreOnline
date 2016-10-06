//
//  MCPServer.m
//  Checklines
//
//  Created by Denis Kurochkin on 15.09.14.
//  Copyright (c) 2014 Denis Kurochkin. All rights reserved.
//

#import "MCPServer.h"
#import "MCPNetworkImpl.h"
#import "MCPSimulatorImpl.h"
#import "MCPOfflineInmpl.h"

#if __has_include("MCPNetworkImpl+RivGosh.h")
#import "MCPNetworkImpl+RivGosh.h"
#endif
#if __has_include("MCPSimulatorImpl+Ostin.h")
#import "MCPOfflineInmpl+Ostin.h"
#endif

static id<MCProtocol> __inst = Nil;

@implementation MCPServer

// Singleton implementation
+ (id<MCProtocol>) instance
{
    if ( __inst == nil )
    {
        
        
#if defined(RIVGOSH)
        __inst = [[MCPNetworkImpl_RivGosh alloc] init];
#elif defined(OSTIN)
        __inst = [[MCPOfflineInmpl_Ostin alloc] init];
#else
        
    #ifdef OFFLINE
            __inst = [[MCPOfflineInmpl alloc] init]; // communication with local data storage
            //__inst = [[MCPSimulatorImpl alloc] init];
    #else
            __inst = [[MCPNetworkImpl alloc] init]; // communication with real web-server
            //__inst = [[MCPSimulatorImpl alloc] init]; // simulation for test purposes
    #endif
#endif
    }
    
    return __inst;
}

+ (void) destroy
{
    if ( __inst != Nil )
    {
        __inst = Nil;
    }
}

@end
