//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    ezutils.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Pascal translation of C routines for EZ MP3 Creator
//
// 2006-04-16
// - Initial release with comments
//------------------------------------------------------------------------------

unit ezutils;

interface

uses SysUtils, Forms, Windows, ogglite;

// Ogg encode routine, because there are problems with the native pascal one, so we write it in C
var OggEncodeChunk: procedure(Input: PBYTE; Output: ppfloat; channels: int; samples: int); cdecl;

// Get drive letter in Windows 95/98/ME
var GetDriveLetter: procedure(DriveLetter: array of Char; MaxCount: Integer); cdecl;

// Get drive letter in Windows NT/2000/XP
var NTGetDriveLetter: function(ha, tgt, lun: BYTE): BYTE; cdecl;

// Load the library
function InitEZUtils: Boolean;

// Unload the library
procedure UninitEZUtils;

implementation

const
  C1 = 31416;
  C2 = 27183;

var 
  EZUFile: string;
  EZUHandle: THandle;

//------------------------------------------------------------------------------
// Procedure: GetTempFile
// Arguments: None
// Result:    string
// Comment:   Get a temporary file name
//------------------------------------------------------------------------------

function GetTempFile: string;
var
  TempPath: array[0..MAX_PATH] of Char;
  FileName: array[0..MAX_PATH] of Char;
begin
  GetTempPath(MAX_PATH, TempPath);
  GetTempFileName(TempPath, PChar('apm'), 0, FileName);
  Result := StrPas(FileName);
end;

//------------------------------------------------------------------------------
// Procedure: Decrypt
// Arguments: const S: string; Key: Word
// Result:    string
// Comment:   Decrypt a string with input key
//------------------------------------------------------------------------------

function Decrypt(const S: string; Key: Word): string;
var
  I: Integer;
begin
  Result := S;
  for I := 1 to Length(S) do
  begin
    Result[I] := char(byte(S[I]) xor (Key shr 8));
    Key := (byte(S[I]) + Key) * C1 + C2;
  end;
end;

//------------------------------------------------------------------------------
// Procedure: InitEZUtils
// Arguments: None
// Result:    Boolean
// Comment:   Load the library ezutils.dll
//------------------------------------------------------------------------------

function InitEZUtils: Boolean;
const
  Key = 9799;
var
  OldMode: Integer;
begin
  Result := False; 

  // Load the library
  EZUFile := ExtractFilePath(Application.ExeName) + 'ezutils.dll';
  OldMode := SetErrorMode($8001);
  EZUHandle := LoadLibrary(PChar(EZUFile)); // obtain the handle we want
  SetErrorMode(OldMode);
  
  if EZUHandle <> 0 then // Load successfully
  begin
    // Get function address
    @OggEncodeChunk := GetProcAddress(EZUHandle, 'OggEncodeChunk');
    @GetDriveLetter := GetProcAddress(EZUHandle, 'GetDriveLetter');
    @NTGetDriveLetter := GetProcAddress(EZUHandle, 'NTGetDriveLetter');

    // now check if everything is linked in correctly
    if (@OggEncodeChunk = nil) or
       (@GetDriveLetter = nil) or
       (@NTGetDriveLetter = nil) then
      UninitEZUtils;
  end;

  if EZUHandle <> 0 then // All success
    Result := True
  else // Error, delete temporary file
    DeleteFile(PChar(EZUFile));
end;

//------------------------------------------------------------------------------
// Procedure: UninitEZUtils
// Arguments: None
// Result:    None
// Comment:   Unload the library ezutils.dll
//------------------------------------------------------------------------------

procedure UninitEZUtils;
begin
  // Unload library
  if EZUHandle <> 0 then
  begin
    FreeLibrary(EZUHandle);
    EZUHandle := 0;
  end;
end;

end.
