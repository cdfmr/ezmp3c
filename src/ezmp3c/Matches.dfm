object frmMatches: TfrmMatches
  Left = 326
  Top = 222
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsNone
  ClientHeight = 252
  ClientWidth = 363
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
  object sfMatches: TEZShapeForm
    Left = 0
    Top = 0
    Width = 363
    Height = 252
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWhite
    TitleFont.Height = -13
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = [fsBold]
    Caption = 'Disc Matches'
    object Shape1: TShape
      Left = 11
      Top = 64
      Width = 342
      Height = 142
      Pen.Color = 8623776
    end
    object lblHint: TLabel
      Left = 12
      Top = 28
      Width = 340
      Height = 35
      AutoSize = False
      Caption = 
        'More than one potential matches have been found in database, ple' +
        'ase choose the correct one.'
      WordWrap = True
    end
    object lvQueryItems: TListView
      Left = 12
      Top = 65
      Width = 340
      Height = 140
      BorderStyle = bsNone
      Checkboxes = True
      Columns = <
        item
          Width = 0
        end
        item
          Alignment = taCenter
          Caption = 'No.'
          Width = 32
        end
        item
          Alignment = taCenter
          Caption = 'Disc Title'
          Width = 160
        end
        item
          Alignment = taCenter
          Caption = 'Artist'
          Width = 128
        end>
      ColumnClick = False
      FlatScrollBars = True
      HideSelection = False
      ReadOnly = True
      RowSelect = True
      TabOrder = 0
      ViewStyle = vsReport
      OnDblClick = lvQueryItemsDblClick
    end
    object btnOK: TFlatButton
      Left = 195
      Top = 215
      Width = 75
      Height = 25
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 1
    end
    object btnCancel: TFlatButton
      Left = 278
      Top = 215
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 2
    end
  end
end
