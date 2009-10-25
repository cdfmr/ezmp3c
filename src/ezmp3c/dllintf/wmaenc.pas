//------------------------------------------------------------------------------
// Project: WMA Encoding Library Pascal Interface
// Unit:    wmaenc.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Pascal Interface of WMA Encoding Library
//
// 2006-04-16
// - Initial release with comments
//------------------------------------------------------------------------------

unit wmaenc;

interface

uses Windows, MMSystem, SysUtils, Forms;

const
  WMAENCLIB = 'wmaenc.dll';

{$IFDEF WMA_STATIC}

// Initialize WMA encoder
function WMA_InitEncoder(wfWaveFormat: TWaveFormatEx; pszOutFile: PChar; dwBitrate, dwSampleRate, dwChannels: DWORD): HRESULT; cdecl; external WMAENCLIB;

// Set media attribute
function WMA_SetAttribute(pTagName, pTagValue: PChar): HRESULT; cdecl; external WMAENCLIB;

// Encode audio sample
function WMA_EncodeSample(pBuffer: PByte; dwLength: DWORD): HRESULT; cdecl; external WMAENCLIB;

// Cleanup the encoder
function WMA_Cleanup: HRESULT; cdecl; external WMAENCLIB;

{$ENDIF} // WMA_STATIC

// Initialize WMA encoder
var WMA_InitEncoder: function(wfWaveFormat: TWaveFormatEx; pszOutFile: PChar; dwBitrate, dwSampleRate, dwChannels: DWORD): HRESULT; cdecl;

// Set media attribute
var WMA_SetAttribute: function(pTagName, pTagValue: PChar): HRESULT; cdecl;

// Encode audio sample
var WMA_EncodeSample: function(pBuffer: PByte; dwLength: DWORD): HRESULT; cdecl;

// Cleanup the encoder
var WMA_Cleanup: function: HRESULT; cdecl;

// Load the library
function InitWMAENC: Boolean;

// Unload the library
procedure UninitWMAENC;

implementation

var
  WMAENCHandle: THandle;

//------------------------------------------------------------------------------
// Procedure: InitEZUtils
// Arguments: None
// Result:    Boolean
// Comment:   Load the library ezutils.dll
//------------------------------------------------------------------------------

function InitWMAENC: Boolean;
const
  Key = 9799;
var
  OldMode: Integer;
begin
  Result := False;

  // Load the library
  OldMode := SetErrorMode($8001);
  WMAENCHandle :=                       // obtain the handle we want
    LoadLibrary(PChar(ExtractFilePath(Application.ExeName) + 'wmaenc.dll')); 
  SetErrorMode(OldMode);
  
  if WMAENCHandle <> 0 then // Load successfully
  begin
    // Get function address
    @WMA_InitEncoder := GetProcAddress(WMAENCHandle, 'WMA_InitEncoder');
    @WMA_SetAttribute := GetProcAddress(WMAENCHandle, 'WMA_SetAttribute');
    @WMA_EncodeSample := GetProcAddress(WMAENCHandle, 'WMA_EncodeSample');
    @WMA_Cleanup := GetProcAddress(WMAENCHandle, 'WMA_Cleanup');

    // now check if everything is linked in correctly
    if (@WMA_InitEncoder = nil) or
       (@WMA_SetAttribute = nil) or
       (@WMA_EncodeSample = nil) or
       (@WMA_Cleanup = nil) then
      UninitWMAENC;
  end;

  if WMAENCHandle <> 0 then // All success
    Result := True;
end;

//------------------------------------------------------------------------------
// Procedure: UninitEZUtils
// Arguments: None
// Result:    None
// Comment:   Unload the library ezutils.dll
//------------------------------------------------------------------------------

procedure UninitWMAENC;
begin
  // Unload library
  if WMAENCHandle <> 0 then
  begin
    FreeLibrary(WMAENCHandle);
    WMAENCHandle := 0;
  end;
end;

end.

