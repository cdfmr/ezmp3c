object frmCDDBConfig: TfrmCDDBConfig
  Left = 254
  Top = 169
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  ClientHeight = 255
  ClientWidth = 332
  Color = 12965593
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clBlack
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  KeyPreview = True
  OldCreateOrder = True
  Position = poScreenCenter
  Scaled = False
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object sfCDDBCfg: TEZShapeForm
    Left = 0
    Top = 0
    Width = 332
    Height = 255
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    Caption = 'CDDB Connection'
    object lblServer: TLabel
      Left = 12
      Top = 33
      Width = 36
      Height = 13
      Caption = '&Server:'
      FocusControl = edtServer
    end
    object lblScript: TLabel
      Left = 12
      Top = 61
      Width = 64
      Height = 13
      Caption = '&Query Script:'
      FocusControl = edtScript
    end
    object lblHost: TLabel
      Left = 27
      Top = 117
      Width = 26
      Height = 13
      Caption = '&Host:'
      FocusControl = edtHost
    end
    object lblPort: TLabel
      Left = 27
      Top = 144
      Width = 24
      Height = 13
      Caption = 'P&ort:'
      FocusControl = edtPort
    end
    object lblName: TLabel
      Left = 39
      Top = 200
      Width = 31
      Height = 13
      Caption = '&Name:'
      FocusControl = edtName
    end
    object lblPassword: TLabel
      Left = 39
      Top = 227
      Width = 50
      Height = 13
      Caption = 'Pass&word:'
      FocusControl = edtPassword
    end
    object btnOK: TFlatButton
      Left = 246
      Top = 29
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 8
    end
    object btnCancel: TFlatButton
      Left = 246
      Top = 62
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 9
    end
    object edtScript: TFlatEdit
      Left = 96
      Top = 58
      Width = 140
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 1
    end
    object edtServer: TFlatComboBox
      Left = 96
      Top = 29
      Width = 140
      Height = 21
      Color = clWindow
      ItemHeight = 13
      Items.Strings = (
        'freedb.freedb.org'
        'freedb.freedb.de'
        'at.freedb.org'
        'au.freedb.org'
        'bg.freedb.org'
        'ca.freedb.org'
        'de.freedb.org'
        'es.freedb.org'
        'fr.freedb.org'
        'lu.freedb.org'
        'no.freedb.org'
        'uk.freedb.org'
        'us.freedb.org')
      TabOrder = 0
      ItemIndex = -1
    end
    object edtPort: TFlatEdit
      Left = 96
      Top = 141
      Width = 140
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      MaxLength = 5
      TabOrder = 4
      OnKeyPress = edtPortKeyPress
    end
    object edtHost: TFlatEdit
      Left = 96
      Top = 114
      Width = 140
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 3
    end
    object edtPassword: TFlatEdit
      Left = 96
      Top = 224
      Width = 140
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      PasswordChar = '*'
      TabOrder = 7
    end
    object edtName: TFlatEdit
      Left = 96
      Top = 197
      Width = 140
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 6
    end
    object chkProxy: TFlatCheckBox
      Left = 11
      Top = 89
      Width = 222
      Height = 17
      Caption = 'Enable &Proxy'
      TabOrder = 2
      TabStop = True
      OnClick = UpdateControlState
    end
    object chkAuthorization: TFlatCheckBox
      Left = 23
      Top = 172
      Width = 210
      Height = 17
      Caption = '&Authorization'
      TabOrder = 5
      TabStop = True
      OnClick = UpdateControlState
    end
  end
end
