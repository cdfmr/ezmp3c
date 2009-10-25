//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    Log.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Processing Log
//
// 2006-05-07
// - Initial release with comments
//------------------------------------------------------------------------------

unit Log;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  IniFiles, ShellApi, TFlatMemoUnit, TFlatButtonUnit, EZShapeForm;

type
  TfrmLog = class(TForm)
    sfLog: TEZShapeForm;
    dlgSave: TSaveDialog;
    fmLog: TFlatMemo;
    btnBrowse: TFlatButton;
    btnList: TFlatButton;
    btnClose: TFlatButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnBrowseClick(Sender: TObject);
    procedure btnListClick(Sender: TObject);
  private
    procedure UpdateLanguage;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses RipUnit, Languages, Routine;

{$R *.DFM}

procedure TfrmLog.FormCreate(Sender: TObject);
begin
  UpdateLanguage;
  btnList.Visible := not SomethingFailed;
end;

procedure TfrmLog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN, VK_ESCAPE: ModalResult := mrOk;
  end;
end;

procedure TfrmLog.btnBrowseClick(Sender: TObject);
begin
  ShellExecute(Handle, 'explore', PChar(ExtractFileDir(Playlist[2])), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TfrmLog.btnListClick(Sender: TObject);
begin
  dlgSave.InitialDir := OutputFolder;
  dlgSave.Filter := PlaylistFilter;
  if dlgSave.Execute then
  try
    Playlist.SaveToFile(dlgSave.FileName);
  except
    MsgDlg(PlaylistFailed, MB_OK or MB_ICONWARNING);
  end;
end;

procedure TfrmLog.UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    sfLog.Caption := ReadString('Log', 'Title', sfLog.Caption);
    sfLog.TitleFont.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    sfLog.TitleFont.Size := ReadInteger('Font', 'TitleFontSize', 10);
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);

    btnClose.Caption := ButtonCloseCaption;
    btnBrowse.Caption := ReadString('Log', 'OpenOutputFolder', btnBrowse.Caption);
    btnList.Caption := ReadString('Log', 'CreatePlaylist', btnList.Caption);
  finally
    Free;
  end;
end;

end.

