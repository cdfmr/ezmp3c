unit Main;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Menus,
  StdCtrls, ExtCtrls, ComCtrls, TFlatCheckBoxUnit, TFlatComboBoxUnit, MCDPlayer,
  TFlatEditUnit, TFlatButtonUnit, EZImageButton, TFlatGaugeUnit, RipUnit,
  CommCtrl, ShellApi, IniFiles, Registry, EZShapeForm, Routine;

type
  TfrmMain = class(TForm)
    sfMain: TEZShapeForm;
    Shape2: TShape;
    Shape8: TShape;
    imgLogo: TImage;
    nbWizard: TNotebook;
    lblSelectOperation: TLabel;
    lblSelectCDROM: TLabel;
    cmbCDROMs: TFlatComboBox;
    rbCD2MP3: TFlatButton;
    rbCD2Wave: TFlatButton;
    rbCD2Ogg: TFlatButton;
    rbCD2WMA: TFlatButton;
    Shape1: TShape;
    btnPCDPrev: TEZImageButton;
    btnPCDPlay: TEZImageButton;
    btnPCDPause: TEZImageButton;
    btnPCDStop: TEZImageButton;
    btnPCDNext: TEZImageButton;
    btnPCDEject: TEZImageButton;
    btnSelAll: TEZImageButton;
    btnSelNone: TEZImageButton;
    btnSelInv: TEZImageButton;
    btnRefresh: TEZImageButton;
    btnSetCDDB: TEZImageButton;
    btnQueryCDDB: TEZImageButton;
    btnCDInfo: TEZImageButton;
    btnID3: TEZImageButton;
    btnReset: TEZImageButton;
    lvTracks: TListView;
    pnlError: TPanel;
    lblOutputFolder: TLabel;
    lblFileName: TLabel;
    lblPriority: TLabel;
    Shape3: TShape;
    Shape4: TShape;
    pnlWave: TPanel;
    nbOptions: TNotebook;
    lblMP3AudioMode: TLabel;
    lblMP3Bitrate: TLabel;
    lblMP3From: TLabel;
    lblMP3To: TLabel;
    lblMP3Quality: TLabel;
    lblMP3VBRQuality: TLabel;
    lblMP3QualityHint: TLabel;
    cmbMP3AudioMode: TFlatComboBox;
    cmbMP3MinBitrate: TFlatComboBox;
    chkMP3EnableVBR: TFlatCheckBox;
    cmbMP3MaxBitrate: TFlatComboBox;
    chkMP3WriteVBRHeader: TFlatCheckBox;
    cmbMP3Quality: TFlatComboBox;
    cmbMP3VBRQuality: TFlatComboBox;
    lblOggAudioMode: TLabel;
    lblOggFrom: TLabel;
    lblOggTo: TLabel;
    lblOggVBRQuality: TLabel;
    lblOggBitrate: TLabel;
    cmbOggAudioMode: TFlatComboBox;
    cmbOggMinBitrate: TFlatComboBox;
    chkOggVBR: TFlatCheckBox;
    cmbOggMaxBitrate: TFlatComboBox;
    chkOggBBR: TFlatCheckBox;
    cmbOggVBRQuality: TFlatComboBox;
    cmbOggBitrate: TFlatComboBox;
    lblWMABitrate: TLabel;
    lblWMAAudioMode: TLabel;
    cmbWMABitrate: TFlatComboBox;
    cmbWMAAudioMode: TFlatComboBox;
    edtOutputFolder: TFlatEdit;
    cmbFileNameRule: TFlatComboBox;
    cmbPriority: TFlatComboBox;
    btnBrowse: TFlatButton;
    Shape5: TShape;
    lblCurrentTrack: TLabel;
    Shape7: TShape;
    lblTotalProgress: TLabel;
    fgCurrent: TFlatGauge;
    fgTotal: TFlatGauge;
    lblProgress: TLabel;
    lblTitle: TLabel;
    btnBack: TFlatButton;
    btnNext: TFlatButton;
    btnExit: TFlatButton;
    btnMenu: TFlatButton;
    pmMenu: TPopupMenu;
    miLanguage: TMenuItem;
    miLangMoreBar: TMenuItem;
    miMoreLang: TMenuItem;
    miLanguageBar: TMenuItem;
    miHelp: TMenuItem;
    miDonate: TMenuItem;
    miAbout: TMenuItem;
    CDPlayer: TCDPlayer;
    pmTracks: TPopupMenu;
    miRefresh: TMenuItem;
    N1: TMenuItem;
    miSelAll: TMenuItem;
    miSelNone: TMenuItem;
    miSelInv: TMenuItem;
    N2: TMenuItem;
    miSetCDDB: TMenuItem;
    miQueryCDDB: TMenuItem;
    miCDInfo: TMenuItem;
    miID3: TMenuItem;
    miReset: TMenuItem;
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnBackClick(Sender: TObject);
    procedure btnSelAllClick(Sender: TObject);
    procedure btnSelNoneClick(Sender: TObject);
    procedure btnSelInvClick(Sender: TObject);
    procedure btnRefreshClick(Sender: TObject);
    procedure btnMenuClick(Sender: TObject);
    procedure nbWizardPageChanged(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure PlayerButtonsClick(Sender: TObject);
    procedure btnCDInfoClick(Sender: TObject);
    procedure btnID3Click(Sender: TObject);
    procedure OnDiscChange(Sender: TObject; FirstDriveLetter: Char);
    procedure btnResetClick(Sender: TObject);
    procedure btnSetCDDBClick(Sender: TObject);
    procedure btnQueryCDDBClick(Sender: TObject);
    procedure btnBrowseClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure chkMP3EnableVBRClick(Sender: TObject);
    procedure OggBBRVBRClick(Sender: TObject);
    procedure miDonateClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure lvTracksMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miHelpClick(Sender: TObject);
    procedure pmMenuPopup(Sender: TObject);
    procedure cmbWMABitrateChange(Sender: TObject);
    procedure cmbWMAAudioModeChange(Sender: TObject);
    procedure miMoreLangClick(Sender: TObject);
    procedure lvTracksCustomDrawItem(Sender: TCustomListView;
      Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lblUnregMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtOutputFolderKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    ProcessThread: TProcessThread;
    Ripping: Boolean;
    CurrentTrack, TotalTrack: Integer;
    CurrentTrackTitle: string;
    procedure UpdateNavigatorButtons;
    procedure InitApplication;
    function GetSelectedTrackCount: Integer;
    procedure BackClick_CDTracks;
    procedure BackClick_Options;
    procedure NextClick_Start;
    procedure NextClick_CDTracks;
    procedure NextClick_Options;
    procedure NextClick_Process;
    procedure RefreshDisc(RefreshInfo, ReadIni: Boolean);
    procedure RefreshListViewDisplay;
    procedure SetOptions;
    procedure GetOptions;
    procedure LngMenuClick(Sender: TObject);
    procedure UpdateLanguage;
    procedure ProcessTerminate(Sender: TObject);
    procedure UpdateProcessUI(Sender: TObject;
      Current, Total, CurrentProgress: Integer; Title: string);
    procedure LoadStartPageOptions;
    procedure SaveStartPageOptions;
    function GetTaskType: TTaskType;
    procedure SetTaskType(Value: TTaskType);
    { Private declarations }
  public
    procedure CreateParams(var Params: TCreateParams); override;
    procedure RestoreRequest(var message: TMessage); message WM_EZMP3CONLYONE;
    property TaskType: TTaskType read GetTaskType write SetTaskType;
    { Public declarations }
  end;

var
  frmMain: TfrmMain;

implementation

uses
  DiscInfo, TrackInfo, CDDBConfig, CFGParam, GetCDDB, Log, Languages, About,
  akrip32, myaspi32;

{$R *.DFM}

////////////////////////////////////////////////////////////////////////////////
// Application & Main Form Functions 

procedure TfrmMain.InitApplication;
begin
  Application.Title := AppTitle + ' ' + AppVersion;
  sfMain.Caption := Application.Title;

  SetOptions;

  GetDriveList(TStringList(cmbCDROMs.Items));
  cmbCDROMs.ItemIndex := 0;
  LoadStartPageOptions;
  nbWizard.ActivePage := 'Start';
  ActiveControl := rbCD2MP3;

  UpdateNavigatorButtons;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  InitApplication;

  // Language
  with TRegIniFile.Create(EZMP3CKey) do
  try
    LangName := ReadString('Options', 'Language', '');
    LangFile := ExtractFilePath(Application.ExeName) + 'Languages\' + LangName + '.lng';
    if FileExists(LangFile) then
    begin
      Languages.UpdateLanguage;
      UpdateLanguage;
      UpdateNavigatorButtons;
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // Stop cd player
  try
    CDPlayer.Stop;
    CDPlayer.Deinit;
  except
  end;

  SaveStartPageOptions;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
var
  Save: Boolean;
begin
  if Ripping then // processing, suspend then ask user
  begin
    // Suspend thread
    Save := ProcessThread.Suspended;
    if not Save then
      ProcessThread.Suspend;

    // Prompt
    if MsgDlg(QuitProcess, MB_YESNO or MB_ICONWARNING) = idYes then // Terminate
    begin
      ProcessThread.OnTerminate := nil;
      ProcessThread.Terminate;
      ProcessThread.Resume;
    end
    else // Continue
    begin
      CanClose := False;

      // Resume thread
      if not Save then
        ProcessThread.Resume;
    end;
  end;
end;

procedure TfrmMain.lblUnregMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture();
  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TfrmMain.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  Params.WinClassName := EZMP3CONLYONECLASS;
end;

procedure TfrmMain.RestoreRequest(var message: TMessage);
begin
  if IsIconic(Application.Handle) then
    Application.Restore
  else
    Application.BringToFront;
end;

function TfrmMain.GetTaskType: TTaskType;
begin
  if rbCD2MP3.Down then
    Result := ttMP3
  else if rbCD2Ogg.Down then
    Result := ttOgg
  else if rbCD2WMA.Down then
    Result := ttWMA
  else
    Result := ttWave;
end;

procedure TfrmMain.SetTaskType(Value: TTaskType);
begin
  if (not WMAInstalled) and (Value = ttWMA) then
    Value := ttMP3;
  case Value of
    ttMP3: rbCD2MP3.Down := True;
    ttOgg: rbCD2Ogg.Down := True;
    ttWMA: rbCD2WMA.Down := True;
    else rbCD2Wave.Down := True;
  end;
end;

procedure TfrmMain.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  VK_1 = $31;
  VK_2 = $32;
  VK_3 = $33;
  VK_4 = $34;
begin
  if GetKeyState(VK_CONTROL) and $80000000 = $80000000 then
    case Key of
      VK_1: TaskType := ttMP3;
      VK_2: TaskType := ttOgg;
      VK_3: TaskType := ttWMA;
      VK_4: TaskType := ttWave;
    end;
end;

////////////////////////////////////////////////////////////////////////////////
// Menu Functions

procedure TfrmMain.btnMenuClick(Sender: TObject);
var
  P: TPoint;
begin
  P := Point(btnMenu.Left, btnMenu.Top + btnMenu.Height);
  P := ClientToScreen(P);
  pmMenu.Popup(P.X, P.Y);
end;

procedure TfrmMain.pmMenuPopup(Sender: TObject);
var
  I: Integer;
  Sr: TSearchRec;
  Err: Integer;
  tFile: TFileName;
  LngMenu: TMenuItem;
  LngList: TStringList;
begin
  while miLanguage.Count > 2 do
    miLanguage.Delete(0);

  LngList := TStringList.Create;
  try
    Err := FindFirst(ExtractFilePath(Application.ExeName) + 'Languages\*.*',
      faAnyFile, Sr); // Search .lng files
    while Err = 0 do
    begin
      tFile := Sr.Name;
      if ((Sr.Attr and faDirectory) = 0) and
        (ExtractFileExt(tFile) = '.lng') then
      begin
        tFile := ExtractFileName(tFile);
        SetLength(tFile, Length(tFile) - 4);
        LngList.Add(tFile);
      end;
      Err := FindNext(Sr); // Search next file
    end;
    FindClose(Sr);

    LngList.Sort;
    for I := 0 to LngList.Count - 1 do
    begin
      LngMenu := TMenuItem.Create(Self);
      with LngMenu do
      begin
        miLanguage.Insert(miLanguage.Count - 2, LngMenu);
        Caption := LngList[I];
        Checked := (Caption = LangName) or
          ((LangName = '') and (Caption = 'English'));
        OnClick := LngMenuClick;
      end;
    end;
  finally
    LngList.Free;
  end;

  miLangMoreBar.Visible := miLanguage.Count > 2;
end;

procedure TfrmMain.LngMenuClick(Sender: TObject);
var
  TempLangFile: string;
begin
  if (Sender as TMenuItem).Checked then Exit;

  TempLangFile := ExtractFilePath(Application.ExeName) + 'languages\' +
    (Sender as TMenuItem).Caption + '.lng';
  if FileExists(TempLangFile) then
  begin
    LangName := (Sender as TMenuItem).Caption;
    LangFile := TempLangFile;
    with TRegIniFile.Create(EZMP3CKey) do
    try
      WriteString('Options', 'Language', LangName);
    finally
      Free;
    end;
    Languages.UpdateLanguage;
    UpdateLanguage;
    UpdateNavigatorButtons;
  end;
end;

procedure TfrmMain.miMoreLangClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar(LangURL), nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.miHelpClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open',
    PChar(ExtractFilePath(Application.ExeName) + CHMFile),
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.miDonateClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', 'https://www.paypal.com/cgi-bin/webscr?hosted_button_id=9130206&cmd=_s-xclick',
    nil, nil, SW_SHOWNORMAL);
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
begin
  with TfrmAbout.Create(Self) do
  try
    ShowModal;
  finally
    Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Navigator Button Functions

procedure TfrmMain.UpdateNavigatorButtons;
begin
  btnBack.Enabled := (nbWizard.ActivePage <> 'Start')
    and (nbWizard.ActivePage <> 'Process');
  btnNext.Enabled := ((nbWizard.ActivePage = 'Start') and (CDList.num > 0))
    or (nbWizard.ActivePage = 'CDTracks')
    or (nbWizard.ActivePage = 'Options')
    or (nbWizard.ActivePage = 'Process');

  if (nbWizard.ActivePage = 'Options') then
    btnNext.Caption := ButtonGOCaption
  else if (nbWizard.ActivePage = 'Process') and Ripping then
  begin
    if ProcessThread.Suspended then
      btnNext.Caption := ButtonResumeCaption
    else
      btnNext.Caption := ButtonPauseCaption;
  end
  else
    btnNext.Caption := ButtonNextCaption;

  if nbWizard.ActivePage = 'Process' then
    btnExit.Caption := ButtonAbortCaption
  else
    btnExit.Caption := ButtonExitCaption;
end;

procedure TfrmMain.btnExitClick(Sender: TObject);
var
  Save: Boolean;
begin
  if not Ripping then
    Close
  else // Processing
  begin
    // Suspended thread
    Save := ProcessThread.Suspended;
    if not Save then
      ProcessThread.Suspend;

    // Prompt
    if MsgDlg(QuitProcess, MB_YESNO or MB_ICONWARNING) = idYes then // Abort
    begin
      ProcessThread.Terminate;
      ProcessThread.Resume;
    end
    else if not Save then // Continue
      ProcessThread.Resume;
  end;
end;

procedure TfrmMain.btnBackClick(Sender: TObject);
begin
  if nbWizard.ActivePage = 'CDTracks' then
    BackClick_CDTracks
  else if nbWizard.ActivePage = 'Options' then
    BackClick_Options;

  UpdateNavigatorButtons;
end;

procedure TfrmMain.btnNextClick(Sender: TObject);
begin
  if nbWizard.ActivePage = 'Start' then
    NextClick_Start
  else if nbWizard.ActivePage = 'CDTracks' then
    NextClick_CDTracks
  else if nbWizard.ActivePage = 'Options' then
    NextClick_Options
  else if nbWizard.ActivePage = 'Process' then
    NextClick_Process;

  UpdateNavigatorButtons;
end;

////////////////////////////////////////////////////////////////////////////////
// Start Page Functions

procedure TfrmMain.NextClick_Start;
begin
  nbWizard.ActivePage := 'CDTracks';
  RefreshDisc(True, True);
end;

procedure TfrmMain.LoadStartPageOptions;

  function GetDriveIndexFromCommandLine: Integer;
  const
    DRIVESPEC = '/Drive:';
  var
    I: Integer;
    S: string;
  begin
    Result := -1;
    if ParamCount <= 0 then Exit;
    S := ParamStr(1);
    if Copy(S, 1, Length(DRIVESPEC)) <> DRIVESPEC then Exit;
    Delete(S, 1, Length(DRIVESPEC));
    if Length(S) < 1 then Exit;
    S := UpperCase(S);
    if (S[1] < 'C') or (S[1] > 'Z') then Exit; 
    for I := 0 to CDList.num - 1 do
      if CDListLetter[I] = S[1] then
      begin
        Result := I;
        Break;
      end;
  end;

var
  Task: Integer;
  DriveIndex, DriveIndexFromCmdLine: Integer;
begin
  with TRegIniFile.Create(EZMP3CKey) do
  try
    rbCD2WMA.Enabled := WMAInstalled;
    Task := ReadInteger('StartPage', 'TaskIndex', Ord(ttMP3));
    if (Task < Ord(ttMP3)) or (Task > Ord(ttWave)) then
      Task := Ord(ttMP3);
    TaskType := TTaskType(Task);

    DriveIndexFromCmdLine := GetDriveIndexFromCommandLine;
    if DriveIndexFromCmdLine <> -1 then
      cmbCDROMs.ItemIndex := DriveIndexFromCmdLine
    else
    begin
      DriveIndex := ReadInteger('StartPage', 'CDIndex', 0);
      if (DriveIndex >= 0) and (DriveIndex < cmbCDROMs.Items.Count) then
        cmbCDROMs.ItemIndex := DriveIndex;
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.SaveStartPageOptions;
begin
  with TRegIniFile.Create(EZMP3CKey) do
  try
    WriteInteger('StartPage', 'TaskIndex', Ord(TaskType));
    WriteInteger('StartPage', 'CDIndex', cmbCDROMs.ItemIndex);
  finally
    Free;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Tracks Page Functions

procedure TfrmMain.nbWizardPageChanged(Sender: TObject);
begin
  try
    if nbWizard.ActivePage = 'CDTracks' then
    begin
      CDPlayer.CurrentDrive := CDListLetter[cmbCDROMs.ItemIndex];
      CDPlayer.Init;
    end
    else
    begin
      CDPlayer.Stop;
      CDPlayer.Deinit;
    end;
  except
  end;
end;

procedure TfrmMain.OnDiscChange(Sender: TObject; FirstDriveLetter: Char);
begin
  if nbWizard.ActivePage = 'CDTracks' then
    RefreshDisc(True, True);
end;

procedure TfrmMain.RefreshDisc(RefreshInfo, ReadIni: Boolean);
var
  i: Integer;
begin
  lvTracks.Items.Clear;
  pnlError.Visible := False;
  if GetTrackInfo(cmbCDROMs.ItemIndex, RefreshInfo, ReadIni) then
    for i := CDTOC.firstTrack to CDTOC.lastTrack do
      with lvTracks.Items.Add do
      begin
        SubItems.Add(Format('%.2d', [i]));
        if Trim(TrackInfos[i].Title) <> '' then
          SubItems.Add(TrackInfos[i].Title)
        else
          SubItems.Add(Format('Track-%.2d', [i]));
        SubItems.Add(Format('%.2d:%.2d',
          [TrackInfos[i].TimeM, TrackInfos[i].TimeS]));
        SubItems.Add(Format('%.2f', [TrackInfos[i].Size * 2352 / 1024 / 1024]));
        Checked :=
          ((CDTOC.tracks[i - CDTOC.firstTrack].ADR and 4) = 0); // is audio track
      end
  else
    pnlError.Visible := True;
end;

procedure TfrmMain.BackClick_CDTracks;
begin
  nbWizard.ActivePage := 'Start';
end;

procedure TfrmMain.NextClick_CDTracks;
begin
  if GetSelectedTrackCount > 0 then
  begin
    nbWizard.ActivePage := 'Options';

    // Display options page
    nbOptions.Visible := not (TaskType = ttWave);
    case TaskType of
      ttMP3: nbOptions.ActivePage := 'MP3';
      ttOgg: nbOptions.ActivePage := 'Ogg';
      ttWMA: nbOptions.ActivePage := 'WMA';
    end;
  end
  else if lvTracks.Items.Count <= 0 then
    MsgDlg(pnlError.Caption, MB_OK or MB_ICONWARNING)
  else
    MsgDlg(NoTrackSelected, MB_OK or MB_ICONWARNING);
end;

procedure TfrmMain.lvTracksMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Index: Integer;
  HTInfo: tagLVHITTESTINFO;
begin
  HTInfo.pt := Point(X, Y);
  HTInfo.flags := LVHT_ONITEMSTATEICON;
  Index := ListView_HitTest(lvTracks.Handle, HTInfo);
  if Index = -1 then Exit;
  if ((CDTOC.tracks[Index].ADR and 4) <> 0) then // not audio track
    lvTracks.Items[Index].Checked := False;
end;

procedure TfrmMain.lvTracksCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
  if Item = nil then Exit;

  if (CDTOC.tracks[Item.Index].ADR and 4) <> 0 then // not audio track
    Sender.Canvas.Font.Style := Sender.Canvas.Font.Style + [fsStrikeOut];
end;

procedure TfrmMain.RefreshListViewDisplay;
var
  I: Integer;
begin
  for I := 0 to lvTracks.Items.Count - 1 do
    if Trim(TrackInfos[I + CDTOC.firstTrack].Title) <> '' then
      lvTracks.Items[I].SubItems[1] := TrackInfos[I + CDTOC.firstTrack].Title
    else
      lvTracks.Items[I].SubItems[1] := Format('Track-%.2d',
        [I + CDTOC.firstTrack]);
end;

function TfrmMain.GetSelectedTrackCount: Integer;
var
  i: Integer;
begin
  Result := 0;
  for i := 0 to lvTracks.Items.Count - 1 do
    if lvTracks.Items[i].Checked then
      Inc(Result);
end;

procedure TfrmMain.btnRefreshClick(Sender: TObject);
begin
  PlayerButtonsClick(btnPCDStop);
  RefreshDisc(False, False);
end;

procedure TfrmMain.btnSelAllClick(Sender: TObject);
var
  i: Integer;
begin
  for I := 0 to lvTracks.Items.Count - 1 do
    lvTracks.Items[I].Checked := ((CDTOC.tracks[I].ADR and 4) = 0); // is audio
end;

procedure TfrmMain.btnSelNoneClick(Sender: TObject);
var
  i: Integer;
begin
  for i := 0 to lvTracks.Items.Count - 1 do
    lvTracks.Items[i].Checked := False;
end;

procedure TfrmMain.btnSelInvClick(Sender: TObject);
var
  i: Integer;
begin
  for I := 0 to lvTracks.Items.Count - 1 do
    lvTracks.Items[I].Checked := ((CDTOC.tracks[I].ADR and 4) = 0) // is audio
      and (not lvTracks.Items[I].Checked);
end;

procedure TfrmMain.btnSetCDDBClick(Sender: TObject);
begin
  with TfrmCDDBConfig.Create(Self) do
  try
    SetCDDB(CDDBConnection);
    if ShowModal = mrOK then
    begin
      CDDBConnection := GetCDDB;
      SaveParam;
    end;
  finally
    Free;
  end;
end;

procedure TfrmMain.btnQueryCDDBClick(Sender: TObject);
var
  I: Integer;
begin
  if lvTracks.Items.Count <= 0 then
    MsgDlg(pnlError.Caption, MB_OK or MB_ICONWARNING)
  else
    with TfrmGetCDDB.Create(Self) do
    try
      pnlMessage.Caption := Format(CDDBMsgConnect, [CDDBConnection.Server]);
      QueryCDDB; // Query CDDB
      if ShowModal = mrOK then // Get query result
      begin
        CDInfo.Album := edtAlbum.Text;
        CDInfo.Artist := edtArtist.Text;
        CDInfo.Genre := GetGenreIndex(edtGenre.Text);
        for I := CDTOC.firstTrack to CDTOC.lastTrack do
        begin
          TrackInfos[I].Album := edtAlbum.Text;
          TrackInfos[I].Artist := edtArtist.Text;
          TrackInfos[I].Genre := CDInfo.Genre;
          if (lbTitles.Items.Count > I - CDTOC.firstTrack) then
            TrackInfos[I].Title := Trim(lbTitles.Items[I - CDTOC.firstTrack]);
        end;
        RefreshListViewDisplay;
        CDPlayerIniRW(True);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.btnCDInfoClick(Sender: TObject);
begin
  if lvTracks.Items.Count <= 0 then
    MsgDlg(pnlError.Caption, MB_OK or MB_ICONWARNING)
  else
    with TfrmDiscInfo.Create(Self) do
    try
      SetCDInfo(CDInfo);
      if ShowModal = mrOK then
      begin
        CopyToAllTracks;
        CDInfo := GetCDInfo;
        CDPlayerIniRW(True);
      end;
    finally
      Free;
    end;
end;

procedure TfrmMain.btnID3Click(Sender: TObject);
var
  P: TPoint;
begin
  if Sender = lvTracks then
  begin
    GetCursorPos(P);
    P := lvTracks.ScreenToClient(P);
    if P.X < 22 then Exit;
  end;

  if lvTracks.Items.Count <= 0 then
    MsgDlg(pnlError.Caption, MB_OK or MB_ICONWARNING)
  else
  begin
    with TfrmTrackInfo.Create(Self) do
    try
      SetID3Infos;
      if lvTracks.Selected = nil then
        lvTracks.Selected := lvTracks.Items[0];
      Index := lvTracks.Selected.Index + CDTOC.firstTrack;
      SetID3Info;
      RefreshIndexLabel;
      if ShowModal = mrOK then
      begin
        GetID3Info;
        GetID3Infos;
        RefreshListViewDisplay;
        CDPlayerIniRW(True);
      end;
    finally
      Free;
    end;
  end;
end;

procedure TfrmMain.btnResetClick(Sender: TObject);
var
  I: Integer;
begin
  ResetTrackInfo(CDInfo);
  for I := Low(TrackInfos) to High(TrackInfos) do
    ResetTrackInfo(TrackInfos[I]);
  RefreshListViewDisplay;
end;

procedure TfrmMain.PlayerButtonsClick(Sender: TObject);
begin
  if (lvTracks.Items.Count <= 0) and ((Sender as TControl).Tag <> 6) then Exit;
  try
    case (Sender as TComponent).Tag of
      1: // Prev
        begin
          CDPlayer.Prior;
          lvTracks.Selected := lvTracks.Items[CDPlayer.CurrentTrack - 1];
          lvTracks.ItemFocused := lvTracks.Selected;
        end;
      2: // Play
        begin
          if CDPlayer.Mode = mpStopped then
          try
            CDPlayer.Resume;
          except
          end;
          if CDPlayer.Mode <> mpPlaying then
          begin
            if CDPlayer.IsFinish then
              CDPlayer.Init;
            if lvTracks.Selected = nil then
              lvTracks.Selected := lvTracks.Items[0];
            CDPlayer.GotoTrack(lvTracks.Selected.Index + 1);
            CDPlayer.Play;
            lvTracks.Selected := lvTracks.Items[CDPlayer.CurrentTrack - 1];
            lvTracks.ItemFocused := lvTracks.Selected;
          end;
        end;
      3: // Pause
        begin
          if CDPlayer.Mode = mpPlaying then
            CDPlayer.Pause
          else if CDPlayer.Mode = mpStopped then
            CDPlayer.Resume;
        end;
      4: // Stop
        begin
          CDPlayer.Stop;
          CDPlayer.Rewind;
        end;
      5: // Next
        begin
          CDPlayer.Next;
          lvTracks.Selected := lvTracks.Items[CDPlayer.CurrentTrack - 1];
          lvTracks.ItemFocused := lvTracks.Selected;
        end;
      6: // Eject
        CDPlayer.OpenDoor; 
    end;
  except
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// Options Page Functions

procedure TfrmMain.BackClick_Options;
var
  I: Integer;
  CheckFlag: array[0..99] of Boolean;
begin
  nbWizard.ActivePage := 'CDTracks';
  for I := 0 to lvTracks.Items.Count - 1 do
    CheckFlag[I] := lvTracks.Items[I].Checked;
  RefreshDisc(False, False);
  for I := 0 to lvTracks.Items.Count - 1 do
    lvTracks.Items[I].Checked := CheckFlag[I];
end;

procedure TfrmMain.NextClick_Options;
begin
  if not ValidDirName(edtOutputFolder.Text) then
  begin
    MsgDlg(OutputFolderError, MB_OK or MB_ICONWARNING);
    Exit;
  end;
  if not ValidFileNameRule(cmbFileNameRule.Text) then
  begin
    MsgDlg(FileNameRuleError, MB_OK or MB_ICONWARNING);
    Exit;
  end;

  GetOptions;
  SaveParam;

  if (ReadTOC(CDHandle, CDTOC, False) <> SS_COMP) or
    (CDTOC.lastTrack < CDTOC.firstTrack) then
  begin
    MsgDlg(NoCDFound, MB_OK or MB_ICONWARNING);
    Exit;
  end;

  try
    ForceDirectories(OutputFolder);
  except
    MsgDlg(CreateFolderError, MB_OK or MB_ICONWARNING);
    Exit;
  end;

  nbWizard.ActivePage := 'Process';

  // Create process thread
  ProcessThread := TProcessThread.Create(True);
  Ripping := True;
  with ProcessThread do
  begin
    FreeOnTerminate := True;
    Priority := ActionPriority;
    Total := GetSelectedTrackCount;
    OnUpdateUI := UpdateProcessUI;
    OnTerminate := ProcessTerminate;
    Resume;
  end;
end;

procedure TfrmMain.btnBrowseClick(Sender: TObject);
var
  TempStr: string;
begin
  if BrowseDirectory(Handle, TempStr) then
    edtOutputFolder.Text := TempStr;
end;

procedure TfrmMain.edtOutputFolderKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnBrowseClick(Self);
end;

procedure TfrmMain.GetOptions;
begin
  OutputFolder := edtOutputFolder.Text;
  FileNameRule := cmbFileNameRule.Text;
  ActionPriority := TThreadPriority(cmbPriority.ItemIndex + 1);

  with MP3EncodeParam do
  begin
    EnableVBR := chkMP3EnableVBR.Checked;
    WriteVBRHeader := chkMP3WriteVBRHeader.Checked;
    VBRQuality := cmbMP3VBRQuality.ItemIndex;
    MinBitrate := MP3Bitrates[cmbMP3MinBitrate.ItemIndex];
    MaxBitrate := MP3Bitrates[cmbMP3MaxBitrate.ItemIndex];
    if EnableVBR then
      if MinBitrate > MaxBitrate then
        SwapDword(MinBitrate, MaxBitrate);
    Quality := cmbMP3Quality.ItemIndex;
    AudioMode := TMP3CoderMode(cmbMP3AudioMode.ItemIndex);
  end;

  with OggEncodeParam do
  begin
    EnableBBR := chkOggBBR.Checked;
    EnableVBR := chkOggVBR.Checked;
    Bitrate := OggBitrates[cmbOggBitrate.ItemIndex];
    MinBitrate := OggBitrates[cmbOggMinBitrate.ItemIndex];
    MaxBitrate := OggBitrates[cmbOggMaxBitrate.ItemIndex];
    if MinBitrate > MaxBitrate then
      SwapDword(MinBitrate, MaxBitrate);
    VBRQuality := OggBitrates[cmbOggVBRQuality.ItemIndex];
    AudioMode := TOggCoderMode(cmbOggAudioMode.ItemIndex);
  end;

  with WMAEncodeParam do
  begin
    Bitrate := WMABitrates[cmbWMABitrate.ItemIndex];
    AudioMode := TWMACoderMode(cmbWMAAudioMode.ItemIndex);
  end;
end;

procedure TfrmMain.SetOptions;
begin
  edtOutputFolder.Text := OutputFolder;
  cmbFileNameRule.Text := FileNameRule;
  cmbPriority.ItemIndex := Ord(ActionPriority) - 1;

  with MP3EncodeParam do
  begin
    chkMP3EnableVBR.Checked := EnableVBR;
    chkMP3WriteVBRHeader.Checked := WriteVBRHeader;
    cmbMP3VBRQuality.ItemIndex := VBRQuality;
    cmbMP3MinBitrate.ItemIndex := GetMP3BitrateIndex(MinBitrate, 128);
    cmbMP3MaxBitrate.ItemIndex := GetMP3BitrateIndex(MaxBitrate, 320);
    cmbMP3Quality.ItemIndex := Quality;
    cmbMP3AudioMode.ItemIndex := Ord(AudioMode);
  end;
  chkMP3EnableVBRClick(Self);

  with OggEncodeParam do
  begin
    chkOggBBR.Checked := EnableBBR;
    chkOggVBR.Checked := EnableVBR;
    cmbOggBitrate.ItemIndex := GetOggBitrateIndex(Bitrate, 128);
    cmbOggMinBitrate.ItemIndex := GetOggBitrateIndex(MinBitrate, 128);
    cmbOggMaxBitrate.ItemIndex := GetOggBitrateIndex(MaxBitrate, 320);
    cmbOggVBRQuality.ItemIndex := GetOggBitrateIndex(VBRQuality, 128);
    cmbOggAudioMode.ItemIndex := Ord(AudioMode);
  end;
  OggBBRVBRClick(chkOggBBR);

  with WMAEncodeParam do
  begin
    cmbWMABitrate.ItemIndex := GetWMABitrateIndex(Bitrate, 64);
    cmbWMAAudioMode.ItemIndex := Ord(AudioMode);
  end;
  cmbWMABitrateChange(cmbWMABitrate);
end;

procedure TfrmMain.chkMP3EnableVBRClick(Sender: TObject);
begin
  chkMP3WriteVBRHeader.Enabled := chkMP3EnableVBR.Checked;
  lblMP3VBRQuality.Enabled := chkMP3EnableVBR.Checked;
  cmbMP3VBRQuality.Enabled := chkMP3EnableVBR.Checked;
  cmbMP3MaxBitrate.Enabled := chkMP3EnableVBR.Checked;
  lblMP3From.Enabled := chkMP3EnableVBR.Checked;
  lblMP3To.Enabled := chkMP3EnableVBR.Checked;
end;

procedure TfrmMain.OggBBRVBRClick(Sender: TObject);
begin
  if Sender = chkOggBBR then
    if chkOggBBR.Checked then
      chkOggVBR.Checked := False;
  if Sender = chkOggVBR then
    if chkOggVBR.Checked then
      chkOggBBR.Checked := False;
  lblOggBitrate.Enabled := not chkOggVBR.Checked;
  cmbOggBitrate.Enabled := not chkOggVBR.Checked;
  lblOggFrom.Enabled := chkOggBBR.Checked;
  lblOggTo.Enabled := chkOggBBR.Checked;
  cmbOggMinBitrate.Enabled := chkOggBBR.Checked;
  cmbOggMaxBitrate.Enabled := chkOggBBR.Checked;
  lblOggVBRQuality.Enabled := chkOggVBR.Checked;
  cmbOggVBRQuality.Enabled := chkOggVBR.Checked;
end;

procedure TfrmMain.cmbWMABitrateChange(Sender: TObject);
begin
  if WMABitrates[cmbWMABitrate.ItemIndex] > 32 then
    cmbWMAAudioMode.ItemIndex := Ord(wmamStereo);
end;

procedure TfrmMain.cmbWMAAudioModeChange(Sender: TObject);
var
  DefaultMonoBitrate: DWORD;
begin
  DefaultMonoBitrate := 32;
  if TWMACoderMode(cmbWMAAudioMode.ItemIndex) = wmamMono then
    if WMABitrates[cmbWMABitrate.ItemIndex] > 32 then
      cmbWMABitrate.ItemIndex := GetWMABitrateIndex(DefaultMonoBitrate, 32);
end;

////////////////////////////////////////////////////////////////////////////////
// Process Page Options

procedure TfrmMain.NextClick_Process;
begin
  if not Ripping then Exit;
  if ProcessThread.Suspended then
    ProcessThread.Resume
  else
    ProcessThread.Suspend;
end;

procedure TfrmMain.ProcessTerminate(Sender: TObject);
begin
  Ripping := False;

  // Show log
  with TfrmLog.Create(Self) do
  try
    fmLog.Lines.Assign(ProcessLog);
    ShowModal;
  finally
    Free;
  end;

  nbWizard.ActivePage := 'Start';
  UpdateProcessUI(Self, 0, 1, 0, '');
  UpdateNavigatorButtons;
end;

procedure TfrmMain.UpdateProcessUI(Sender: TObject;
  Current, Total, CurrentProgress: Integer; Title: string);
begin
  CurrentTrack := Current;
  TotalTrack := Total;
  lblProgress.Caption := Format(ProgressLabel, [Current, Total]);
  lblTitle.Caption := Title;
  CurrentTrackTitle := Title;

  fgCurrent.Progress := CurrentProgress;
  fgTotal.Progress := ((Current - 1) * 100 + CurrentProgress) div Total;
end;

////////////////////////////////////////////////////////////////////////////////
// Language Functions

procedure TfrmMain.UpdateLanguage;
var
  Save: Integer;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);
    pnlError.Font.Name := Font.Name;
    pnlError.Font.Size := Font.Size;
    pnlWave.Font.Name := Font.Name;
    lblProgress.Font.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    lblProgress.Font.Size := ReadInteger('Font', 'TitleFontSize', 10);
    lblTitle.Font.Assign(lblProgress.Font);

    btnMenu.Caption := ReadString('Button', 'Menu', btnMenu.Caption);
    btnBack.Caption := ReadString('Button', 'Back', btnBack.Caption);
    miHelp.Caption := ReadString('Main', 'MenuHelp', miHelp.Caption);
    miAbout.Caption := ReadString('Main', 'MenuAbout', miAbout.Caption);

    lblSelectOperation.Caption := ReadString('Main', 'SelectOperation', lblSelectOperation.Caption);
    lblSelectCDROM.Caption := ReadString('Main', 'SelectCDROM', lblSelectCDROM.Caption);

    pnlError.Caption := ReadString('Main', 'NoDisc', pnlError.Caption);
    lvTracks.Columns[2].Caption := ReadString('Main', 'Title', lvTracks.Columns[2].Caption);
    lvTracks.Columns[3].Caption := ReadString('Main', 'Length', lvTracks.Columns[3].Caption);
    lvTracks.Columns[4].Caption := ReadString('Main', 'Size', lvTracks.Columns[4].Caption);
    miRefresh.Caption := ReadString('Main', 'MenuRefresh', miRefresh.Caption);
    miSelAll.Caption := ReadString('Main', 'MenuSelectAll', miSelAll.Caption);
    miSelNone.Caption := ReadString('Main', 'MenuSelectNone', miSelNone.Caption);
    miSelInv.Caption := ReadString('Main', 'MenuInverseSelection', miSelInv.Caption);
    miSetCDDB.Caption := ReadString('Main', 'MenuConfigCDDB', miSetCDDB.Caption);
    miQueryCDDB.Caption := ReadString('Main', 'MenuQueryCDDB', miQueryCDDB.Caption);
    miCDInfo.Caption := ReadString('Main', 'MenuEditDiscInfo', miCDInfo.Caption);
    miID3.Caption := ReadString('Main', 'MenuEditTrackInfo', miID3.Caption);
    miReset.Caption := ReadString('Main', 'MenuClearInfo', miReset.Caption);
    btnRefresh.Hint := ReadString('Main', 'ButtonRefresh', btnRefresh.Hint);
    btnSelAll.Hint := ReadString('Main', 'ButtonSelectAll', btnSelAll.Hint);
    btnSelNone.Hint := ReadString('Main', 'ButtonSelectNone', btnSelNone.Hint);
    btnSelInv.Hint := ReadString('Main', 'ButtonInverseSelection', btnSelInv.Hint);
    btnSetCDDB.Hint := ReadString('Main', 'ButtonConfigCDDB', btnSetCDDB.Hint);
    btnQueryCDDB.Hint := ReadString('Main', 'ButtonQueryCDDB', btnQueryCDDB.Hint);
    btnCDInfo.Hint := ReadString('Main', 'ButtonEditDiscInfo', btnCDInfo.Hint);
    btnID3.Hint := ReadString('Main', 'ButtonEditTrackInfo', btnID3.Hint);
    btnReset.Hint := ReadString('Main', 'ButtonClearInfo', btnReset.Hint);

    lblOutputFolder.Caption := ReadString('Main', 'OutputFolder', lblOutputFolder.Caption);
    btnBrowse.Height := edtOutputFolder.Height;
    lblFileName.Caption := ReadString('Main', 'FileName', lblFileName.Caption);
    lblPriority.Caption := ReadString('Main', 'Priority', lblPriority.Caption);
    Save := cmbPriority.ItemIndex;
    cmbPriority.Items[0] := ReadString('Main', 'Priority1', cmbPriority.Items[0]);
    cmbPriority.Items[1] := ReadString('Main', 'Priority2', cmbPriority.Items[1]);
    cmbPriority.Items[2] := ReadString('Main', 'Priority3', cmbPriority.Items[2]);
    cmbPriority.Items[3] := ReadString('Main', 'Priority4', cmbPriority.Items[3]);
    cmbPriority.Items[4] := ReadString('Main', 'Priority5', cmbPriority.Items[4]);
    cmbPriority.ItemIndex := Save;
    pnlWave.Caption := ReadString('Main', 'WaveOptions', pnlWave.Caption);
    chkMP3EnableVBR.Caption := ReadString('Main', 'MP3EnableVBR', chkMP3EnableVBR.Caption);
    chkMP3WriteVBRHeader.Caption := ReadString('Main', 'MP3WriteVBRHeader', chkMP3WriteVBRHeader.Caption);
    lblMP3VBRQuality.Caption := ReadString('Main', 'Quality', lblMP3VBRQuality.Caption);
    lblMP3Bitrate.Caption := ReadString('Main', 'Bitrate', lblMP3Bitrate.Caption);
    lblMP3From.Caption := ReadString('Main', 'From', lblMP3From.Caption);
    lblMP3To.Caption := ReadString('Main', 'To', lblMP3To.Caption);
    lblMP3Quality.Caption := ReadString('Main', 'Quality', lblMP3Quality.Caption);
    lblMP3QualityHint.Caption := ReadString('Main', 'MP3QualityHint', lblMP3QualityHint.Caption);
    lblMP3AudioMode.Caption := ReadString('Main', 'AudioMode', lblMP3AudioMode.Caption);
    Save := cmbMP3AudioMode.ItemIndex;
    cmbMP3AudioMode.Items[0] := ReadString('Main', 'AudioMode1', cmbMP3AudioMode.Items[0]);
    cmbMP3AudioMode.Items[1] := ReadString('Main', 'AudioMode2', cmbMP3AudioMode.Items[1]);
    cmbMP3AudioMode.Items[2] := ReadString('Main', 'AudioMode3', cmbMP3AudioMode.Items[2]);
    cmbMP3AudioMode.ItemIndex := Save;
    lblOggBitrate.Caption := ReadString('Main', 'Bitrate', lblOggBitrate.Caption);
    lblOggFrom.Caption := ReadString('Main', 'From', lblOggFrom.Caption);
    lblOggTo.Caption := ReadString('Main', 'To', lblOggTo.Caption);
    lblOggVBRQuality.Caption := ReadString('Main', 'Quality', lblOggVBRQuality.Caption);
    lblOggAudioMode.Caption := ReadString('Main', 'AudioMode', lblOggAudioMode.Caption);
    Save := cmbOggAudioMode.ItemIndex;
    cmbOggAudioMode.Items[0] := ReadString('Main', 'AudioMode1', cmbOggAudioMode.Items[0]);
    cmbOggAudioMode.Items[1] := ReadString('Main', 'AudioMode2', cmbOggAudioMode.Items[1]);
    cmbOggAudioMode.ItemIndex := Save;
    lblWMABitrate.Caption := ReadString('Main', 'Bitrate', lblWMABitrate.Caption);
    lblWMAAudioMode.Caption := ReadString('Main', 'AudioMode', lblWMAAudioMode.Caption);
    Save := cmbWMAAudioMode.ItemIndex;
    cmbWMAAudioMode.Items[0] := ReadString('Main', 'AudioMode1', cmbWMAAudioMode.Items[0]);
    cmbWMAAudioMode.Items[1] := ReadString('Main', 'AudioMode2', cmbWMAAudioMode.Items[1]);
    cmbWMAAudioMode.ItemIndex := Save;

    lblCurrentTrack.Caption := ' ' + ReadString('Main', 'CurrentTrack', lblCurrentTrack.Caption) + ' ';
    lblTotalProgress.Caption := ' ' + ReadString('Main', 'TotalProgess', lblTotalProgress.Caption) + ' ';
    if nbWizard.ActivePage = 'Process' then
    begin
      lblProgress.Caption := Format(ProgressLabel, [CurrentTrack, TotalTrack]);
      lblTitle.Caption := CurrentTrackTitle;
    end;

    if CDList.num <= 0 then
    begin
      cmbCDROMs.Items[0] := NoDriver;
      cmbCDROMs.ItemIndex := 0;
    end;
  finally
    Free;
  end;
end;

end.

