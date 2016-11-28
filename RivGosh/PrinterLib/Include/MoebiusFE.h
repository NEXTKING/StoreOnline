#pragma once

#define MAX_STRING_LENGTH_FE     8192

#include "MoebiusKKM.h"
#include "Device.h"

#pragma pack(8)

namespace MoebiusNG
{
   class MoebiusFE
	{
   public:
      MoebiusFE();

      //.................................
      bool Init(TCHAR *DeviceName);
      bool IsConnected();

      //=================================
   private:
      CMoebiusKKM *m_pMoebiusKKM;
   };
}

#pragma pack()
