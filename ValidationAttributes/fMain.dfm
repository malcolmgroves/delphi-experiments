object Form7: TForm7
  Left = 0
  Top = 0
  Caption = 'Form7'
  ClientHeight = 343
  ClientWidth = 325
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    325
    343)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 24
    Width = 27
    Height = 13
    Caption = 'Name'
  end
  object Label2: TLabel
    Left = 24
    Top = 53
    Width = 19
    Height = 13
    Caption = 'Age'
  end
  object Edit1: TEdit
    Left = 57
    Top = 21
    Width = 170
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = 'Edit1'
  end
  object Button1: TButton
    Left = 233
    Top = 48
    Width = 75
    Height = 25
    Anchors = [akTop, akRight]
    Caption = 'Set Values'
    TabOrder = 2
    OnClick = Button1Click
  end
  object ListBox1: TListBox
    Left = 24
    Top = 96
    Width = 284
    Height = 231
    Anchors = [akLeft, akTop, akRight, akBottom]
    ItemHeight = 13
    TabOrder = 3
  end
  object SpinEdit1: TSpinEdit
    Left = 57
    Top = 50
    Width = 170
    Height = 22
    Anchors = [akLeft, akTop, akRight]
    MaxValue = 0
    MinValue = 0
    TabOrder = 1
    Value = 0
  end
end
