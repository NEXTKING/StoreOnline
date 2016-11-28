//
//  CaseInterface.hpp
//  TestDLLLibrary
//
//  Created by Admin on 14.10.15.
//  Copyright © 2015 Admin. All rights reserved.
//

#ifndef CaseInterface_hpp
#define CaseInterface_hpp

#include <stdio.h>


class iOSStreamInterface
{
public:
    virtual bool write  (unsigned char * buffer, int bufferSize) = 0;
    virtual bool read   (unsigned char * buffer, int * pLenIncBuffer, int timeout, bool &bwastimeout)  = 0;
};


#endif /* CaseInterface_hpp */
