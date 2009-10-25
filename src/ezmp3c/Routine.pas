//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    Routine.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Common Routines
//
// 2006-05-07
// - Initial release with comments 
//------------------------------------------------------------------------------

unit Routine;

interface

uses Windows, Messages, Forms, SysUtils, ShlObj;

const
  // Only one instance constants
  WM_EZMP3CONLYONE = WM_USER + 1000;
  EZMP3CONLYONECLASS = 'OnlyOneInstanceOfEZMP3CreatorCanRun';

  // Valid words for file name rule
  FNRuleConsts: array[0..4] of string =
    ('<track>', '<number>', '<title>', '<artist>', '<album>');

// Display a message box
function MsgDlg(const Text: string; Flags: Longint = 0): Integer;

// Browse directory dialog
function BrowseDirectory(Handle: THandle; out Directory: string): Boolean;

// Check whether a directory name is valid
function ValidDirName(const DirName: string): Boolean;

// Check whether a file name is valid
function ValidFileName(const FileName: string): Boolean;

// Check whether a file name rule is valid
function ValidFileNameRule(const Rule: string): Boolean;

// Create directory recursively
procedure ForceDirectories(Dir: string);

// Convert ascii string to wide string
function Latin1ToWideString(const S: string): string;

// Convert wide string to utf8 string
function WideStringToUTF8(const S: string): string;

// Swap two double-word variables
procedure SwapDword(var a: DWORD; var b: DWORD);

implementation

uses CFGParam;

//------------------------------------------------------------------------------
// Procedure: MsgDlg
// Arguments: const Text: string - message to show
//            Flags: Longint = 0 - message box flags
// Result:    button clicked
// Comment:   Display a message box
//------------------------------------------------------------------------------

function MsgDlg(const Text: string; Flags: Longint = 0): Integer;
begin
  Result := Application.MessageBox(PChar(Text), PChar(AppTitle), Flags);
end;

//------------------------------------------------------------------------------
// Procedure: BrowseDirectory
// Arguments: Handle: THandle - owner window
//            out Directory: string - directory selected
// Result:    Boolean
// Comment:   Show a browse directory dialog
//------------------------------------------------------------------------------

function BrowseDirectory(Handle: THandle; out Directory: string): Boolean;
var
  BrowseInfo: TBrowseInfo;
  Buffer: array[0..MAX_PATH] of Char;
  ItemIDList: PItemIDList;
begin
  Directory := '';

  // Initialize BROWSEINFO structure
  FillChar(BrowseInfo, SizeOf(BrowseInfo), 0);
  with BrowseInfo do begin
    hwndOwner := Handle;
    pszDisplayName := Buffer;
    ulFlags := BIF_RETURNONLYFSDIRS;
    lParam := BFFM_INITIALIZED;
  end;

  // Show dialog
  ItemIDList := ShBrowseForFolder(BrowseInfo);

  // Get directory
  Result := ItemIDList <> nil;
  if Result then begin
    ShGetPathFromIDList(ItemIDList, Buffer);
    Directory := StrPas(Buffer);
  end;
end;

//------------------------------------------------------------------------------
// Procedure: HasAny
// Arguments: const Str, Substr: string
// Result:    Boolean
// Comment:   Check whether a string has specified characters
//------------------------------------------------------------------------------

function HasAny(const Str, Substr: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 1 to Length(Substr) do // Check every character
    if Pos(Substr[I], Str) > 0 then
    begin
      Result := True;
      Break;
    end;
end;

//------------------------------------------------------------------------------
// Procedure: ValidDirName
// Arguments: const DirName: string
// Result:    Boolean
// Comment:   Check whether a directory name is valid
//------------------------------------------------------------------------------

function ValidDirName(const DirName: string): Boolean;

  function GetCharCount(C: Char; S: string): Integer;
  var
    i: Integer;
  begin
    Result := 0;
    for i := 1 to Length(S) do
      if S[i] = C then
        Inc(Result);
  end;

var
  I: Integer;
begin
  Result := (DirName <> '') and
            (not HasAny(DirName, '/*?"<>|')) and
            (Pos('\', ExtractFileName(DirName)) = 0) and
            (GetCharCount(':', DirName) <= 1);

  if Result then
  begin
    // Absolute path only
    I := Pos(':', DirName);
    Result := I = 2;

    // Check disk letter
    if Result then
    begin
      Result := DirName[1] in ['A'..'Z', 'a'..'z'];
      if Result and (Length(DirName) > 2) then
        Result := DirName[3] = '\';
    end;
  end;

  // Check UNC path
  if Result then
  begin
    i := Pos('\\', DirName);
    Result := (i = 0) or (i = 1);
  end;

  // Check dots
  if Result then
    Result := Pos('...', DirName) = 0;
end;

//------------------------------------------------------------------------------
// Procedure: ValidFileName
// Arguments: const FileName: string
// Result:    Boolean
// Comment:   Check whether a file name rule is valid
//------------------------------------------------------------------------------

function ValidFileName(const FileName: string): Boolean;
begin
  Result := (FileName <> '') and (not HasAny(FileName, '/:*?"<>|'));
  if Result then
    Result := Pos('\', FileName) <> 1;
  if Result then
    Result := Pos('\\', FileName) = 0;
end;

//------------------------------------------------------------------------------
// Procedure: ValidFileNameRule
// Arguments: const Rule: string
// Result:    Boolean
// Comment:   Check whether a file name rule is valid
//------------------------------------------------------------------------------

function ValidFileNameRule(const Rule: string): Boolean;
var
  i: Integer;
  FN: string;
begin
  FN := Rule;
  for i := Low(FNRuleConsts) to High(FNRuleConsts) do
    FN := StringReplace(FN, FNRuleConsts[i], 'A', [rfReplaceAll, rfIgnoreCase]);
  Result := ValidFileName(FN);
end;

//------------------------------------------------------------------------------
// Procedure: ForceDirectories
// Arguments: Dir: string
// Result:    None
// Comment:   Create directory recursively
//------------------------------------------------------------------------------

procedure ForceDirectories(Dir: string);
begin
  if Length(Dir) = 0 then Exit;
  if Dir[Length(Dir)] = '\' then
    Delete(Dir, Length(Dir), 1);
  if (Length(Dir) < 3) or DirectoryExists(Dir) or
    (ExtractFilePath(Dir) = Dir) then Exit;
  ForceDirectories(ExtractFilePath(Dir));
  CreateDir(Dir);
end;

//------------------------------------------------------------------------------
// Procedure: Latin1ToWideString
// Arguments: const S: string
// Result:    string
// Comment:   Convert ascii string to wide string
//------------------------------------------------------------------------------

function Latin1ToWideString(const S: string): string;
begin
  SetLength(Result, SizeOf(WCHAR) *
    (MultiByteToWideChar(CP_ACP, 0, @S[1], Length(S), nil, 0) + 1));
  MultiByteToWideChar(CP_ACP, 0, @S[1], Length(S), @Result[1],
    Length(Result) div SizeOf(WCHAR));
  PWord(@Result[Length(Result) + 1 - SizeOf(WCHAR)])^ := 0;
end;

//------------------------------------------------------------------------------
// Procedure: WideStringToUTF8
// Arguments: const S: string
// Result:    string
// Comment:   Convert wide string to utf8 string
//------------------------------------------------------------------------------

function WideStringToUTF8(const S: string): string;
begin
  SetLength(Result, WideCharToMultiByte(CP_UTF8, 0, @S[1],
    Length(S) div SizeOf(WCHAR), nil, 0, nil, nil));
  WideCharToMultiByte(CP_UTF8, 0, @S[1], Length(S) div SizeOf(WCHAR),
    @Result[1], Length(Result), nil, nil);
end;

//------------------------------------------------------------------------------
// Procedure: SwapDword
// Arguments: var A: DWORD; var B: DWORD
// Result:    None
// Comment:   Swap two double-word variables
//------------------------------------------------------------------------------

procedure SwapDword(var A: DWORD; var B: DWORD);
var
  T: DWORD;
begin
  T := A; A := B; B := T;
end;

end.

