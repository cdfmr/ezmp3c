//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    Matches.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: Disc Information Selection
//
// 2006-05-07
// - Initial release with comments 
//------------------------------------------------------------------------------

unit Matches;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  ComCtrls, TFlatButtonUnit, IniFiles, EZShapeForm;

type
  TfrmMatches = class(TForm)
    sfMatches: TEZShapeForm;
    Shape1: TShape;
    lblHint: TLabel;
    lvQueryItems: TListView;
    btnOK: TFlatButton;
    btnCancel: TFlatButton;
    procedure FormCreate(Sender: TObject);
    procedure lvQueryItemsDblClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure UpdateLanguage;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Languages;

{$R *.DFM}

procedure TfrmMatches.FormCreate(Sender: TObject);
begin
  UpdateLanguage;
end;

procedure TfrmMatches.lvQueryItemsDblClick(Sender: TObject);
begin
  if lvQueryItems.Selected <> nil then
    ModalResult := mrOK;
end;

procedure TfrmMatches.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: ModalResult := mrOk;
    VK_ESCAPE: ModalResult := mrCancel;
  end; 
end;

procedure TfrmMatches.UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    sfMatches.Caption := ReadString('CDDBMatch', 'Title', sfMatches.Caption);
    sfMatches.TitleFont.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    sfMatches.TitleFont.Size := ReadInteger('Font', 'TitleFontSize', 10);
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);

    btnOK.Caption := ReadString('Button', 'OK', btnOK.Caption);
    btnCancel.Caption := ReadString('Button', 'Cancel', btnCancel.Caption);

    lblHint.Caption := ReadString('CDDBMatch', 'Hint', lblHint.Caption);
    lvQueryItems.Columns[2].Caption := ReadString('CDDBMatch', 'DiscTitle', lvQueryItems.Columns[2].Caption);
    lvQueryItems.Columns[3].Caption := ReadString('CDDBMatch', 'Artist', lvQueryItems.Columns[3].Caption);
  finally
    Free;
  end;
end;

end.

