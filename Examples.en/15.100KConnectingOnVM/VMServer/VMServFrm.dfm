object VMServForm: TVMServForm
  Left = 0
  Top = 0
  Caption = 'VM built in server'
  ClientHeight = 412
  ClientWidth = 1387
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 1387
    Height = 412
    Align = alClient
    TabOrder = 0
    object StateMemo: TMemo
      Left = 493
      Top = 1
      Width = 287
      Height = 410
      Align = alRight
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'StateMemo')
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 0
      WordWrap = False
    end
    object ReceiveMemo: TMemo
      Left = 780
      Top = 1
      Width = 202
      Height = 410
      Align = alRight
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'StateMemo')
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 1
      WordWrap = False
    end
    object SendMemo: TMemo
      Left = 982
      Top = 1
      Width = 202
      Height = 410
      Align = alRight
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'StateMemo')
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 2
      WordWrap = False
    end
    object CpuMemo: TMemo
      Left = 1184
      Top = 1
      Width = 202
      Height = 410
      Align = alRight
      DoubleBuffered = True
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = []
      Lines.Strings = (
        'StateMemo')
      ParentDoubleBuffered = False
      ParentFont = False
      TabOrder = 3
      WordWrap = False
    end
    object Panel1: TPanel
      Left = 1
      Top = 1
      Width = 176
      Height = 410
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 4
      object VMListenButton: TButton
        Left = 7
        Top = 8
        Width = 154
        Height = 25
        Caption = 'Listen on VM service port'
        TabOrder = 0
        OnClick = VMListenButtonClick
      end
      object VMStopListenButton: TButton
        Left = 7
        Top = 39
        Width = 154
        Height = 25
        Caption = 'Pause VM listening'
        TabOrder = 1
        OnClick = VMStopListenButtonClick
      end
      object CloseAllClientButton: TButton
        Left = 7
        Top = 101
        Width = 154
        Height = 25
        Caption = 'Elegant close'
        TabOrder = 2
        OnClick = CloseAllClientButtonClick
      end
      object ExecuteTestButton: TButton
        Left = 7
        Top = 70
        Width = 154
        Height = 25
        Caption = 'Elegant instruction test'
        TabOrder = 3
        OnClick = ExecuteTestButtonClick
      end
      object StatusCheckBox: TCheckBox
        Left = 8
        Top = 132
        Width = 97
        Height = 17
        Caption = 'state'
        Checked = True
        State = cbChecked
        TabOrder = 4
      end
    end
    object Memo: TMemo
      Left = 177
      Top = 1
      Width = 316
      Height = 410
      Align = alClient
      ScrollBars = ssVertical
      TabOrder = 5
      WordWrap = False
      ExplicitLeft = 138
      ExplicitWidth = 355
    end
  end
  object ProgressTimer: TTimer
    Interval = 500
    OnTimer = ProgressTimerTimer
    Left = 208
    Top = 80
  end
  object PrintStateTimer: TTimer
    Interval = 2000
    OnTimer = PrintStateTimerTimer
    Left = 256
    Top = 208
  end
end
