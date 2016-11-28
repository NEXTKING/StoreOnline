#ifndef _STDAFX_
#define _STDAFX_

#ifdef _MSC_VER


// Insert your headers here
#define WIN32_LEAN_AND_MEAN		// Exclude rarely-used stuff from Windows headers


#define USE_PROSH_DEBUG

#include <windows.h>

#include <io.h>

#include <stdio.h>

#include <atlbase.h>

#include <share.h>

#ifdef _ZWINRT

#define MOEBIUSLIB_API
#define EXTSTATIC

#else

#ifdef MOEBIUSLIB_EXPORTS
#define MOEBIUSLIB_API __declspec(dllexport)
#else
#define MOEBIUSLIB_API __declspec(dllimport)
#endif


#define EXTSTATIC    static

#endif

#define  _CRT_SECURE_NO_WARNINGS
#define  _CRT_SECURE_NO_DEPRECATE
#define  _ATL_SECURE_NO_DEPRECATE

#pragma warning(disable:4127)
#pragma warning(disable:4996)
#pragma warning(disable:4311)
#pragma warning(disable:4312)

#else

#include <time.h>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <string.h>
#include "TargetConditionals.h"

typedef unsigned char   BYTE;
#if __LP64__
typedef bool            BOOL;
#else
typedef signed char     BOOL;
#endif
typedef short           WORD;
typedef int             DWORD;
typedef void*           LPVOID;
typedef void            VOID;
typedef int             LONG;

#define TRUE      1
#define FALSE     0

#define MOEBIUSLIB_API
#define CALLBACK
#define EXTSTATIC

#define ZeroMemory(P,L)    memset(P, 0, L)
#define _itoa     Itoa
#define _ltoa     Itoa

#define MAX_PATH     255

#endif

#define EXTEXPORT    MOEBIUSLIB_API

#endif
