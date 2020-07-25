object Dados: TDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 368
  Width = 371
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
  object cdsUsuario: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 96
    Top = 24
    object cdsUsuarioid: TIntegerField
      FieldName = 'id'
    end
    object cdsUsuarionome: TStringField
      FieldName = 'nome'
      Size = 200
    end
    object cdsUsuarioapelido: TStringField
      FieldName = 'apelido'
      Size = 50
    end
    object cdsUsuarioemail: TStringField
      FieldName = 'email'
      Size = 100
    end
    object cdsUsuariousuario: TStringField
      FieldName = 'usuario'
      Size = 50
    end
    object cdsUsuariosenha: TStringField
      FieldName = 'senha'
      Size = 50
    end
    object cdsUsuarioperfil_id: TIntegerField
      FieldName = 'perfil_id'
    end
    object cdsUsuarioincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsUsuarioincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsUsuarioalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsUsuarioalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsUsuarioexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsUsuarioexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
end
