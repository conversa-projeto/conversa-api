object ConversaVCL: TConversaVCL
  Left = 0
  Top = 0
  Caption = 'Conversa VCL Testador'
  ClientHeight = 532
  ClientWidth = 814
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 30
    Align = alTop
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 0
    object btnInserir: TButton
      Left = 75
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Incluir'
      TabOrder = 0
      OnClick = btnInserirClick
    end
    object btnPostar: TButton
      Left = 225
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Postar'
      TabOrder = 1
      OnClick = btnPostarClick
    end
    object btnObter: TButton
      Left = 0
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Obter'
      TabOrder = 2
      OnClick = btnObterClick
    end
    object btnAlterar: TButton
      Left = 150
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Alterar'
      TabOrder = 3
      OnClick = btnAlterarClick
    end
    object btnExcluir: TButton
      Left = 300
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Excluir'
      TabOrder = 4
      OnClick = btnExcluirClick
    end
  end
  object dbgridTabela: TDBGrid
    Left = 281
    Top = 30
    Width = 533
    Height = 502
    Align = alClient
    DataSource = srcTabela
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object vledtTabelas: TValueListEditor
    Left = 0
    Top = 30
    Width = 281
    Height = 502
    Align = alLeft
    Options = [goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect, goThumbTracking]
    Strings.Strings = (
      'anexo_tipo=cdsAnexoTipo'
      'contato=cdsContato'
      'conversa=cdsConversa'
      'conversa_tipo=cdsConversaTp'
      'conversa_usuario=cdsConversaUsuario'
      'mensagem=cdsMensagem'
      'mensagem_anexo=cdsMensagemAnexo'
      'mensagem_confirmacao=cdsMensagemConf'
      'mensagem_evento=cdsMensagemEvento'
      'mensagem_evento_tipo=cdsMensagemEventoTp'
      'perfil=cdsPerfil'
      'usuario=cdsUsuario')
    TabOrder = 2
    TitleCaptions.Strings = (
      'Tabela'
      'Componente')
    OnClick = vledtTabelasClick
    ExplicitLeft = -6
    ExplicitTop = 34
    ColWidths = (
      133
      142)
  end
  object srcTabela: TDataSource
    Left = 472
    Top = 1
  end
end
