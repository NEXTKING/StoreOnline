#ifndef _STRUCT_
#define _STRUCT_

#pragma pack(push)
#pragma pack(1)


const BYTE RC_CMD_OK			= 0;//RC_NOT_INIT+3;

const BYTE RC_MONEY_OVER    = 0xED;

const BYTE RC_FNC_NOT_FOUND = 0xEE;
const BYTE RC_OBJ_NOT_EXIST = 0xEF;

const BYTE RC_NOT_INIT			= 0xF0;//0xA0;//14.02.07
const BYTE RC_CMD_WRITE_ERR		= RC_NOT_INIT+1;
const BYTE RC_PTR_NOT_READY_DSR	= RC_NOT_INIT+2;
const BYTE RC_PTR_NOT_READY_PRG	= RC_NOT_INIT+3;
const BYTE RC_CMD_RESP_TIMEOUT	= RC_NOT_INIT+4;//??????? 
const BYTE RC_PTR_RESP_ERROR	= RC_NOT_INIT+5;//??????? Проанализировать логи и сделать доп. запрос off-line статуса мебиуса и принтера
const BYTE RC_CMD_RESP_LARGE	= RC_NOT_INIT+6;
const BYTE RC_CMD_RESP_SMALL	= RC_NOT_INIT+7;
const BYTE RC_CMD_ANY_DATA		= RC_NOT_INIT+8;
const BYTE RC_PORT_NOT_OPEN		= RC_NOT_INIT+9;
const BYTE RC_CMD_BREAK			= RC_NOT_INIT+10;
const BYTE RC_PS_OFF			= RC_NOT_INIT+11;
const BYTE RC_PS_OFFLINE		= RC_NOT_INIT+12;
const BYTE RC_CMD_PARAM_ERR		= RC_NOT_INIT+13;
const BYTE RC_CMD_CMD_NUM_ERR	= RC_NOT_INIT+14;
const BYTE RC_CMD_PREV_CMD_RUN	= RC_NOT_INIT+0x0F;
//ошибки которые генерирует MoebiusLib.DLL теперь, во 2-ой версии начинаются не с F0, 
//			а с A0, т.к. F8 - мог генерировать сам мебиус и былобы не понятно это ошибка или код ответа от ФР

//#define MBC 1
const LONG FPTR_S_JOURNAL_DLL                   = 1;
const LONG FPTR_S_RECEIPT_DLL                   = 2;
const LONG FPTR_S_SLIP_DLL                      = 4;
const LONG FPTR_S_FISCAL_RECEIPT = 8;

const DWORD MAX_MONEY_VALUE = 0x7FFFFFFF;


#define COVER_OPEN		0x0001
#define JOURNAL_EMPTY	0x0002
#define JOURNAL_LOW		0x0004
#define RECEIPT_EMPTY	0x0008
#define RECEIPT_LOW		0x0010
#define SLIP_BOTTOM		0x0020
#define SLIP_INSERTED	0x0040
#define SLIP_EMPTY		0x0080
#define HARDWARE_ERROR	0x0100
//#define OFFLINE			0x0200
#define JOURNAL_OK		0x0400
#define RECEIPT_OK		0x0800
#define OUTPUT_COMPLETE 0x1000
#define COVER_CLOSED	0x2000
#define HARDWARE_OK		0x4000
//#define ONLINE			0x8000
#define PS_UNKNOWN      0x8000
#define PS_ONLINE       0x8001
#define PS_OFFLINE      0x8002
#define PS_OFF          0x8003
//#define PS_OFF_OFFLINE  = 2004;
#define SC_PTR_READY	0x8004//	= 0;
#define SC_PTR_BUSY		0x8005//	= 1;
#define SC_PTR_PWR_ON	0x8006//	= 1;

#define SC_FPTR_REC_ERR	0x8007//	= 1;

/*

/////////////////////////////////////////////////////////////////////
// OPOS "State" Property Constants
/////////////////////////////////////////////////////////////////////
const LONG OPOS_S_CLOSED        = 1;
const LONG OPOS_S_IDLE          = 2;
const LONG OPOS_S_BUSY          = 3;
const LONG OPOS_S_ERROR         = 4;


/////////////////////////////////////////////////////////////////////
// OPOS "ResultCode" Property Constants
/////////////////////////////////////////////////////////////////////
const LONG OPOS_SUCCESS         =   0;
const LONG OPOS_E_NOTCLAIMED    = 103;
const LONG OPOS_E_FAILURE       = 111;
const LONG OPOS_E_TIMEOUT       = 112;
const LONG OPOS_E_BUSY          = 113;
const LONG OPOS_E_EXTENDED      = 114;
*/
typedef enum {
 A_NO_DATA = 0,
 A_SEPR,     /*1*/
 A_1CL,      /*2*/
 A_2CL,      /*3*/
 A_3CL,      /*4*/
 AT_1CL,     /*5*/
 AT_2CL,     /*6*/
 AT_3CL,     /*7*/
 A_CARD,     /*8*/
 AT_CARD,    /*9*/
 A_POS,      /*10*/
 AT_POS,     /*11*/
 A_1GS,      /*12*/
 A_2GS,      /*13*/
 A_3GS,      /*14*/
 AT_1GS,     /*15*/
 AT_2GS,     /*16*/
 AT_3GS,     /*17*/
 A_AMNT ,    /*18*/
 AT_AMNT,    /*19*/
 A_1CURRS,   /*20*/
 A_1BASES,   /*21*/
 AT_1CURRS,  /*22*/
 AT_1BASES,  /*23*/
 A_INCR,     /*24*/
 AT_INCR,    /*25*/
 A_DISC,     /*26*/
 AT_DISC,    /*27*/
 A_FIRM,     /*28*/
 AT_FIRM,    /*29*/
 A_KKM,      /*30*/
 AT_KKM,     /*31*/
 A_FM,       /*32*/
 AT_FM,      /*33*/
 A_OPRC,     /*34*/
 AT_OPRC,    /*35*/
 A_OPRN,     /*36*/
 AT_OPRN,    /*37*/
 A_DATE,     /*38*/
 AT_DATE,    /*39*/
 A_TIME,     /*40*/
 AT_TIME,    /*41*/
 A_ISN,      /*42*/
 AT_ISN,     /*43*/
 A_LSN,      /*44*/
 AT_LSN,     /*45*/
 A_TAPE,     /*46*/
 AT_TAPE,    /*47*/
 A_SHIFT,    /*48*/
 AT_SHIFT,   /*49*/
 A_ZERO,     /*50*/
 AT_ZERO,    /*51*/
 A_DOC,      /*52*/
 AT_DOC,     /*53*/
 A_DOCT,     /*54*/
 AT_DOCT,    /*55*/
 A_CURRC ,   /*56*/
 A_BASEC ,   /*57*/
 AT_CURRC,   /*58*/
 AT_BASEC,   /*59*/
 A_CURRCN,   /*60*/
 A_BASECN,   /*61*/
 AT_CURRCN,  /*62*/
 AT_BASECN,  /*63*/
 A_RATE ,    /*64*/
 AT_RATE,    /*65*/
 A_CURRS ,   /*66*/
 A_BASES ,   /*67*/
 AT_CURRS,   /*68*/
 AT_BASES,   /*69*/
 A_PSC,      /*70*/
 A_PSB,      /*71*/
 AT_PSC,     /*72*/
 AT_PSB,     /*73*/
 A_ISC ,     /*74*/
 A_ISB ,     /*75*/
 AT_ISC,     /*76*/
 AT_ISB,     /*77*/
 A_SUMC ,    /*78*/
 A_SUMB ,    /*79*/
 AT_SUMC,    /*80*/
 AT_SUMB,    /*81*/
 A_PAYC ,    /*82*/
 A_PAYB ,    /*83*/
 AT_PAYC,    /*84*/
 AT_PAYB,    /*85*/
 A_PAYCC,    /*86*/
 A_PAYCB,    /*87*/
 AT_PAYCC,   /*88*/
 AT_PAYCB,   /*89*/
 A_PAYICC,   /*90*/
 A_PAYICB,   /*91*/
 AT_PAYICC,  /*92*/
 AT_PAYICB,  /*93*/
 A_CHGC,     /*94*/
 A_CHGB,     /*95*/
 AT_CHGC,    /*96*/
 AT_CHGB,    /*97*/
 A_BACKC ,   /*98*/
 A_BACKB ,   /*99*/
 AT_BACKC,   /*100*/
 AT_BACKB,   /*101*/
 A_END,      /*102*/
 A_PAYGOODS, /*103*/
 AT_PAYGOODS,/*104*/
 A_INCRP,    /*105*/
 AT_INCRP,   /*106*/
 A_DISCP,    /*107*/
 AT_DISCP,   /*108*/
 A_TAX,      /*109*/
 A_TAXT,     /*110*/
 A_TPIN,     /*111*/
 A_TAXR,     /*112*/
 A_RCPINFO,  /*113*/
 N_OF_OBJ
}AtomTypes;

struct fin                             /* financial ic/sc info     */
{  char text[13];
   short rate;
};

typedef enum {
 REL_FREE = 0xFF,
 REL_PROG = 0xFE,
 REL_OK   = 0xFC
} Reliable;

typedef struct{
  BYTE Esc;
  BYTE SP;
  WORD Len;
  BYTE Pid;
  BYTE Code;
  BYTE tsrPW[4];
  BYTE oprCode;
} Header;

typedef struct{
  WORD Year;
  BYTE Month;
  BYTE Day;
  BYTE Hour;
  BYTE Min;
  BYTE Sec;
} Date;

typedef struct{
  DWORD Year;
  DWORD Month;
  DWORD Day;
  DWORD Hour;
  DWORD Min;
  DWORD Sec;
} DateI;

typedef struct{
 BYTE X,Y;
} Coord[3];

typedef struct{
  Header Hdr;
  BYTE  Num;
  BYTE  origPresent;
  BYTE  copyPresent;
  BYTE  field1;
  BYTE  field2;
  BYTE  field3;
  BYTE  field4;
  BYTE  reserved[3];
  Coord  C;  /*NEW EDITION [N_OF_PT]*/
} AtomHeader;

typedef struct{
  AtomHeader H;
  BYTE Len;
  BYTE Txt[40];
} AtText;

typedef struct{
  AtomHeader H;
  BYTE Len;
  BYTE Txt[256];
} AtText256;

typedef struct{
  AtomHeader H;
  BYTE Sum_A[18];
} AtSum;

typedef struct{
  AtomHeader H;
  BYTE Code;
} AtCurrCode;

typedef struct{
  AtomHeader H;
  WORD Num;
} AtNum;

typedef struct{
  AtomHeader H;
  DWORD Code;
} AtCode;

typedef struct{
  AtomHeader H;
  Coord C[5];
} AtFirm;

typedef enum {
 PT_CHK = 0,
 PT_SLIP= 1,
 PT_CTL = 2,
  N_OF_PT
} TapeTypes;

typedef enum {
 DOC_NO = 0,
 DOC_PUT=1,
 DOC_GET=2,
 DOC_ANN=3,
 DOC_RET=4,
 DOC_BUY = 5,
 DOC_SALE= 6,
 DOC_EXCH= 7,
  N_OF_DOC
}DocTypes;

typedef union   // ~~~~~ new version
{
   WORD  v0;
   DWORD v2;
} SlcMode;

typedef struct {
  BYTE		 Mask;
  Date	    Dt;
  char	    FaktNum[16];
  WORD       ShiftNum;
  SlcMode    DocNum;
} KkmState;

typedef union   // ~~~~~ new version
{
   BYTE     dig[8];
   double   dig2;
} MoneyA;

typedef struct 
{
	WORD   TClear       ;//mCMOS->Lr.GenReg.Opr.Clear           ;//Total erase
	WORD   TShow        ;//mCMOS->Lr.GenReg.Opr.Show            ;//Total show
	WORD   DShow        ;//mCMOS->Lr.Opr.Show                   ;//Day reports
	WORD   TFiscal      ;//mCMOS->Io.fskRecord                  ;//Total fiscal days
	MoneyA Annl         ;//mCMOS->Wa.ShiftReg.Cas.AnnlA
	MoneyA Rets[8]      ;//mCMOS->Wa.ShiftReg.Cas.Rets[cntr]
	MoneyA Loan         ;//mCMOS->Wa.ShiftReg.Cas.InComA
	MoneyA Pickup       ;//mCMOS->Wa.ShiftReg.Cas.OutComA
	MoneyA Cash         ;//mCMOS->Wa.ShiftReg.Cas.Pay.CashA
	MoneyA Card         ;//mCMOS->Wa.ShiftReg.Cas.Pay.CardA
	MoneyA Credit       ;//mCMOS->Wa.ShiftReg.Cas.Pay.InCreditA
	MoneyA Goods        ;//mCMOS->Wa.ShiftReg.Cas.Pay.GoodsA
	MoneyA curCash      ;//mCMOS->Wa.ShiftReg.Cas.currentCash
	MoneyA DSale        ;//mCMOS->Wa.ShiftReg.Sum.SaleA
	MoneyA DBuy         ;//mCMOS->Wa.ShiftReg.Sum.BuyA
	struct RTRA
	{ 
		WORD rate;
		DWORD amt;
	}Dtr[16];//mCMOS->cArea.fArea.dtr[i]
	MoneyA DTax         ;//mCMOS->Wa.ShiftReg.Sum.tax
	MoneyA TSale        ;//mCMOS->Lr.GenReg.Sum.SaleA
	MoneyA TBuy         ;//mCMOS->Lr.GenReg.Sum.BuyA
	SlcMode   SlcMd     ;      // ~~~~~ new version
}TotSendHost;

typedef struct 
{
	WORD   TClear       ;//mCMOS->Lr.GenReg.Opr.Clear           ;//Total erase
	WORD   TShow        ;//mCMOS->Lr.GenReg.Opr.Show            ;//Total show
	WORD   DShow        ;//mCMOS->Lr.Opr.Show                   ;//Day reports
	WORD   TFiscal      ;//mCMOS->Io.fskRecord                  ;//Total fiscal days
	MoneyA Annl         ;//mCMOS->Wa.ShiftReg.Cas.AnnlA
	MoneyA Rets[8]      ;//mCMOS->Wa.ShiftReg.Cas.Rets[cntr]
	MoneyA Loan         ;//mCMOS->Wa.ShiftReg.Cas.InComA
	MoneyA Pickup       ;//mCMOS->Wa.ShiftReg.Cas.OutComA
	MoneyA Cash         ;//mCMOS->Wa.ShiftReg.Cas.Pay.CashA
	MoneyA Card         ;//mCMOS->Wa.ShiftReg.Cas.Pay.CardA
	MoneyA Credit       ;//mCMOS->Wa.ShiftReg.Cas.Pay.InCreditA
	MoneyA Goods        ;//mCMOS->Wa.ShiftReg.Cas.Pay.GoodsA
	MoneyA curCash      ;//mCMOS->Wa.ShiftReg.Cas.currentCash
	MoneyA DSale        ;//mCMOS->Wa.ShiftReg.Sum.SaleA
	MoneyA DBuy         ;//mCMOS->Wa.ShiftReg.Sum.BuyA
	struct RTRA
	{ 
		WORD rate;
		DWORD amt;
	}Dtr[16];//mCMOS->cArea.fArea.dtr[i]
	MoneyA DTax         ;//mCMOS->Wa.ShiftReg.Sum.tax
	MoneyA TSale        ;//mCMOS->Lr.GenReg.Sum.SaleA
	MoneyA TBuy         ;//mCMOS->Lr.GenReg.Sum.BuyA
	DWORD   SlcModeNew      ;
}TotSendHostNew;

typedef struct 
{
	DWORD LastKPK;
	DWORD PereregTail;
	DWORD ActivizTail;
	DWORD CloseShiftTail;
}KkmDopInfo;

typedef struct 
{
	char strINN[16];
	char strRN[16];
	char strFiscalPsw[16];
}KkmRegistrInfo;

typedef struct {
  Header     Hdr;
  Date	     Dt;
  BYTE	     Doc;
  BYTE       Req [N_OF_PT];
  BYTE       Copy[N_OF_PT];
} OpMakeCheck;

typedef struct {
  Header     Hdr;
  Date	     date;
  BYTE		 OpCode;
  char		 OpName[24];
  BYTE       bufferIs;
} OpOpenShift;

typedef struct {
  Header     Hdr;
  BYTE       ToClear;
  Date	     Date;
} OpCloseShift;

typedef struct {
  Header     Hdr;
  BYTE		 OpCode;
  char		 OpName[24];
} OpOperator;

typedef struct {
  Header     Hdr;
  char		 OpHeader[256];
} OpCngHeader;

typedef struct {
  Header     Hdr;
  char		 OpPsw[4];
} OpPassword;

typedef struct {
  Header     Hdr;
  char       pWord[16];
} OpGenErase;

typedef struct {
  Header	Hdr;
  BYTE Mirror;
} OpMirror;

typedef struct {
  Header     Hdr;
  Date	     Date;
} OpEKLZActivate;

typedef struct {
  Header	Hdr;
  DWORD SheftNum;
} OpEKLZContrLent;

typedef struct {
  Header	Hdr;
  DWORD KPKnum;
} OpEKLZChek;

typedef struct
{
 char type, cmd, rt, req, cpy, xr, nl, xc, yc, p1,p2,p3,p4,p5,p6,p7,p8,p9;
 DWORD lnum; char *text;
}AtomProperties;

typedef struct {
  Header	Hdr;
  BYTE		ReportType;
  Date	    StartDate;
  Date	    EndDate;
  BYTE		Section;
} OpGetReport;

typedef struct {
  Header	Hdr;
  char      pWord[16];
  BYTE		ReportType;
  BYTE		ReportRange;
  Date	    NowDate;
  Date	    StartDate;
  Date	    EndDate;
  WORD	    StartNum;
  WORD	    EndNum;
} OpGetFiscalReport;

typedef struct {
  Header	Hdr;
  char      FactoryNum[16];
  char		FactoryPsw[16];
  BYTE		Rezerv1;
  Date		RegDate;
  char		RegNumKKM[16];
  char		FiscalPsw[16];
  BYTE		Rezerv2;
} OpFactoryReg;

typedef struct {
  Header	Hdr;
  char      FactoryNum[16];
  char		FiscalPsw[16];
  BYTE		Rezerv1;
  Date	    FiscalDate;
  char		RegNumKKM[16];
  char	    InnOwner[16];
  char	    FirmName[256];
  char	    AccesPsw[16];
  BYTE		Rezerv2;
} OpFiscalCmd;

typedef struct {
  Header	Hdr;
  char      FactoryNum[16];
  char		FiscalPsw[16];
  BYTE		Rezerv1;
  Date	    PereregDate;
  char		NewRegNumKKM[16];
  char	    InnOwner[16];
  char	    FirmName[256];
  char	    NewAccesPsw[16];
  BYTE		Rezerv2;
} OpPereregCmd;

typedef struct {
  Header	Hdr;
  char      FactoryNum[16];
  char		FactoryPsw[16];
  BYTE		Rezerv1;
  Date		RegDate;
  char		RegNumKKM[16];
  char		FiscalPsw[16];
  BYTE		Rezerv2;
  BYTE		idx[7];
} OpFactoryRegMBC;

typedef struct {
  Header	Hdr;
  char      FactoryNum[16];
  char		FiscalPsw[16];
  BYTE		Rezerv1;
  Date	    FiscalDate;
  char		RegNumKKM[16];
  char	    InnOwner[16];
  char	    AccesPsw[16];
  BYTE		Rezerv2;
} OpFiscalCmdMBC;

typedef struct {
  Header	Hdr;
  char      FactoryNum[16];
  char		FiscalPsw[16];
  BYTE		Rezerv1;
  Date	    PereregDate;
  char		NewRegNumKKM[16];
  char	    InnOwner[16];
  char	    NewAccesPsw[16];
  BYTE		Rezerv2;
} OpPereregCmdMBC;


///////////////////////////////////////////////////////////////////////////
struct Ifmt
{ unsigned char len;
  unsigned char fil;
  unsigned char filup:1;
  unsigned char left:1;
  unsigned char scndf:1;
  unsigned char dblw:1;
  unsigned char emph:1;
  unsigned char newl:1;
};

 enum presentInItem
 {
  ZER   = 0x0000,
  QUANT = 0x0001,
  PRICE = 0x0002,
  COST  = 0x0004,
  STORNO= 0x0008,
  DISC  = 0x0010,
  DISCM = 0x0020,
  INCR  = 0x0040,
  INCRM = 0x0080,
  WEGHT = 0x0100,
  SUBTOT= 0x0200,
  TAX   = 0x0400,
  DEPT  = 0x0800,
  BARC  = 0x1000,
  NAME  = 0x2000,
  TAXN  = 0x4000
 };
 
struct Field
{ struct Ifmt rst;
  struct Ifmt pse;
  short  type;
};

struct Item
{ struct Field fld[16];
  short fnum;
};

typedef struct {
  Header     Hdr;
  struct Item itm;
} OpSetItm;

struct FieldNew
{ struct Ifmt rst;
  struct Ifmt pse;
  unsigned int  type;
};

struct ItemNew
{ struct FieldNew fld[16];
  short fnum;
};

typedef struct {
  Header     Hdr;
  struct ItemNew itm;
} OpSetItmNew;

typedef struct {
   Header     Hdr;
   char Len[2];
   char pTxtData[255];

} OpSetFirmInfo;

typedef struct {
   Header     Hdr;
   char Len[2];
   char pTxtData[500];

} OpSendTextBlock;

typedef struct{
	char Name[9]; 
	char Num[21];
	DWORD Sum;
} PaymentSt;

#define OpITM_FMT 47 // may be 45
 enum ModeSet
 {
  mdSbank   = 0x0001,
  mdRetail  = 0x0002,
  md4branch = 0x0004,
  mdFfont   = 0x0008,
  mdFix     = 0x8000,
  mdRound1  = 0x0010,//рубли
  mdRound2  = 0x0020,//10 р
  mdRound3  = 0x0030,//100 р
  mdRes     = 0x0000//зав. сброс
 };

typedef struct {
  Header     Hdr;
  WORD  modeSet;
} OpSettings;

typedef struct {
  Header     Hdr;
  DWORD  modeSet;
} OpSettingsNew;

#endif

#pragma pack(pop)
