//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    About.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: About Dialog
//
// 2006-05-06
// - Initial release with comments 
//------------------------------------------------------------------------------

unit About;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, ExtCtrls,
  TFlatButtonUnit, ShellAPI, IniFiles, EZShapeForm, DateUtils;

type
  TfrmAbout = class(TForm)
    sfAbout: TEZShapeForm;
    Image1: TImage;
    lblVersion: TLabel;
    lblRegTo: TLabel;
    lblName: TLabel;
    lblHomePage: TLabel;
    lblHomePageURL: TLabel;
    lblSupport: TLabel;
    lblSupportURL: TLabel;
    lblCopyright: TLabel;
    lblTranslator: TLabel;
    btnOK: TFlatButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure LinkLabelClick(Sender: TObject);
    procedure LinkLabelMouseEnter(Sender: TObject);
    procedure LinkLabelMouseLeave(Sender: TObject);
  private
    procedure UpdateLanguage;
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

uses Languages, CFGParam;

{$R *.DFM}

procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  UpdateLanguage;
  lblVersion.Caption := Format('Version %s, Build %s', [AppVersion, AppBuild]);
  lblCopyright.Caption :=
    Format('Copyright (C) 2003-%d, Linasoft', [YearOf(Now)]);
  lblHomePageURL.Caption := HomePage;
  lblSupportURL.Caption := SupportURL;
  lblName.Caption := FullVersion;
end;

procedure TfrmAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN, VK_ESCAPE: ModalResult := mrOk;
  end;
end;

procedure TfrmAbout.LinkLabelMouseEnter(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := [fsUnderline];
end;

procedure TfrmAbout.LinkLabelMouseLeave(Sender: TObject);
begin
  (Sender as TLabel).Font.Style := [];
end;

procedure TfrmAbout.LinkLabelClick(Sender: TObject);
begin
  ShellExecute(Handle, 'open', PChar((Sender as TLabel).Caption), nil, nil,
    SW_SHOWNORMAL);
end;

procedure TfrmAbout.UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    sfAbout.Caption := ReadString('About', 'Title', sfAbout.Caption);
    sfAbout.TitleFont.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    sfAbout.TitleFont.Size := ReadInteger('Font', 'TitleFontSize', 10);
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);
    lblHomePageURL.Font.Name := Font.Name;
    lblHomePageURL.Font.Size := Font.Size;
    lblSupportURL.Font.Name := Font.Name;
    lblSupportURL.Font.Size := Font.Size;
    lblName.Font.Name := Font.Name;
    lblName.Font.Size := Font.Size;

    btnOK.Caption := ReadString('Button', 'OK', btnOK.Caption);

    lblTranslator.Caption := ReadString('About', 'Translator', 'Language File: ' + ExtractFileName(LangFile));
    lblHomePage.Caption := ReadString('About', 'HomePage', lblHomePage.Caption);
    lblSupport.Caption := ReadString('About', 'Support', lblSupport.Caption);
    lblRegTo.Caption := ReadString('About', 'RegisterTo', lblRegTo.Caption);
    lblName.Caption := ReadString('About', 'Unregistered', lblName.Caption);
  finally
    Free;
  end;
end;

end.

