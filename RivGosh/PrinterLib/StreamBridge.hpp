//
//  StreamBridge.hpp
//  BluetoothPrinterSDK
//
//  Created by Denis Kurochkin on 15/10/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#ifndef StreamBridge_hpp
#define StreamBridge_hpp

#include <stdio.h>
#include "IOSStreamInterface.h"
#include "MoebiusPrinter_C_Interface.h"

class StreamBridge: public iOSStreamInterface
{
    
public:
    bool write (unsigned char * buffer, int bufferSize);
    bool read   (unsigned char * buffer, int * pLenIncBuffer, int timeout, bool &bwastimeout);
    StreamBridge(void *bridgeObject);
    ~StreamBridge();
    
private:
    void *bridgeObject;
    
};

#endif /* StreamBridge_hpp */
