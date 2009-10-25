//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    GetCDDB.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Query CDDB Dialog
//
// 2006-05-07
// - Initial release with comments
//------------------------------------------------------------------------------

unit GetCDDB;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, IniFiles, StdCtrls,
  ExtCtrls, TFlatListBoxUnit, TFlatEditUnit, TFlatButtonUnit, EZShapeForm,
  akrip32, myaspi32;

////////////////////////////////////////////////////////////////////////////////
// TQueryThread Interface

const
  QUERYITEM_MAX = 32;

type
  TQueryThread = class(TThread)
  private
    procedure ShowMatchesForm;
  protected
    procedure Execute; override;
  public
    CDQuery: TCDDBQUERY;
    QueryItem: TCDDBQUERYITEM;
    QueryItems: array[0..QUERYITEM_MAX - 1] of TCDDBQUERYITEM;

    DiscTitle: string;
    Artist: string;
    Category: string;
    DiscInfo: array[0..32000] of Char;
    
    Selected: Boolean;
    Success: Boolean;
  end;

////////////////////////////////////////////////////////////////////////////////
// Query CDDB Form Interface

type
  TfrmGetCDDB = class(TForm)
    sfGetCDDB: TEZShapeForm;
    Shape1: TShape;
    lblAlbum: TLabel;
    lblArtist: TLabel;
    lblTitles: TLabel;
    lblGenre: TLabel;
    edtAlbum: TFlatEdit;
    pnlMessage: TPanel;
    edtArtist: TFlatEdit;
    edtGenre: TFlatEdit;
    lbTitles: TFlatListBox;
    btnOK: TFlatButton;
    btnCancel: TFlatButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormDestroy(Sender: TObject);
  private
    QueryThread: TQueryThread;
    procedure UpdateLanguage;
    procedure ThreadDone(Sender: TObject);
    { Private declarations }
  public
    procedure QueryCDDB;
    { Public declarations }
  end;

implementation

uses Languages, CFGParam, Matches, RipUnit;

{$R *.DFM}

//------------------------------------------------------------------------------
// Procedure: GetCDDBTrackTitle
// Arguments: iTrackNum: Integer; sDiscInfo: string
// Result:    string
// Comment:   Get track title
//------------------------------------------------------------------------------

function GetCDDBTrackTitle(iTrackNum: Integer; sDiscInfo: string): string;
var
  sTitleID: string;
  sTrackTitle: string;
  cCurrentChar: string;
  sEnter: string;
  iTitlePos: Integer;
begin
  sTrackTitle := '';
  sTitleID := 'TITLE' + IntToStr(iTrackNum - 1) + '=';
  iTitlePos := AnsiPos(sTitleID, sDiscInfo);
  SetLength(sEnter, 1);
  sEnter[1] := #13;
  if iTitlePos <> 0 then
  begin
    iTitlePos := iTitlePos + Length(sTitleID);
    cCurrentChar := Copy(sDiscInfo, iTitlePos, 1);

    while cCurrentChar <> sEnter do
    begin
      sTrackTitle := sTrackTitle + cCurrentChar;
      iTitlePos := iTitlePos + 1;
      cCurrentChar := Copy(sDiscInfo, iTitlePos, 1);
    end;
  end;
  Result := sTrackTitle;
end;

////////////////////////////////////////////////////////////////////////////////
// TQueryThread Implementation (CDDB Query Thread)

procedure TQueryThread.Execute;
begin
  // Set connection parameters
  with CDDBConnection do
  begin
    CDDBSetOption(CDDB_OPT_SERVER, PChar(Server), 0);
    CDDBSetOption(CDDB_OPT_HTTPPORT, '', 80);
    CDDBSetOption(CDDB_OPT_CGI, PChar(Script), 0);
    CDDBSetOption(CDDB_OPT_USER, DefaultCDDBUser, 0);
    CDDBSetOption(CDDB_OPT_AGENT, AppName + ' ' + AppVersion, 0);
    CDDBSetOption(CDDB_OPT_PROTOLEVEL, '', 5);
    CDDBSetOption(CDDB_OPT_USECDPLAYERINI, '', Integer(True));
    CDDBSetOption(CDDB_OPT_USEPROXY, '', Integer(Proxy));
    if Proxy then
    begin
      CDDBSetOption(CDDB_OPT_PROXY, PChar(Host), 0);
      CDDBSetOption(CDDB_OPT_PROXYPORT, '', Port);
      if Authorization and (Name <> '') and (Password <> '') then
        CDDBSetOption(CDDB_OPT_USERAUTH, PChar(Name + ':' + Password), 0)
      else
        CDDBSetOption(CDDB_OPT_USERAUTH, '', 0);
    end;
  end;

  // Set query parameters
  FillChar(QueryItem, SizeOf(TCDDBQUERYITEM), 0);
  FillChar(QueryItems, SizeOf(QueryItems), 0);
  CDQuery.num := QUERYITEM_MAX;
  CDQuery.q := @QueryItems;

  if Terminated then Exit;

  // Query CDDB
  if CDDBQuery(CDHandle, CDQuery) = SS_COMP then // Success
    if CDQuery.num > 0 then // Get result
    begin
      if CDQuery.num > 1 then // More than one, let user choose
      begin
        if Terminated then Exit;
        Synchronize(ShowMatchesForm); // Show selection dialog
        if not Selected then Exit;
      end
      else
        QueryItem := QueryItems[0];

      if Terminated then Exit;

      // Query disc information
      if CDDBGetDiskInfo(QueryItem, DiscInfo, 32000) = SS_COMP then // Success
      begin
        if Terminated then Exit;
        DiscTitle := FixDiscTitle(QueryItem.title);
        Artist := QueryItem.artist;
        Category := QueryItem.categ;
        Success := True;
      end;
    end;
end;

procedure TQueryThread.ShowMatchesForm;
var
  i: Integer;
begin
  with TfrmMatches.Create(Application) do
  try
    if Terminated then Exit;

    // List all disc items
    for i := 0 to CDQuery.num - 1 do
      with lvQueryItems.Items.Add do
      begin
        SubItems.Add(IntToStr(i + 1));
        SubItems.Add(FixDiscTitle(QueryItems[i].title));
        SubItems.Add(QueryItems[i].artist);
      end;
    lvQueryItems.Selected := lvQueryItems.Items[0];
    
    if ShowModal = mrOK then
    begin
      QueryItem := QueryItems[lvQueryItems.Selected.Index];
      Selected := True;
    end;
  finally
    Free;
  end;
end;

{ TfrmGetCDDB }

procedure TfrmGetCDDB.FormCreate(Sender: TObject);
begin
  UpdateLanguage;
  ActiveControl := lbTitles;
end;

procedure TfrmGetCDDB.QueryCDDB;
begin
  QueryThread := TQueryThread.Create(False);
  QueryThread.OnTerminate := ThreadDone;
end;

procedure TfrmGetCDDB.ThreadDone(Sender: TObject);
var
  I: Integer;
begin
  with (Sender as TQueryThread) do
    if Success then // Query successfully
    begin
      // Display cd information
      edtAlbum.Text := DiscTitle;
      edtArtist.Text := Artist;
      edtGenre.Text := Category;
      lbTitles.Items.Clear;
      for I := CDTOC.firstTrack to CDTOC.lastTrack do
        lbTitles.Items.Add(GetCDDBTrackTitle(I, DiscInfo));

      // Display message
      pnlMessage.Caption := CDDBMsgSuccess;

      // Enable save button
      btnOK.Enabled := True;
    end
    else
      pnlMessage.Caption := CDDBMsgFailed;

  // Update close button
  btnCancel.Caption := ButtonCloseCaption;
end;

procedure TfrmGetCDDB.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: if btnOK.Enabled then ModalResult := mrOk;
    VK_ESCAPE: ModalResult := mrCancel;
  end;
end;

procedure TfrmGetCDDB.FormDestroy(Sender: TObject);
begin
  if QueryThread <> nil then
  begin
    QueryThread.OnTerminate := nil;
    QueryThread.Terminate;
  end;
end;

procedure TfrmGetCDDB.UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    sfGetCDDB.Caption := ReadString('CDDBQuery', 'Title', sfGetCDDB.Caption);
    sfGetCDDB.TitleFont.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    sfGetCDDB.TitleFont.Size := ReadInteger('Font', 'TitleFontSize', 10);
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);

    pnlMessage.Font.Name := Font.Name;
    pnlMessage.Font.Size := Font.Size;

    btnOK.Caption := ReadString('CDDBQuery', 'Save', btnOK.Caption);
    btnCancel.Caption := ReadString('Button', 'Cancel', btnCancel.Caption);

    lblAlbum.Caption := ReadString('AudioInfo', 'Album', lblAlbum.Caption);
    lblArtist.Caption := ReadString('AudioInfo', 'Artist', lblArtist.Caption);
    lblGenre.Caption := ReadString('AudioInfo', 'Genre', lblGenre.Caption);
    lblTitles.Caption := ReadString('AudioInfo', 'TrackTitles', lblTitles.Caption);
  finally
    Free;
  end;
end;

end.

