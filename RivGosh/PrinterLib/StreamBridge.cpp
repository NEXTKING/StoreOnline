//
//  StreamBridge.cpp
//  BluetoothPrinterSDK
//
//  Created by Denis Kurochkin on 15/10/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#include "StreamBridge.hpp"
#include <chrono>
#include <thread>
#include <iostream>

StreamBridge::StreamBridge(void* bridgeObj)
{
    bridgeObject = bridgeObj;
};

bool StreamBridge::write (unsigned char * buffer, int bufferSize)
{
    return writeBytes(bridgeObject, buffer, bufferSize);
};


bool StreamBridge::read (unsigned char * buffer, int * pLenIncBuffer, int timeout, bool &bwastimeout)
{
    return readBytes(bridgeObject, buffer, pLenIncBuffer, timeout, bwastimeout);
};

StreamBridge::~StreamBridge()
{
    bridgeObject = NULL;
};