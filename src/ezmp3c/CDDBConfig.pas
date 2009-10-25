//------------------------------------------------------------------------------
// Project: EZ MP3 Creator
// Unit:    CDDBConfig.pas
// Author:  Lin Fan
// Email:   cnlinfan@gmail.com
// Comment: CDDB Configuration
//
// 2006-05-06
// - Initial release with comments
//------------------------------------------------------------------------------

unit CDDBConfig;

interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, StdCtrls, IniFiles,
  TFlatButtonUnit, TFlatComboBoxUnit, TFlatEditUnit, TFlatCheckBoxUnit,
  EZShapeForm, RipUnit;

type
  TfrmCDDBConfig = class(TForm)
    sfCDDBCfg: TEZShapeForm;
    lblServer: TLabel;
    lblScript: TLabel;
    lblHost: TLabel;
    lblPort: TLabel;
    lblName: TLabel;
    lblPassword: TLabel;
    btnOK: TFlatButton;
    btnCancel: TFlatButton;
    edtScript: TFlatEdit;
    edtServer: TFlatComboBox;
    edtPort: TFlatEdit;
    edtHost: TFlatEdit;
    edtPassword: TFlatEdit;
    edtName: TFlatEdit;
    chkProxy: TFlatCheckBox;
    chkAuthorization: TFlatCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure UpdateControlState(Sender: TObject);
    procedure edtPortKeyPress(Sender: TObject; var Key: Char);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    procedure UpdateLanguage;
    { Private declarations }
  public
    function GetCDDB: TCDDBConnection;
    procedure SetCDDB(CDDBConnection: TCDDBConnection);
    { Public declarations }
  end;

implementation

uses Languages;

{$R *.DFM}

procedure TfrmCDDBConfig.FormCreate(Sender: TObject);
begin
  UpdateLanguage;
end;

procedure TfrmCDDBConfig.UpdateControlState(Sender: TObject);
begin
  lblHost.Enabled := chkProxy.Checked;
  lblPort.Enabled := chkProxy.Checked;
  edtHost.Enabled := chkProxy.Checked;
  edtPort.Enabled := chkProxy.Checked;
  chkAuthorization.Enabled := chkProxy.Checked;
  lblName.Enabled := chkProxy.Checked and chkAuthorization.Checked;
  lblPassword.Enabled := chkProxy.Checked and chkAuthorization.Checked;
  edtName.Enabled := chkProxy.Checked and chkAuthorization.Checked;
  edtPassword.Enabled := chkProxy.Checked and chkAuthorization.Checked;
end;

procedure TfrmCDDBConfig.edtPortKeyPress(Sender: TObject; var Key: Char);
begin
  if not (Key in ['0'..'9', #3, #22, #24]) then
    Key := #0;
end;

function TfrmCDDBConfig.GetCDDB: TCDDBConnection;
begin
  with Result do
  begin
    Server := edtServer.Text;
    Script := edtScript.Text;
    Proxy := chkProxy.Checked;
    Host := edtHost.Text;
    try
      Port := StrToInt(edtPort.Text);
    except
      Port := 80;
    end;
    Authorization := chkAuthorization.Checked;
    Name := edtName.Text;
    Password := edtPassword.Text;
  end;
end;

procedure TfrmCDDBConfig.SetCDDB(CDDBConnection: TCDDBConnection);
begin
  with CDDBConnection do
  begin
    edtServer.Text := Server;
    edtScript.Text := Script;
    chkProxy.Checked := Proxy;
    edtHost.Text := Host;
    edtPort.Text := IntToStr(Port);
    chkAuthorization.Checked := Authorization;
    edtName.Text := Name;
    edtPassword.Text := Password;
  end;
  UpdateControlState(Self);
end;

procedure TfrmCDDBConfig.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    VK_RETURN: ModalResult := mrOk;
    VK_ESCAPE: ModalResult := mrCancel;
  end;
end;

procedure TfrmCDDBConfig.UpdateLanguage;
begin
  if not FileExists(LangFile) then Exit;
  with TIniFile.Create(LangFile) do
  try
    sfCDDBCfg.Caption := ReadString('CDDBConfig', 'Title', sfCDDBCfg.Caption);
    sfCDDBCfg.TitleFont.Name := ReadString('Font', 'TitleFontName', 'Tahoma');
    sfCDDBCfg.TitleFont.Size := ReadInteger('Font', 'TitleFontSize', 10);
    Font.Name := ReadString('Font', 'FontName', 'Tahoma');
    Font.Size := ReadInteger('Font', 'FontSize', 8);

    btnOK.Caption := ReadString('Button', 'OK', btnOK.Caption);
    btnCancel.Caption := ReadString('Button', 'Cancel', btnCancel.Caption);

    lblServer.Caption := ReadString('CDDBConfig', 'Server', lblServer.Caption);
    lblScript.Caption := ReadString('CDDBConfig', 'Script', lblScript.Caption);
    chkProxy.Caption := ReadString('CDDBConfig', 'Proxy', chkProxy.Caption);
    lblHost.Caption := ReadString('CDDBConfig', 'Host', lblHost.Caption);
    lblPort.Caption := ReadString('CDDBConfig', 'Port', lblPort.Caption );
    chkAuthorization.Caption := ReadString('CDDBConfig', 'Authorization', chkAuthorization.Caption);
    lblName.Caption := ReadString('CDDBConfig', 'Name', lblName.Caption);
    lblPassword.Caption := ReadString('CDDBConfig', 'Password', lblPassword.Caption);
  finally
    Free;
  end;
end;

end.

