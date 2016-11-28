// MoebiusAux.h: interface for the CPrintData, CResponseData, CQueue class.

//#pragma once

#ifndef _MOEBIUSAUX_
#define _MOEBIUSAUX_

#include <thread>
#include <chrono>
#include <mutex>
#include <condition_variable>
#include <queue>

class CClock
{
public:
   static long now()
   {
#ifdef WIN32
#ifdef _USING_V110_SDK71_
      return (long)GetTickCount();
#else
      return (long)GetTickCount64();
#endif
#else
      using namespace std::chrono;
      return (unsigned long)duration_cast<milliseconds>(steady_clock::now().time_since_epoch()).count();
#endif
   }
   static void sleep(int timeoutms)
   {
#ifdef WIN32
      Sleep(timeoutms);
#else
      std::this_thread::sleep_for(std::chrono::milliseconds(timeoutms));
#endif
   }
};

class semaphore
{
private:
   std::mutex mutex_;
   std::condition_variable condition_;
   unsigned long count_;

public:
   semaphore(int count = 0) : count_(count) {}

   void notify()
   {
      std::unique_lock<std::mutex> lock(mutex_);
      ++count_;
      condition_.notify_one();
   }
   void notify_all()
   {
      std::unique_lock<std::mutex> lock(mutex_);
      ++count_;
      condition_.notify_all();
   }
   void wait()
   {
      std::unique_lock<std::mutex> lock(mutex_);
      while (count_ == 0)
         condition_.wait(lock);
      --count_;
   }
   bool wait_for(int timeoutms)
   {
      std::unique_lock<std::mutex> lock(mutex_);
      while (count_ == 0)
      {
         if (timeoutms)
            CClock::sleep(timeoutms);
         if (condition_.wait_for(lock, std::chrono::milliseconds(0)) == std::cv_status::timeout)
            return false;
      }
      --count_;
      return true;
   }
   //bool wait_for(int timeoutms)
   //{
   //   std::unique_lock<std::mutex> lock(mutex_);
   //   while (count_ == 0)
   //   {
   //      if (condition_.wait_for(lock, std::chrono::milliseconds(timeoutms)) == std::cv_status::timeout)
   //         return false;
   //   }
   //   --count_;
   //   return true;
   //}
   void reset()
   {
      std::unique_lock<std::mutex> lock(mutex_);
      count_ = 0;
   }
};

class CPrintData
{
public:
	CPrintData(){}
	CPrintData(long len)
	{
		Data = new BYTE[len];
		szData = len;
	}
	~CPrintData()
	{
		delete [] Data;
	}

	BYTE*   Data;
	long    szData;
	long    Station;
	long    OutputID;
	long	szResponceData;
	BOOL	fLastCmd;
	long    WaitDelay;
	BOOL    fDataRqst;
};

class CResponseData
{
public:
	CResponseData()
	{
		szData = 0;
		Data = NULL;
		TypeCmd = 0;
	}

	CResponseData(long len)
	{
		TypeCmd = 0;
		szData = len;
		if(szData)
			Data = new BYTE[len];
		else
			Data = NULL;
	}
	~CResponseData()
	{
		if(Data)
			delete [] Data;
	}

	BYTE*   Data;
	long    szData;
	long    Station;
	long    OutputID;
	BYTE	ResponseCode;
	BYTE    TypeCmd;
	BOOL    fDataRqst;
};

template <class N> class CQueue//CPrintDataQueue
{
public:
	CQueue()
	{
      m_pQueueAvailable = new semaphore;
	}

	~CQueue()
	{
		RemoveAll();
      delete m_pQueueAvailable;
	}

	void RemoveAll()
	{
      std::unique_lock<std::mutex> lock(m_Lock);

      m_pQueueAvailable->reset();

      if (DataQueue.empty())
         return;

		int NumElements = (int)DataQueue.size();

		for(int i = 0; i < NumElements; i++)
		{
         N* p = DataQueue.front();
         delete p;
         DataQueue.pop();
		}
	}

	void Add(N* pData)//CPrintData
	{
      std::unique_lock<std::mutex> lock(m_Lock);

      DataQueue.push(pData);
		m_pQueueAvailable->notify();
	}

	N* Get()
	{
      std::unique_lock<std::mutex> lock(m_Lock);

      if (DataQueue.empty())
         return NULL;
   
      N* p = DataQueue.front();
      DataQueue.pop();
      return p;
   }

	int GetSize()
	{
      std::unique_lock<std::mutex> lock(m_Lock);
		
      return (int)(DataQueue.size());
	}

private:
   std::mutex m_Lock;
   std::queue<N*> DataQueue;

public:
   semaphore *m_pQueueAvailable;

};

#endif
