object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 469
  ClientWidth = 838
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 838
    Height = 428
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel1'
    TabOrder = 0
    object Splitter1: TSplitter
      Left = 401
      Top = 0
      Height = 428
      ExplicitLeft = 440
      ExplicitTop = 128
      ExplicitHeight = 100
    end
    object DBMemo1: TDBMemo
      Left = 404
      Top = 0
      Width = 434
      Height = 428
      Align = alClient
      DataField = 'Def'
      DataSource = DM.dsObjectDefsQuery
      ScrollBars = ssBoth
      TabOrder = 0
    end
    object cxGrid1: TcxGrid
      Left = 0
      Top = 0
      Width = 401
      Height = 428
      Align = alLeft
      TabOrder = 1
      object cxGrid1DBTableView1: TcxGridDBTableView
        Navigator.Buttons.CustomButtons = <>
        DataController.DataSource = DM.dsObjectDefsQuery
        DataController.Summary.DefaultGroupSummaryItems = <>
        DataController.Summary.FooterSummaryItems = <>
        DataController.Summary.SummaryGroups = <>
        OptionsBehavior.ImmediateEditor = False
        OptionsView.ColumnAutoWidth = True
        object cxGrid1DBTableView1Id: TcxGridDBColumn
          DataBinding.FieldName = 'Id'
          Width = 43
        end
        object cxGrid1DBTableView1ObjectType: TcxGridDBColumn
          DataBinding.FieldName = 'ObjectType'
          Width = 92
        end
        object cxGrid1DBTableView1ObjectName: TcxGridDBColumn
          DataBinding.FieldName = 'ObjectName'
          Width = 134
        end
      end
      object cxGrid1Level1: TcxGridLevel
        GridView = cxGrid1DBTableView1
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 428
    Width = 838
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object Button1: TButton
      Left = 0
      Top = 6
      Width = 129
      Height = 25
      Caption = 'Replace in Database'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 161
      Top = 6
      Width = 129
      Height = 25
      Caption = 'Get Object Definitions'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 296
      Top = 8
      Width = 129
      Height = 25
      Caption = 'Replace in Delphi'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
end
