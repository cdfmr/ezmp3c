//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    ezutils.h
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: C routines for EZ MP3 Creator
//
// 2006-04-16
// - Initial release with comments
//------------------------------------------------------------------------------

#define EZUTILS_API __declspec(dllexport)

#include <windows.h>

// Encode audio buffer to ogg format
EZUTILS_API void OggEncodeChunk(PBYTE Input, float **Output, int channels, int samples);

// Get cdrom letters in Windows 95/98/ME
EZUTILS_API void GetDriveLetter(char *CDListLetter, int MaxCount);

// Get cdrom letter in Windows NT/2000/XP with device attribute
EZUTILS_API BYTE NTGetDriveLetter(BYTE ha, BYTE tgt, BYTE lun);
