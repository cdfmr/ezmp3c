//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    instplug.dpr
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Plugin for Nullsoft Scriptable Install System
//
// 2006-06-03
// - Initial release with comments
//------------------------------------------------------------------------------

library instplug;

uses Windows, SysUtils;

type
  VarConstants = (
    INST_0,       // $0
    INST_1,       // $1
    INST_2,       // $2
    INST_3,       // $3
    INST_4,       // $4
    INST_5,       // $5
    INST_6,       // $6
    INST_7,       // $7
    INST_8,       // $8
    INST_9,       // $9
    INST_R0,      // $R0
    INST_R1,      // $R1
    INST_R2,      // $R2
    INST_R3,      // $R3
    INST_R4,      // $R4
    INST_R5,      // $R5
    INST_R6,      // $R6
    INST_R7,      // $R7
    INST_R8,      // $R8
    INST_R9,      // $R9
    INST_CMDLINE, // $CMDLINE
    INST_INSTDIR, // $INSTDIR
    INST_OUTDIR,  // $OUTDIR
    INST_EXEDIR,  // $EXEDIR
    __INST_LAST
    );
  TVariableList = INST_0..__INST_LAST;
  pstack_t = ^stack_t;
  stack_t = record
    next: pstack_t;
    text: PChar;
  end;

var
  g_stringsize: integer;
  g_stacktop: ^pstack_t;
  g_variables: PChar;
  g_hwndParent: HWND;

function PopString(str: PChar): integer;
var
  th: pstack_t;
begin
  if integer(g_stacktop^) = 0 then
  begin
    Result := 1;
    Exit;
  end;
  th := g_stacktop^;
  lstrcpy(str, @th.text);
  g_stacktop^ := th.next;
  GlobalFree(HGLOBAL(th));
  Result := 0;
end;

function PushString(str: PChar): integer;
var
  th: pstack_t;
begin
  if integer(g_stacktop) = 0 then
  begin
    Result := 1;
    Exit;
  end;
  th := pstack_t(GlobalAlloc(GPTR, sizeof(stack_t) + g_stringsize));
  lstrcpyn(@th.text, str, g_stringsize);
  th.next := g_stacktop^;
  g_stacktop^ := th;
  Result := 0;
end;

//------------------------------------------------------------------------------
// Procedure: GetSysType
// Result:    Return "NT" or "9X" in stack
// Comment:   Detect whether the system is nt series or 9x series
//------------------------------------------------------------------------------

function GetSysType(hwndParent: HWND; string_size: integer; variables: PChar;
  stacktop: pointer): Integer; cdecl;
var
  OSVersionInfo: TOSVersionInfo;
begin
  // set up global variables
  g_stringsize := string_size;
  g_hwndParent := hwndParent;
  g_stacktop := stacktop;
  g_variables := variables;

  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  GetVersionEx(OSVersionInfo);
  if OSVersionInfo.dwPlatformId = VER_PLATFORM_WIN32_NT then
    PushString('NT')
  else
    PushString('9X');

  Result := 1;
end;

//------------------------------------------------------------------------------
// Procedure: IsXPorNewer
// Result:    Return "YES" or "NO" in stack
// Comment:   Detect whether the system is windows xp or newer
//------------------------------------------------------------------------------

function IsXPorNewer(hwndParent: HWND; string_size: integer; variables: PChar;
  stacktop: pointer): Integer; cdecl;
var
  OSVersionInfo: TOSVersionInfo;
begin
  // set up global variables
  g_stringsize := string_size;
  g_hwndParent := hwndParent;
  g_stacktop := stacktop;
  g_variables := variables;

  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  GetVersionEx(OSVersionInfo);
  with OSVersionInfo do
    if (dwPlatformId = VER_PLATFORM_WIN32_NT) and
      ((dwMajorVersion > 5) or
      ((dwMajorVersion = 5) and (dwMinorVersion >= 1))) then
      PushString('YES')
    else
      PushString('NO');

  Result := 1;
end;

//------------------------------------------------------------------------------
// Procedure: IsWMAInstalled
// Result:    Return "YES" or "NO" in stack
// Comment:   Detect whether Windows Media Audio component is installed
//------------------------------------------------------------------------------

function IsWMAInstalled(hwndParent: HWND; string_size: integer; variables: PChar; 
  stacktop: pointer): Integer; cdecl;
const
  WMA_FILES: array[0..5] of string = (
    'msaud32.acm', 'wmaudsdk.dll', 'drmclien.dll', 'asfsipc.dll', 'drmstor.dll',
    'strmdll.dll'
  );
var
  TempSysDir: array[0..MAX_PATH] of Char;
  SysDir: string;
  WMAFile: string;
  I: Integer;
begin
  // set up global variables
  g_stringsize := string_size;
  g_hwndParent := hwndParent;
  g_stacktop := stacktop;
  g_variables := variables;

  GetSystemDirectory(TempSysDir, MAX_PATH);
  SysDir := StrPas(TempSysDir);
  if SysDir[Length(SysDir)] <> '\' then
    SysDir := SysDir + '\';

  Result := 1;
  for I := Low(WMA_FILES) to High(WMA_FILES) do
  begin
    WMAFile := SysDir + WMA_FILES[I];
    if not FileExists(WMAFile) then
    begin
      PushString('NO');
      Exit;
    end;
  end;
  PushString('YES');
end;

exports
  GetSysType,
  IsXPorNewer,
  IsWMAInstalled;

begin
end.

