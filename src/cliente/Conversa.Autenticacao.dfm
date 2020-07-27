object Autenticacao: TAutenticacao
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Autenticacao'
  ClientHeight = 265
  ClientWidth = 217
  Color = clWindow
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object lbUsuario: TLabel
    Left = 48
    Top = 112
    Width = 36
    Height = 13
    Caption = 'Usu'#225'rio'
  end
  object lbSenha: TLabel
    Left = 48
    Top = 155
    Width = 30
    Height = 13
    Caption = 'Senha'
  end
  object lbC: TLabel
    Left = 82
    Top = -1
    Width = 53
    Height = 117
    Caption = 'C'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -96
    Font.Name = 'Impact'
    Font.Style = []
    ParentFont = False
  end
  object sbtAcessar: TSpeedButton
    Left = 29
    Top = 216
    Width = 75
    Height = 22
    Caption = 'Acessar'
    Flat = True
    OnClick = sbtAcessarClick
  end
  object sbtCancelar: TSpeedButton
    Left = 110
    Top = 216
    Width = 75
    Height = 22
    Caption = 'Cancelar'
    Flat = True
    OnClick = sbtCancelarClick
  end
  object edtUsuario: TEdit
    Left = 48
    Top = 128
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtSenha: TEdit
    Left = 48
    Top = 171
    Width = 121
    Height = 21
    PasswordChar = '*'
    TabOrder = 1
    OnKeyDown = edtSenhaKeyDown
  end
end
