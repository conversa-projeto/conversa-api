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
    Top = 0
    Width = 814
    Height = 532
    ActivePage = tshPerfil
    Align = alClient
    TabOrder = 0
    object tshPerfil: TTabSheet
      Caption = 'Perfil'
      object dbgridPerfil: TDBGrid
        Left = 0
        Top = 0
        Width = 806
        Height = 504
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
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'descricao'
            Width = 171
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'incluido_id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'incluido_em'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alterado_id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'alterado_em'
            Width = 64
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'excluido_id'
            Visible = True
          end
          item
            Expanded = False
            FieldName = 'excluido_em'
            Width = 64
            Visible = True
          end>
      end
    end
  end
  object srcPerfil: TDataSource
    DataSet = Dados.cdsPerfil
    Left = 96
    Top = 1
  end
end
