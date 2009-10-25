object frmLog: TfrmLog
  Left = 186
  Top = 150
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  ClientHeight = 277
  ClientWidth = 263
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
  object sfLog: TEZShapeForm
    Left = 0
    Top = 0
    Width = 263
    Height = 277
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    Caption = 'Log'
    object fmLog: TFlatMemo
      Left = 11
      Top = 28
      Width = 241
      Height = 205
      ColorFocused = clWindow
      ColorFlat = clWindow
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object btnBrowse: TFlatButton
      Left = 11
      Top = 240
      Width = 75
      Height = 25
      Caption = '&Browse'
      TabOrder = 1
      OnClick = btnBrowseClick
    end
    object btnList: TFlatButton
      Left = 94
      Top = 240
      Width = 75
      Height = 25
      Caption = '&Playlist'
      TabOrder = 2
      OnClick = btnListClick
    end
    object btnClose: TFlatButton
      Left = 177
      Top = 240
      Width = 75
      Height = 25
      Caption = 'Close'
      ModalResult = 1
      TabOrder = 3
    end
  end
  object dlgSave: TSaveDialog
    DefaultExt = 'm3u'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofPathMustExist, ofEnableSizing]
    Left = 117
    Top = 124
  end
end
