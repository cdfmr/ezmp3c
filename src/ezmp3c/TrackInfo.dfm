object frmTrackInfo: TfrmTrackInfo
  Left = 278
  Top = 168
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  ClientHeight = 201
  ClientWidth = 355
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
  object sfTrackInfo: TEZShapeForm
    Left = 0
    Top = 0
    Width = 355
    Height = 201
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    Caption = 'Track Information'
    object lblAlbum: TLabel
      Left = 12
      Top = 85
      Width = 33
      Height = 13
      Caption = 'Al&bum:'
    end
    object lblArtist: TLabel
      Left = 12
      Top = 58
      Width = 30
      Height = 13
      Caption = '&Artist:'
    end
    object lblYear: TLabel
      Left = 12
      Top = 112
      Width = 26
      Height = 13
      Caption = '&Year:'
    end
    object lblComment: TLabel
      Left = 12
      Top = 139
      Width = 49
      Height = 13
      Caption = '&Comment:'
    end
    object lblGenre: TLabel
      Left = 128
      Top = 112
      Width = 33
      Height = 13
      Caption = '&Genre:'
    end
    object lblTitle: TLabel
      Left = 12
      Top = 31
      Width = 24
      Height = 13
      Caption = '&Title:'
    end
    object lblIndex: TLabel
      Left = 238
      Top = 3
      Width = 20
      Height = 16
      Caption = 'No.'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWhite
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
      Transparent = True
      OnMouseDown = lblIndexMouseDown
    end
    object edtAlbum: TFlatEdit
      Left = 64
      Top = 82
      Width = 281
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 2
    end
    object edtArtist: TFlatEdit
      Left = 64
      Top = 55
      Width = 281
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 1
    end
    object edtYear: TFlatEdit
      Left = 64
      Top = 109
      Width = 49
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      MaxLength = 4
      TabOrder = 3
      OnKeyPress = edtYearKeyPress
    end
    object btnPrev: TFlatButton
      Left = 64
      Top = 164
      Width = 41
      Height = 25
      Hint = 'Page Up / Ctrl + J'
      Caption = '<<'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 6
      OnClick = btnPrevClick
    end
    object btnOK: TFlatButton
      Left = 187
      Top = 164
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 8
    end
    object btnCancel: TFlatButton
      Left = 270
      Top = 164
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 9
    end
    object edtTitle: TFlatEdit
      Left = 64
      Top = 28
      Width = 281
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 0
    end
    object btnNext: TFlatButton
      Left = 113
      Top = 164
      Width = 41
      Height = 25
      Hint = 'Page Down / Ctrl + K'
      Caption = '>>'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 7
      OnClick = btnNextClick
    end
    object edtGenre: TFlatComboBox
      Left = 168
      Top = 108
      Width = 177
      Height = 21
      Color = clWindow
      ItemHeight = 13
      TabOrder = 4
      ItemIndex = -1
    end
    object edtComment: TFlatEdit
      Left = 64
      Top = 136
      Width = 281
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 5
    end
  end
end
