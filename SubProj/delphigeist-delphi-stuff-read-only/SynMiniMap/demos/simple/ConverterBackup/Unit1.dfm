object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 558
  ClientWidth = 816
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object SynMiniMap1: TSynMiniMap
    Left = 0
    Top = 0
    Width = 200
    Height = 558
    Colors.Background = clWhite
    Colors.Highlight = 16053492
    Colors.PreviousLine = clNone
    Colors.PreviousLineText = clNone
    Colors.Text = clGray
    Colors.TextHighlight = clGray
    FontFactor = 3.000000000000000000
    PixelFormat = pf32bit
    Align = alLeft
    ExplicitLeft = 320
    ExplicitTop = 96
    ExplicitHeight = 400
  end
  object PageControl1: TPageControl
    Left = 200
    Top = 0
    Width = 616
    Height = 558
    Align = alClient
    TabOrder = 1
    ExplicitLeft = 272
    ExplicitTop = 200
    ExplicitWidth = 289
    ExplicitHeight = 193
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    Left = 440
    Top = 448
    object File1: TMenuItem
      Caption = 'File'
      object Open1: TMenuItem
        Caption = 'Open'
        OnClick = Open1Click
      end
    end
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = '*.*'
    Filter = 'Any file|*.*'
    Options = [ofHideReadOnly, ofAllowMultiSelect, ofEnableSizing]
    Left = 352
    Top = 456
  end
  object SynPasSyn1: TSynPasSyn
    KeyAttri.Foreground = clMaroon
    Left = 512
    Top = 448
  end
end
