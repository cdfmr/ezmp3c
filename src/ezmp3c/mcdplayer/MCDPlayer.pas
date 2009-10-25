{*******************************************************}
{                                                       }
{             MiTeC CD Player Component                 }
{           version 1.0 for Delphi 3,4,5                }
{                                                       }
{          Copyright (C) 2000 MichaL MutL               }
{                                                       }
{*******************************************************}

unit MCDPlayer;

interface

uses
  Windows, Messages, SysUtils, Forms, Classes, DBT, MMSystem;

const
  cAbout = 'MiTeC CD Player 1.0 - Copyright © 2000, Michal Mutl';

  cIsAudioCDString = 'AUDIO CD';

  MCI_INFO_PRODUCT = $00000100;
  MCI_INFO_FILE = $00000200;
  MCI_INFO_MEDIA_UPC = $00000400;
  MCI_INFO_MEDIA_IDENTITY = $00000800;
  MCI_INFO_NAME = $00001000;
  MCI_INFO_COPYRIGHT = $00002000;

  cCDDB = '/~cddb/cddb.cgi?cmd=';
  cCDDBHello = '&hello=username+hostname+MiTeC_CDPlayer+1.0&proto=4';

  cCategs: array[0..10] of string = (
    'rock',
    'misc',
    'classical',
    'jazz',
    'folk',
    'blues',
    'soundtrack',
    'newage',
    'country',
    'reggae',
    'data'
    );

  cCDFile = 'cdplayer.ini';
  cArtist = 'artist';
  cTitle = 'title';
  cTracks = 'numtracks';
  cDate = 'date';
  cCateg = 'category';

type
  EMCIDeviceError = class(Exception);
  ECDPlayerError = class(Exception);

  TTimeFormats = (tfMilliseconds, tfHMS, tfMSF, tfFrames, tfSMPTE24, tfSMPTE25,
    tfSMPTE30, tfSMPTE30Drop, tfBytes, tfSamples, tfTMSF);

  TDisplayTimeFormats = (tfTotalElapsed, tfTotalRemain, tfTrackElapsed, tfTrackRemain);

  TModes = (mpNotReady, mpStopped, mpPlaying, mpRecording, mpSeeking,
    mpPaused, mpOpen);

  TNotifyValues = (nvSuccessful, nvSuperseded, nvAborted, nvFailure);

  TDevCaps = (mpCanStep, mpCanEject, mpCanPlay, mpCanRecord, mpUsesWindow);
  TDevCapsSet = set of TDevCaps;

  TDeviceChangeEvent = procedure(Sender: TObject; FirstDriveLetter: char) of object;
  TMMNotifyEvent = procedure(Sender: TObject; NotifyValue: TNotifyValues) of object;

  TTMSF = record
    Tracks: byte;
    Minutes: byte;
    Seconds: byte;
    Frames: Byte;
  end;

  TMSF = record
    Minutes: byte;
    Seconds: Byte;
    Frames: byte;
    Unavailable: byte;
  end;

  TTOCEntry = record
    StartMin, StartSec,
      LenMin, LenSec,
      Frames: LongInt;
    Title: string;
    Extra: string;
  end;

  TDisplayTime = record
    Min, Sec: integer;
  end;

  TTOC = record
    Extra,
      Category,
      Artist,
      Album,
      Year: string;
    Tracks: array of TTOCEntry;
  end;

  TCDPlayer = class(TComponent)
  private
    FAfterInsert: TDeviceChangeEvent;
    FAfterRemove: TDeviceChangeEvent;
    FCDDrives: TStrings;
    FDeviceID: Word;
    FWindowHandle: HWND;
    FAbout: string;
    FOnNotify: TMMNotifyEvent;
    FTo: Longint;
    FFrom: Longint;
    FUseFrom,
      FUseTo: Boolean;
    FAutoRewind: Boolean;
    FTOC: TTOC;
    FCDDBID: Longint;
    FDrive: char;
    FDisplayTimeFormat: TDisplayTimeFormats;
    FDisplayTime: TDisplayTime;
    FDevCaps: TDevCapsSet;
    FKnownCD: Boolean;

    procedure WndProc(var Msg: TMessage);

    function GetCDInfo(ACommand: Word): string;
    function GetFirstDriveLetter(AUnitMask: longint): char;
    function GetDevice: Word;
    procedure GetDeviceCaps;
    function GetProductInfo: string;
    function GetSerialNumber: DWORD;
    function GetUPCNumber: string;
    procedure SetDevice(const Value: Word);
    procedure GetAllCDDrives;
    function GetAudioCDAutoRun: Boolean;
    function GetAudioCDPlayer: string;
    procedure SetAudioCDAutoRun(const Value: Boolean);
    procedure SetAudioCDPlayer(const Value: string);
    function GetLength: Longint;
    function GetStart: Longint;
    function GetTracks: Longint;
    function GetPosition: Longint;
    procedure SetPosition(const Value: Longint);
    function GetTrackLength(TrackNum: Integer): Longint;
    function GetTrackPosition(TrackNum: Integer): Longint;
    function GetTimeFormat: TTimeFormats;
    procedure SetTimeFormat(const Value: TTimeFormats);
    function GetMode: TModes;
    procedure SetAbout(const Value: string);
    procedure SetFrom(const Value: Longint);
    procedure SetTo(const Value: Longint);
    function GetTOCEntry(TrackNum: integer): TTOCEntry;
    procedure ReadTOC;
    function GetCDDBID: Longint;
    procedure ReadCDInfo;
    function GetCurrentTrack: integer;
    procedure GetCDTime(AFormat: TDisplayTimeFormats; var Min, Sec: integer);
    function GetDisplayTime: TDisplayTime;
    function GetDriveVolumeLabel(ADrive: char): string;
    function IsDriveAudioCD(ADrive: char): Boolean;
    function GetIsAudioCD: Boolean;
    function GetVolumeLabel: string;
    function GetAlbum: string;
    function GetArtist: string;
    function GetCategory: string;
    function GetYear: string;
    procedure ClearTOC;
  protected
    procedure WMDeviceChange(var Msg: TWMDeviceChange); dynamic;
    procedure MMNotify(var Message: TMessage); dynamic;
    procedure DoNotify(Value: TNotifyValues); dynamic;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    procedure Init;
    procedure Deinit;
    procedure OpenDoor;
    procedure CloseDoor;
    procedure Play;
    procedure Stop;
    procedure Pause;
    procedure Resume;
    procedure Rewind;
    procedure Next;
    procedure Prior;
    procedure Refresh;

    procedure SetCurrentTrackTime(APos: TDisplayTime);
    procedure SetCurrentTrackPosInMS(APos: Longint);
    function GetCurrentTrackPosInMS: Longint;
    function GetCurrentTrackLenInMS: Longint;
    function GetLengthInMS: Longint;
    function GetPosInMS: Longint;
    procedure GotoTrack(TrackNum: integer);

    function IsFinish: Boolean;

    function GetCDDBQuery(ACDDBServer: string): string;
    function GetCDDBRead(ACDDBServer, ACateg, ACDDBID: string): string;
    function GetCDDBMOTD(ACDDBServer: string): string;
    function GetCDDBStat(ACDDBServer: string): string;

    procedure ReadCDFromCDDB(ACDDBAnswer: string; var AArtist, AAlbum: string; var ATracks: TStringList);

    procedure FillCDInfo(AArtist, AAlbum, AYear, ACateg: string; ATracks: TStringList);

    procedure WriteCDToINI(ASerial: DWORD; AArtist, AAlbum, AYear, ACateg: string; ATracks: TStringList);
    function ReadCDFromINI(ASerial: DWORD; var AArtist, AAlbum, AYear, ACateg: string; var ATracks: TStringList): Boolean;

    property SerialNumber: DWORD read GetSerialNumber;
    property UPCNumber: string read GetUPCNumber;
    property ProductInfo: string read GetProductInfo;
    property Drives: TStrings read FCDDrives;
    property DeviceID: Word read FDeviceID write SetDevice;
    property Start: Longint read GetStart;
    property Length: Longint read GetLength;
    property Tracks: Longint read GetTracks;
    property Position: Longint read GetPosition write SetPosition;
    property TrackLength[TrackNum: Integer]: Longint read GetTrackLength;
    property TrackPosition[TrackNum: Integer]: Longint read GetTrackPosition;
    property TimeFormat: TTimeFormats read GetTimeFormat write SetTimeFormat;
    property Mode: TModes read GetMode;
    property StartPos: Longint read FFrom write SetFrom;
    property EndPos: Longint read FTo write SetTo;
    property TOC[TrackNum: integer]: TTOCEntry read GetTOCEntry;
    property Artist: string read GetArtist;
    property Album: string read GetAlbum;
    property Category: string read GetCategory;
    property Year: string read GetYear;
    property CDDBID: Longint read FCDDBID;
    property CurrentTrack: integer read GetCurrentTrack;
    property DisplayTime: TDisplayTime read GetDisplayTime;
    property VolumeLabel: string read GetVolumeLabel;
    property IsAudioCD: Boolean read GetIsAudioCD;
    property KnownCD: Boolean read FKnownCD;
  published
    property About: string read FAbout write SetAbout;
    property DefaultPlayer: string read GetAudioCDPlayer write SetAudioCDPlayer stored false;
    property AutoRun: Boolean read GetAudioCDAutoRun write SetAudioCDAutoRun stored false;
    property CurrentDrive: char read FDrive write FDrive;
    property AutoRewind: Boolean read FAutoRewind write FAutoRewind default True;
    property DisplayTimeMode: TDisplayTimeFormats read FDisplayTimeFormat write FDisplayTimeFormat;
    property AfterInsert: TDeviceChangeEvent read FAfterInsert write FAfterInsert;
    property AfterRemove: TDeviceChangeEvent read fAfterRemove write FAfterRemove;
    property OnNotify: TMMNotifyEvent read FOnNotify write FOnNotify;
  end;

procedure Register;

implementation

uses INIFiles, Registry;

procedure Register;
begin
  RegisterComponents('MiTeC', [TCDPlayer]);
end;

function MSFToFrame(MSF: Longint): Longint;
begin
  Result := MCI_MSF_FRAME(MSF);
  Result := Result + 75 * MCI_MSF_SECOND(MSF);
  Result := Result + 75 * 60 * MCI_MSF_MINUTE(MSF);
end;

function Frame2MSF(Frame: Longint; M, S, F: PInteger): Longint;
var
  Temp: Integer;
begin
  Temp := (Frame mod 75);
  if (F <> nil) then
    F^ := Temp;
  Result := Temp shl 16;

  Temp := Frame div 75;
  Result := Result or (Temp div 60);
  Temp := Temp mod 60;
  if (M <> nil) then
    M^ := Result and $FF;
  if (S <> nil) then
    S^ := Temp;
  Result := Result or (Temp shl 8);
end;

function FrameToMSF(Frame: Longint): Longint;
var
  M, S, F: integer;
begin
  Frame2MSF(Frame, @M, @S, @F);
  Result := MCI_MAKE_MSF(M, S, F);
end;

function MSFToSecond(MSF: Longint): Longint;
begin
  Result := MCI_MSF_Minute(MSF) * 60 + MCI_MSF_Second(MSF);
end;

{ TCDPlayer }

procedure TCDPlayer.CloseDoor;
var
  Parm: TMCI_SET_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_SET_DOOR_CLOSED;
    Parm.dwCallback := 0;
    mcierr := mciSendCommand(FDeviceID, MCI_SET, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

constructor TCDPlayer.Create(AOwner: TComponent);
begin
  inherited;
  FAbout := cAbout;
  FWindowHandle := AllocateHWnd(WndProc);
  SetLength(FTOC.Tracks, 0);
  FDrive := #0;
  FDeviceID := 0;
  FCDDrives := TStringList.Create;
  FAutoRewind := True;
  FDisplayTimeFormat := tfTotalElapsed;
  GetAllCDDrives;
  if FCDDrives.Count > 0 then
    CurrentDrive := FCDDrives[0][1];
end;

procedure TCDPlayer.Deinit;
begin
  DeviceID := 0;
end;

destructor TCDPlayer.Destroy;
begin
  FCDDrives.Free;
  SetLength(FTOC.Tracks, 0);
  Deinit;
  DeallocateHWnd(FWindowHandle);
  inherited;
end;

procedure TCDPlayer.ReadCDInfo;
var
  i: integer;
  sl: TStringList;
  art, alb, yr, cat: string;
begin
  ReadTOC;
  sl := TStringList.Create;
  FKnownCD := ReadCDFromINI(SerialNumber, art, alb, yr, cat, sl);
  FTOC.Artist := art;
  FTOC.Album := alb;
  FTOC.Category := cat;
  FTOC.Year := yr;
  for i := 0 to sl.Count - 1 do
    FTOC.Tracks[i].Title := sl[i];
  sl.Free;
  FCDDBID := GetCDDBID;
end;

procedure TCDPlayer.DoNotify;
begin
  if Assigned(FOnNotify) then
    FOnNotify(Self, Value);
end;

procedure TCDPlayer.GetAllCDDrives;
var
  Buffer: array[0..500] of char;
  TmpPC: PChar;
begin
  GetLogicalDriveStrings(SizeOf(Buffer), Buffer);
  TmpPC := Buffer;
  FCDDrives.Clear;
  FCDDrives.BeginUpdate;
  try
    while TmpPC[0] <> #0 do begin
      if GetDriveType(TmpPC) = Drive_CDROM then
        FCDDrives.Add(TmpPC);
      TmpPC := StrEnd(TmpPC) + 1;
    end;
  finally
    FCDDrives.EndUpdate;
  end;
end;

function TCDPlayer.GetAudioCDAutoRun: Boolean;
var
  Classes, ClassesRoot: string;
begin
  with TRegistry.Create do begin
    Rootkey := HKEY_LOCAL_MACHINE;
    OpenKey('Software\Classes\AudioCD\Shell', false);
    Classes := ReadString('');
    CloseKey;
    RootKey := HKEY_CLASSES_ROOT;
    OpenKey('AudioCD\Shell', false);
    ClassesRoot := ReadString('');
    CloseKey;
    Free;
  end;
  Classes := Uppercase(Classes);
  ClassesRoot := Uppercase(ClassesRoot);
  Result := (Classes <> '') and (ClassesRoot <> '');
end;

function TCDPlayer.GetAudioCDPlayer: string;
var
  s: string;
begin
  with TRegistry.Create do begin
    Rootkey := HKEY_LOCAL_MACHINE;
    OpenKey('SOFTWARE\Classes\AudioCD\Shell', false);
    s := ReadString('');
    CloseKey;
    if s = '' then
      s := 'play';
    OpenKey('SOFTWARE\Classes\AudioCD\Shell\' + s + '\command', false);
    Result := ReadString('');
    CloseKey;
    Free;
  end;
end;

function TCDPlayer.GetCDDBID: Longint;

  function cddb_sum(n: LongInt): LongInt;
  begin
    result := 0;
    while (n > 0) do begin
      result := result + n mod 10;
      n := n div 10;
    end;
  end;

var
  i, n, d: Longint;
  Offset_m,
    Offset_s,
    Offset_f,
    Len_m,
    Len_s,
    Len_f: LongInt;
  tf: TTimeFormats;
begin
  n := 0;
  if System.Length(FTOC.Tracks) = Tracks then begin
    for i := 0 to Tracks - 1 do
      n := n + cddb_sum(FTOC.Tracks[i].StartMin * 60 + FTOC.Tracks[i].StartSec);
    tf := TimeFormat;
    TimeFormat := tfMSF;
    offset_m := MCI_MSF_MINUTE(TrackPosition[Tracks]);
    offset_s := MCI_MSF_SECOND(TrackPosition[Tracks]);
    offset_f := MCI_MSF_FRAME(TrackPosition[Tracks]);
    Len_m := MCI_MSF_MINUTE(TrackLength[Tracks]);
    Len_s := MCI_MSF_SECOND(TrackLength[Tracks]);
    Len_f := MCI_MSF_FRAME(TrackLength[Tracks]);
    d := ((offset_m * 60 * 75) + (offset_s * 75) + offset_f +
      (len_m * 60 * 75) + (Len_s * 75) + len_f + 1);
    d := d div 75;
    d := d - (MCI_MSF_MINUTE(TrackPosition[1]) * 60 +
      MCI_MSF_SECOND(TrackPosition[1]));
    n := n mod 255;
    n := n shl 24;
    d := d shl 8;
    result := n or d or tracks;
    TimeFormat := tf;
  end else
    raise ECDPlayerError.Create('Table of content is not initialized.');
end;

function TCDPlayer.GetCDInfo(ACommand: Word): string;
var
  Parm: TMCI_INFO_PARMS;
  MediaString: array[0..255] of char;
  mcierr: DWORD;
begin
  if FDeviceID > 0 then begin
    FillChar(MediaString, SizeOf(MediaString), #0);
    FillChar(Parm, sizeof(Parm), #0);
    Parm.lpstrReturn := @MediaString;
    Parm.dwRetSize := 255;
    mcierr := mciSendCommand(FDeviceID, MCI_INFO, ACommand, longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @MediaString, SizeOf(MediaString));
      Result := StrPas(MediaString);
    end else
      Result := StrPas(MediaString);
  end;
end;

function TCDPlayer.GetDevice: Word;
var
  Parm: TMCI_OPEN_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  Path: string;
  ErrString: array[0..255] of char;
begin
  if not (csDesigning in ComponentState) then begin
    if FDeviceID = 0 then begin
      FillChar(Parm, SizeOf(TMCI_OPEN_PARMS), 0); // Added by Lin Fan
      Parm.lpstrDeviceType := 'CDAudio';
      if FDrive <> '' then begin
        Path := FDrive + ':';
        Parm.lpstrElementName := PChar(Path);
      end;
      Parm.dwCallback := 0;
      FFlags := MCI_NOTIFY or MCI_OPEN_TYPE or MCI_OPEN_ELEMENT or MCI_OPEN_SHAREABLE;
      mcierr := mciSendCommand(0, MCI_OPEN, FFlags, Longint(@Parm));
      if mcierr <> 0 then begin
        MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
        raise EMCIDeviceError.Create(StrPas(ErrString));
      end else
        FDeviceID := Parm.wDeviceID;
      GetDeviceCaps;
      TimeFormat := tfTMSF;
    end;
  end else
    FDeviceID := 0;
  Result := FDeviceID;
end;

function TCDPlayer.GetDriveVolumeLabel(ADrive: char): string;
var
  MaximumComponentLength: DWord;
  FileSystemFlags: DWord;
  VolumeName: Pchar;
begin
  Volumename := AllocMem(64);
  GetVolumeInformation(PChar(ADrive + ':\'), VolumeName,
    64, nil,
    MaximumComponentLength,
    FileSystemFlags, nil, 0);
  Result := StrPas(VolumeName);
  FreeMem(VolumeName);
end;

function TCDPlayer.GetFirstDriveLetter(AUnitMask: Integer): char;
var
  DriveLetter: shortint;
begin
  DriveLetter := Ord('A');
  while (AUnitMask and 1) = 0 do begin
    AUnitMask := AUnitMask shr 1;
    inc(DriveLetter);
  end;
  Result := Char(DriveLetter);
end;

function TCDPlayer.GetLength: Longint;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := 0;
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT;
    Parm.dwItem := MCI_STATUS_LENGTH;
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := Parm.dwReturn;
  end;
end;

function TCDPlayer.GetMode;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := mpNotReady; // Added by Lin Fan
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT;
    Parm.dwItem := MCI_STATUS_MODE;
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := TModes(Parm.dwReturn - 524);
  end;
end;

function TCDPlayer.GetPosition: Longint;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := 0;
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT;
    Parm.dwItem := MCI_STATUS_POSITION;
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := Parm.dwReturn;
  end;
end;

function TCDPlayer.GetProductInfo: string;
begin
  Result := GetCDInfo(MCI_INFO_Product);
end;

function TCDPlayer.GetSerialNumber;
begin
  try
    Result := StrToInt(GetCDInfo(MCI_INFO_MEDIA_IDENTITY));
  except
    Result := 0;
  end;
end;

function TCDPlayer.GetStart: Longint;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := 0;
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT or MCI_STATUS_START;
    Parm.dwItem := MCI_STATUS_POSITION;
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := Parm.dwReturn;
  end;
end;

function TCDPlayer.GetTimeFormat;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := tfMilliseconds; // Added by Lin Fan
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT;
    Parm.dwItem := MCI_STATUS_TIME_FORMAT;
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := TTimeFormats(Parm.dwReturn);
  end;
end;

function TCDPlayer.GetTOCEntry(TrackNum: integer): TTOCEntry;
begin
  if (TrackNum >= 0) or (TrackNum <= High(FTOC.Tracks)) then
    Result := FTOC.Tracks[TrackNum]
  else
    raise ECDPlayerError.Create('Table of content is not initialized.');
end;

function TCDPlayer.GetTrackLength(TrackNum: Integer): Longint;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := 0;
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT or MCI_TRACK;
    Parm.dwItem := MCI_STATUS_LENGTH;
    Parm.dwTrack := Longint(TrackNum);
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := Parm.dwReturn;
  end;
end;

function TCDPlayer.GetTrackPosition(TrackNum: Integer): Longint;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := 0;
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT or MCI_TRACK;
    Parm.dwItem := MCI_STATUS_POSITION;
    Parm.dwTrack := Longint(TrackNum);
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := Parm.dwReturn;
  end;
end;

function TCDPlayer.GetTracks: Longint;
var
  Parm: TMCI_STATUS_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  Result := 0;
  if FDeviceID > 0 then begin
    FFlags := MCI_STATUS_ITEM or MCI_WAIT;
    Parm.dwItem := MCI_STATUS_NUMBER_OF_TRACKS;
    mcierr := mciSendCommand(FDeviceID, MCI_STATUS, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end else
      Result := Parm.dwReturn;
  end;
end;

function TCDPlayer.GetUPCNumber: string;
begin
  Result := GetCDInfo(MCI_INFO_MEDIA_UPC);
end;

procedure TCDPlayer.Init;
begin
  DeInit;
  GetDevice;
  if IsAudioCD then
    ReadCDInfo;
end;

function TCDPlayer.IsDriveAudioCD(ADrive: char): Boolean;
begin
  try
    Result := (cIsAudioCDString = Uppercase(GetDriveVolumeLabel(ADrive))) or (Tracks > 1);
  except
    Result := False;
  end;
end;

procedure TCDPlayer.MMNotify(var Message: TMessage);
begin
  case Message.WParam of
    mci_Notify_Successful: DoNotify(nvSuccessful);
    mci_Notify_Superseded: DoNotify(nvSuperseded);
    mci_Notify_Aborted: DoNotify(nvAborted);
    mci_Notify_Failure: DoNotify(nvFailure);
  end;
end;

procedure TCDPlayer.Next;
var
  Parm: TMCI_SEEK_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_WAIT;
    Parm.dwCallback := FWindowHandle;

    if TimeFormat = tfTMSF then begin
      if Mode = mpPlaying then begin
        if MCI_TMSF_TRACK(Position) = Tracks then
          StartPos := GetTrackPosition(Tracks)
        else
          StartPos := GetTrackPosition((MCI_TMSF_TRACK(Position)) + 1);
        Play;
        Exit;
      end else begin
        if MCI_TMSF_TRACK(Position) = Tracks then
          Parm.dwTo := GetTrackPosition(Tracks)
        else
          Parm.dwTo := GetTrackPosition((MCI_TMSF_TRACK(Position)) + 1);
        FFlags := FFlags or MCI_TO;
      end;
    end else
      FFlags := FFlags or MCI_SEEK_TO_END;

    mcierr := mciSendCommand(FDeviceID, MCI_SEEK, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.OpenDoor;
var
  Parm: TMCI_SET_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_SET_DOOR_OPEN;
    Parm.dwCallback := 0;
    mcierr := mciSendCommand(FDeviceID, MCI_SET, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.Pause;
var
  Parm: TMCI_GENERIC_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_WAIT;
    Parm.dwCallback := FWindowHandle;
    mcierr := mciSendCommand(FDeviceID, MCI_PAUSE, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.Play;
var
  Parm: TMCI_PLAY_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    if FAutoRewind and (Position = Length) then
      if not FUseFrom and not FUseTo then
        Rewind;

    FFlags := MCI_NOTIFY; // or MCI_WAIT;

    if FUseFrom then begin
      FFlags := FFlags or MCI_FROM;
      Parm.dwFrom := FFrom;
      FUseFrom := False;
    end;
    if FUseTo then begin
      FFlags := FFlags or MCI_TO;
      Parm.dwTo := FTo;
      FUseTo := False;
    end;

    Parm.dwCallback := FWindowHandle;
    mcierr := mciSendCommand(FDeviceID, MCI_PLAY, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.Prior;
var
  Parm: TMCI_SEEK_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
  tpos, cpos: Longint;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_WAIT;
    Parm.dwCallback := FWindowHandle;

    if TimeFormat = tfTMSF then begin
      cpos := Position;
      tpos := GetTrackPosition(MCI_TMSF_TRACK(Position));
      if Mode = mpPlaying then begin
        if (MCI_TMSF_TRACK(cpos) <> 1) and
          (MCI_TMSF_MINUTE(cpos) = MCI_TMSF_MINUTE(tpos)) and
          (MCI_TMSF_SECOND(cpos) = MCI_TMSF_SECOND(tpos)) then
          StartPos := GetTrackPosition(MCI_TMSF_TRACK(Position) - 1)
        else
          StartPos := tpos;
        Play;
        Exit;
      end else begin
        if (MCI_TMSF_TRACK(cpos) <> 1) and
          (MCI_TMSF_MINUTE(cpos) = MCI_TMSF_MINUTE(tpos)) and
          (MCI_TMSF_SECOND(cpos) = MCI_TMSF_SECOND(tpos)) then
          Parm.dwTo := GetTrackPosition(MCI_TMSF_TRACK(Position) - 1)
        else
          Parm.dwTo := tpos;
        FFlags := FFlags or MCI_TO;
      end;
    end else
      FFlags := FFlags or MCI_SEEK_TO_START;

    mcierr := mciSendCommand(FDeviceID, MCI_SEEK, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.ReadTOC;
var
  i: byte;
  offset_m, offset_s, offset_f, pos: Longint;
  tf: TTimeFormats;
begin
  tf := TimeFormat;
  TimeFormat := tfMSF;
  SetLength(FTOC.Tracks, Tracks);
  for i := 0 to Tracks - 1 do begin
    offset_m := MCI_MSF_Minute(TrackPosition[i + 1]);
    offset_s := MCI_MSF_Second(TrackPosition[i + 1]);
    offset_f := MCI_MSF_Frame(TrackPosition[i + 1] + 1);
    pos := (offset_m * 60 * 75) + (offset_s * 75) + offset_f;
    FTOC.Tracks[i].Frames := pos;
    pos := pos div 75;
    FTOC.Tracks[i].StartMin := pos div 60;
    FTOC.Tracks[i].StartSec := pos mod 60;
    FTOC.Tracks[i].LenMin := TMSF(TrackLength[i + 1]).Minutes;
    FTOC.Tracks[i].LenSec := TMSF(TrackLength[i + 1]).Seconds;
    FTOC.Tracks[i].Title := '';
  end;
  TimeFormat := tf;
end;

procedure TCDPlayer.Resume;
var
  Parm: TMCI_GENERIC_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_WAIT;
    Parm.dwCallback := FWindowHandle;
    mcierr := mciSendCommand(FDeviceID, MCI_RESUME, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.Rewind;
var
  Parm: TMCI_SEEK_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_WAIT or MCI_SEEK_TO_START;
    mcierr := mciSendCommand(FDeviceID, MCI_SEEK, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.SetAbout(const Value: string);
begin
end;

procedure TCDPlayer.SetAudioCDAutoRun(const Value: Boolean);
begin
  with TRegistry.Create do begin
    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('SOFTWARE\Classes\AudioCD\Shell', False);
    if Value then
      WriteString('', 'play')
    else
      WriteString('', '');
    CloseKey;
    RootKey := HKEY_CLASSES_ROOT;
    OpenKey('AudioCD\Shell', false);
    if Value then
      WriteString('', 'play')
    else
      WriteString('', '');
    CloseKey;
    Free;
  end;
end;

procedure TCDPlayer.SetAudioCDPlayer(const Value: string);
var
  s: string;
begin
  with TRegistry.Create do begin
    RootKey := HKEY_CLASSES_ROOT;
    OpenKey('AudioCD\Shell', false);
    s := ReadString('');
    if s = '' then
      s := 'play';
    CloseKey;
    OpenKey('AudioCD\Shell\' + s + '\command', false);
    WriteString('', Value);
    CloseKey;

    RootKey := HKEY_LOCAL_MACHINE;
    OpenKey('SOFTWARE\Classes\AudioCD\Shell\' + s + '\command', false);
    WriteString('', Value);
    CloseKey;

    Free;
  end;
end;

procedure TCDPlayer.SetCurrentTrackPosInMS;
var
  tf: TTimeFormats;
  ct: integer;
begin
  ct := CurrentTrack;
  tf := TimeFormat;
  TimeFormat := tfMilliseconds;
  try
    Position := FTOC.Tracks[ct - 1].StartMin * 1000 * 60 + FTOC.Tracks[ct - 1].StartSec * 1000 + APos;
  except
  end;
  TimeFormat := tf;
end;

procedure TCDPlayer.SetDevice(const Value: Word);
var
  Parms: TMCI_GENERIC_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
begin
  if not (csDesigning in ComponentState) then begin
    if (Value = 0) and (FDeviceID <> 0) then begin
      FFlags := MCI_NOTIFY or MCI_OPEN_TYPE or MCI_OPEN_SHAREABLE;
      mcierr := mciSendCommand(FDeviceID, MCI_CLOSE, FFlags, Longint(@Parms));
      if mcierr = 0 then
        FDeviceID := 0;
    end;
  end;
end;

procedure TCDPlayer.SetFrom(const Value: Longint);
begin
  if Value <> FFrom then
    FFrom := Value;
  FUseFrom := True;
end;

procedure TCDPlayer.SetPosition(const Value: Longint);
var
  Parm: TMCI_SEEK_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_TO;
    Parm.dwTo := Value;
    Parm.dwCallback := FWindowHandle;
    mcierr := mciSendCommand(FDeviceID, MCI_SEEK, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.SetTimeFormat;
var
  Parm: TMCI_SET_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_SET_TIME_FORMAT;
    Parm.dwTimeFormat := Longint(Value);
    mcierr := mciSendCommand(FDeviceID, MCI_SET, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.SetTo(const Value: Longint);
begin
  if Value <> FTo then
    FTo := Value;
  FUseTo := True;
end;

procedure TCDPlayer.Stop;
var
  Parm: TMCI_GENERIC_PARMS;
  mcierr: DWORD;
  FFlags: Longint;
  ErrString: array[0..255] of char;
begin
  if FDeviceID > 0 then begin
    FFlags := MCI_NOTIFY or MCI_WAIT;
    Parm.dwCallback := FWindowHandle;
    mcierr := mciSendCommand(FDeviceID, MCI_STOP, FFlags, Longint(@Parm));
    if mcierr <> 0 then begin
      MciGetErrorString(mcierr, @ErrString, SizeOf(ErrString));
      raise EMCIDeviceError.Create(StrPas(ErrString));
    end;
  end;
end;

procedure TCDPlayer.WMDeviceChange(var Msg: TWMDeviceChange);
var
  lpdb: PDEV_BROADCAST_HDR;
  lpdbv: PDEV_BROADCAST_VOLUME;
  Drive: char;
begin
  lpdb := PDEV_BROADCAST_HDR(Msg.dwData);
  case Msg.Event of
    DBT_DEVICEARRIVAL: begin
        if lpdb^.dbch_devicetype = DBT_DEVTYP_VOLUME then begin
          lpdbv := PDEV_BROADCAST_VOLUME(Msg.dwData);
          if (lpdbv^.dbcv_flags and DBTF_MEDIA) = 1 then begin
            Drive := GetFirstDriveLetter(lpdbv^.dbcv_unitmask);
            if Drive = FDrive then begin
              Deinit;
              Init;
              if IsAudioCD then
                ReadCDInfo;
            end;
            if Assigned(FAfterInsert) then
              FAfterInsert(Self, Drive);
          end;
        end;
      end;
    DBT_DEVICEREMOVECOMPLETE: begin
        if lpdb^.dbch_devicetype = DBT_DEVTYP_VOLUME then begin
          lpdbv := PDEV_BROADCAST_VOLUME(Msg.dwData);
          if (lpdbv^.dbcv_flags and DBTF_MEDIA) = 1 then begin
            ClearTOC;
            if Assigned(FAfterRemove) then
              FAfterRemove(Self, GetFirstDriveLetter(lpdbv^.dbcv_unitmask));
          end;
        end;
      end;
  end;
end;

procedure TCDPlayer.WndProc(var Msg: TMessage);
begin
  if (Msg.Msg = WM_DEVICECHANGE) then
  try
    WMDeviceChange(TWMDeviceChange(Msg));
  except
    Application.HandleException(Self);
  end
  else
    if (Msg.Msg = MM_MCINOTIFY) then
      MMNotify(Msg)
    else
      Msg.Result := DefWindowProc(FWindowHandle, Msg.Msg, Msg.wParam, Msg.lParam);
end;

procedure TCDPlayer.Refresh;
begin
  if IsAudioCD then
    ReadCDInfo;
end;

function TCDPlayer.GetCurrentTrack: integer;
begin
  try
    result := TTMSF(Position).Tracks;
  except
    Result := 0;
  end;
end;

function TCDPlayer.GetDisplayTime: TDisplayTime;
begin
  GetCDTime(FDisplayTimeFormat, FDisplayTime.Min, FDisplayTime.Sec);
  Result := FDisplayTime;
end;

procedure TCDPlayer.GetCDTime(AFormat: TDisplayTimeFormats; var Min,
  Sec: integer);
var
  dl, p, tl, ct, et, em, es, Lm, Ls, lt: LongInt;
  tf: TTimeFormats;
begin
  case AFormat of
    tfTotalElapsed: begin
        tf := TimeFormat;
        TimeFormat := tfMSF;
        p := Position;
        min := TMSF(p).Minutes;
        sec := TMSF(p).Seconds;
        TimeFormat := tf;
      end;
    tfTotalRemain: begin
        tf := TimeFormat;
        TimeFormat := tfMSF;
        dl := Length;
        p := Position;
        lt := MCI_MSF_MINUTE(dl) * 60 + MCI_MSF_MINUTE(dl);
        et := TMSF(p).Minutes * 60 + TMSF(p).Seconds;
        min := (lt - et) div 60;
        sec := (lt - et) mod 60;
        TimeFormat := tf;
      end;
    tfTrackElapsed: begin
        p := Position;
        min := TTMSF(p).Minutes;
        sec := TTMSF(p).Seconds;
      end;
    tfTrackRemain: begin
        p := Position;
        ct := CurrentTrack;
        tl := TrackLength[ct];
        em := TTMSF(p).Minutes;
        es := TTMSF(p).Seconds;
        et := em * 60 + es;
        tf := TimeFormat;
        TimeFormat := tfMSF;
        Lm := MCI_MSF_MINUTE(tl);
        Ls := MCI_MSF_SECOND(tl);
        lt := lm * 60 + ls;
        min := (lt - et) div 60;
        sec := (lt - et) mod 60;
        TimeFormat := tf;
      end;
  end;
end;

function TCDPlayer.IsFinish: Boolean;
var
  m, s: integer;
begin
  if (Mode = mpStopped) then begin
    GetCDTime(tfTrackRemain, m, s);
    Result := (CurrentTrack = Tracks) and (m <= 0) and (s <= 10);
  end else
    Result := False;
end;

function TCDPlayer.GetIsAudioCD: Boolean;
begin
  Result := IsDriveAudioCD(FDrive);
end;

function TCDPlayer.GetVolumeLabel: string;
begin
  Result := GetDriveVolumeLabel(FDrive);
end;

function TCDPlayer.GetCurrentTrackPosInMS: Longint;
var
  m, s: Longint;
begin
  GetCDTime(tfTrackElapsed, m, s);
  Result := m * 60 * 1000 + s * 1000;
end;

procedure TCDPlayer.SetCurrentTrackTime(APos: TDisplayTime);
var
  ct: integer;
  tf: TTimeFormats;
begin
  tf := TimeFormat;
  ct := CurrentTrack;
  TimeFormat := tfMilliseconds;
  Position := (FTOC.Tracks[ct - 1].StartMin + APos.Min) * 1000 * 60 + (FTOC.Tracks[ct - 1].StartSec + APos.Sec) * 1000;
  TimeFormat := tf;
end;

function TCDPlayer.GetCurrentTrackLenInMS: Longint;
var
  ct: integer;
  tl: Longint;
begin
  ct := CurrentTrack;
  tl := TrackLength[ct];
  Result := TMSF(tl).Minutes * 60 * 1000 + TMSF(tl).Seconds * 1000;
end;

procedure TCDPlayer.GetDeviceCaps;
var
  Parm: TMCI_GETDEVCAPS_PARMS;
  devType: Longint;
  FFlags: Longint;
begin
  FDevCaps := [];
  if FDeviceID > 0 then begin
    FFlags := MCI_WAIT or MCI_GETDEVCAPS_ITEM;

    Parm.dwItem := MCI_GETDEVCAPS_CAN_PLAY;
    mciSendCommand(FDeviceID, MCI_GETDEVCAPS, FFlags, Longint(@Parm));
    if Boolean(Parm.dwReturn) then
      Include(FDevCaps, mpCanPlay);

    Parm.dwItem := MCI_GETDEVCAPS_CAN_RECORD;
    mciSendCommand(FDeviceID, MCI_GETDEVCAPS, FFlags, Longint(@Parm));
    if Boolean(Parm.dwReturn) then
      Include(FDevCaps, mpCanRecord);

    Parm.dwItem := MCI_GETDEVCAPS_CAN_EJECT;
    mciSendCommand(FDeviceID, MCI_GETDEVCAPS, FFlags, Longint(@Parm));
    if Boolean(Parm.dwReturn) then
      Include(FDevCaps, mpCanEject);

    Parm.dwItem := MCI_GETDEVCAPS_HAS_VIDEO;
    mciSendCommand(FDeviceID, MCI_GETDEVCAPS, FFlags, Longint(@Parm));
    if Boolean(Parm.dwReturn) then
      Include(FDevCaps, mpUsesWindow);

    Parm.dwItem := MCI_GETDEVCAPS_DEVICE_TYPE;
    mciSendCommand(FDeviceID, MCI_GETDEVCAPS, FFlags, Longint(@Parm));
    devType := Parm.dwReturn;
    if (devType = MCI_DEVTYPE_ANIMATION) or
      (devType = MCI_DEVTYPE_DIGITAL_VIDEO) or
      (devType = MCI_DEVTYPE_OVERLAY) or
      (devType = MCI_DEVTYPE_VCR) then
      Include(FDevCaps, mpCanStep);
  end;
end;

function TCDPlayer.GetCDDBQuery;
var
  i: integer;
begin
  Result := 'http://' + ACDDBServer + cCDDB + 'cddb+query+' + IntToHex(CDDBID, 8) + '+' + IntToStr(Tracks);
  for i := 0 to Tracks - 1 do
    Result := Result + '+' + IntToStr(FTOC.Tracks[i].Frames);
  Result := Result + '+' + IntToStr(MSFToSecond(Length));
  Result := LowerCase(Result) + cCDDBHello;
//http://cddb.cddb.com/~cddb/cddb.cgi?cmd=cddb+query+c611cd0e+12+183+34813+54428+69133+94350+119940+135170+167013+188603+227750+246220+288523+205&hello=username+hostname+NotifyCDPlayer(CDDB)+1.51.3&proto=1
end;

function TCDPlayer.GetCDDBRead;
begin
  if ACDDBID <> '' then
    Result := 'http://' + ACDDBServer + cCDDB + 'cddb+read+' + ACateg + '+' + ACDDBID
  else
    Result := 'http://' + ACDDBServer + cCDDB + 'cddb+read+' + ACateg;
  Result := LowerCase(Result) + cCDDBHello;
end;

function TCDPlayer.GetCDDBMOTD(ACDDBServer: string): string;
begin
  Result := 'http://' + ACDDBServer + ccddb + 'motd' + cCDDBHello;
end;

function TCDPlayer.GetCDDBStat(ACDDBServer: string): string;
begin
  Result := 'http://' + ACDDBServer + ccddb + 'stat' + cCDDBHello;
end;

function TCDPlayer.GetAlbum: string;
begin
  Result := FTOC.Album;
end;

function TCDPlayer.GetArtist: string;
begin
  Result := FTOC.Artist;
end;

procedure TCDPlayer.WriteCDToINI(ASerial: DWORD; AArtist, AAlbum, AYear, ACateg: string;
  ATracks: TStringList);
var
  i: integer;
  s: string;
begin
  s := IntToHex(ASerial, 6);
  with TINIFile.Create(cCDFile) do begin
    WriteString(s, cArtist, AArtist);
    WriteString(s, cTitle, AAlbum);
    WriteString(s, cTracks, IntToStr(ATracks.Count));
    WriteString(s, cDate, AYear);
    for i := 0 to ATracks.Count - 1 do
      WriteString(s, IntToStr(i), ATracks[i]);
    Free;
  end;
end;

function TCDPlayer.ReadCDFromINI(ASerial: DWORD; var AArtist, AAlbum, AYear,
  ACateg: string; var ATracks: TStringList): Boolean;
var
  sl: TStringList;
  i, tn: integer;
  s: string;
begin
  sl := nil;
  s := IntToHex(ASerial, 6);
  ATracks.Clear;
  with TINIFile.Create(cCDFile) do begin
    Result := SectionExists(s);
    if Result then begin
      sl := TStringList.Create;
      ReadSectionValues(s, sl);
    end;
    Free;
  end;
  if Result and Assigned(sl) then begin
    AAlbum := sl.Values[cTitle];
    AArtist := sl.Values[cArtist];
    AYear := sl.Values[cDate];
    ACateg := sl.Values[cCateg];
    try
      tn := StrToInt(sl.Values[cTracks]);
    except
      tn := 0;
    end;
    for i := 0 to tn - 1 do
      ATracks.Add(sl.Values[IntToStr(i)]);
    sl.Free;
  end;
end;

function TCDPlayer.GetLengthInMS: Longint;
var
  l: Longint;
begin
  l := Length;
  Result := TMSF(l).Minutes * 60 * 1000 + TMSF(l).Seconds * 1000;
end;

function TCDPlayer.GetPosInMS: Longint;
var
  m, s: Longint;
begin
  GetCDTime(tfTotalElapsed, m, s);
  Result := m * 60 * 1000 + s * 1000;
end;

procedure TCDPlayer.GotoTrack(TrackNum: integer);
begin
  if CurrentTrack <> TrackNum then
    Position := TrackPosition[TrackNum];
end;

procedure TCDPlayer.ReadCDFromCDDB;
var
  i, si, p, j: integer;
  sl: tstringlist;
  s: string;
begin
  AArtist := '';
  AAlbum := '';
  si := 0;
  sl := TStringList.Create;
  sl.text := ACDDBAnswer;
  s := '';
  for i := 0 to sl.Count - 1 do
    if pos('DTITLE=', sl[i]) = 1 then begin
      s := s + copy(sl[i], system.Length('DTITLE=') + 1, 1024);
      si := i;
    end else
      if s <> '' then
        Break;
  p := pos(' / ', s);
  if p > 0 then begin
    AArtist := copy(s, 1, p - 1);
    AAlbum := copy(s, p + 3, 1024);
  end;
  j := 0;
  ATracks.Clear;
  for i := si + 1 to sl.count - 1 do begin
    if pos('TTITLE', sl[i]) = 1 then begin
      ATracks.Add(copy(sl[i], system.Length('TTITLE' + inttostr(j) + '=') + 1, 1024));
      inc(j);
    end else
      break;
  end;
  sl.free;
end;

function TCDPlayer.GetCategory: string;
begin
  Result := FTOC.Category;
end;

function TCDPlayer.GetYear: string;
begin
  Result := FTOC.Year;
end;

procedure TCDPlayer.FillCDInfo(AArtist, AAlbum, AYear, ACateg: string;
  ATracks: TStringList);
var
  i: integer;
begin
  with FTOC do begin
    Album := AAlbum;
    Artist := AArtist;
    Year := AYear;
    Category := ACateg;
    SetLength(Tracks, ATracks.Count);
    for i := 0 to ATracks.Count - 1 do
      Tracks[i].Title := ATracks[i];
  end;
end;

procedure TCDPlayer.ClearTOC;
begin
  with FTOC do begin
    Category := '';
    Artist := '';
    Album := '';
    Year := '';
    SetLength(Tracks, 0);
  end;
end;

end.

