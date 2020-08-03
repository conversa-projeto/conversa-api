// Eduardo - 20/07/2020

unit Conversa.Conversa;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TConversa = class(TBase)
  private
    class function IncluirConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    function ConsultaEnvolvidos: String;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TConversa }

class procedure TConversa.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('conversa.incluir', TConversa.IncluirConversa);
  Rotas.Add('conversa.obter',   TConversa.ObterConversa);
  Rotas.Add('conversa.alterar', TConversa.AlterarConversa);
  Rotas.Add('conversa.excluir', TConversa.ExcluirConversa);
end;

class function TConversa.IncluirConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversa.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into conversa '+
      '     ( descricao '+
      '     , tipo '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ QuotedStr(Dados.GetValue<String>('[0].descricao')) +
      '     , '+ Dados.GetValue<String>('[0].tipo') +
      '     , '+ IntToStr(Usuario) +
      '     ); '+
      'select LAST_INSERT_ID() as id '
    );
    Identificador := QryDados.FieldByName('id').AsLargeInt;
    cmdResposta.Dados.AddElement(TJSONObject.Create.AddPair('id', TJSONNumber.Create(Identificador)));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TConversa.ObterConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TConversa.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    QryDados.Open(
      'select conversa.id'+
      '     , cast(if(conversa.tipo = 1, usuario.nome, conversa.descricao) as varchar(100)) as descricao'+
      '     , conversa.tipo'+
      '     , conversa.incluido_id'+
      '     , conversa.incluido_em'+
      '     , conversa.alterado_id'+
      '     , conversa.alterado_em'+
      '     , conversa.excluido_id'+
      '     , conversa.excluido_em'+
      '     , usuario.nome'+
      '     , mensagem.id'+
      '     , mensagem.conteudo'+
      '     , mensagem.usuario_id'+
      '     , mensagem.incluido_em as msg_incluido_em'+
      '  from conversa.conversa'+
      ' inner '+
      '  join conversa.conversa_usuario as cvs_usuario'+
      '    on cvs_usuario.excluido_em is null'+
      '   and cvs_usuario.conversa_id = conversa.id'+
      '   and cvs_usuario.usuario_id = '+ Usuario.ToString +
      '  left '+
      '  join conversa.usuario'+
      '    on usuario.excluido_em is null'+
      '   and usuario.id = ( select conversa_usuario.usuario_id'+
      '                        from conversa.conversa_usuario'+
      '                       where conversa_usuario.excluido_em is null'+
      '                         and conversa_usuario.conversa_id = conversa.id'+
      '                         and conversa_usuario.usuario_id <> '+ Usuario.ToString +')'+
      '  left '+
      '  join conversa.mensagem'+
      '    on mensagem.id = (select msg.id'+
      '                        from conversa.mensagem as msg'+
      '                       where msg.excluido_em is null'+
      '                         and msg.conversa_id = conversa.conversa.id'+
      '                       order'+
      '                          by msg.incluido_em DESC'+
      '                       limit 1'+
      '                      )'+
      '  left '+
      '  join conversa.usuario as usuario_msg'+
      '    on usuario_msg.id = mensagem.usuario_id'+
      ' where conversa.excluido_em is null'
    );
    QryDados.First;
    while not QryDados.Eof do
    begin
      jaDados.AddElement(TabelaParaJSONObject(QryDados));
      QryDados.Next;
    end;
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TConversa.AlterarConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversa.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('conversa'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TConversa.ExcluirConversa(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversa.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('conversa'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

function TConversa.ConsultaEnvolvidos: String;
begin
  Result :=
    'select usuario_id '+
    '  from conversa '+
    ' inner '+
    '  join conversa_usuario '+
    '    on conversa_usuario.conversa_id = conversa.id '+
    ' where conversa.id = ';
end;

end.
