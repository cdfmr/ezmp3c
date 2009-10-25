//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    DiscInfo.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Disc Information Editor
//
// 2006-05-06
// - Initial release with comments 
//------------------------------------------------------------------------------

unit DiscInfo;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, IniFiles,
  TFlatEditUnit, TFlatComboBoxUnit, TFlatButtonUnit, EZShapeForm, RipUnit;

type
  TfrmDiscInfo = class(TForm)
    sfDiscInfo: TEZShapeForm;
    lblAlbum: TLabel;
    lblArtist: TLabel;
    lblYear: TLabel;
    lblComment: TLabel;
    lblGenre: TLabel;
    edtAlbum: TFlatEdit;
    edtArtist: TFlatEdit;
    edtYear: TFlatEdit;
    edtGenre: TFlatComboBox;
    btnOK: TFlatButton;
    btnCancel: TFlatButton;
    edtComment: TFlatEdit;
    procedure FormCreate(Sender: TObject);
    procedure edtYearKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure UpdateLanguage;
    { Private declarations }
  public
    procedure SetCDInfo(CDInfo: TTrackInfo);
    function GetCDInfo: TTrackInfo;
    procedure CopyToAllTracks;
    { Public declarations }
  end;

implementation

uses Languages;

{$R *.DFM}

procedure TfrmDiscInfo.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  edtGenre.Items.Clear;
  for I := Low(ID3GenreList) to High(ID3GenreList) do
    edtGenre.Items.Add(ID3GenreList[I]);
  edtGenre.Sorted := True;
  UpdateLanguage;
end;

procedure TfrmDiscInfo.edtYearKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #03, #08, #22, #24]) then
    Key := #0;
end;

procedure TfrmDiscInfo.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: ModalResult := mrOk;
    VK_ESCAPE: ModalResult := mrCancel;
  end;  
end;

function TfrmDiscInfo.GetCDInfo: TTrackInfo;
begin
  with Result do
  begin
    Album := edtAlbum.Text;
    Artist := edtArtist.Text;
    Year := edtYear.Text;
    Genre := GetGenreIndex(edtGenre.Text);
    Comment := edtComment.Text;
  end;
end;

procedure TfrmDiscInfo.SetCDInfo(CDInfo: TTrackInfo);
begin
  with CDInfo do
  begin
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

procedure TfrmDiscInfo.CopyToAllTracks;
var
  I: Integer;
  TempInfo: TTrackInfo;
begin
  TempInfo := GetCDInfo;
  for I := Low(TrackInfos) to High(TrackInfos) do
  begin
    TempInfo.Title := TrackInfos[I].Title;
    TempInfo.TimeF := TrackInfos[I].TimeF;
    TempInfo.TimeM := TrackInfos[I].TimeM;
    TempInfo.TimeS := TrackInfos[I].TimeS;
    TempInfo.Size := TrackInfos[I].Size;
    TrackInfos[I] := TempInfo;
  end;
end;

procedure TfrmDiscInfo.UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    sfDiscInfo.Caption := ReadString('DiscInfo', 'Title', sfDiscInfo.Caption);
    sfDiscInfo.TitleFont.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    sfDiscInfo.TitleFont.Size := ReadInteger('Font', 'TitleFontSize', 10);
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);

    btnOK.Caption := ReadString('Button', 'OK', btnOK.Caption);
    btnCancel.Caption := ReadString('Button', 'Cancel', btnCancel.Caption);

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

