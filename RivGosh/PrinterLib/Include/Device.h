/////////////////////////////////////////////////////////////////////////////////////
//
// ----------------------------- ComPort --------------------------------------------
//
/////////////////////////////////////////////////////////////////////////////////////

#if !defined(AFX_COMMPORT_H__F4D3FC81_6449_11D3_A1D0_008048C9FABA__INCLUDED_)
#define AFX_COMMPORT_H__F4D3FC81_6449_11D3_A1D0_008048C9FABA__INCLUDED_

//#include "MoebiusKKM.h"

//#pragma pack(8)

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#include "MoebiusAux.h"
#include "IOSStreamInterface.h"

#pragma pack(8)

#define MAX_MESSAGE_LEN       4096

/////////////////////////////////////////////////////////////////////////////
#define MAX_STRING_LENGTH_FE              8192
#define READ_TIMEOUT                      20000

class CMoebiusKKM;

class CDevice //: public CWnd
{
   // Construction
public:
   CDevice(CMoebiusKKM* pMoebiusKKM = NULL)
   {
      m_pMoebiusKKM = pMoebiusKKM;
   }
   virtual ~CDevice() {}

   //========================================================================
   BOOL Initialize()
   {
      return TRUE;
   }
   BOOL UnInitialize(BOOL fInDllMain = FALSE) { return TRUE; }

   BOOL WriteToDevice(BYTE* pBuffer, int szBuffer, BOOL fUseDSR = TRUE)
   {
	   if (!m_bInitialized /*|| (m_NotResponseCount <= 0)*/)
	   {
		   return FALSE;
	   }
	   
	   return m_pIAppleSDK->write(pBuffer, szBuffer) ? TRUE : FALSE;
   }

   BOOL ReadFromDevice(BYTE* pBuffer, int *pnLengthIncoming, int nLengthWaiting = 0)
   {
	   if (!m_bInitialized /*|| (m_NotResponseCount <= 0)*/)
	   {
		   return FALSE;
	   }

	   *pnLengthIncoming = 0;
	   pBuffer[0] = 0x00;

	   bool bWasTimeout = false;
	   return m_pIAppleSDK->read(pBuffer, pnLengthIncoming, 25, bWasTimeout) ? TRUE : FALSE;
   }

   //========================================================================
   BYTE GetLastKkmErr() { return TRUE; }
   void ClrDTR() {}
   void SetDTR() {}
   void ClearDeviceError() {}
   char *GetLastErrorDescription(char *psPrefix = NULL) { return NULL; }
   BOOL GetDSRStatus() { return TRUE; }
   static BOOL IsCommEnable(int ComNum) { return TRUE; }

   static int GetSystemError(char *sError, int nMessageId /*= GetLastError()*/, char *sHeader = NULL) { return 0; }

public:

   BYTE InOutCmd[MAX_MESSAGE_LEN];              //буфер выходных комманд
   BYTE ReadDataBuffer[MAX_MESSAGE_LEN];        //буфер входных данных
   char m_sError[1024];                         //сообщение об ошибке

   char m_DeviceName[1024];

   // --------------------------------------------------------------
   CMoebiusKKM *m_pMoebiusKKM;

   // --------------------------------------------------------------
   iOSStreamInterface *m_pIAppleSDK = NULL;

   //===============================================================
   bool        m_bInitialized = false;
};

/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#pragma pack()

#endif // !defined(AFX_COMMPORT_H__F4D3FC81_6449_11D3_A1D0_008048C9FABA__INCLUDED_)
