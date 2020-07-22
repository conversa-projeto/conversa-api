object Dados: TDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 150
  Width = 215
  object cdsPerfil: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 32
    Top = 24
    object cdsPerfilid: TIntegerField
      FieldName = 'id'
    end
    object cdsPerfildescricao: TStringField
      FieldName = 'descricao'
      Size = 100
    end
    object cdsPerfilincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsPerfilincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsPerfilalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsPerfilalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsPerfilexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsPerfilexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
end
