//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    ezutils.c
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: C routines for EZ MP3 Creator
//
// 2006-04-16
// - Initial release with comments
//------------------------------------------------------------------------------

#include <windows.h>
#include <stdio.h>
#include <stddef.h>
#include "ezutils.h"
#include "../akrip32/scsipt.h"

// SCSI drive definition, from akrip32
typedef struct {
	BYTE ha;
	BYTE tgt;
	BYTE lun;
	BOOL iscdrom;
} DRIVE;

static DRIVE DriveInfos[26];

//------------------------------------------------------------------------------
// Procedure: GetFileHandle
// Arguments: BYTE
// Result:    HANDLE
// Comment:   Function from akrip
//------------------------------------------------------------------------------

HANDLE GetFileHandle( BYTE i )
{
	TCHAR buf[12];
	HANDLE fh;
	OSVERSIONINFO osver;
	DWORD dwFlags;

	ZeroMemory(&osver, sizeof(osver));
	osver.dwOSVersionInfoSize = sizeof(osver);
	GetVersionEx(&osver);

	// if Win2K or greater, add GENERIC_WRITE
	dwFlags = GENERIC_READ;
	if ((osver.dwPlatformId == VER_PLATFORM_WIN32_NT) && (osver.dwMajorVersion > 4)) {
		dwFlags |= GENERIC_WRITE;
	}

	wsprintf(buf, TEXT("\\\\.\\%c:"), (char)('A' + i));
	fh = CreateFile(buf, dwFlags, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);

	if (fh == INVALID_HANDLE_VALUE) {
		// it went foobar somewhere, so try it with the GENERIC_WRITE
		// bit flipped
		dwFlags ^= GENERIC_WRITE;
		fh = CreateFile(buf, dwFlags, FILE_SHARE_READ, NULL, OPEN_EXISTING, 0, NULL);
	}

	return fh;
}

//------------------------------------------------------------------------------
// Procedure: GetDriveInformation
// Arguments: BYTE, DRIVE *
// Result:    HANDLE
// Comment:   Function from akrip
//------------------------------------------------------------------------------

void GetDriveInformation( BYTE i, DRIVE *pDrive )
{
	HANDLE fh;
	char buf[1024];
	BOOLEAN status;
	PSCSI_PASS_THROUGH_DIRECT_WITH_BUFFER pswb;
	PSCSI_ADDRESS pscsiAddr;
	ULONG length, returned;
	BYTE inqData[100];

	fh = GetFileHandle(i);

	if (fh == INVALID_HANDLE_VALUE)
		return;

	// Get the drive inquiry data
	ZeroMemory(&buf, 1024);
	ZeroMemory(inqData, 100);
	pswb							= (PSCSI_PASS_THROUGH_DIRECT_WITH_BUFFER)buf;
	pswb->spt.Length				= sizeof(SCSI_PASS_THROUGH);
	pswb->spt.CdbLength				= 6;
	pswb->spt.SenseInfoLength		= 24;
	pswb->spt.DataIn				= SCSI_IOCTL_DATA_IN;
	pswb->spt.DataTransferLength	= 100;
	pswb->spt.TimeOutValue			= 5;
	pswb->spt.DataBuffer			= inqData;
	pswb->spt.SenseInfoOffset		= offsetof(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER,ucSenseBuf );
	pswb->spt.Cdb[0]				= 0x12;
	pswb->spt.Cdb[4]				= 100;

	length = sizeof(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);
	status = DeviceIoControl(fh,
							 IOCTL_SCSI_PASS_THROUGH_DIRECT,
							 pswb,
							 length,
							 pswb,
							 length,
							 &returned,
							 NULL);

	if (!status) {
		CloseHandle(fh);
		return;
	}

	// Get the address (path/tgt/lun) of the drive via IOCTL_SCSI_GET_ADDRESS
	ZeroMemory(&buf, 1024);
	pscsiAddr = (PSCSI_ADDRESS)buf;
	pscsiAddr->Length = sizeof(SCSI_ADDRESS);
	if (DeviceIoControl(fh, IOCTL_SCSI_GET_ADDRESS, NULL, 0,
						pscsiAddr, sizeof(SCSI_ADDRESS), &returned,	NULL)) {
		pDrive->iscdrom = TRUE;
		pDrive->ha = pscsiAddr->PortNumber;
		pDrive->tgt = pscsiAddr->TargetId;
		pDrive->lun = pscsiAddr->Lun;
	}
	else {
		// support USB/FIREWIRE devices where this call is not supported
		// assign drive letter as device ID
		if (GetLastError() == 50) {
			pDrive->iscdrom = TRUE;
			pDrive->ha = i;
			pDrive->tgt = 0;
			pDrive->lun = 0;
		}
		else {
			pDrive->iscdrom = FALSE;
			return;
		}
	}

	CloseHandle(fh);
}

//------------------------------------------------------------------------------
// Procedure: NTGetDriveLetter
// Arguments: cdrom parameters
// Result:    cdrom letter
// Comment:   Get cdrom letter in Windows NT/2000/XP with device attribute
//------------------------------------------------------------------------------

EZUTILS_API BYTE NTGetDriveLetter(BYTE ha, BYTE tgt, BYTE lun)
{
	BYTE i;

	for (i=2; i<26; i++)
		if (DriveInfos[i].iscdrom)
			if ((DriveInfos[i].ha == ha) && (DriveInfos[i].tgt == tgt) && (DriveInfos[i].lun == lun))
				return i;

	return 0;
}

//------------------------------------------------------------------------------
// Procedure: GetDriveLetter
// Arguments: CDListLetter - store all cdrom letters
//            MaxCount - max count of cdroms
// Result:    None
// Comment:   Get cdrom letters in Windows 95/98/ME
//------------------------------------------------------------------------------

EZUTILS_API void GetDriveLetter(char *CDListLetter, int MaxCount)
{
	int		i = 0;
	char	Letter;
	char	Drive[3];

    for (Letter = 'A'; Letter <= 'Z'; Letter++) {
		Drive[0] = Letter;
		Drive[1] = ':';
		Drive[2] = '\\';
		if (GetDriveType(Drive) == DRIVE_CDROM) {
			CDListLetter[i++] = Letter;
			if (i >= MaxCount) break;
		}
	}
}

//------------------------------------------------------------------------------
// Procedure: OggEncodeChunk
// Arguments: Input - input buffer
//            Output - output buffer
//            channels - channel count
//            samples - sample count
// Result:    None
// Comment:   Encode audio buffer to ogg format
//------------------------------------------------------------------------------

EZUTILS_API void OggEncodeChunk(PBYTE Input, float** Output, int channels, int samples)
{
	int i, j;
	signed char* b = (signed char*)Input;

	if (channels == 2) {
		for (i = 0; i < samples; i++) {
			j = i << 2;
			Output[0][i] = (((long)b[j + 1] << 8) | (0x00ff & (int)b[j])) / 32768.0f;
			Output[1][i] = (((long)b[j + 3] << 8) | (0x00ff & (int)b[j + 2])) / 32768.0f;
		}
	}
	else {
		for (i = 0; i < samples; i++) {
			for(j = 0; j < channels; j++) {
				Output[j][i] = (((long)b[i * 2 * channels + 2 * j+1] << 8)|
					((long)b[i * 2 * channels + 2 * j] & 0xff)) / 32768.0f;
			}
		}
	}

	return;
}

//------------------------------------------------------------------------------
// Procedure: DllMain
// Arguments: System
// Result:    BOOL
// Comment:   Dll Entrance
//------------------------------------------------------------------------------

BOOL APIENTRY DllMain(HANDLE hModule, DWORD reason_for_call, LPVOID lpReserved)
{
	BYTE			i;
	char			buf[4];
	UINT			uDriveType;
	HMODULE			hApp;
	char			lpAppFile[MAX_PATH];
	unsigned char	digest[16];

	switch (reason_for_call) {
		case DLL_PROCESS_ATTACH:

			// Get drive information
			ZeroMemory(&DriveInfos, sizeof(DriveInfos));
			for(i = 2; i < 26; i++) {
				DriveInfos[i].iscdrom = FALSE;
				wsprintf(buf, "%c:\\", (char)('A'+i));
				uDriveType = GetDriveType(buf);
				if (uDriveType == DRIVE_CDROM)
					GetDriveInformation(i, &DriveInfos[i]);
			}

			break;

		case DLL_PROCESS_DETACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
			break;
	}

	return TRUE;
}
