unit akrip32;
{*
 * akrip32.h - Copyright (C) 1999 Jay A. Key
 *
 * API for akrip32.dll (V0.93)
 *
 * Translated for Borland Delphi by Holger Dors (holger@dors.de)
 *
 * History of Delphi version:
 *
 * 09. January 2000:  First released version
 * 05. February 2000: Updated for new function "CDDBGetServerList"
 *                   in V.093 of akrip32.dll
 *
 **********************************************************************
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published
 * by the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 *}

interface

uses Windows;

const

  TRACK_AUDIO = $00;
  TRACK_DATA = $01;

  MAXIDLEN = 64;
  MAXCDLIST = 8;

  {*
   * TRACKBUF
   *
   * This structure should not be allocated directly.  If a buffer containing
   * 27 * 2353 bytes is desired, a buffer should be allocated containing
   * the desired amount + 24 bytes.  The allocated memory can then be
   * typecast to a LPTRACKBUF.  It is the program's responsibility to guard
   * against reading/writing past the end of allocated memory.
   *
   * The following must always apply:
   *   (len + startOffset) <= (numFrames * 2352) <= maxLen
   *}

type
  PTRACKBUF = ^TTRACKBUF;
  TTRACKBUF = record
    startFrame: DWord; {* 00: starting frame number          *}
    numFrames: DWord; {* 04: number of frames read          *}
    maxLen: DWord; {* 08: length of buffer itself        *}
    len: DWord; {* 0C: length of data actually in buf *}
    status: DWord; {* 10: status of last read operation  *}
    startOffset: Integer; {* 14: offset of valid data in buf    *}
    buf: array[0..1024 * 1024 - 1] of Byte; {* 18: the data itself       *}
  end;

  TTRACKBUFDUMMY = record
    startFrame: DWord; {* 00: starting frame number          *}
    numFrames: DWord; {* 04: number of frames read          *}
    maxLen: DWord; {* 08: length of buffer itself        *}
    len: DWord; {* 0C: length of data actually in buf *}
    status: DWord; {* 10: status of last read operation  *}
    startOffset: Integer; {* 14: offset of valid data in buf    *}
  end;

const
  TRACKBUFEXTRA = SizeOf(TTRACKBUFDUMMY);

type
  PCDINFO = ^TCDINFO;
  TCDINFO = record
    vendor: array[0..8] of Char;
    prodId: array[0..16] of Char;
    rev: array[0..4] of Char;
    vendSpec: array[0..20] of Char;
  end;

  PCDREC = ^TCDREC;
  TCDREC = record
    ha: Byte;
    tgt: Byte;
    lun: Byte;
    pad: Byte;
    id: array[0..MAXIDLEN] of Char;
    info: TCDINFO;
  end;

  PCDLIST = ^TCDLIST;
  TCDLIST = record
    max: Byte;
    num: Byte;
    cd: array[0..MAXCDLIST - 1] of TCDREC;
  end;

    {*
     * TOCTRACK and TOC must be byte-aligned.  If you're not using Mingw32,
     * CygWin, or some other compiler that understands the PACKED keyword,
     * you need to ensure that these structures are byte aligned.  Usually,
     * this is done using a
     *  #pragma pack(1)
     * See your compiler's documentation for details
     *}

  TTOCTRACK = packed record
    rsvd: Byte;
    ADR: Byte;
    trackNumber: Byte;
    rsvd2: Byte;
    addr: array[0..3] of Byte;
  end;

  PTOC = ^TTOC;
  TTOC = packed record
    tocLen: Word;
    firstTrack: Byte;
    lastTrack: Byte;
    tracks: array[0..99] of TTOCTRACK;
  end;

  PTRACK = ^TTRACK;
  TTRACK = packed record
    trackNo: Integer;
    startLBA: DWord;
    trackLen: DWord;
    _type: Byte;
    pad: array[0..2] of Byte;
    name: array[0..255] of Char;
  end;

  PREADMSF = ^TREADMSF;
  TREADMSF = record
    sm: Byte;
    ss: Byte;
    sf: Byte;
    em: Byte;
    es: Byte;
    ef: Byte;
  end;

const
  {*
   * Error codes set by functions in ASPILIB.C
   *}

  ALERR_NOERROR = 0;
  ALERR_NOWNASPI = -1;
  ALERR_NOGETASPI32SUPP = -2;
  ALERR_NOSENDASPICMD = -3;
  ALERR_ASPI = -4;
  ALERR_NOCDSELECTED = -5;
  ALERR_BUFTOOSMALL = -6;
  ALERR_INVHANDLE = -7;
  ALERR_NOMOREHAND = -8;
  ALERR_BUFPTR = -9;
  ALERR_NOTACD = -10;
  ALERR_LOCK = -11;
  ALERR_DUPHAND = -12;
  ALERR_INVPTR = -13;
  ALERR_INVPARM = -14;
  ALERR_JITTER = -15;
  ALERR_NOADAPTERS = -16;
  ALERR_NOCDFOUND = -17;

  {*
   * API codes
   *}
  APIC_NONE = 0;
  APIC_ASPI = 1;
  APIC_SCSIPT = 2;

  {*
   * constants used for queryCDParms()
   *}

  CDP_READCDR = $0001; // can read CD-R
  CDP_READCDE = $0002; // can read CD-E
  CDP_METHOD2 = $0003; // can read CD-R wriiten via method 2
  CDP_WRITECDR = $0004; // can write CD-R
  CDP_WRITECDE = $0005; // can write CD-E
  CDP_AUDIOPLAY = $0006; // can play audio
  CDP_COMPOSITE = $0007; // composite audio/video stream
  CDP_DIGITAL1 = $0008; // digital output (IEC958) on port 1
  CDP_DIGITAL2 = $0009; // digital output (IEC958) on port 2
  CDP_M2FORM1 = $000A; // reads Mode 2 Form 1 (XA) format
  CDP_M2FORM2 = $000B; // reads Mode 2 Form 2 format
  CDP_MULTISES = $000C; // reads multi-session or Photo-CD
  CDP_CDDA = $000D; // supports cd-da
  CDP_STREAMACC = $000E; // supports "stream is accurate"
  CDP_RW = $000F; // can return R-W info
  CDP_RWCORR = $0010; // returns R-W de-interleaved and err.
  // corrected
  CDP_C2SUPP = $0011; // C2 error pointers
  CDP_ISRC = $0012; // can return the ISRC info
  CDP_UPC = $0013; // can return the Media Catalog Number
  CDP_CANLOCK = $0014; // prevent/allow cmd. can lock the media
  CDP_LOCKED = $0015; // current lock state (TRUE = LOCKED)
  CDP_PREVJUMP = $0016; // prevent/allow jumper state
  CDP_CANEJECT = $0017; // drive can eject disk
  CDP_MECHTYPE = $0018; // type of disk loading supported
  CDP_SEPVOL = $0019; // independent audio level for channels
  CDP_SEPMUTE = $001A; // independent mute for channels
  CDP_SDP = $001B; // supports disk present (SDP)
  CDP_SSS = $001C; // Software Slot Selection
  CDP_MAXSPEED = $001D; // maximum supported speed of drive
  CDP_NUMVOL = $001E; // number of volume levels
  CDP_BUFSIZE = $001F; // size of output buffer
  CDP_CURRSPEED = $0020; // current speed of drive
  CDP_SPM = $0021; // "S" units per "M" (MSF format)
  CDP_FPS = $0022; // "F" units per "S" (MSF format)
  CDP_INACTMULT = $0023; // inactivity multiplier ( x 125 ms)
  //CDP_MSF = $0024; // use MSF format for READ TOC cmd
  CDP_OVERLAP = $0025; // number of overlap frames for jitter
  CDP_JITTER = $0026; // number of frames to check for jitter
  CDP_READMODE = $0027; // mode to attempt jitter corr.

  {*
   * defines for GETCDHAND  readType
   *
   *}
  CDR_ANY = $00; // unknown
  CDR_ATAPI1 = $01; // ATAPI per spec
  CDR_ATAPI2 = $02; // alternate ATAPI
  CDR_READ6 = $03; // using SCSI READ(6)
  CDR_READ10 = $04; // using SCSI READ(10)
  CDR_READ_D8 = $05; // using command 0xD8 (Plextor?)
  CDR_READ_D4 = $06; // using command 0xD4 (NEC?)
  CDR_READ_D4_1 = $07; // 0xD4 with a mode select
  CDR_READ10_2 = $08; // different mode select w/ READ(10)

  {*
   * defines for the read mode (CDP_READMODE)
   *}
  CDRM_NOJITTER = $00; // never jitter correct
  CDRM_JITTER = $01; // always jitter correct
  CDRM_JITTERONERR = $02; // jitter correct only after a read error

type
  THCDROM = THandle;

  PGETCDHAND = ^TGETCDHAND;
  TGETCDHAND = packed record
    size: Byte; {* set to sizeof(GETCDHAND)            *}
    ver: Byte; {* set to AKRIPVER                     *}
    ha: Byte; {* host adapter                        *}
    tgt: Byte; {* target id                           *}
    lun: Byte; {* LUN                                 *}
    readType: Byte; {* read function to use                *}
    jitterCorr: Bool; {* use built-in jitter correction?     *}
    numJitter: Byte; {* number of frames to try to match    *}
    numOverlap: Byte; {* number of frames to overlap         *}
  end;

const
  // Used by InsertCDCacheItem
  CDDB_NONE = 0;
  CDDB_QUERY = 1;
  CDDB_ENTRY = 2;

  CDDB_OPT_SERVER = 0;
  CDDB_OPT_PROXY = 1;
  CDDB_OPT_USEPROXY = 2;
  CDDB_OPT_AGENT = 3;
  CDDB_OPT_USER = 4;
  CDDB_OPT_PROXYPORT = 5;
  CDDB_OPT_CGI = 6;
  CDDB_OPT_HTTPPORT = 7;
  CDDB_OPT_USECDPLAYERINI = 8;
  CDDB_OPT_USEHTTP1_0 = 9;
  CDDB_OPT_SUBMITCGI = 10;
  CDDB_OPT_USERAUTH = 11;
  CDDB_OPT_PROTOLEVEL = 12;

const
  akriplib = 'akrip32.dll';

function GetNumAdapters: Integer; cdecl; external akriplib;

(******************************************************************
 * GetCDList
 *
 * Scans all host adapters for CD-ROM units, and stores information
 * for all units located
 ******************************************************************)
function GetCDList(var cd: TCDLIST): Integer; cdecl; external akriplib;
function GetAspiLibError: Integer; cdecl; external akriplib;
function GetAspiLibAspiError: Byte; cdecl; external akriplib;

(****************************************************************
 * GetCDId
 *
 * Generates an identifier string for the CD drive identified by
 * hCD
 *
 ****************************************************************)
function GetCDId(hCD: THCDROM; buf: PChar; maxBuf: Integer): DWord; cdecl; external akriplib;
function GetDriveInfo(ha, tgt, lun: byte; var cdrec: TCDREC): DWord; cdecl; external akriplib;
function ReadTOC(hCD: THCDROM; var MyToc: TTOC; bMSF: Bool): DWord; cdecl; external akriplib;
function ReadCDAudioLBA(hCD: THCDROM; TrackBuf: PTRACKBUF): DWord; cdecl; external akriplib;
function QueryCDParms(hCD: THCDROM; which: Integer; var Num: DWord): Bool; cdecl; external akriplib;
function ModifyCDParms(hCD: THCDROM; which: Integer; val: DWord): Bool; cdecl; external akriplib;
function GetCDHandle(var cd: TGETCDHAND): THCDROM; cdecl; external akriplib;
function CloseCDHandle(hCD: THCDROM): Bool; cdecl; external akriplib;

(*
 * Reads CD-DA audio, implementing jitter correction.  tOver is used to align
 * the current read, if possible.  After a successful read, numOverlap frames
 * are copied to tOver.
 *)
function ReadCDAudioLBAEx(hCD: THCDROM; TrackBuf, Overlap: PTRACKBUF): DWord; cdecl; external akriplib;
//function GetAKRipDllVersion: DWORD; cdecl; external akriplib;

function AkripInit: Bool; cdecl; external akriplib;
procedure AkripDeinit; cdecl; external akriplib;


{*
 * CDDB support
 *}
type
  PCDDBQUERYITEM = ^TCDDBQUERYITEM;
  TCDDBQUERYITEM = record
    categ: array[0..11] of Char;
    cddbId: array[0..8] of Char;
    bExact: BOOL;
    artist: array[0..80] of Char;
    title: array[0..80] of Char;
  end;

  PCDDBQUERY = ^TCDDBQUERY;
  TCDDBQUERY = record
    num: Integer;
    q: PCDDBQUERYITEM;
  end;

  PCDDBSITE = ^TCDDBSITE;
  TCDDBSITE = record
    szServer: array[0..80] of Char;
    bHTTP: Bool;
    iPort: Integer;
    szCGI: array[0..80] of Char;
    szNorth: array[0..15] of Char;
    szSouth: array[0..15] of Char;
    szLocation: array[0..80] of Char;
  end;

  PCDDBSITELIST = ^TCDDBSITELIST;
  TCDDBSITELIST = record
    num: Integer;
    s: PCDDBSITE;
  end;


(*
 * Computes the CDDBID for the CD in the drive represented by hCD.
 * Data which can be used to construct a CDDB query is stored in the
 * array pID.
 *   pID[0] = CDDBID
 *   pID[1] = number of tracks
 *   pID[2..(2+n)] = starting MSF offset of tracks on CD
 * pID will need to have (at least) n+3 entries, where n is the number
 * of tracks on the CD.  102 should always be enough.  Note that the lead-out
 * track is included.
 *)
function GetCDDBDiskID(hCD: THCDROM; var pID: array of DWord; numEntries: Integer): DWord; cdecl; external akriplib;

(*
 * Queries the CDDB for a given disk.
 * Returns SS_COMP on success, SS_ERR on error.  numEntries on entry contains
 * the number of elements in the lpq array, and on return is set to the
 * number of entries returned.
 *
 * If the no items are returned, or if no network connection is available,
 * returns one item with category "cdplayerini" and the index stored in
 * cddbId;
 *)
function CDDBQuery(hCD: THCDROM; var lpq: TCDDBQUERY): DWORD; cdecl; external akriplib;

(*
 * Returns the CDDB entry verbatim from the CDDB database.  If not large
 * enough, no data is copied.  Verifies that the return code from CDDB is
 * 210 -- CDDB entry follows...
 *
 * If the use of CDPLAYER.INI is enabled and the category is for the query
 * is "cdplayerini", then an attempt is made to read the information from
 * CDPLAYER.INI.
 *)
function CDDBGetDiskInfo(var lpq: TCDDBQUERYITEM; szCDDBEntry: PChar; maxLen: Integer): DWORD; cdecl; external akriplib;
procedure CDDBSetOption(what: Integer; szVal: PChar; iVal: Integer); cdecl; external akriplib;
function CDDBGetServerList(var lpSiteList: TCDDBSITELIST): DWord; cdecl; external akriplib;

implementation

end.
