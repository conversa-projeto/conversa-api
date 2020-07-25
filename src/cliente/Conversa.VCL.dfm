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
  PixelsPerInch = 96
  TextHeight = 13
  object pgcConversa: TPageControl
    Left = 0
    Top = 30
    Width = 814
    Height = 502
    ActivePage = tshPerfil
    Align = alClient
    TabOrder = 0
    OnChange = pgcConversaChange
    ExplicitTop = 34
    object tshPerfil: TTabSheet
      Caption = 'Perfil'
      object dbgridPerfil: TDBGrid
        Left = 0
        Top = 0
        Width = 806
        Height = 474
        Align = alClient
        DataSource = srcPerfil
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'descricao'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'incluido_id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'incluido_em'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alterado_id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alterado_em'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'excluido_id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'excluido_em'
            Width = 100
            Visible = True
          end>
      end
    end
    object tshUsuario: TTabSheet
      Caption = 'Usu'#225'rio'
      ImageIndex = 1
      object DBGrid1: TDBGrid
        Left = 0
        Top = 0
        Width = 806
        Height = 474
        Align = alClient
        DataSource = srcUsuario
        TabOrder = 0
        TitleFont.Charset = DEFAULT_CHARSET
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Tahoma'
        TitleFont.Style = []
        Columns = <
          item
            Expanded = False
            FieldName = 'id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'nome'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'apelido'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'email'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'usuario'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'senha'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'perfil_id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'incluido_id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'incluido_em'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alterado_id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alterado_em'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'excluido_id'
            Width = 100
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'excluido_em'
            Width = 100
            Visible = True
          end>
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 814
    Height = 30
    Align = alTop
    BevelKind = bkTile
    BevelOuter = bvNone
    TabOrder = 1
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
    object Button2: TButton
      Left = 225
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Postar'
      TabOrder = 1
      OnClick = Button2Click
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
    object Button1: TButton
      Left = 150
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Alterar'
      TabOrder = 3
      OnClick = Button1Click
    end
    object Button3: TButton
      Left = 300
      Top = 0
      Width = 75
      Height = 26
      Align = alLeft
      Caption = 'Excluir'
      TabOrder = 4
      OnClick = Button3Click
    end
  end
  object srcPerfil: TDataSource
    DataSet = Dados.cdsPerfil
    Left = 472
    Top = 1
  end
  object srcUsuario: TDataSource
    DataSet = Dados.cdsUsuario
    Left = 536
    Top = 1
  end
end
