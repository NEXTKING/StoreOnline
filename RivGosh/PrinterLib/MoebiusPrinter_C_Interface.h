//
//  MoebiusPrinter_C_Interface.h
//  BluetoothPrinterSDK
//
//  Created by Denis Kurochkin on 15/10/15.
//  Copyright © 2015 Denis Kurochkin. All rights reserved.
//

#ifndef MoebiusPrinter_C_Interface_h
#define MoebiusPrinter_C_Interface_h


bool writeBytes (void *moebiusInstance, unsigned char *buffer, int bufferSize);
bool readBytes  (void *moebiusInstance, unsigned char *buffer, int * pLenIncBuffer, int timeout, bool &bwastimeout);

#endif /* MoebiusPrinter_C_Interface_h */
