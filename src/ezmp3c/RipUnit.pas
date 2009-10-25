unit RipUnit;

interface

uses
  Classes, SysUtils, Windows, IniFiles, MMSystem,
  akrip32, myaspi32, gogo, ogglite, wmaenc, ezutils;

const
  FRAMESIZE = 2352;
  FRAMECOUNT = 8;
  GOGOREAD_MAX = 4;

  // Genre List
  ID3GenreList: array[0..147] of string =
     ('Blues',
      'Classic Rock',
      'Country',
      'Dance',
      'Disco',
      'Funk',
      'Grunge',
      'Hip-Hop',
      'Jazz',
      'Metal',
      'New Age',
      'Oldies',
      'Other',
      'Pop',
      'R&B',
      'Rap',
      'Reggae',
      'Rock',
      'Techno',
      'Industrial',
      'Alternative',
      'Ska',
      'Death Metal',
      'Pranks',
      'Soundtrack',
      'Euro-Techno',
      'Ambient',
      'Trip-Hop',
      'Vocal',
      'Jazz+Funk',
      'Fusion',
      'Trance',
      'Classical',
      'Instrumental',
      'Acid',
      'House',
      'Game',
      'Sound Clip',
      'Gospel',
      'Noise',
      'AlternRock',
      'Bass',
      'Soul',
      'Punk',
      'Space',
      'Meditative',
      'Instrumental Pop',
      'Instrumental Rock',
      'Ethnic',
      'Gothic',
      'Darkwave',
      'Techno-Industrial',
      'Electronic',
      'Pop-Folk',
      'Eurodance',
      'Dream',
      'Southern Rock',
      'Comedy',
      'Cult',
      'Gangsta',
      'Top 40',
      'Christian Rap',
      'Pop/Funk',
      'Jungle',
      'Native American',
      'Cabaret',
      'New Wave',
      'Psychadelic',
      'Rave',
      'Showtunes',
      'Trailer',
      'Lo-Fi',
      'Tribal',
      'Acid Punk',
      'Acid Jazz',
      'Polka',
      'Retro',
      'Musical',
      'Rock & Roll',
      'Hard Rock',
      'Folk',
      'Folk-Rock',
      'National Folk',
      'Swing',
      'Fast Fusion',
      'Bebob',
      'Latin',
      'Revival',
      'Celtic',
      'Bluegrass',
      'Avantgarde',
      'Gothic Rock',
      'Progessive Rock',
      'Psychedelic Rock',
      'Symphonic Rock',
      'Slow Rock',
      'Big Band',
      'Chorus',
      'Easy Listening',
      'Acoustic',
      'Humour',
      'Speech',
      'Chanson',
      'Opera',
      'Chamber Music',
      'Sonata',
      'Symphony',
      'Booty Bass',
      'Primus',
      'Porn Groove',
      'Satire',
      'Slow Jam',
      'Club',
      'Tango',
      'Samba',
      'Folklore',
      'Ballad',
      'Power Ballad',
      'Rhythmic Soul',
      'Freestyle',
      'Duet',
      'Punk Rock',
      'Drum Solo',
      'A Capella',
      'Euro-House',
      'Dance Hall',
      'Goa',
      'Drum & Bass',
      'Club-House',
      'Hardcore',
      'Terror',
      'Indie',
      'BritPop',
      'Negerpunk',
      'Polsk Punk',
      'Beat',
      'Christian Gangsta Rap',
      'Heavy Metal',
      'Black Metal',
      'Crossover',
      'Contemporary Christian',
      'Christian Rock',
      'Merengue',
      'Salsa',
      'Trash Metal',
      'Anime',
      'JPop',
      'Synthpop');

type

  // Task Type
  TTaskType = (ttMP3, ttOgg, ttWMA, ttWave);

  // CDDB Connection Parameters
  TCDDBConnection = record
    Server: string;
    Script: string;
    Proxy: Boolean;
    Host: string;
    Port: Integer;
    Authorization: Boolean;
    Name: string;
    Password: string;
  end;

  // Track Information
  TTrackInfo = record
    Title: string;
    Album: string;
    Artist: string;
    Year: string;
    Genre: Byte;
    Comment: string;
    TimeF: Integer;
    TimeM: Integer;
    TimeS: Integer;
    Size: Integer;
  end;

////////////////////////////////////////////////////////////////////////////////
// Encode Parameters

  // MP3 Encoding Parameter
  TMP3CoderMode = (mpcmMono, mpcmStereo, mpcmJointStereo);
  TMP3EncodeParam = record
    EnableVBR: Boolean;
    WriteVBRHeader: Boolean;
    VBRQuality: DWORD;
    MinBitrate, MaxBitrate: DWORD;
    Quality: WORD;
    AudioMode: TMP3CoderMode;
  end;

  // Ogg Encoding Parameter
  TOggCoderMode = (ogcmMono, ogcmStereo);
  TOggEncodeParam = record
    Bitrate: DWORD;
    EnableBBR: Boolean;
    MaxBitrate, MinBitrate: DWORD;
    EnableVBR: Boolean;
    VBRQuality: DWORD;
    AudioMode: TOggCoderMode;
  end;

  // WMA Encoding Parameter
  TWMACoderMode = (wmamMono, wmamStereo);
  TWMAEncodeParam = record
    Bitrate: DWORD;
    AudioMode: TWMACoderMode;
  end;

////////////////////////////////////////////////////////////////////////////////
// Encoders

  // Root class for all encoders
  TEncoder = class(TObject)
  protected
    FileStream: TFileStream;
  public
    function Init(OutFile: TFileName; TrackNo, NumFrames: Integer): Boolean;
      virtual; abstract;
    function EncodeBuffer(Buffer: Pointer; Length: Integer;
      OggFinish: Boolean = False): Boolean; virtual; abstract;
    procedure Uninit; virtual; abstract;
  end;

  // Wave Encoder
  TWaveEncoder = class(TEncoder)
  public
    function Init(OutFile: TFileName; TrackNo, NumFrames: Integer): Boolean;
      override;
    function EncodeBuffer(Buffer: Pointer; Length: Integer;
      OggFinish: Boolean = False): Boolean; override;
    procedure Uninit; override;
  end;

  // MP3 Encoder
  TMP3Encoder = class(TEncoder)
  public
    function Init(OutFile: TFileName; TrackNo, NumFrames: Integer): Boolean;
      override;
    function EncodeBuffer(Buffer: Pointer; Length: Integer;
      OggFinish: Boolean = False): Boolean; override;
    function EncodeFrame: Boolean;
    procedure Uninit; override;
  end;

  // Ogg Encoder
  TOggEncoder = class(TEncoder)
  private
    vd: vorbis_dsp_state;
    vb: vorbis_block;
    os: ogg_stream_state;
    og: ogg_page;
    op: ogg_packet;
    vi: vorbis_info;
    vc: vorbis_comment;
    Channels: Integer;
  public
    function Init(OutFile: TFileName; TrackNo, NumFrames: Integer): Boolean;
      override;
    function EncodeBuffer(Buffer: Pointer; Length: Integer;
      OggFinish: Boolean = False): Boolean; override;
    procedure Uninit; override;
  end;

  // WMA Encoder
  TWMAEncoder = class(TEncoder)
  private
  public
    function Init(OutFile: TFileName; TrackNo, NumFrames: Integer): Boolean;
      override;
    function EncodeBuffer(Buffer: Pointer; Length: Integer;
      OggFinish: Boolean = False): Boolean; override;
    procedure Uninit; override;
  end;

////////////////////////////////////////////////////////////////////////////////
// Rip & Encode Thread

  TOnUpdateUI = procedure(Sender: TObject;
    Current, Total, CurrentProgress: Integer; Title: string) of object;
  
  TProcessThread = class(TThread)
  private
    FOnUpdateUI: TOnUpdateUI;
    TempTitle: string;
    TrackBuffer: PTrackBuf;

    function GetOutputFileName(Track: Integer): string;
  protected
    procedure Execute; override;
  public
    Current, Total: Integer;
    property OnUpdateUI: TOnUpdateUI read FOnUpdateUI write FOnUpdateUI;
  end;

////////////////////////////////////////////////////////////////////////////////
// Variables

var
  AkripInited: Boolean;
  WMAInstalled: Boolean;
  CDList: TCDLIST;
  CDListLetter: array[0..MAXCDLIST - 1] of Char;
  CDHandle: THCDROM;
  CDTOC: TTOC;
  CDInfo: TTrackInfo;
  TrackInfos: array[0..99] of TTrackInfo;

  MP3Buffer: array[0..FRAMESIZE * (FRAMECOUNT + GOGOREAD_MAX) - 1] of Byte;
  MP3BufferLength, MP3BufferPos: DWORD;

  ///////////////////////////////////
  // Program Configuration Parameters
  CDDBConnection: TCDDBConnection;

  OutputFolder: string;
  FileNameRule: string;
  ActionPriority: TThreadPriority;

  MP3EncodeParam: TMP3EncodeParam;
  OggEncodeParam: TOggEncodeParam;
  WMAEncodeParam: TWMAEncodeParam;
  // Program Configuration Parameters
  ///////////////////////////////////

  Playlist: TStringList;
  ProcessLog: TStringList;

  SomethingFailed: Boolean;

////////////////////////////////////////////////////////////////////////////////
// Functions

procedure GetDriveList(DriverList: TStringList);
function GetTrackInfo(CDIndex: Integer; RefreshInfo, ReadIni: Boolean): Boolean;
procedure ResetTrackInfo(var Info: TTrackInfo);
function GetGenreIndex(Value: string): Integer;
procedure CDPlayerIniRW(Write: Boolean);
function FixDiscTitle(Title: string): string;

implementation

uses
  Main, CFGParam, Languages, Routine;

//------------------------------------------------------------------------------
// Procedure: FixDiscTitle
// Arguments: Title: string
// Result:    string
// Comment:   Fix disc title from cddb server
//------------------------------------------------------------------------------

function FixDiscTitle(Title: string): string;
var
  Index: Integer;
begin
  Index := Pos(' / ', Title);
  if Index <> 0 then
    Result := Copy(Title, Index + 3, Length(Title) - Index - 2)
  else
    Result := Title;
end;

//------------------------------------------------------------------------------
// Procedure: GetDriveList
// Arguments: DriverList: TStringList
// Result:    None
// Comment:   Get cdrom list
//------------------------------------------------------------------------------

procedure GetDriveList(DriverList: TStringList);
var
  I: Integer;
  NTLetter: BYTE;
begin
  DriverList.Clear;
  if AkripInited then
    GetCDList(CDList)
  else
    CDList.num := 0;

  // Get drive letter
  if Win32Platform = VER_PLATFORM_WIN32_NT then
    for I := 0 to CDList.num - 1 do
    begin
      NTLetter := NTGetDriveLetter(CDList.cd[I].ha, CDList.cd[I].tgt,
        CDList.cd[I].lun);
      if NTLetter <> 0 then
        CDListLetter[I] := Chr(Ord('A') + NTLetter)
      else
        CDListLetter[I] := #0;
    end
  else
    GetDriveLetter(CDListLetter, MAXCDLIST);

  // create drive list
  if CDList.num <= 0 then
    DriverList.Add(NoDriver)
  else
    for I := 0 to CDList.num - 1 do
      if CDListLetter[I] <> #0 then
        DriverList.Add(Trim(StrPas(CDList.cd[I].info.vendor)) + ' ' +
          Trim(StrPas(CDList.cd[I].info.prodId)) +
          '  (' + CDListLetter[I] + ':)')
      else
        DriverList.Add(Trim(StrPas(CDList.cd[I].info.vendor)) + ' ' +
          Trim(StrPas(CDList.cd[I].info.prodId)));
end;

//------------------------------------------------------------------------------
// Procedure: WinCDPlayerID
// Arguments: TableOC: TTOC
// Result:    string
// Comment:   Get cd serial number
//------------------------------------------------------------------------------

function WinCDPlayerID(TableOC: TTOC): string;
  function MSF2DWORD(Unused, Minutes, Seconds, Frames: byte): DWORD;
  begin
    Result := DWord(Unused);
    Result := (Result shl 8) + DWord(Minutes);
    Result := (Result shl 8) + DWord(Seconds);
    Result := (Result shl 8) + DWord(Frames);
  end;
var
  I: integer;
  id: DWORD;
begin
  id := 0;
  for I := TableOC.firstTrack - 1 to TableOC.lastTrack - 1 do begin
    with TableOC do
      ID := ID + MSF2DWORD(Tracks[I].Addr[0], Tracks[I].Addr[1],
        Tracks[I].Addr[2], Tracks[I].Addr[3]);
  end;
  Result := IntToHex(id, 1);
end;

//------------------------------------------------------------------------------
// Procedure: GetTrackInfo
// Arguments: CDIndex: Integer; RefreshInfo, ReadIni: Boolean
// Result:    Boolean
// Comment:   Get track information
//------------------------------------------------------------------------------

function GetTrackInfo(CDIndex: Integer; RefreshInfo, ReadIni: Boolean): Boolean;
var
  I: Integer;
  GetCDHand: TGetCDHand;
begin
  Result := False;

  FillChar(CDTOC, SizeOf(TTOC), #0);

  if CDHandle > 0 then CloseCDHandle(CDHandle);

  // Get cd handle
  FillChar(GetCDHand, SizeOf(TGetCDHand), #0);
  with GetCDHand do
  begin
    size := SizeOf(TGetCDHand);
    ver := 1;
    ha := CDList.cd[CDIndex].ha;
    tgt := CDList.cd[CDIndex].tgt;
    lun := CDList.cd[CDIndex].lun;
    readType := CDR_ANY;
    numJitter := 1;
    numOverlap := 3;
  end;
  CDHandle := GetCDHandle(GetCDHand);

  if CDHandle = 0 then Exit;

  // Get track information
  if ReadTOC(CDHandle, CDTOC, False) <> SS_COMP then Exit;

  if RefreshInfo then
    ResetTrackInfo(CDInfo);

  // Calculate track length/size
  for I := CDTOC.firstTrack to CDTOC.lastTrack do
  begin
    with TrackInfos[I] do
    begin
      if RefreshInfo then
        ResetTrackInfo(TrackInfos[I]);
      Size := CDTOC.Tracks[I].addr[0] shl 24 +
        CDTOC.Tracks[I].addr[1] shl 16 +
        CDTOC.Tracks[I].addr[2] shl 8 +
        CDTOC.Tracks[I].addr[3] -
        CDTOC.Tracks[I - 1].addr[0] shl 24 -
        CDTOC.Tracks[I - 1].addr[1] shl 16 -
        CDTOC.Tracks[I - 1].addr[2] shl 8 -
        CDTOC.Tracks[I - 1].addr[3];
      TimeF := Size div 75;
      TimeM := TimeF div 60;
      TimeS := TimeF mod 60;
    end;
  end;

  // Read information from cdplayer.ini
  if ReadIni then
    CDPlayerIniRW(False);

  if CDTOC.lastTrack - CDTOC.firstTrack >= 0 then
    Result := True;
end;

//------------------------------------------------------------------------------
// Procedure: ResetTrackInfo
// Arguments: var Info: TTrackInfo
// Result:    None
// Comment:   Reset track information
//------------------------------------------------------------------------------

procedure ResetTrackInfo(var Info: TTrackInfo);
begin
  with Info do
  begin
    Title := '';
    Album := '';
    Artist := '';
    Year := '';
    Genre := 255;
    Comment := '';
  end;
end;

//------------------------------------------------------------------------------
// Procedure: GetGenreIndex
// Arguments: Value: string
// Result:    Integer
// Comment:   Get index from genre list with the name
//------------------------------------------------------------------------------

function GetGenreIndex(Value: string): Integer;
var
  I: Integer;
begin
  Result := 255;
  for I := Low(ID3GenreList) to High(ID3GenreList) do
    if UpperCase(Trim(Value)) = UpperCase(Trim(ID3GenreList[I])) then
    begin
      Result := I;
      Break;
    end;
end;

//------------------------------------------------------------------------------
// Procedure: TrackLBA2DWORD
// Arguments: TrackNo: Integer; TOC: TTOC
// Result:    DWORD
// Comment:   Get track length
//------------------------------------------------------------------------------

function TrackLBA2DWORD(TrackNo: Integer; TOC: TTOC): DWORD;
begin
  Result := (DWORD(TOC.tracks[TrackNo].addr[0]) shl 24) +
    (DWORD(TOC.tracks[TrackNo].addr[1]) shl 16) +
    (DWORD(TOC.tracks[TrackNo].addr[2]) shl 8) +
    (DWORD(TOC.tracks[TrackNo].addr[3]));
end;

//------------------------------------------------------------------------------
// Procedure: CDPlayerIniRW
// Arguments: Write: Boolean
// Result:    None
// Comment:   Read/Write CDPLAYER.INI
//------------------------------------------------------------------------------

procedure CDPlayerIniRW(Write: Boolean);
var
  I: Integer;
  TIDTOC: TTOC;
  CDID: string;
  Buffer: array[0..MAX_PATH - 1] of Char;
  WinDir: string;
begin
  if CDHandle = 0 then Exit;
  FillChar(TIDTOC, SizeOf(TTOC), #0);
  ReadToc(CDHandle, TIDTOC, True);
  CDID := WinCDPlayerID(TIDTOC);
  GetWindowsDirectory(Buffer, MAX_PATH);
  WinDir := StrPas(Buffer);
  if WinDir[Length(WinDir)] <> '\' then
    WinDir := WinDir + '\';
  with TIniFile.Create(WinDir + 'CDPLAYER.INI') do
  try
    if Write then
    begin
      if Trim(CDInfo.Album) <> '' then
        WriteString(CDID, 'TITLE', CDInfo.Artist + ' / ' + CDInfo.Album);
      if Trim(CDInfo.Artist) <> '' then
        WriteString(CDID, 'ARTIST', CDInfo.Artist);
      if Trim(CDInfo.Year) <> '' then
        WriteString(CDID, 'YEAR', CDInfo.Year);
      if CDInfo.Genre <= High(ID3GenreList) then
        WriteString(CDID, 'GENRE', ID3GenreList[CDInfo.Genre]);
      if Trim(CDInfo.Comment) <> '' then
        WriteString(CDID, 'COMMENT', CDInfo.Comment);
      for I := TIDTOC.firstTrack to TIDTOC.lastTrack do
      begin
        if Trim(TrackInfos[I].Title) <> '' then
          WriteString(CDID, IntToStr(I - TIDTOC.firstTrack),
            TrackInfos[I].Title);
        if Trim(TrackInfos[I].Comment) <> '' then
          WriteString(CDID, 'comment' + IntToStr(I - TIDTOC.firstTrack),
            TrackInfos[I].Comment);
      end;
    end
    else
      if SectionExists(CDID) then
      begin
        CDInfo.Album := FixDiscTitle(ReadString(CDID, 'TITLE', CDInfo.Album));
        CDInfo.Artist := ReadString(CDID, 'ARTIST', CDInfo.Artist);
        CDInfo.Year := ReadString(CDID, 'YEAR', CDInfo.Year);
        CDInfo.Genre := GetGenreIndex(ReadString(CDID, 'GENRE', ''));
        CDInfo.Comment := ReadString(CDID, 'COMMENT', CDInfo.Comment);
        for I := TIDTOC.firstTrack to TIDTOC.lastTrack do
        begin
          TrackInfos[I].Album := CDInfo.Album;
          TrackInfos[I].Artist := CDInfo.Artist;
          TrackInfos[I].Year := CDInfo.Year;
          TrackInfos[I].Genre := CDInfo.Genre;
          TrackInfos[I].Title := ReadString(CDID,
            IntToStr(I - TIDTOC.firstTrack), TrackInfos[I].Title);
          TrackInfos[I].Comment := ReadString(CDID,
            'comment' + IntToStr(I - TIDTOC.firstTrack), CDInfo.Comment);
        end;
      end;
  finally
    Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TProcessThread

//------------------------------------------------------------------------------
// Procedure: NewTrackBuf
// Arguments: numFrames: DWORD
// Result:    Pointer
// Comment:   Allocate memory
//------------------------------------------------------------------------------

function NewTrackBuf(numFrames: DWORD): Pointer;
var
  T: PTrackBuf;
  numAlloc: integer;
begin
  numAlloc := integer((NumFrames * FRAMESIZE) + TRACKBUFEXTRA);

  // GetMem(T, NumAlloc); // Crash on one user's system
  T := PTrackBuf(GlobalAlloc(GMEM_FIXED, NumAlloc));
  T^.startFrame := 0;
  T^.numFrames := 0;
  T^.maxLen := numFrames * FRAMESIZE;
  T^.len := 0;
  T^.status := 0;
  T^.startOffset := 0;

  Result := T;
end;

//------------------------------------------------------------------------------
// Procedure: GetPlaylistString
// Arguments: Track: Integer
// Result:    string
// Comment:   Get string to write in playlist
//------------------------------------------------------------------------------

function GetPlaylistString(Track: Integer): string;
var
  Artist, Title: string;
begin
  Result := '';
  if (Track < CDTOC.firstTrack) or (Track > CDTOC.lastTrack) then Exit;
  Artist := TrackInfos[Track].Artist;
  Title := TrackInfos[Track].Title;
  Result := '#EXTINF:';
  Result := Result +
    IntToStr(TrackInfos[Track].TimeM * 60 + TrackInfos[Track].TimeS);
  Result := Result + ',';
  if Artist <> '' then
    Result := Result + Artist + ' - ';
  if Title = '' then
    Title := Format('Track-%.2d', [Track]);
  Result := Result + Title;
end;

//------------------------------------------------------------------------------
// Procedure: GetOutputFileNameWithExt
// Arguments: MainName, Ext: string
// Result:    string
// Comment:   Get new file name
//------------------------------------------------------------------------------

function GetOutputFileNameWithExt(MainName, Ext: string): string;
var
  I: Integer;
begin
  Result := MainName + Ext;
  I := 0;
  while FileExists(Result) do
  begin
    Inc(I);
    Result := MainName + ' - ' + IntToStr(I) + Ext;
  end;
end;

//------------------------------------------------------------------------------
// Procedure: TProcessThread.GetOutputFileName
// Arguments: Track: Integer
// Result:    string
// Comment:   Get file name with specified rule
//------------------------------------------------------------------------------

function TProcessThread.GetOutputFileName(Track: Integer): string;
const
  InvalidChar = '*:?"|/<>';
  ValidChar = '###''##()';
  var
  I: Integer;
  FDir: string;
  FName: string;
  TempStr: array[0..MAX_PATH] of Char;
begin
  FDir := OutputFolder;
  if FDir[Length(FDir)] <> '\' then
    FDir := FDir + '\';
  FName := FileNameRule;

  // Replace macro
  FName := StringReplace(FName, '<number>', Format('%.2d', [Track]),
    [rfReplaceAll, rfIgnoreCase]);
  FName := StringReplace(FName, '<track>', Format('%.2d', [Track]),
    [rfReplaceAll, rfIgnoreCase]);
  if Trim(TrackInfos[Track].Title) <> '' then
    FName := StringReplace(FName, '<title>', TrackInfos[Track].Title,
      [rfReplaceAll, rfIgnoreCase])
  else
    FName := StringReplace(FName, '<title>', Format('Track-%.2d', [Track]),
      [rfReplaceAll, rfIgnoreCase]);
  if Trim(TrackInfos[Track].Artist) <> '' then
    FName := StringReplace(FName, '<artist>', TrackInfos[Track].Artist,
      [rfReplaceAll, rfIgnoreCase])
  else
    FName := StringReplace(FName, '<artist>', UnknownArtist,
      [rfReplaceAll, rfIgnoreCase]);
  if Trim(TrackInfos[Track].Album) <> '' then
    FName := StringReplace(FName, '<album>', TrackInfos[Track].Album,
      [rfReplaceAll, rfIgnoreCase])
  else
    FName := StringReplace(FName, '<album>', UnkonwnAlbum,
      [rfReplaceAll, rfIgnoreCase]);

  // Replace invalid characters
  for I := 1 to Length(InvalidChar) do
    FName := StringReplace(FName, InvalidChar[I], ValidChar[I], [rfReplaceAll]);

  // Create random file name if invalid
  while not ValidFileName(FName) do
  begin
    GetTempFileName(PChar(FDir), 'Music', 0, TempStr);
    FName := ChangeFileExt(ExtractFileName(StrPas(TempStr)), '');
  end;

  Result := FDir + FName;
end;

//------------------------------------------------------------------------------
// Procedure: TProcessThread.Execute
// Arguments: None
// Result:    None
// Comment:   Execute process thread
//------------------------------------------------------------------------------

procedure TProcessThread.Execute;
const
  EXTS: array[TTaskType] of string =
    ('.mp3', '.ogg', '.wma', '.wav');
var
  TotalFrames, NumFrames: DWORD;
  StartLBA: DWORD;
  Buffer: array[0..MAX_PATH] of Char;
  Progress: DWORD;

  I, Track: Integer;
  OutFile: string;
  Encoder: TEncoder;
  BreakAll: Boolean;

  IsMP3: Boolean;

  ReRead: Integer;
  ReadSuccess: Boolean;
begin
  // Initialize
  SomethingFailed := False;
  ProcessLog.Clear;
  ProcessLog.Add(LogStart + '  (' + FormatDateTime('hh:nn:ss', Now) + ')');
  Playlist.Clear;
  Playlist.Add('#EXTM3U');
  Current := 0;

  if Assigned(FOnUpdateUI) then
    FOnUpdateUI(Self, Current, Total, 0, '');

  // Allocate memory
  TrackBuffer := NewTrackBuf(FRAMECOUNT);

  // Create encoder
  case frmMain.TaskType of
    ttMP3: Encoder := TMP3Encoder.Create;
    ttOgg: Encoder := TOggEncoder.Create;
    ttWMA: Encoder := TWMAEncoder.Create;
    else Encoder := TWaveEncoder.Create;
  end;
  IsMP3 := frmMain.TaskType = ttMP3;

  try
    // Process in loop
    for I := 0 to frmMain.lvTracks.Items.Count - 1 do
      if frmMain.lvTracks.Items[I].Checked and not Terminated then
      begin
        Inc(Current);
        Track := CDTOC.firstTrack + I;

        ProcessLog.Add('');

        // Get title for writing to log
        TempTitle := TrackInfos[Track].Title;
        if Trim(TempTitle) = '' then
          TempTitle := Format('Track-%.2d', [Track]);

        // Get cd id
        if GetCDId(CDHandle, Buffer, SizeOf(Buffer)) <> SS_COMP then
        begin
          SomethingFailed := True;
          ProcessLog.Add(Format(LogRip + '  ' + LogFailed, [TempTitle]));
          Break;
        end;

        // Get track length
        TotalFrames := TrackLBA2DWORD(Track, CDTOC) -
          TrackLBA2DWORD(Track - 1, CDTOC);
        NumFrames := TotalFrames;
        StartLBA := TrackLBA2DWORD(Track - 1, CDTOC);
        Progress := 0;
        if Assigned(FOnUpdateUI) then
          FOnUpdateUI(Self, Current, Total, 0, {0, }TempTitle);

        // Get file name
        OutFile := GetOutputFileName(Track);
        OutFile := GetOutputFileNameWithExt(OutFile, EXTS[frmMain.TaskType]);

        // Create directory
        try
          ForceDirectories(ExtractFileDir(OutFile));
        except
          SomethingFailed := True;
          ProcessLog.Add(Format(LogRip + '  ' + LogFailed, [TempTitle]));
          ProcessLog.Add(Format(LogEncode + '  ' + LogFailed, [TempTitle]));
          Break;
        end;

        // Initialize encoder
        if not Encoder.Init(OutFile, Track, NumFrames) then
        begin
          SomethingFailed := True;
          ProcessLog.Add(Format(LogRip + '  ' + LogFailed, [TempTitle]));
          ProcessLog.Add(Format(LogEncode + '  ' + LogFailed, [TempTitle]));
          Encoder.Uninit;
          DeleteFile(PChar(OutFile));
          Break;
        end;

        if Terminated then Break;

        // Rip in loop
        BreakAll := False;
        MP3BufferLength := 0;
        MP3BufferPos := 0;
        while (NumFrames > 0) and not Terminated do
        begin
          // Read to buffer
          ReadSuccess := False;
          for ReRead := 0 to 4 do
          begin
            TrackBuffer^.startFrame := StartLBA;
            TrackBuffer^.numFrames := FRAMECOUNT;
            if TrackLBA2DWORD(Track, CDTOC) - StartLBA < FRAMECOUNT then
              TrackBuffer^.numFrames := TrackLBA2DWORD(Track, CDTOC) - StartLBA;
            if ReadCDAudioLBA(CDHandle, TrackBuffer) = SS_COMP then
            begin
              ReadSuccess := True;
              Break;
            end;
          end;
          if not ReadSuccess then
          begin
            SomethingFailed := True;
            ProcessLog.Add(Format(LogRip + '  ' + LogFailed, [TempTitle]));
            BreakAll := True;
            Encoder.Uninit;
            DeleteFile(PChar(OutFile));
            Break;
          end;

          // Encode
          if IsMP3 then
          begin
            Move(TrackBuffer.buf[0], MP3Buffer[MP3BufferLength], TrackBuffer.len);
            MP3BufferLength := MP3BufferLength + TrackBuffer.len;
            while MP3BufferLength - MP3BufferPos >= FRAMESIZE * GOGOREAD_MAX do
              if not TMP3Encoder(Encoder).EncodeFrame then
              begin
                SomethingFailed := True;
                ProcessLog.Add(Format(LogRip + '  ' + LogSuccess, [TempTitle]));
                ProcessLog.Add(Format(LogEncode + '  ' + LogFailed, [TempTitle]));
                BreakAll := True;
                Encoder.Uninit;
                DeleteFile(PChar(OutFile));
                Break;
              end;
            if BreakAll then Break;
            Move(MP3Buffer[MP3BufferPos], MP3Buffer[0],
              MP3BufferLength - MP3BufferPos);
            MP3BufferLength := MP3BufferLength - MP3BufferPos;
            MP3BufferPos := 0;
          end
          else
          if not Encoder.EncodeBuffer(@TrackBuffer.buf[0], TrackBuffer.len) then
          begin
            SomethingFailed := True;
            ProcessLog.Add(Format(LogRip + '  ' + LogSuccess, [TempTitle]));
            ProcessLog.Add(Format(LogEncode + '  ' + LogFailed, [TempTitle]));
            BreakAll := True;
            Encoder.Uninit;
            DeleteFile(PChar(OutFile));
            Break;
          end;

          // Update progress
          StartLBA := StartLBA + TrackBuffer^.numFrames;
          NumFrames := NumFrames - TrackBuffer^.numFrames;
          Progress := Progress + TrackBuffer^.numFrames;
          if Assigned(FOnUpdateUI) then
            FOnUpdateUI(Self, Current, Total,
              Trunc(Progress / TotalFrames * 100), TempTitle);
        end;

        // MP3 finalization
        if IsMP3 and not BreakAll then
          while TMP3Encoder(Encoder).EncodeFrame do ;

        // Encoder finalization
        Encoder.Uninit;

        if BreakAll then Break;

        // User cancelled
        if Terminated then
        begin
          DeleteFile(PChar(OutFile));
          SomethingFailed := True;
          ProcessLog.Add(Format(LogRip + '  ' + LogFailed, [TempTitle]));
          ProcessLog.Add(Format(LogEncode + '  ' + LogFailed, [TempTitle]));
          Break;
        end;

        // Update log and playlist
        ProcessLog.Add(Format(LogRip + '  ' + LogSuccess, [TempTitle]));
        ProcessLog.Add(Format(LogEncode + '  ' + LogSuccess, [TempTitle]));
        Playlist.Add(GetPlaylistString(CDTOC.firstTrack + I));
        Playlist.Add(OutFile);             
      end;
  finally
    Encoder.Free;
    // FreeMem(TrackBuffer, (FRAMEBUFFERSIZE * FRAMESIZE) + TRACKBUFEXTRA);
    // GetMem() crash on one user's system
    GlobalFree(HGLOBAL(TrackBuffer));
  end;

  // Finished
  if not SomethingFailed then
    if Assigned(FOnUpdateUI) then
      FOnUpdateUI(Self, Current, Total, 100, {100, }TempTitle);

  // Write log
  ProcessLog.Add('');
  if not Terminated then
    ProcessLog.Add(LogFinish + '  (' + FormatDateTime('hh:nn:ss', Now) + ')')
  else
  begin
    ProcessLog.Add(LogCanceled + '  (' + FormatDateTime('hh:nn:ss', Now) + ')');
    SomethingFailed := True;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TMP3Encoder

function GogoInputCallback(pBuffer: Pointer; nLength: DWORD): MERET; cdecl;
begin
  if MP3BufferLength - MP3BufferPos >= nLength then
  begin
    Move(MP3Buffer[MP3BufferPos], pBuffer^, nLength);
    MP3BufferPos := MP3BufferPos + nLength;
    Result := ME_NOERR;
  end
  else
    Result := ME_EMPTYSTREAM;
end;

function TMP3Encoder.Init(OutFile: TFileName; TrackNo,
  NumFrames: Integer): Boolean;
var
  ID3v1Buf: array[0..127] of Byte;
  InpDevUserFunc: MCP_INPDEV_USERFUNC;

  function IsID3v1Empty(TrackInfo: TTrackInfo): Boolean;
  begin
    with TrackInfo do
      Result := (Trim(Title) = '') and (Trim(Artist) = '')
        and (Trim(Album) = '') and (Trim(Year) = '')
        and (Genre > High(ID3GenreList)) and (Trim(Comment) = '');
  end;

  // Write ID3
  procedure BuildID3v1;
    procedure StrBuf(APos, ALen: Integer; const AStr: string);
    var
      Len: Integer;
    begin
      Len := Length(AStr);
      if Len > ALen then Len := ALen;
      Move(AStr[1], ID3v1Buf[APos], Len);
    end;
  begin
    FillChar(ID3v1Buf, SizeOf(ID3v1Buf), #0);
    with TrackInfos[TrackNo] do
    begin
      StrBuf(0, 3, 'TAG');
      StrBuf(3, 30, Title);
      StrBuf(33, 30, Artist);
      StrBuf(63, 30, Album);
      StrBuf(93, 4, Year);
      StrBuf(97, 28, Comment);
      ID3v1Buf[125] := 0;
      ID3v1Buf[126] := TrackNo;
      ID3v1Buf[127] := Genre;
    end;
  end;

begin
  Result := False;

  if MPGE_initializeWork = ME_NOFPU then
    Exit;

  if MP3EncodeParam.EnableVBR then
  begin
    if MPGE_setConfigure(MC_VBR, MP3EncodeParam.VBRQuality, 0) <> ME_NOERR then
      Exit;
    if MPGE_setConfigure(MC_VBRBITRATE, MP3EncodeParam.MinBitrate,
      MP3EncodeParam.MaxBitrate) <> ME_NOERR then
      Exit;
    if not MP3EncodeParam.WriteVBRHeader then
      if MPGE_setConfigure(MC_WRITEVBRTAG, 0, 0) <> ME_NOERR then
        Exit;
  end
  else if MPGE_setConfigure(MC_BITRATE, MP3EncodeParam.MinBitrate, 0)
    <> ME_NOERR then
    Exit;

  if MPGE_setConfigure(MC_ENCODE_QUALITY, MP3EncodeParam.Quality, 0)
    <> ME_NOERR then
    Exit;
    
  if MPGE_setConfigure(MC_ENCODEMODE, Ord(MP3EncodeParam.AudioMode), 0)
    <> ME_NOERR then
    Exit;

  with InpDevUserFunc do
  begin
    @pUserFunc := @GogoInputCallback;
    nSize := MC_INPDEV_MEMORY_NOSIZE;
    nBit := 16;
    nFreq := 44100;
    nChn := 2;
  end;
  if MPGE_setConfigure(MC_INPUTFILE, MC_INPDEV_USERFUNC,
    UPARAM(@InpDevUserFunc)) <> ME_NOERR then
    Exit;

  if MPGE_setConfigure(MC_OUTPUTFILE, MC_OUTDEV_FILE, UPARAM(OutFile))
    <> ME_NOERR then
    Exit;

  if not IsID3v1Empty(TrackInfos[TrackNo]) then
  begin
    BuildID3v1;
    if MPGE_setConfigure(MC_ADDTAG, SizeOf(ID3v1Buf), UPARAM(@ID3v1Buf))
      <> ME_NOERR then
      Exit;
  end;

  if MPGE_detectConfigure <> ME_NOERR then
    Exit;

  Result := True;
end;

function TMP3Encoder.EncodeBuffer(Buffer: Pointer;
  Length: Integer; OggFinish: Boolean = False): Boolean;
begin
  Result := False;
end;

function TMP3Encoder.EncodeFrame: Boolean;
begin
  Result := MPGE_processFrame = ME_NOERR;
end;

procedure TMP3Encoder.Uninit;
begin
  try
    MPGE_closeCoder;
    MPGE_endCoder;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TOggEncoder

type
  PSHORT = ^SHORT;
  SHORTARRAY = array of SHORT;
  BYTEARRAY = array of Byte;

procedure DownMixToMono(psData: PSHORT; dwNumSamples: DWORD);
var
  dwSample: DWORD;
begin
  for dwSample := 0 to dwNumSamples div 2 do
    SHORTARRAY(psData)[dwSample] := SHORTARRAY(psData)[2 * dwSample] div 2
      + SHORTARRAY(psData)[2 * dwSample + 1] div 2;
end;

function TOggEncoder.Init(OutFile: TFileName;
  TrackNo, NumFrames: Integer): Boolean;

  procedure AddComment(const Comment: string);
  begin
    vorbis_comment_add(vc, PChar(WideStringToUTF8(Latin1ToWideString(Comment))));
  end;

var
  header: ogg_packet;
  header_comm: ogg_packet;
  header_code: ogg_packet;

begin
  Result := False;

  // Create file
  try
    FileStream := TFileStream.Create(OutFile, fmCreate or fmShareExclusive);
  except
    Exit;
  end;

  Channels := Ord(OggEncodeParam.AudioMode) + 1;

  try
    // Initialize encode engine
    vorbis_info_init(vi);
    with OggEncodeParam do
      if EnableVBR then
        vorbis_encode_init_vbr(vi, Channels, 44100, GetOggBitrateIndex(VBRQuality, 128) / 10)
      else if EnableBBR then
        vorbis_encode_init(vi, Channels, 44100, MaxBitrate * 1000, Bitrate * 1000, MinBitrate * 1000)
      else
        vorbis_encode_init(vi, Channels, 44100, Bitrate * 1000, Bitrate * 1000, Bitrate * 1000);

    // Write comments
    vorbis_comment_init(vc);
    with TrackInfos[TrackNo] do
      begin
        AddComment('ENCODER=' + UpperCase(AppTitle));
        AddComment('TRACKNUMBER=' + IntToStr(TrackNo));
        if Trim(Title) <> '' then
          AddComment('TITLE=' + Title);
        if Trim(Artist) <> '' then
          AddComment('ARTIST=' + Artist);
        if Trim(Album) <> '' then
          AddComment('ALBUM=' + Album);
        if Trim(Year) <> '' then
          AddComment('DATE=' + Year);
        if Genre <= High(ID3GenreList) then
          AddComment('GENRE=' + ID3GenreList[Genre]);
        if Trim(Comment) <> '' then
          AddComment('COMMENT=' + Comment);
      end;

    // Write file header
    
    vorbis_analysis_init(vd, vi);
    vorbis_block_init(vd, vb);

    Randomize;
    ogg_stream_init(os, Random(MaxInt));
    vorbis_analysis_headerout(vd, vc, header, header_comm, header_code);
    ogg_stream_packetin(os, header);
    ogg_stream_packetin(os, header_comm);
    ogg_stream_packetin(os, header_code);

    repeat
      if ogg_stream_flush(os, og) = 0 then Break;
      FileStream.Write(og.header^, og.header_len);
      FileStream.Write(og.body^, og.body_len);
    until False;
  except
    Exit;
  end;

  Result := True;
end;

function TOggEncoder.EncodeBuffer(Buffer: Pointer; Length: Integer;
  OggFinish: Boolean = False): Boolean;
var
  BufferPos: Integer;
  Buf: ppfloat;
  Bytes: Integer;
  RealSamples: Integer;
begin
  Result := False;

  BufferPos := 0;

  try
    // encode in loop
    while (BufferPos < Length) or OggFinish do
    begin
      Buf := vorbis_analysis_buffer(vd, FRAMESIZE);

      if OggFinish then
        Bytes := 0
      else if Length - BufferPos >= FRAMESIZE * 4 then
        Bytes := FRAMESIZE * 4
      else
        Bytes := Length - BufferPos;

      if Bytes = 0 then
        vorbis_analysis_wrote(vd, 0)
      else
      begin
        RealSamples := Bytes div (Channels * 2);
        
        // Convert to mono
        if Channels = 1 then
        begin
          DownMixToMono(@BYTEARRAY(Buffer)[BufferPos], RealSamples);
          RealSamples := RealSamples div 2;
        end;

        // Encode
        OggEncodeChunk(@BYTEARRAY(Buffer)[BufferPos], Buf, Channels, RealSamples);

        BufferPos := BufferPos + Bytes;

        vorbis_analysis_wrote(vd, RealSamples);
      end;


      while vorbis_analysis_blockout(vd, vb) = 1 do
      begin
        try // avoid zero-devided exception
          vorbis_analysis(vb, ogg_packet(nil^));
        except
        end;
        vorbis_bitrate_addblock(vb);

        while vorbis_bitrate_flushpacket(vd, op) <> 0 do
        begin
          ogg_stream_packetin(os, op);

          // Write to file
          while True do
          begin
            if ogg_stream_pageout(os, og) = 0 then break;
            FileStream.Write(og.header^, og.header_len);
            FileStream.Write(og.body^, og.body_len);
            if OggFinish then
            begin
              OggFinish := False;
              Break;
            end;
          end;
        end;
      end;
    end;
  except
    Exit;
  end;

  Result := True;
end;

procedure TOggEncoder.Uninit;
begin
  EncodeBuffer(nil, 0, True);
  try
    ogg_stream_clear(os);
    vorbis_block_clear(vb);
    vorbis_dsp_clear(vd);
    vorbis_info_clear(vi);
    vorbis_comment_clear(vc);
  except
  end;
  try
    if Assigned(FileStream) then
      FileStream.Free;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TWMAEncoder

function TWMAEncoder.Init(OutFile: TFileName;
  TrackNo, NumFrames: Integer): Boolean;
var
  WavFormat: TWaveFormatEx;
begin
  Result := False;

  with WavFormat do
  begin
    wFormatTag := WAVE_FORMAT_PCM;
    nChannels := 2;
    nSamplesPersec := 44100;
    wBitsPerSample := 16;
    nBlockAlign := nChannels * wBitsPerSample div 8;
    nAvgBytesPerSec := nSamplesPerSec * nBlockAlign;
    cbSize := 0;
  end;

  if WMA_InitEncoder(WavFormat, PChar(OutFile), WMAEncodeParam.Bitrate * 1000,
    0, Ord(WMAEncodeParam.AudioMode) + 1) <> S_OK then
    Exit;

  // Write comments
  with TrackInfos[TrackNo] do
    begin
      if WMA_SetAttribute('Encoder', PChar(UpperCase(AppTitle))) <> S_OK then
        Exit;
      if WMA_SetAttribute('WM/TrackNumber', PChar(IntToStr(TrackNo)))
        <> S_OK then
        Exit;
      if Trim(Title) <> '' then
        if WMA_SetAttribute('Title', PChar(Title)) <> S_OK then
          Exit;
      if Trim(Artist) <> '' then
        if WMA_SetAttribute('Author', PChar(Artist)) <> S_OK then
          Exit;
      if Trim(Album) <> '' then
        if WMA_SetAttribute('WM/AlbumTitle', PChar(Album)) <> S_OK then
          Exit;
      if Trim(Year) <> '' then
        if WMA_SetAttribute('WM/Year', PChar(Year)) <> S_OK then
          Exit;
      if Genre <= High(ID3GenreList) then
        if WMA_SetAttribute('WM/Genre', PChar(ID3GenreList[Genre])) <> S_OK then
          Exit;
      if Trim(Comment) <> '' then
        if WMA_SetAttribute('Description', PChar(Comment)) <> S_OK then
          Exit;
    end;

  Result := True;
end;

function TWMAEncoder.EncodeBuffer(Buffer: Pointer; Length: Integer;
  OggFinish: Boolean = False): Boolean;
begin
  Result := WMA_EncodeSample(Buffer, Length) = S_OK;
end;

procedure TWMAEncoder.Uninit;
begin
  try
    WMA_Cleanup;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// TWaveEncoder 

type
  // Wave File Header
  TWaveHeader = record
    Marker1: array[0..3] of Char; // Normalement 'WAV '
    BytesFollowing: LongInt;
    Marker2: array[0..3] of Char;
    Marker3: array[0..3] of Char;
    Fixed1: LongInt;
    FormatTag: Word;
    Channels: Word;
    SampleRate: LongInt;
    BytesPerSecond: LongInt;
    BytesPerSample: Word;
    BitsPerSample: Word;
    Marker4: array[0..3] of Char;
    DataBytes: LongInt;
  end;

procedure WriteWavHeader(AFileStream: TFileStream; len: Integer);
var
  wav: TWaveHeader;
begin
  wav.Marker1 := 'RIFF';
  wav.BytesFollowing := len + 44 - 8;
  wav.Marker2 := 'WAVE';
  wav.Marker3 := 'fmt ';
  wav.Fixed1 := 16;
  wav.FormatTag := WAVE_FORMAT_PCM;
  wav.Channels := 2;
  wav.SampleRate := 44100;
  wav.BytesPerSecond := 44100 * 2 * 2;
  wav.BytesPerSample := 4;
  wav.BitsPerSample := 16;
  wav.Marker4 := 'data';
  wav.DataBytes := len;
  AFileStream.Write(wav, SizeOf(TWaveHeader));
end;

function TWaveEncoder.Init(OutFile: TFileName; TrackNo, NumFrames: Integer):
  Boolean;
begin
  Result := False;

  // Create file
  try
    FileStream := TFileStream.Create(OutFile, fmCreate or fmShareExclusive);
    WriteWavHeader(FileStream, NumFrames * FRAMESIZE); //Ð´ÎÄ¼þÍ·
  except
    Exit;
  end;

  Result := True;
end;

function TWaveEncoder.EncodeBuffer(Buffer: Pointer; Length: Integer;
  OggFinish: Boolean = False): Boolean;
begin
  Result := False;

  // Write buffer to file
  try
    if FileStream.Write(Buffer^, Length) <> Length then
      Exit;
  except
    Exit;
  end;

  Result := True;
end;

procedure TWaveEncoder.Uninit;
begin
  // Free file stream
  try
    if Assigned(FileStream) then
      FileStream.Free;
  except
  end;
end;

initialization
  Randomize;
  ProcessLog := TStringList.Create;
  Playlist := TStringList.Create;

finalization
  if CDHandle > 0 then
    CloseCDHandle(CDHandle);
  ProcessLog.Free;
  Playlist.Free;

end.

