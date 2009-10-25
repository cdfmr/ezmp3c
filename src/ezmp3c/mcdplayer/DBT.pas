{*****************************************************************************
 *
 *                          Delphi Runtime Library
 *
 *
 * Title:      DBT.pas - Equates for WM_DEVICECHANGE and BroadcastSystemMessage
 *
 * Version:    4.00
 *
 * Date:       01-January-1998
 *
 * Author:     ZifNab (Tom Deprez)
 *
 *----------------------------------------------------------------------------
 *  Change log:
 *
 *     DATE     REV                 DESCRIPTION
 *  ----------- --- ----------------------------------------------------------
 *  01-01-1998   1   Only translation for WM_DEVICECHANGE : called DBTMsg
 *  04-08-1998   2   Totally translation, with help of htrans (A. Staubo)
 *  05-08-1998   3   Made some modifications (G. Ongun)
 *  06-08-1998   4   Released it as finished
 *****************************************************************************}

 // original header

{*****************************************************************************
 *
 *  Copyright (c) 1993-1996 Microsoft Corporation
 *
 *  Title:      DBT.H - Equates for WM_DEVICECHANGE and BroadcastSystemMessage
 *
 *  Version:    4.00
 *
 *  Date:       24-May-1993
 *
 *  Author:     rjc
 *
 *----------------------------------------------------------------------------
 *
 *  Change log:
 *
 *     DATE     REV                 DESCRIPTION
 *  ----------- --- ----------------------------------------------------------
 *
 *****************************************************************************}

unit DBT;

{$ALIGN ON}
{$MINENUMSIZE 4}

interface

uses
  Windows;

{$IFNDEF _DBT_H}

{$DEFINE _DBT_H}

{$IFNDEF WIN32}
  Pitty, this code is for Delphi 2+.
{$ENDIF}

{
 * BroadcastSpecialMessage constants.
 }

const
  WM_DEVICECHANGE = $0219;

{
 * Broadcast message and receipient flags.
 *
 * Note that there is a third "flag". If the wParam has:
 *
 * bit 15 on: lparam is a pointer and bit 14 is meaningfull.
 * bit 15 off: lparam is just a UNLONG data type.
 *
 * bit 14 on: lparam is a pointer to an ASCIIZ string.
 * bit 14 off: lparam is a pointer to a binary struture starting with
 * a dword describing the length of the structure.
 }

const
  BSF_QUERY = $00000001;
  BSF_IGNORECURRENTTASK = $00000002;    { Meaningless for VxDs }
  BSF_FLUSHDISK = $00000004;            { Shouldn't be used by VxDs }
  BSF_NOHANG = $00000008;
  BSF_POSTMESSAGE = $00000010;
  BSF_FORCEIFHUNG = $00000020;
  BSF_NOTIMEOUTIFNOTHUNG = $00000040;
  BSF_MSGSRV32ISOK = $80000000;         { Called synchronously from PM API }
  BSF_MSGSRV32ISOK_BIT = 31;            { Called synchronously from PM API }
  BSM_ALLCOMPONENTS = $00000000;
  BSM_VXDS = $00000001;
  BSM_NETDRIVER = $00000002;
  BSM_INSTALLABLEDRIVERS = $00000004;
  BSM_APPLICATIONS = $00000008;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_APPYBEGIN
 * lParam  = (not used)
 *
 * 'Appy-time is now available.  This message is itself sent
 * at 'Appy-time.
 *
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_APPYEND
 * lParam  = (not used)
 *
 * 'Appy-time is no longer available.  This message is *NOT* sent
 * at 'Appy-time.  (It cannot be, because 'Appy-time is gone.)
 *
 * NOTE!  It is possible for DBT_APPYBEGIN and DBT_APPYEND to be sent
 * multiple times during a single Windows session.  Each appearance of
 * 'Appy-time is bracketed by these two messages, but 'Appy-time may
 * momentarily become unavailable during otherwise normal Windows
 * processing.  The current status of 'Appy-time availability can always
 * be obtained from a call to _SHELL_QueryAppyTimeAvailable.
 }

const
  DBT_APPYBEGIN = $0000;
  DBT_APPYEND = $0001;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_DEVNODES_CHANGED
 * lParam  = 0
 *
 * send when configmg finished a process tree batch. Some devnodes
 * may have been added or removed. This is used by ring3 people which
 * need to be refreshed whenever any devnode changed occur (like
 * device manager). People specific to certain devices should use
 * DBT_DEVICE* instead.
 }

const
  DBT_DEVNODES_CHANGED = $0007;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_QUERYCHANGECONFIG
 * lParam  = 0
 *
 * sent to ask if a config change is allowed
 }

const
  DBT_QUERYCHANGECONFIG = $0017;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_CONFIGCHANGED
 * lParam  = 0
 *
 * sent when a config has changed
 }

const
  DBT_CONFIGCHANGED = $0018;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_CONFIGCHANGECANCELED
 * lParam  = 0
 *
 * someone cancelled the config change
 }

const
  DBT_CONFIGCHANGECANCELED = $0019;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_MONITORCHANGE
 * lParam  = new resolution to use (LOWORD=x, HIWORD=y)
 *           if 0, use the default res for current config
 *
 *      this message is sent when the display monitor has changed
 *      and the system should change the display mode to match it.
 }

const
  DBT_MONITORCHANGE = $001;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_SHELLLOGGEDON
 * lParam  = 0
 *
 * The shell has finished login on: VxD can now do Shell_EXEC.
 }

const
  DBT_SHELLLOGGEDON = $0020;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_CONFIGMGAPI
 * lParam  = CONFIGMG API Packet
 *
 * CONFIGMG ring 3 call.
 }

const
  DBT_CONFIGMGAPI32 = $0022;

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_VOLLOCK*
 * lParam  = pointer to VolLockBroadcast structure described below
 *
 * Messages issued by IFSMGR for volume locking purposes on WM_DEVICECHANGE.
 * All these messages pass a pointer to a struct which has no pointers.
 }

const
  DBT_VOLLOCKQUERYLOCK = $8041;
  DBT_VOLLOCKLOCKTAKEN = $8042;
  DBT_VOLLOCKLOCKFAILED = $8043;
  DBT_VOLLOCKQUERYUNLOCK = $8044;
  DBT_VOLLOCKLOCKRELEASED = $8045;
  DBT_VOLLOCKUNLOCKFAILED = $8046;

{
 * Device broadcast header
 }


type

  PDEV_BROADCAST_HDR = ^TDEV_BROADCAST_HDR;
  TDEV_BROADCAST_HDR = packed record
    dbch_size : DWORD;
    dbch_devicetype : DWORD;
    dbch_reserved : DWORD;
  end;

{
 * Structure for volume lock broadcast
 }

type

  PVolLockBroadcast = ^TVolLockBroadcast;
  TVolLockBroadcast = packed record
      vlb_dbh : TDEV_BROADCAST_HDR; 
      vlb_owner : DWORD;       // thread on which lock request is being issued
      vlb_perms : BYTE;        // lock permission flags defined below
      vlb_lockType : BYTE;     // type of lock
      vlb_drive : BYTE;        // drive on which lock is issued
      vlb_flags : BYTE;        // miscellaneous flags
    end;

{
 * Values for vlb_perms
 }

const
  LOCKP_ALLOW_WRITES = $01;  // Bit 0 set - allow writes
  LOCKP_FAIL_WRITES = $00;  // Bit 0 clear - fail writes
  LOCKP_FAIL_MEM_MAPPING = $02;  // Bit 1 set - fail memory mappings
  LOCKP_ALLOW_MEM_MAPPING = $00;  // Bit 1 clear - allow memory mappings
  LOCKP_USER_MASK = $03;  // Mask for user lock flags
  LOCKP_LOCK_FOR_FORMAT = $04;  // Level 0 lock for format

{
 * Values for vlb_flags
 }

const
  LOCKF_LOGICAL_LOCK = $00;  // Bit 0 clear - logical lock
  LOCKF_PHYSICAL_LOCK = $01;  // Bit 0 set - physical lock

{
 * Message = WM_DEVICECHANGE
 * wParam  = DBT_NODISKSPACE
 * lParam  = drive number of drive that is out of disk space (1-based)
 *
 * Message issued by IFS manager when it detects that a drive is run out of
 * free space.
 }

const
  DBT_NO_DISK_SPACE = $0047;
  DBT_CONFIGMGPRIVATE = $7FFF;

{
 * The following messages are for WM_DEVICECHANGE. The immediate list
 * is for the wParam. ALL THESE MESSAGES PASS A POINTER TO A STRUCT
 * STARTING WITH A DWORD SIZE AND HAVING NO POINTER IN THE STRUCT.
 *
 }

const
  DBT_DEVICEARRIVAL = $8000;  // system detected a new device
  DBT_DEVICEQUERYREMOVE = $8001;  // wants to remove, may fail
  DBT_DEVICEQUERYREMOVEFAILED = $8002;  // removal aborted
  DBT_DEVICEREMOVEPENDING = $8003;  // about to remove, still avail.
  DBT_DEVICEREMOVECOMPLETE = $8004;  // device is gone
  DBT_DEVICETYPESPECIFIC = $8005;  // type specific event
  DBT_DEVTYP_OEM = $00000000;  // oem-defined device type
  DBT_DEVTYP_DEVNODE = $00000001;  // devnode number
  DBT_DEVTYP_VOLUME = $00000002;  // logical volume
  DBT_DEVTYP_PORT = $00000003;  // serial, parallel
  DBT_DEVTYP_NET = $00000004;  // network resource

type

  TDEV_BROADCAST_HEADER = packed record
      dbcd_size : DWORD;
      dbcd_devicetype : DWORD;
      dbcd_reserved : DWORD;
    end;

  PDEV_BROADCAST_OEM = ^TDEV_BROADCAST_OEM;
  TDEV_BROADCAST_OEM = packed record
      dbco_size : DWORD;
      dbco_devicetype : DWORD;
      dbco_reserved : DWORD;
      dbco_identifier : DWORD;
      dbco_suppfunc : DWORD;
    end;

  PDEV_BROADCAST_DEVNODE = ^TDEV_BROADCAST_DEVNODE;
  TDEV_BROADCAST_DEVNODE = packed record
      dbcd_size : DWORD;
      dbcd_devicetype : DWORD;
      dbcd_reserved : DWORD;
      dbcd_devnode : DWORD;
    end;

  PDEV_BROADCAST_VOLUME = ^TDEV_BROADCAST_VOLUME;
  TDEV_BROADCAST_VOLUME = packed record
      dbcv_size : DWORD;
      dbcv_devicetype : DWORD;
      dbcv_reserved : DWORD;
      dbcv_unitmask : DWORD;
      dbcv_flags : WORD;
    end;

const
  DBTF_MEDIA = $0001;  // media comings and goings
  DBTF_NET = $0002;  // network volume

type

  PDEV_BROADCAST_PORT = ^TDEV_BROADCAST_PORT;
  TDEV_BROADCAST_PORT = packed record
      dbcp_size : DWORD;
      dbcp_devicetype : DWORD;
      dbcp_reserved : DWORD;
      dbcp_name : array[0.. 1-1] of char;
    end;

  PDEV_BROADCAST_NET = ^TDEV_BROADCAST_NET;
  TDEV_BROADCAST_NET = packed record
      dbcn_size : DWORD;
      dbcn_devicetype : DWORD;
      dbcn_reserved : DWORD;
      dbcn_resource : DWORD;
      dbcn_flags : DWORD;
    end;

const
  DBTF_RESOURCE = $00000001;  // network resource
  DBTF_XPORT = $00000002;  // new transport coming or going
  DBTF_SLOWNET = $00000004;  // new incoming transport is slow
  // (dbcn_resource undefined for now)
  DBT_VPOWERDAPI = $8100;  // VPOWERD API for Win95


{
 *  User-defined message types all use wParam = 0xFFFF with the
 *  lParam a pointer to the structure below.
 *
 *  dbud_dbh - DEV_BROADCAST_HEADER must be filled in as usual.
 *
 *  dbud_szName contains a case-sensitive ASCIIZ name which names the
 *  message.  The message name consists of the vendor name, a backslash,
 *  then arbitrary user-defined ASCIIZ text.  For example:
 *
 * "WidgetWare\QueryScannerShutdown"
 * "WidgetWare\Video Q39S\AdapterReady"
 *
 *  After the ASCIIZ name, arbitrary information may be provided.
 *  Make sure that dbud_dbh.dbch_size is big enough to encompass
 *  all the data.  And remember that nothing in the structure may
 *  contain pointers.
 }

const
  DBT_USERDEFINED = $FFFF;

type
  TDEV_BROADCAST_USERDEFINED = packed record
      dbud_dbh : TDEV_BROADCAST_HDR;
      dbud_szName : array[0..1-1] of Char;
    {  BYTE dbud_rgbUserDefined[];} { User-defined contents }
  end;

{ added own message type for WM_DEVICECHANGE }

type
  TWMDeviceChange = record
   Msg : Cardinal;
   Event : UINT;
   dwData : Pointer;
   Result : LongInt;
  end;

{$ENDIF} // _DBT_H

implementation

end.

