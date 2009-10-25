//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    CFGParam.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Store Configuration
//
// 2006-05-06
// - Initial release with comments
//------------------------------------------------------------------------------

unit CFGParam;

interface

uses Classes, Windows, Registry;

const
  {$I Version.inc}

  EZMP3CKey = 'Software\Linasoft\' + AppTitle;
  DefaultCDDBServer = 'freedb.freedb.org';
  DefaultCDDBScript = '/~cddb/cddb.cgi';
  DefaultCDDBUser = 'user@host.com';
  DefaultOutputFolder = 'C:\Music';
  DefaultFileNameRule = '<artist>\<album>\<track>. <title>';

const
  MP3Bitrates: array[0..13] of DWORD
  = (32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320);
  OggBitrates: array[0..10] of DWORD
  = (60, 80, 96, 112, 128, 160, 192, 224, 256, 320, 498);
  WMABitrates: array[0..11] of DWORD
  = (12, 16, 20, 32, 36, 40, 48, 64, 80, 96, 128, 160);

var
  UserName, RegCode: string;

// Get index of input value in bitrate array
function GetMP3BitrateIndex(var Bitrate: DWORD; Default: DWORD): DWORD;
function GetOggBitrateIndex(var Bitrate: DWORD; Default: DWORD): DWORD;
function GetWMABitrateIndex(var Bitrate: DWORD; Default: DWORD): DWORD;

// Load configuration from registry
procedure LoadParam;

// Save configuration in registry
procedure SaveParam;

implementation

uses RipUnit, Routine;

////////////////////////////////////////////////////////////////////////////////
// Bitrate Routines

//------------------------------------------------------------------------------
// Procedure: AdjustMP3Bitrate
// Arguments: var Bitrate: DWORD - Input Value
//            Default: DWORD - Default Value
// Result:    None
// Comment:   Adjust bitrate to value supported by LAME/GOGO
//------------------------------------------------------------------------------

procedure AdjustMP3Bitrate(var Bitrate: DWORD; Default: DWORD);
var
  I: Integer;
begin
  for I := Low(MP3Bitrates) to High(MP3Bitrates) do
    if Bitrate = MP3Bitrates[I] then Exit;
  Bitrate := Default;
end;

//------------------------------------------------------------------------------
// Procedure: GetMP3BitrateIndex
// Arguments: var Bitrate: DWORD - Input Value
//            Default: DWORD - Default Value
// Result:    Index
// Comment:   Get index of input value in mp3 bitrate array
//------------------------------------------------------------------------------

function GetMP3BitrateIndex(var Bitrate: DWORD; Default: DWORD): DWORD;
var
  I: Integer;
begin
  AdjustMP3Bitrate(Bitrate, Default);
  for I := Low(MP3Bitrates) to High(MP3Bitrates) do
    if Bitrate = MP3Bitrates[I] then Break;
  Result := I;
end;

//------------------------------------------------------------------------------
// Procedure: AdjustOggBitrate
// Arguments: var Bitrate: DWORD - Input Value
//            Default: DWORD - Default Value
// Result:    None
// Comment:   Adjust bitrate to value supported by Ogg Vorbis
//------------------------------------------------------------------------------

procedure AdjustOggBitrate(var Bitrate: DWORD; Default: DWORD);
var
  I: Integer;
begin
  for I := Low(OggBitrates) to High(OggBitrates) do
    if Bitrate = OggBitrates[I] then Exit;
  Bitrate := Default;
end;

//------------------------------------------------------------------------------
// Procedure: GetOggBitrateIndex
// Arguments: var Bitrate: DWORD - Input Value
//            Default: DWORD - Default Value
// Result:    Index
// Comment:   Get index of input value in ogg bitrate array
//------------------------------------------------------------------------------

function GetOggBitrateIndex(var Bitrate: DWORD; Default: DWORD): DWORD;
var
  I: Integer;
begin
  AdjustOggBitrate(Bitrate, Default);
  for I := Low(OggBitrates) to High(OggBitrates) do
    if Bitrate = OggBitrates[I] then Break;
  Result := I;
end;

//------------------------------------------------------------------------------
// Procedure: AdjustWMABitrate
// Arguments: var Bitrate: DWORD - Input Value
//            Default: DWORD - Default Value
// Result:    None
// Comment:   Adjust bitrate to value supported by Windows Media Audio
//------------------------------------------------------------------------------

procedure AdjustWMABitrate(var Bitrate: DWORD; Default: DWORD);
var
  I: Integer;
begin
  for I := Low(WMABitrates) to High(WMABitrates) do
    if Bitrate = WMABitrates[I] then Exit;
  Bitrate := Default;
end;

//------------------------------------------------------------------------------
// Procedure: GetWMABitrateIndex
// Arguments: var Bitrate: DWORD - Input Value
//            Default: DWORD - Default Value
// Result:    Index
// Comment:   Get index of input value in wma bitrate array
//------------------------------------------------------------------------------

function GetWMABitrateIndex(var Bitrate: DWORD; Default: DWORD): DWORD;
var
  I: Integer;
begin
  AdjustWMABitrate(Bitrate, Default);
  for I := Low(WMABitrates) to High(WMABitrates) do
    if Bitrate = WMABitrates[I] then Break;
  Result := I;
end;

////////////////////////////////////////////////////////////////////////////////
// Configuration Load/Save Routines

//------------------------------------------------------------------------------
// Procedure: LoadParam
// Arguments: None
// Result:    None
// Comment:   Load configuration from registry
//------------------------------------------------------------------------------

procedure LoadParam;
var
  I: Integer;
begin
  with TRegIniFile.Create(EZMP3CKey) do
  try
    // Registration Information
    UserName := ReadString('Registration', 'UserName', '');
    RegCode := ReadString('Registration', 'RegCode', '');
                  
    // CDDB Connection
    with CDDBConnection do
    begin
      Server := ReadString('CDDB', 'Server', DefaultCDDBServer);
      Script := ReadString('CDDB', 'Script', DefaultCDDBScript);
      Proxy := ReadBool('CDDB', 'Proxy', False);
      Host := ReadString('CDDB', 'Host', '');
      Port := ReadInteger('CDDB', 'Port', 80);
      Authorization := ReadBool('CDDB', 'Authorization', False);
      Name := ReadString('CDDB', 'Name', '');
      Password := ReadString('CDDB', 'Password', '');
    end;
                               
    // Output Options
    OutputFolder := ReadString('Options', 'OutputFolder', DefaultOutputFolder);
    FileNameRule := ReadString('Options', 'FileNameRule', DefaultFileNameRule);
    I := ReadInteger('Options', 'ActionPriority', Ord(tpNormal));
    if (I > Ord(tpHighest)) or (I < Ord(tpLowest)) then
      I := Ord(tpNormal);
    ActionPriority := TThreadPriority(I);

    // MP3 Encoding Configuration
    with MP3EncodeParam do
    begin
      EnableVBR := ReadBool('MP3Encoder', 'EnableVBR', True);
      WriteVBRHeader := ReadBool('MP3Encoder', 'WriteVBRHeader', True);
      VBRQuality := ReadInteger('MP3Encoder', 'VBRQuality', 5);
      if VBRQuality > 9 then VBRQuality := 5;
      MinBitrate := ReadInteger('MP3Encoder', 'MinBitrate', 128);
      AdjustMP3Bitrate(MinBitrate, 128);
      MaxBitrate := ReadInteger('MP3Encoder', 'MaxBitrate', 256);
      AdjustMP3Bitrate(MaxBitrate, 256);
      if MinBitrate > MaxBitrate then
        SwapDword(MinBitrate, MaxBitrate);
      Quality := ReadInteger('MP3Encoder', 'Quality', 8);
      if Quality > 9 then Quality := 9;
      I := ReadInteger('MP3Encoder', 'AudioMode', Ord(mpcmJointStereo));
      if (I > Ord(mpcmJointStereo)) or (I < Ord(mpcmMono)) then
        I := Ord(mpcmJointStereo);
      AudioMode := TMP3CoderMode(I);
    end;

    // Ogg Encoding Configuration
    with OggEncodeParam do
    begin
      EnableBBR := ReadBool('OggEncoder', 'EnableBBR', False);
      EnableVBR := ReadBool('OggEncoder', 'EnableVBR', True);
      Bitrate := ReadInteger('OggEncoder', 'Bitrate', 128);
      AdjustOggBitrate(Bitrate, 128);
      MinBitrate := ReadInteger('OggEncoder', 'MinBitrate', 128);
      AdjustOggBitrate(MinBitrate, 128);
      MaxBitrate := ReadInteger('OggEncoder', 'MaxBitrate', 256);
      AdjustOggBitrate(MaxBitrate, 256);
      if MinBitrate > MaxBitrate then
        SwapDword(MinBitrate, MaxBitrate);
      VBRQuality := ReadInteger('OggEncoder', 'VBRQuality', 128);
      AdjustOggBitrate(VBRQuality, 128);
      I := ReadInteger('OggEncoder', 'AudioMode', Ord(ogcmStereo));
      if (I > Ord(ogcmStereo)) or (I < Ord(ogcmMono)) then
        I := Ord(ogcmStereo);
      AudioMode := TOggCoderMode(I);
    end;
             
    // WMA Encoding Configuration
    with WMAEncodeParam do
    begin
      Bitrate := ReadInteger('WMAEncoder', 'Bitrate', 128);
      AdjustWMABitrate(Bitrate, 128);
      I := ReadInteger('WMAEncoder', 'AudioMode', Ord(wmamStereo));
      if (I > Ord(wmamStereo)) or (I < Ord(wmamMono)) then
        I := Ord(wmamStereo);
      AudioMode := TWMACoderMode(I);
      if Bitrate > 32 then
        AudioMode := wmamStereo;
    end;
  finally
    Free;
  end;
end;

//------------------------------------------------------------------------------
// Procedure: SaveParam
// Arguments: None
// Result:    None
// Comment:   Save configuration in registry
//------------------------------------------------------------------------------

procedure SaveParam;
begin
  with TRegIniFile.Create(EZMP3CKey) do
  try
    // Registration Information
    WriteString('Registration', 'UserName', UserName);
    WriteString('Registration', 'RegCode', RegCode);

    // CDDB Connection
    with CDDBConnection do
    begin
      WriteString('CDDB', 'Server', Server);
      WriteString('CDDB', 'Script', Script);
      WriteBool('CDDB', 'Proxy', Proxy);
      WriteString('CDDB', 'Host', Host);
      WriteInteger('CDDB', 'Port', Port);
      WriteBool('CDDB', 'Authorization', Authorization);
      WriteString('CDDB', 'Name', Name);
      WriteString('CDDB', 'Password', Password);
    end;

    // Output Options
    WriteString('Options', 'OutputFolder', OutputFolder);
    WriteString('Options', 'FileNameRule', FileNameRule);
    WriteInteger('Options', 'ActionPriority', Ord(ActionPriority));

    // MP3 Encoding Configuration
    with MP3EncodeParam do
    begin
      WriteBool('MP3Encoder', 'EnableVBR', EnableVBR);
      WriteBool('MP3Encoder', 'WriteVBRHeader', WriteVBRHeader);
      WriteInteger('MP3Encoder', 'VBRQuality', VBRQuality);
      WriteInteger('MP3Encoder', 'MinBitrate', MinBitrate);
      WriteInteger('MP3Encoder', 'MaxBitrate', MaxBitrate);
      WriteInteger('MP3Encoder', 'Quality', Quality);
      WriteInteger('MP3Encoder', 'AudioMode', Ord(AudioMode));
    end;

    // Ogg Encoding Configuration
    with OggEncodeParam do
    begin
      WriteBool('OggEncoder', 'EnableBBR', EnableBBR);
      WriteBool('OggEncoder', 'EnableVBR', EnableVBR);
      WriteInteger('OggEncoder', 'Bitrate', Bitrate);
      WriteInteger('OggEncoder', 'MinBitrate', MinBitrate);
      WriteInteger('OggEncoder', 'MaxBitrate', MaxBitrate);
      WriteInteger('OggEncoder', 'VBRQuality', VBRQuality);
      WriteInteger('OggEncoder', 'AudioMode', Ord(AudioMode));
    end;

    // WMA Encoding Configuration
    with WMAEncodeParam do
    begin
      WriteInteger('WMAEncoder', 'Bitrate', Bitrate);
      WriteInteger('WMAEncoder', 'AudioMode', Ord(AudioMode));
    end;
  finally
    Free;
  end;
end;

end.

