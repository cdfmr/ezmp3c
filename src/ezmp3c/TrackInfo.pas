//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    TrackInfo.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Track Information Editor
//
// 2006-05-07
// - Initial release with comments
//------------------------------------------------------------------------------

unit TrackInfo;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, IniFiles,
  Messages, TFlatButtonUnit, TFlatComboBoxUnit, TFlatEditUnit, EZShapeForm,
  RipUnit;

type
  TfrmTrackInfo = class(TForm)
    sfTrackInfo: TEZShapeForm;
    lblAlbum: TLabel;
    lblArtist: TLabel;
    lblYear: TLabel;
    lblComment: TLabel;
    lblGenre: TLabel;
    lblTitle: TLabel;
    edtAlbum: TFlatEdit;
    edtArtist: TFlatEdit;
    edtYear: TFlatEdit;
    btnPrev: TFlatButton;
    btnOK: TFlatButton;
    btnCancel: TFlatButton;
    edtTitle: TFlatEdit;
    btnNext: TFlatButton;
    edtGenre: TFlatComboBox;
    edtComment: TFlatEdit;
    lblIndex: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure edtYearKeyPress(Sender: TObject; var Key: Char);
    procedure btnPrevClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lblIndexMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    procedure UpdateLanguage;
    { Private declarations }
  public
    Index: Integer;
    EditTrackInfos: array[0..99] of TTrackInfo; // All track info for editing
    procedure SetID3Infos;
    procedure GetID3Infos;
    procedure SetID3Info;
    procedure GetID3Info;
    procedure RefreshIndexLabel;
    { Public declarations }
  end;

implementation

uses Languages;

{$R *.DFM}

procedure TfrmTrackInfo.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  edtGenre.Items.Clear;
  for i := Low(ID3GenreList) to High(ID3GenreList) do
    edtGenre.Items.Add(ID3GenreList[i]);
  edtGenre.Sorted := True;
  UpdateLanguage;
end;

procedure TfrmTrackInfo.lblIndexMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  ReleaseCapture();
  SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
end;

procedure TfrmTrackInfo.edtYearKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #03, #08, #22, #24]) then
    Key := #0;
end;

procedure TfrmTrackInfo.GetID3Infos;
var
  i: Integer;
begin
  for i := Low(TrackInfos) to High(TrackInfos) do
    TrackInfos[i] := EditTrackInfos[i];
end;

procedure TfrmTrackInfo.SetID3Infos;
var
  i: Integer;
begin
  for i := Low(TrackInfos) to High(TrackInfos) do
    EditTrackInfos[i] := TrackInfos[i];
end;

procedure TfrmTrackInfo.GetID3Info;
begin
  with EditTrackInfos[Index] do
  begin
    Title := edtTitle.Text;
    Album := edtAlbum.Text;
    Artist := edtArtist.Text;
    Year := edtYear.Text;
    Genre := GetGenreIndex(edtGenre.Text);
    Comment := edtComment.Text;
  end;
end;

procedure TfrmTrackInfo.SetID3Info;
begin
  with EditTrackInfos[Index] do
  begin
    edtTitle.Text := Title;
    edtAlbum.Text := Album;
    edtArtist.Text := Artist;
    edtYear.Text := Year;
    if Genre <= 147 then
      edtGenre.Text := ID3GenreList[Genre]
    else
      edtGenre.Text := '';
    edtComment.Text := Comment;
  end;
end;

procedure TfrmTrackInfo.btnPrevClick(Sender: TObject);
begin
  if Index > CDTOC.firstTrack then
  begin
    GetID3Info;
    Dec(Index);
    SetID3Info;
    RefreshIndexLabel;
  end;
  edtTitle.SetFocus;
  edtTitle.SelectAll;
end;

procedure TfrmTrackInfo.btnNextClick(Sender: TObject);
begin
  if Index < CDTOC.lastTrack then
  begin
    GetID3Info;
    Inc(Index);
    SetID3Info;
    RefreshIndexLabel;
  end;
  edtTitle.SetFocus;
  edtTitle.SelectAll;
end;

procedure TfrmTrackInfo.RefreshIndexLabel;
begin
  lblIndex.Caption := Format('No. %.2d', [Index]);
end;

procedure TfrmTrackInfo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
const
  VK_J = $4A;
  VK_K = $4B;
begin
  case Key of
    VK_RETURN: ModalResult := mrOk;
    VK_ESCAPE: ModalResult := mrCancel;
    VK_PRIOR: btnPrevClick(Self);
    VK_NEXT: btnNextClick(Self);
    VK_J:
      if GetKeyState(VK_CONTROL) and $80000000 = $80000000 then
        btnPrevClick(Self);
    VK_K:
      if GetKeyState(VK_CONTROL) and $80000000 = $80000000 then
        btnNextClick(Self);
  end;
end;

procedure TfrmTrackInfo.UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    sfTrackInfo.Caption := ReadString('TrackInfo', 'Title', sfTrackInfo.Caption);
    sfTrackInfo.TitleFont.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    sfTrackInfo.TitleFont.Size := ReadInteger('Font', 'TitleFontSize', 10);
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);

    btnOK.Caption := ReadString('Button', 'OK', btnOK.Caption);
    btnCancel.Caption := ReadString('Button', 'Cancel', btnCancel.Caption);

    lblTitle.Caption := ReadString('AudioInfo', 'Title', lblTitle.Caption);
    lblArtist.Caption := ReadString('AudioInfo', 'Artist', lblArtist.Caption);
    lblAlbum.Caption := ReadString('AudioInfo', 'Album', lblAlbum.Caption);
    lblYear.Caption := ReadString('AudioInfo', 'Year', lblYear.Caption);
    lblGenre.Caption := ReadString('AudioInfo', 'Genre', lblGenre.Caption);
    lblComment.Caption := ReadString('AudioInfo', 'Comment', lblComment.Caption);
  finally
    Free;
  end;
end;

end.

