object Dados: TDados
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Height = 340
  Width = 247
  object cdsPerfil: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 216
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
    Left = 152
    Top = 264
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
  object cdsAnexoTipo: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 24
    object cdsAnexoTipoid: TIntegerField
      FieldName = 'id'
    end
    object cdsAnexoTipotipo: TStringField
      FieldName = 'tipo'
      Size = 50
    end
    object cdsAnexoTipodescricao: TStringField
      FieldName = 'descricao'
      Size = 100
    end
    object cdsAnexoTipoincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsAnexoTipoincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsAnexoTipoalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsAnexoTipoalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsAnexoTipoexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsAnexoTipoexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsContato: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 72
    object cdsContatoid: TIntegerField
      FieldName = 'id'
    end
    object cdsContatousuario_id: TIntegerField
      FieldName = 'usuario_id'
    end
    object cdsContatocontato_id: TIntegerField
      FieldName = 'contato_id'
    end
    object cdsContatofavorito: TIntegerField
      FieldName = 'favorito'
    end
    object cdsContatoincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsContatoincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsContatoalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsContatoalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsContatoexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsContatoexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsConversa: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 120
    object cdsConversaid: TIntegerField
      FieldName = 'id'
    end
    object cdsConversadescricao: TStringField
      FieldName = 'descricao'
      Size = 100
    end
    object cdsConversatipo: TIntegerField
      FieldName = 'tipo'
    end
    object cdsConversaincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsConversaincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsConversaalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsConversaalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsConversaexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsConversaexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsConversaTp: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 168
    object cdsConversaTpid: TIntegerField
      FieldName = 'id'
    end
    object cdsConversaTpdescricao: TStringField
      FieldName = 'descricao'
      Size = 100
    end
    object cdsConversaTpincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsConversaTpincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsConversaTpalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsConversaTpalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsConversaTpexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsConversaTpexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsConversaUsuario: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 216
    object cdsConversaUsuarioid: TIntegerField
      FieldName = 'id'
    end
    object cdsConversaUsuariousuario_id: TIntegerField
      FieldName = 'usuario_id'
    end
    object cdsConversaUsuarioconversa_id: TIntegerField
      FieldName = 'conversa_id'
    end
    object cdsConversaUsuarioincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsConversaUsuarioincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsConversaUsuarioalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsConversaUsuarioalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsConversaUsuarioexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsConversaUsuarioexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsMensagem: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 48
    Top = 264
    object cdsMensagemid: TIntegerField
      FieldName = 'id'
    end
    object cdsMensagemusuario_id: TIntegerField
      FieldName = 'usuario_id'
    end
    object cdsMensagemconversa_id: TIntegerField
      FieldName = 'conversa_id'
    end
    object cdsMensagemresposta: TIntegerField
      FieldName = 'resposta'
    end
    object cdsMensagemconfirmacao: TIntegerField
      FieldName = 'confirmacao'
    end
    object cdsMensagemconteudo: TBlobField
      FieldName = 'conteudo'
    end
    object cdsMensagemincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsMensagemincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsMensagemalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsMensagemalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsMensagemexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsMensagemexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
    object cdsMensagemmensagem_id: TIntegerField
      FieldName = 'mensagem_id'
    end
  end
  object cdsMensagemAnexo: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 24
    object cdsMensagemAnexoid: TIntegerField
      FieldName = 'id'
    end
    object cdsMensagemAnexomensagem_id: TIntegerField
      FieldName = 'mensagem_id'
    end
    object cdsMensagemAnexotipo: TIntegerField
      FieldName = 'tipo'
    end
    object cdsMensagemAnexolocal: TStringField
      FieldName = 'local'
      Size = 500
    end
    object cdsMensagemAnexotamanho: TIntegerField
      FieldName = 'tamanho'
    end
    object cdsMensagemAnexoincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsMensagemAnexoincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsMensagemAnexoalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsMensagemAnexoalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsMensagemAnexoexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsMensagemAnexoexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsMensagemConf: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 72
    object cdsMensagemConfid: TIntegerField
      FieldName = 'id'
    end
    object cdsMensagemConfusuario_id: TIntegerField
      FieldName = 'usuario_id'
    end
    object cdsMensagemConfmensagem_id: TIntegerField
      FieldName = 'mensagem_id'
    end
    object cdsMensagemConfconfirmado: TDateTimeField
      FieldName = 'confirmado'
    end
    object cdsMensagemConfincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsMensagemConfincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsMensagemConfalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsMensagemConfalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsMensagemConfexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsMensagemConfexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsMensagemEvento: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 120
    object cdsMensagemEventoid: TIntegerField
      FieldName = 'id'
    end
    object cdsMensagemEventousuario_id: TIntegerField
      FieldName = 'usuario_id'
    end
    object cdsMensagemEventomensagem_id: TIntegerField
      FieldName = 'mensagem_id'
    end
    object cdsMensagemEventotipo: TIntegerField
      FieldName = 'tipo'
    end
    object cdsMensagemEventoincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsMensagemEventoincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsMensagemEventoalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsMensagemEventoalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsMensagemEventoexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsMensagemEventoexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
  object cdsMensagemEventoTp: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 152
    Top = 168
    object cdsMensagemEventoTpid: TIntegerField
      FieldName = 'id'
    end
    object cdsMensagemEventoTpdescricao: TStringField
      FieldName = 'descricao'
      Size = 100
    end
    object cdsMensagemEventoTpincluido_id: TIntegerField
      FieldName = 'incluido_id'
    end
    object cdsMensagemEventoTpincluido_em: TDateTimeField
      FieldName = 'incluido_em'
    end
    object cdsMensagemEventoTpalterado_id: TIntegerField
      FieldName = 'alterado_id'
    end
    object cdsMensagemEventoTpalterado_em: TDateTimeField
      FieldName = 'alterado_em'
    end
    object cdsMensagemEventoTpexcluido_id: TIntegerField
      FieldName = 'excluido_id'
    end
    object cdsMensagemEventoTpexcluido_em: TDateTimeField
      FieldName = 'excluido_em'
    end
  end
end
