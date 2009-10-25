object frmDiscInfo: TfrmDiscInfo
  Left = 274
  Top = 88
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  ClientHeight = 174
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
  object sfDiscInfo: TEZShapeForm
    Left = 0
    Top = 0
    Width = 355
    Height = 174
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    Caption = 'Disc Information'
    object lblAlbum: TLabel
      Left = 12
      Top = 58
      Width = 33
      Height = 13
      Caption = 'Al&bum:'
      FocusControl = edtAlbum
    end
    object lblArtist: TLabel
      Left = 12
      Top = 31
      Width = 30
      Height = 13
      Caption = '&Artist:'
      FocusControl = edtArtist
    end
    object lblYear: TLabel
      Left = 12
      Top = 85
      Width = 26
      Height = 13
      Caption = '&Year:'
      FocusControl = edtYear
    end
    object lblComment: TLabel
      Left = 12
      Top = 112
      Width = 49
      Height = 13
      Caption = '&Comment:'
      FocusControl = edtComment
    end
    object lblGenre: TLabel
      Left = 128
      Top = 85
      Width = 33
      Height = 13
      Caption = '&Genre:'
      FocusControl = edtGenre
    end
    object edtAlbum: TFlatEdit
      Left = 64
      Top = 55
      Width = 281
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 1
    end
    object edtArtist: TFlatEdit
      Left = 64
      Top = 28
      Width = 281
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 0
    end
    object edtYear: TFlatEdit
      Left = 64
      Top = 82
      Width = 49
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      MaxLength = 4
      TabOrder = 2
      OnKeyPress = edtYearKeyPress
    end
    object edtGenre: TFlatComboBox
      Left = 168
      Top = 81
      Width = 177
      Height = 21
      Color = clWindow
      ItemHeight = 13
      TabOrder = 3
      ItemIndex = -1
    end
    object btnOK: TFlatButton
      Left = 187
      Top = 137
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 5
    end
    object btnCancel: TFlatButton
      Left = 270
      Top = 137
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 6
    end
    object edtComment: TFlatEdit
      Left = 64
      Top = 109
      Width = 281
      Height = 19
      ColorFocused = clWindow
      ColorFlat = clWindow
      TabOrder = 4
    end
  end
end
