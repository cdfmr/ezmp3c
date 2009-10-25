//------------------------------------------------------------------------------
// Project: WMA Encoding Library
// Unit:    wmaenc.h
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Windows Media Audio Encoding Library
//
// 2006-04-16
// - Initial release with comments
//------------------------------------------------------------------------------

#define WMAENC_API __declspec(dllexport)

extern "C" {

// Initialize WMA encoder
WMAENC_API HRESULT WMA_InitEncoder(
	WAVEFORMATEX wfWaveFormat,
	LPSTR pszOutFile,
	DWORD dwBitrate,
	DWORD dwSampleRate,
	DWORD dwChannels
);

// Set media attribute
WMAENC_API HRESULT WMA_SetAttribute(LPSTR pTagName, LPSTR pTagValue);

// Encode audio sample
WMAENC_API HRESULT WMA_EncodeSample(LPBYTE pBuffer, DWORD dwLength);

// Cleanup the encoder
WMAENC_API HRESULT WMA_Cleanup(void);

} // extern "C"
