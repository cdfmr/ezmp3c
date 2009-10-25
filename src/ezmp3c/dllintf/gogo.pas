//------------------------------------------------------------------------------
// Project: GOGO-no-coda ver 3.11 Pascal Interface
// Unit:    gogo.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Pascal interface of GOGO, the excellent and fast mp3 encode engine
//
// 2003-05-17
// - Initial release
// 2006-04-16
// - First release with comments
//------------------------------------------------------------------------------

unit gogo;

interface

uses Windows;

const
  GOGOLIB = 'gogo.dll';

type
  MERET   = Integer;
  UPARAM  = DWORD;
  MUPARAM = UPARAM;

const
  ME_NOERR                = 0;  // return normally
  ME_EMPTYSTREAM          = 1;  // stream becomes empty
  ME_HALTED               = 2;  // stopped by user
  ME_MOREDATA             = 3;
  ME_INTERNALERROR        = 10; // internal error
  ME_PARAMERROR           = 11; // parameters error
  ME_NOFPU                = 12; // no FPU
  ME_INFILE_NOFOUND       = 13; // can't open input file
  ME_OUTFILE_NOFOUND      = 14; // can't open output file
  ME_FREQERROR            = 15; // frequency is not good
  ME_BITRATEERROR         = 16; // bitrate is not good
  ME_WAVETYPE_ERR         = 17; // WAV format is not good
  ME_CANNOT_SEEK          = 18; // can't seek
  ME_BITRATE_ERR          = 19; // only for compatibility
  ME_BADMODEORLAYER       = 20; // mode/layer not good
  ME_NOMEMORY             = 21; // fail to allocate memory
  ME_CANNOT_SET_SCOPE     = 22; // thread error
  ME_CANNOT_CREATE_THREAD = 23; // fail to create thear
  ME_WRITEERROR           = 24; // lock of capacity of disk

// definition of call-back function for user
type
  MPGE_USERFUNC  = function(buf: Pointer; nLength: DWORD): MERET;
  MPGE_NULL_FUNC = MPGE_USERFUNC;

////////////////////////////////////////////////////////////////////////////////
// Configuration
////////////////////////////////////////////////////////////////////////////////
// for INPUT
const
  MC_INPUTFILE        = 1;
  // para1 choice of input device
  MC_INPDEV_FILE      = 0; // input device is file
  MC_INPDEV_STDIO     = 1; // stdin
  MC_INPDEV_USERFUNC  = 2; // defined by user
  MC_INPDEV_LIBSND    = 3; // input device is file via LIBSND

  // para2
type
  MCP_INPDEV_USERFUNC = record
    pUserFunc: MPGE_USERFUNC; // pointer to user-function for call-back or MPGE_NULL_FUNC if none
    nSize:     DWORD;         // size of file or MC_INPDEV_MEMORY_NOSIZE if unknown
    nBit:      Integer;       // nBit = 8 or 16
    nFreq:     Integer;       // input frequency
    nChn:      Integer;       // number of channel(1 or 2)
  end;

const
  MC_INPDEV_MEMORY_NOSIZE = $ffffffff;

////////////////////////////////////////////////////////////////////////////////
// for OUTPUT ( now stdout is not support )
  MC_OUTPUTFILE                 = 2;
  // para1 choice of output device
  MC_OUTDEV_FILE                = 0; // output device is file
  MC_OUTDEV_STDOUT              = 1; // stdout
  MC_OUTDEV_USERFUNC            = 2; // defined by user
  MC_OUTDEV_USERFUNC_WITHVBRTAG = 3; // defined by user
  // para2 pointer to file if necessary

////////////////////////////////////////////////////////////////////////////////
// mode of encoding
  MC_ENCODEMODE       = 3;
  // para1 mode
  MC_MODE_MONO        = 0; // mono
  MC_MODE_STEREO      = 1; // stereo
  MC_MODE_JOINT       = 2; // joint-stereo
  MC_MODE_MSSTEREO    = 3; // mid/side stereo
  MC_MODE_DUALCHANNEL = 4; // dual channel

////////////////////////////////////////////////////////////////////////////////
// bitrate
  MC_BITRATE = 4;
// para1 bitrate

////////////////////////////////////////////////////////////////////////////////
// frequency of input file (force)
  MC_INPFREQ = 5;
// para1 frequency

////////////////////////////////////////////////////////////////////////////////
// frequency of output mp3 (force)
  MC_OUTFREQ = 6;
// para1 frequency

////////////////////////////////////////////////////////////////////////////////
// size ofheader if you ignore WAV-header (for example cda)
  MC_STARTOFFSET = 7;

////////////////////////////////////////////////////////////////////////////////
// psycho-acoustics ON/OFF
  MC_USEPSY = 8;
// PARA1 boolean(TRUE/FALSE)

////////////////////////////////////////////////////////////////////////////////
// 16kHz low-pass filter ON/OFF
  MC_USELPF16 = 9;
// PARA1 boolean(TRUE/FALSE)

////////////////////////////////////////////////////////////////////////////////
// use special UNIT, para1:boolean
  MC_USEMMX     = 10;  // MMX
  MC_USE3DNOW   = 11;  // 3DNow!
  MC_USESSE     = 12;  // SSE (KNI);
  MC_USEKNI     = MC_USESSE;  
  MC_USEE3DNOW  = 13;  // Enhanced 3D Now!
  MC_USECMOV    = 38;  // CMOV
  MC_USEEMMX    = 39;  // EMMX
  MC_USESSE2    = 40;  // SSE2
  MC_USESPC1    = 14;  // special switch for debug
  MC_USESPC2    = 15;  // special switch for debug

////////////////////////////////////////////////////////////////////////////////
// addition of TAG
  MC_ADDTAG = 16;
// dwPara1  length of TAG
// dwPara2  pointer to TAG

////////////////////////////////////////////////////////////////////////////////
// emphasis
  MC_EMPHASIS   = 17;
// para1 type of emphasis
  MC_EMP_NONE   = 0;   // no empahsis
  MC_EMP_5015MS = 1;   // 50/15ms
  MC_EMP_CCITT  = 3;   // CCITT

////////////////////////////////////////////////////////////////////////////////
// use VBR
  MC_VBR = 18;

////////////////////////////////////////////////////////////////////////////////
// SMP support para1: interger
  MC_CPU = 19;

////////////////////////////////////////////////////////////////////////////////
// for RAW-PCM
// byte swapping for 16bitPCM
  MC_BYTE_SWAP = 20;

////////////////////////////////////////////////////////////////////////////////
// for 8bit PCM
  MC_8BIT_PCM = 21;

////////////////////////////////////////////////////////////////////////////////
// for mono PCM
  MC_MONO_PCM = 22;

////////////////////////////////////////////////////////////////////////////////
// for Towns SND
  MC_TOWNS_SND = 23;

////////////////////////////////////////////////////////////////////////////////
// BeOS & Win32 Encode thread priority
  MC_THREAD_PRIORITY = 24;
// (WIN32) dwPara1 MULTITHREAD Priority (THREAD_PRIORITY_**** at WinBASE.h )

////////////////////////////////////////////////////////////////////////////////
// BeOS Read thread priority
//#if defined(USE_BTHREAD);
  MC_READTHREAD_PRIORITY = 25;
//#endif

////////////////////////////////////////////////////////////////////////////////
// output format
  MC_OUTPUT_FORMAT    = 26;
// para1
  MC_OUTPUT_NORMAL    = 0;   // mp3+TAG(see MC_ADDTAG)
  MC_OUTPUT_RIFF_WAVE = 1;   // RIFF/WAVE
  MC_OUTPUT_RIFF_RMP  = 2;   // RIFF/RMP

////////////////////////////////////////////////////////////////////////////////
// LIST/INFO chunk of RIFF/WAVE or RIFF/RMP
  MC_RIFF_INFO = 27;
// para1 size of info(include info name)
// para2 pointer to info
//   byte offset       contents
//   0..3              info name
//   4..size of info-1 info

////////////////////////////////////////////////////////////////////////////////
// verify and overwrite
  MC_VERIFY = 28;

////////////////////////////////////////////////////////////////////////////////
// output directory
  MC_OUTPUTDIR = 29;

////////////////////////////////////////////////////////////////////////////////
// VBR
  MC_VBRBITRATE = 30;
// para1 (kbps)
// para2 (kbps)

////////////////////////////////////////////////////////////////////////////////
// LPF1, LPF2
  MC_ENHANCEDFILTER = 31;
// para1 LPF1 (0-100) , dflt=auto setting by outfreq
// para2 LPF2 (0-100) , dflt=auto setting by outfreq

////////////////////////////////////////////////////////////////////////////////
// Joint-stereo
  MC_MSTHRESHOLD = 32;
// para1 threshold  (0-100) , dflt=auto setting by outfreq
// para2 mspower    (0-100) , dflt=auto setting by outfreq

////////////////////////////////////////////////////////////////////////////////
// Language
  MC_LANG = 33;
// t_lang defined in message.h

////////////////////////////////////////////////////////////////////////////////
// max data length ( byte )
  MC_MAXFILELENGTH = 34;
// para1 maxfilesize (PCM body length, not include wave heaher size.)
//       (0-0xfffffffd)   // as byte
  MC_MAXFLEN_IGNORE = High(DWORD);         // DEFAULT
  MC_MAXFLEN_WAVEHEADER = High(DWORD) - 1; // WAVE

////////////////////////////////////////////////////////////////////////////////
  MC_OUTSTREAM_BUFFERD  = 35;
// para1  enable(=1) or disable(=0), dflt=enable
  MC_OBUFFER_ENABLE     = 1;       // DEFAULT
  MC_OBUFFER_DISABLE    = 0;

////////////////////////////////////////////////////////////////////////////////
// quality (same as lame-option `-q')
  MC_ENCODE_QUALITY = 36;
// 1(high quality) <= para1 <= 9(low quality)
// 2:-h
// 5:default
// 7:-f

////////////////////////////////////////////////////////////////////////////////
// use ABR
  MC_ABR= 37;

////////////////////////////////////////////////////////////////////////////////
  MC_WRITELAMETAG = 41;
/// para1: 0 = disable (default)
///        1 = enable

////////////////////////////////////////////////////////////////////////////////
  MC_WRITEVBRTAG = 42;
/// para1: 0 = disable 
///        1 = enable (default)

function MPGE_initializeWork: MERET; cdecl; external GOGOLIB;
function MPGE_setConfigure(mode, dwPara1, dwPara2: UPARAM): MERET; cdecl; external GOGOLIB;
function MPGE_getConfigure(mode: UPARAM; ppara1: Pointer): MERET; cdecl; external GOGOLIB;
function MPGE_detectConfigure: MERET; cdecl; external GOGOLIB;
function MPGE_processFrame: MERET; cdecl; external GOGOLIB;
function MPGE_closeCoder: MERET; cdecl; external GOGOLIB;
function MPGE_endCoder: MERET; cdecl; external GOGOLIB;
function MPGE_getUnitStates(var aUnit: DWORD): MERET; cdecl; external GOGOLIB;
function MPGE_processTrack: MERET; cdecl; external GOGOLIB;

// This function is effective for gogo.dll
function MPGE_getVersion(var vercode: DWORD; verstring: PChar): MERET; cdecl; external GOGOLIB;
// vercode = 0x125 ->  version 1.25
// verstring       ->  "ver 1.25 1999/09/25" (allocate abobe 260bytes buffer)

const
  MGV_BUFLENGTH = 260;

////////////////////////////////////////////////////////////////////////////////
// for getting configuration
////////////////////////////////////////////////////////////////////////////////
const
  MG_INPUTFILE            = 1;          // name of input file
  MG_OUTPUTFILE           = 2;          // name of output file
  MG_ENCODEMODE           = 3;          // type of encoding
  MG_BITRATE              = 4;          // bitrate
  MG_INPFREQ              = 5;          // input frequency
  MG_OUTFREQ              = 6;          // output frequency
  MG_STARTOFFSET          = 7;          // offset of input PCM
  MG_USEPSY               = 8;          // psycho-acoustics
  MG_USEMMX               = 9;          // MMX
  MG_USE3DNOW             = 10;         // 3DNow!
  MG_USESSE               = 11;         // SSE (KNI)
  MG_USEKNI               = MG_USESSE;  
  MG_USEE3DNOW            = 12;         // Enhanced 3DNow!
  MG_USECMOV              = 20;         // CMOV
  MG_USEEMMX              = 21;         // EMMX
  MG_USESSE2              = 22;         // SSE2
  MG_CLFLUSH              = 23;         // CLFLUSH
  MG_USESPC1              = 13;         // special switch for debug
  MG_USESPC2              = 14;         // special switch for debug
  MG_COUNT_FRAME          = 15;         // amount of frame
  MG_NUM_OF_SAMPLES       = 16;         // number of sample for 1 frame
  MG_MPEG_VERSION         = 17;         // MPEG VERSION
  MG_READTHREAD_PRIORITY  = 18;         // thread priority to read for BeOS
  MG_FRAME                = 19;
  
const
////////////////////////////////////////////////////////////////////////////////
//  for MPGE_getUnitStates()
////////////////////////////////////////////////////////////////////////////////
// x86 - Spec
  MU_tFPU         = (1 shl 0);
  MU_tMMX         = (1 shl 1);
  MU_t3DN         = (1 shl 2);
  MU_tSSE         = (1 shl 3);
  MU_tCMOV        = (1 shl 4);
  MU_tE3DN        = (1 shl 5);  // for Athlon(Externd 3D Now!)
  MU_tEMMX        = (1 shl 6);  // EMMX = E3DNow!_INT = SSE_INT
  MU_tSSE2        = (1 shl 7);
  MU_tCLFLUSH     = (1 shl 18);
  MU_tMULTI       = (1 shl 12); // for Multi-threaded encoder. Never set on UP or in the binary linked w/o multithread lib.

// x86 - Vendor
  MU_tINTEL       = (1 shl 8);
  MU_tAMD         = (1 shl 9);
  MU_tCYRIX       = (1 shl 10);
  MU_tIDT         = (1 shl 11);
  MU_tUNKNOWN     = (1 shl 15); // unknown vendor

// x86 - Special
  MU_tSPC1        = (1 shl 16); // special flag
  MU_tSPC2        = (1 shl 17); // freely available
// x86 - CPU TYPES
  MU_tFAMILY4     = (1 shl 20); // 486 vendor maybe isn't correct
  MU_tFAMILY5     = (1 shl 21); // 586 (P5, P5-MMX, K6, K6-2, K6-III)
  MU_tFAMILY6     = (1 shl 22); // 686 above P-Pro, P-II, P-III, Athlon
  MU_tFAMILY7     = (1 shl 23); // Pentium IV ?

// for PPC arc
  MU_tPPC         = (1 shl 0);
  MU_tGRAP        = (1 shl 1);  // fres, frsqrte, fsel
  MU_tFSQRT       = (1 shl 2);  // fsqrt, fsqrts
  MU_tALTIVEC     = (1 shl 3);  // AltiVec

implementation

end.