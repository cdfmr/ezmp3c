//------------------------------------------------------------------------------
// Project: WMA Encoding Library
// Unit:    wmaenc.cpp
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Windows Media Audio Encoding Library
//
// 2006-04-16
// - Initial release with comments
//------------------------------------------------------------------------------

#include <windows.h>
#include "wmaenc.h"
#include "wmasdk/wmaudiosdk.h"

//------------------------------------------------------------------------------
// Procedure: DllMain
// Arguments: System
// Result:    bool
// Comment:   Dll Entrance
//------------------------------------------------------------------------------

BOOL APIENTRY DllMain(HANDLE hModule, DWORD reason_for_call, LPVOID lpReserved)
{
	switch (reason_for_call) {
		case DLL_PROCESS_ATTACH:
		case DLL_THREAD_ATTACH:
		case DLL_THREAD_DETACH:
		case DLL_PROCESS_DETACH:
			break;
	}

	return TRUE;
}

// Writer Interface
IWMAudioWriter *pIWMAudioWriter;

//------------------------------------------------------------------------------
// Procedure: WMA_InitEncoder
// Arguments: wfWaveFormat: Input Format
//            pszOutFile:	Output File
//            dwBitrate, dwSampleRate, dwChannels: Output Format
// Result:    HRESULT
// Comment:   Initialize WMA encoder
//------------------------------------------------------------------------------

WMAENC_API HRESULT WMA_InitEncoder(
	WAVEFORMATEX wfWaveFormat,
	LPSTR pszOutFile,
	DWORD dwBitrate,
	DWORD dwSampleRate,
	DWORD dwChannels
)
{
	pIWMAudioWriter = NULL;
	HRESULT hr = S_OK;
	WCHAR pszwOutFile[1024];

	// Convert to unicode
	if (0 == MultiByteToWideChar(CP_ACP, 0, pszOutFile, strlen(pszOutFile) + 1,
								 pszwOutFile, sizeof(pszwOutFile)))
		return E_UNEXPECTED;

	// Create writer interface
	hr = WMAudioCreateWriter(pszwOutFile, &pIWMAudioWriter);
	if (FAILED(hr))
		return hr;

	// Set input format
	hr = pIWMAudioWriter->SetInputFormat(&wfWaveFormat);
	if (FAILED(hr)) {
		pIWMAudioWriter->Release();
		pIWMAudioWriter = NULL;
		return hr;
	}

	// Set output format
	hr = pIWMAudioWriter->SetOutputFormat(dwBitrate, dwSampleRate, dwChannels,
										  WMT_OPTION_DEFAULT);
	if (FAILED(hr)) {
		pIWMAudioWriter->Release();
		pIWMAudioWriter = NULL;
		return hr;
	}

	return hr;
}

//------------------------------------------------------------------------------
// Procedure: WMA_SetID3Tag
// Arguments: pTagName: Tag Name
//            pTagValue: Tag Value
// Result:    HRESULT
// Comment:	  Set media attribute
//------------------------------------------------------------------------------

WMAENC_API HRESULT WMA_SetAttribute(LPSTR pName, LPSTR pValue)
{
	HRESULT hr;
	WCHAR wName[512];
	WCHAR wValue[512];
	BYTE *pBytes;
	WORD wLen;

	// Convert to unicode
	if (0 == MultiByteToWideChar(CP_ACP, 0, pName, strlen(pName) + 1, wName,
								 sizeof(wName)))
		return E_INVALIDARG;
	if (0 == MultiByteToWideChar(CP_ACP, 0, pValue, strlen(pValue) + 1, wValue,
								 sizeof(wValue)))
		return E_INVALIDARG;

	// Set attribute
	wLen = sizeof(WCHAR) * (wcslen(wValue) + 1);
	pBytes = (BYTE *) wValue;
	hr = pIWMAudioWriter->SetAttribute(wName, WMT_TYPE_STRING, pBytes, wLen);

	return hr;
}

//------------------------------------------------------------------------------
// Procedure: WMA_EncodeSample
// Arguments: pBuffer: Sample Buffer
//            dwLength: Buffer Size
// Result:    HRESULT
// Comment:	  Encode audio sample
//------------------------------------------------------------------------------

WMAENC_API HRESULT WMA_EncodeSample(LPBYTE pBuffer, DWORD dwLength)
{
	HRESULT hr = S_OK;

	if (dwLength)
		hr = pIWMAudioWriter->WriteSample(pBuffer, dwLength);

	return hr;
}

//------------------------------------------------------------------------------
// Procedure: WMA_Cleanup
// Arguments: None
// Result:    HRESULT
// Comment:	  Cleanup the encoder
//------------------------------------------------------------------------------

WMAENC_API HRESULT WMA_Cleanup(void)
{
	HRESULT hr;

	hr = pIWMAudioWriter->Flush();
	if (FAILED(hr))
		return hr;
	pIWMAudioWriter->Release();
	pIWMAudioWriter = NULL;
	return S_OK;
}
