unit myaspi32;

{*
 * myaspi32.h - Copyright (C) 1999 Jay A. Key
 *
 * API for WNASPI32.DLL
 *
 * Translated for Borland Delphi by Holger Dors (holger@dors.de)
 *
 * History of Delphi version:
 *
 * 10. January 2000: First released version
 *
 **********************************************************************
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
 *
 *}

{***************************************************************************
 ** Module Name:    myaspi32.h
 **
 ** Description:    Header file replacement for wnaspi32.h
 **
 ***************************************************************************}

interface

uses Windows;

const

{***************************************************************************
 ** SCSI MISCELLANEOUS EQUATES
 ***************************************************************************}
  SENSE_LEN = 14; {* Default sense buffer length    *}
  SRB_DIR_SCSI = $00; {* Direction determined by SCSI   *}
  SRB_POSTING = $01; {* Enable ASPI posting            *}
  SRB_ENABLE_RESIDUAL_COUNT = $04; {* Enable residual byte count     *}
                                    {* reporting                      *}
  SRB_DIR_IN = $08; {* Transfer from SCSI target to   *}
                                    {* host                           *}
  SRB_DIR_OUT = $10; {* Transfer from host to SCSI     *}
                                    {* target                         *}
  SRB_EVENT_NOTIFY = $40; {* Enable ASPI event notification *}
  RESIDUAL_COUNT_SUPPORTED = $02; {* Extended buffer flag           *}
  MAX_SRB_TIMEOUT = DWORD(1080001); {* 30 hour maximum timeout in sec *}
  DEFAULT_SRB_TIMEOUT = DWORD(1080001); {* use max.timeout by default     *}

{***************************************************************************
 ** ASPI command definitions
 ***************************************************************************}
  SC_HA_INQUIRY = $00; {* Host adapter inquiry           *}
  SC_GET_DEV_TYPE = $01; {* Get device type                *}
  SC_EXEC_SCSI_CMD = $02; {* Execute SCSI command           *}
  SC_ABORT_SRB = $03; {* Abort an SRB                   *}
  SC_RESET_DEV = $04; {* SCSI bus device reset          *}
  SC_SET_HA_PARMS = $05; {* Set HA parameters              *}
  SC_GET_DISK_INFO = $06; {* Get Disk                       *}
  SC_RESCAN_SCSI_BUS = $07; {* Rebuild SCSI device map        *}
  SC_GETSET_TIMEOUTS = $08; {* Get/Set target timeouts        *}


{***************************************************************************
 ** SRB Status
 ***************************************************************************}
  SS_PENDING = $00; {* SRB being processed            *}
  SS_COMP = $01; {* SRB completed without error    *}
  SS_ABORTED = $02; {* SRB aborted                    *}
  SS_ABORT_FAIL = $03; {* Unable to abort SRB            *}
  SS_ERR = $04; {* SRB completed with error       *}
  SS_INVALID_CMD = $80; {* Invalid ASPI command           *}
  SS_INVALID_HA = $81; {* Invalid host adapter number    *}
  SS_NO_DEVICE = $82; {* SCSI device not installed      *}
  SS_INVALID_SRB = $E0; {* Invalid parameter set in SRB   *}
  SS_OLD_MANAGER = $E1; {* ASPI manager doesn't support   *}
                                    {* windows                        *}
  SS_BUFFER_ALIGN = $E1; {* Buffer not aligned (replaces   *}
                                    {* SS_OLD_MANAGER in Win32)       *}
  SS_ILLEGAL_MODE = $E2; {* Unsupported Windows mode       *}
  SS_NO_ASPI = $E3; {* No ASPI managers               *}
  SS_FAILED_INIT = $E4; {* ASPI for windows failed init   *}
  SS_ASPI_IS_BUSY = $E5; {* No resources available to      *}
                                    {* execute command                *}
  SS_BUFFER_TO_BIG = $E6; {* Buffer size too big to handle  *}
  SS_BUFFER_TOO_BIG = $E6; {* Correct spelling of 'too'      *}
  SS_MISMATCHED_COMPONENTS = $E7; {* The DLLs/EXEs of ASPI don't    *}
                                    {* version check                  *}
  SS_NO_ADAPTERS = $E8; {* No host adapters to manager    *}
  SS_INSUFFICIENT_RESOURCES = $E9; {* Couldn't allocate resources    *}
                                    {* needed to init                 *}
  SS_ASPI_IS_SHUTDOWN = $EA; {* Call came to ASPI after        *}
                                    {* PROCESS_DETACH                 *}
  SS_BAD_INSTALL = $EB; {* The DLL or other components    *}
                                    {* are installed wrong            *}

{***************************************************************************
 ** Host Adapter Status
 ***************************************************************************}
  HASTAT_OK = $00; {* No error detected by HA        *}
  HASTAT_SEL_TO = $11; {* Selection Timeout              *}
  HASTAT_DO_DU = $12; {* Data overrun/data underrun     *}
  HASTAT_BUS_FREE = $13; {* Unexpected bus free            *}
  HASTAT_PHASE_ERR = $14; {* Target bus phase sequence      *}
  HASTAT_TIMEOUT = $09; {* Timed out while SRB was        *}
                                    {* waiting to be processed        *}
  HASTAT_COMMAND_TIMEOUT = $0B; {* Adapter timed out while        *}
                                    {* processing SRB                 *}
  HASTAT_MESSAGE_REJECT = $0D; {* While processing the SRB, the  *}
                                    {* adapter received a MESSAGE     *}
  HASTAT_BUS_RESET = $0E; {* A bus reset was detected       *}
  HASTAT_PARITY_ERROR = $0F; {* A parity error was detected    *}
  HASTAT_REQUEST_SENSE_FAILED = $10; {* The adapter failed in issuing  *}

{***************************************************************************
 ** SRB - HOST ADAPTER INQUIRIY - SC_HA_INQUIRY (0)
 ***************************************************************************}
type

  PSRB_HAInquiry = ^SRB_HAInquiry;
  SRB_HAInquiry = packed record
    SRB_Cmd: Byte; {* 00/000 ASPI command code == SC_HA_INQUIRY *}
    SRB_Status: Byte; {* 01/001 ASPI command status byte           *}
    SRB_HaID: Byte; {* 02/002 ASPI host adapter number           *}
    SRB_Flags: Byte; {* 03/003 ASPI request flags                 *}
    SRB_Hdr_Rsvd: DWORD; {* 04/004 Reserved, must = 0                 *}
    HA_Count: Byte; {* 08/008 Number of host adapters present    *}
    HA_SCSI_ID: Byte; {* 09/009 SCSI ID of host adapter            *}
    HA_ManagerId: array[0..15] of Byte; {* 0a/010 String describing the manager      *}
    HA_Identifier: array[0..15] of Byte; {* 1a/026 String describing the host adapter *}
    HA_Unique: array[0..15] of Byte; {* 2a/042 Host Adapter Unique parameters     *}
    HA_Rsvd1: Word; {* 3a/058 Reserved, must = 0                 *}
  end;

{***************************************************************************
 ** SRB - GET DEVICE TYPE - SC_GET_DEV_TYPE (1)
 ***************************************************************************}
  PSRB_GDEVBlock = ^SRB_GDEVBlock;
  SRB_GDEVBlock = packed record
    SRB_Cmd: Byte; {* 00/000 ASPI cmd code == SC_GET_DEV_TYPE   *}
    SRB_Status: Byte; {* 01/001 ASPI command status byte           *}
    SRB_HaID: Byte; {* 02/002 ASPI host adapter number           *}
    SRB_Flags: Byte; {* 03/003 Reserved, must = 0                 *}
    SRB_Hdr_Rsvd: DWord; {* 04/004 Reserved, must = 0                 *}
    SRB_Target: Byte; {* 08/008 Target's SCSI ID                   *}
    SRB_Lun: Byte; {* 09/009 Target's LUN number                *}
    SRB_DeviceType: Byte; {* 0a/010 Target's peripheral device type    *}
    SRB_Rsvd1: Byte; {* 0b/011 Reserved, must = 0                 *}
  end;


{***************************************************************************
 ** SRB - EXECUTE SCSI COMMAND - SC_EXEC_SCSI_CMD (2)
 ***************************************************************************}
  PSRB_ExecSCSICmd = ^SRB_ExecSCSICmd;
  SRB_ExecSCSICmd = packed record
    SRB_Cmd: Byte; {* 00/000 ASPI cmd code == SC_EXEC_SCSI_CMD  *}
    SRB_Status: Byte; {* 01/001 ASPI command status byte           *}
    SRB_HaID: Byte; {* 02/002 ASPI host adapter number           *}
    SRB_Flags: Byte; {* 03/003 Reserved, must = 0                 *}
    SRB_Hdr_Rsvd: DWord; {* 04/004 Reserved, must = 0                 *}
    SRB_Target: Byte; {* 08/008 Target's SCSI ID                   *}
    SRB_Lun: Byte; {* 09/009 Target's LUN                       *}
    SRB_Rsvd1: Word; {* 0a/010 Reserved for alignment             *}
    SRB_BufLen: DWord; {* 0c/012 Data Allocation Length             *}
    SRB_BufPointer: PByte; {* 10/016 Data Buffer Pointer                *}
    SRB_SenseLen: Byte; {* 14/020 Sense Allocation Length            *}
    SRB_CDBLen: Byte; {* 15/021 CDB Length                         *}
    SRB_HaStat: Byte; {* 16/022 Host Adapter Status                *}
    SRB_TargStat: Byte; {* 17/023 Target Status                      *}
    SRB_PostProc: Pointer; {* 18/024 Post routine                       *}
    SRB_Rsvd2: array[0..19] of Byte; {* 1c/028 Reserved, must = 0                 *}
    CDBByte: array[0..15] of Byte; {* 30/048 SCSI CDB                           *}
    SenseArea: array[0..SENSE_LEN + 1] of Byte; {* 40/064 Request Sense buffer              *}
  end;

{***************************************************************************
 ** SRB - BUS DEVICE RESET - SC_RESET_DEV (4)
 ***************************************************************************}
  PSRB_BusDeviceReset = ^SRB_BusDeviceReset;
  SRB_BusDeviceReset = packed record
    SRB_Cmd: Byte; {* 00/000 ASPI cmd code == SC_RESET_DEV      *}
    SRB_Status: Byte; {* 01/001 ASPI command status byte           *}
    SRB_HaId: Byte; {* 02/002 ASPI host adapter number           *}
    SRB_Flags: Byte; {* 03/003 Reserved, must = 0                 *}
    SRB_Hdr_Rsvd: DWord; {* 04/004 Reserved                           *}
    SRB_Target: Byte; {* 08/008 Target's SCSI ID                   *}
    SRB_Lun: Byte; {* 09/009 Target's LUN number                *}
    SRB_Rsvd1: array[0..11] of Byte; {* 0A/010 Reserved for alignment             *}
    SRB_HaStat: Byte; {* 16/022 Host Adapter Status                *}
    SRB_TargStat: Byte; {* 17/023 Target Status                      *}
    SRB_PostProc: Pointer; {* 18/024 Post routine                       *}
    SRB_Rsvd2: array[0..35] of Byte; {* 1C/028 Reserved, must = 0                 *}
  end;


  PASPI32BUFF = ^ASPI32BUFF;
  ASPI32BUFF = packed record
    AB_BufPointer: PByte;
    AB_BufLen: DWord;
    AB_ZeroFill: DWord;
    AB_Reserved: DWord;
  end;

  PSRB = ^SRB;
  SRB = packed record
    SRB_Cmd: Byte;
    SRB_Status: Byte;
    SRB_HaId: Byte;
    SRB_Flags: Byte;
    SRB_Hdr_Rsvd: DWord;
  end;

implementation
end.
