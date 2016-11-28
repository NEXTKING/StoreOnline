#if !defined(AFX_COMMPORT_H__F4D3FC81_6449_11D3_A1D0_008048C9FABA__INCLUDED_)
#define AFX_COMMPORT_H__F4D3FC81_6449_11D3_A1D0_008048C9FABA__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


#include "MoebiusAux.h"


#define MAX_MESSAGE_LEN 1024//512

/////////////////////////////////////////////////////////////////////////////
// CCommPort window

class CMoebiusKKM;//CPOSFiscalPrinter;

class CDevice //: public CWnd
{
// Construction
public:
   CDevice(CMoebiusKKM* pMoebiusKKM = NULL) {}
   virtual ~CDevice() {}

   //========================================================================
   BOOL Initialize()
   {
      // CreateFile, PurgeComm, GetCommTimeouts, SetCommTimeouts, GetCommState, SetCommState, SetCommMask... here

      return TRUE;
   }
   BOOL UnInitialize(BOOL fInDllMain = FALSE)
   {
      // EscapeCommFunction, CloseHandle... here

      return TRUE;
   }
   BOOL WriteToDevice(BYTE* pBuffer, int szBuffer, BOOL fUseDSR = TRUE) { return TRUE; }
   BOOL ReadFromDevice(BYTE* ReadDataBuffer, int *pnLengthIncoming, int nLengthwaiting = 0) { return TRUE; }

   //========================================================================
   BYTE GetInternalPrinterStatus(BYTE WaitDelay = 20) { return 0; }
   DWORD GetPowerState() { return 0; }
   BYTE GetLastKkmErr() { return 0; }
   void ClrDTR() {}
   void SetDTR() {}
   BOOL WaitDSR(long szTime/*, BOOL fUseDSR*/) { return TRUE; }
   void ClearDeviceError() {}
   char *GetLastErrorDescription(char *psPrefix = NULL) { return NULL; }
   BOOL GetDSRStatus() { return TRUE; }
   static BOOL IsCommEnable(int ComNum) { return TRUE; }

public:

   BYTE InOutCmd[4096];                //буфер выходных комманд
   BYTE ReadDataBuffer[4096];          //буфер входных данных
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_COMMPORT_H__F4D3FC81_6449_11D3_A1D0_008048C9FABA__INCLUDED_)
