object frmGetCDDB: TfrmGetCDDB
  Left = 186
  Top = 150
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  ClientHeight = 289
  ClientWidth = 358
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
  OnDestroy = FormDestroy
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object sfGetCDDB: TEZShapeForm
    Left = 0
    Top = 0
    Width = 358
    Height = 289
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    Caption = 'CDDB Information'
    object Shape1: TShape
      Left = 11
      Top = 28
      Width = 337
      Height = 25
      Pen.Color = 8623776
    end
    object lblAlbum: TLabel
      Left = 12
      Top = 64
      Width = 33
      Height = 13
      Caption = 'Al&bum:'
      FocusControl = edtAlbum
    end
    object lblArtist: TLabel
      Left = 12
      Top = 91
      Width = 30
      Height = 13
      Caption = '&Artist:'
      FocusControl = edtArtist
    end
    object lblTitles: TLabel
      Left = 12
      Top = 145
      Width = 29
      Height = 13
      Caption = '&Titles:'
      FocusControl = lbTitles
    end
    object lblGenre: TLabel
      Left = 12
      Top = 118
      Width = 33
      Height = 13
      Caption = '&Genre:'
      FocusControl = edtGenre
    end
    object edtAlbum: TFlatEdit
      Left = 64
      Top = 61
      Width = 284
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      ReadOnly = True
      TabOrder = 1
    end
    object pnlMessage: TPanel
      Left = 12
      Top = 29
      Width = 335
      Height = 23
      BevelOuter = bvNone
      Color = 10280695
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlue
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object edtArtist: TFlatEdit
      Left = 64
      Top = 88
      Width = 284
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      ReadOnly = True
      TabOrder = 2
    end
    object edtGenre: TFlatEdit
      Left = 64
      Top = 115
      Width = 284
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      ReadOnly = True
      TabOrder = 3
    end
    object lbTitles: TFlatListBox
      Left = 64
      Top = 142
      Width = 284
      Height = 100
      ScrollBars = True
      ColorItemsRect = clWindow
    end
    object btnOK: TFlatButton
      Left = 190
      Top = 252
      Width = 75
      Height = 25
      Caption = 'Save'
      Enabled = False
      ModalResult = 1
      TabOrder = 5
    end
    object btnCancel: TFlatButton
      Left = 273
      Top = 252
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 6
    end
  end
end
