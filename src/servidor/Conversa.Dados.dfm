object ConversaDados: TConversaDados
  OldCreateOrder = False
  Height = 332
  Width = 250
  object conMariaDB: TFDConnection
    Params.Strings = (
      'Database=test'
      'Password=sql@dev'
      'User_Name=root'
      'DriverID=MySQL')
    Connected = True
    LoginPrompt = False
    Left = 112
    Top = 16
  end
  object qryUsuario: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , nome'
      '     , apelido'
      '     , email'
      '     , usuario'
      '     , senha'
      '  from usuario')
    Left = 64
    Top = 64
    object qryUsuarioid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryUsuarionome: TStringField
      FieldName = 'nome'
      Origin = 'nome'
      Required = True
      Size = 200
    end
    object qryUsuarioapelido: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'apelido'
      Origin = 'apelido'
      Size = 50
    end
    object qryUsuarioemail: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'email'
      Origin = 'email'
      Size = 100
    end
    object qryUsuariousuario: TStringField
      FieldName = 'usuario'
      Origin = 'usuario'
      Required = True
      Size = 50
    end
    object qryUsuariosenha: TStringField
      FieldName = 'senha'
      Origin = 'senha'
      Required = True
      Size = 50
    end
  end
  object qryMensagemStatus: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , descricao'
      '  from mensagem_status')
    Left = 64
    Top = 112
    object qryMensagemStatusid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryMensagemStatusdescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 100
    end
  end
  object qryMensagemArquivo: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , mensagem_id'
      '     , arquivo_id'
      '  from mensagem_arquivo')
    Left = 64
    Top = 161
    object qryMensagemArquivoid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryMensagemArquivomensagem_id: TIntegerField
      FieldName = 'mensagem_id'
      Origin = 'mensagem_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMensagemArquivoarquivo_id: TIntegerField
      FieldName = 'arquivo_id'
      Origin = 'arquivo_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object qryMensagem: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , conversa_id'
      '     , usuario_id'
      '     , status'
      '     , confirmacao'
      '     , conteudo'
      '  from mensagem')
    Left = 64
    Top = 209
    object qryMensagemid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryMensagemconversa_id: TIntegerField
      FieldName = 'conversa_id'
      Origin = 'conversa_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMensagemusuario_id: TIntegerField
      FieldName = 'usuario_id'
      Origin = 'usuario_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMensagemstatus2: TIntegerField
      FieldName = 'status'
      Origin = '`status`'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryMensagemconfirmacao: TIntegerField
      FieldName = 'confirmacao'
      Origin = 'confirmacao'
      Required = True
    end
    object qryMensagemconteudo: TStringField
      FieldName = 'conteudo'
      Origin = 'conteudo'
      Required = True
      Size = 8000
    end
  end
  object qryConversaUsuario: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , usuario_id'
      '     , conversa_id'
      '  from conversa_usuario')
    Left = 64
    Top = 257
    object qryConversaUsuarioid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryConversaUsuariousuario_id: TIntegerField
      FieldName = 'usuario_id'
      Origin = 'usuario_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryConversaUsuarioconversa_id: TIntegerField
      FieldName = 'conversa_id'
      Origin = 'conversa_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object qryConversaTipo: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , descricao'
      '  from conversa_tipo')
    Left = 168
    Top = 65
    object qryConversaTipoid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryConversaTipodescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 100
    end
  end
  object qryConversa: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'SELECT id'
      '     , descricao'
      '     , tipo'
      '  FROM conversa')
    Left = 168
    Top = 113
    object qryConversaid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryConversadescricao: TStringField
      FieldName = 'descricao'
      Origin = 'descricao'
      Required = True
      Size = 100
    end
    object qryConversatipo2: TIntegerField
      FieldName = 'tipo'
      Origin = 'tipo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object qryContato: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , usuario_id'
      '     , contato_id'
      '  from contato')
    Left = 168
    Top = 161
    object qryContatoid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryContatousuario_id: TIntegerField
      FieldName = 'usuario_id'
      Origin = 'usuario_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryContatocontato_id: TIntegerField
      FieldName = 'contato_id'
      Origin = 'contato_id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
  end
  object qryArquivoTipo: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id'
      '     , descricao'
      '  from arquivo_tipo')
    Left = 168
    Top = 209
    object qryArquivoTipoid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryArquivoTipodescricao: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'descricao'
      Origin = 'descricao'
      Size = 100
    end
  end
  object qryArquivo: TFDQuery
    Connection = conMariaDB
    SQL.Strings = (
      'select id '
      '     , arquivo'
      '     , tipo'
      '     , tamanho'
      '  from arquivo')
    Left = 168
    Top = 257
    object qryArquivoid: TFDAutoIncField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInWhere, pfInKey]
      ReadOnly = True
    end
    object qryArquivoarquivo: TStringField
      FieldName = 'arquivo'
      Origin = 'arquivo'
      Required = True
      Size = 100
    end
    object qryArquivotipo2: TIntegerField
      FieldName = 'tipo'
      Origin = 'tipo'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object qryArquivotamanho: TIntegerField
      FieldName = 'tamanho'
      Origin = 'tamanho'
      Required = True
    end
  end
end
