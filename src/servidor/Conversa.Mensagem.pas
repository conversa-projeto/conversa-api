// Eduardo - 20/07/2020

unit Conversa.Mensagem;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TMensagem = class(TBase)
  private
    class function IncluirMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    function ConsultaEnvolvidos: String;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TMensagem }

class procedure TMensagem.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('mensagem.incluir', TMensagem.IncluirMensagem);
  Rotas.Add('mensagem.obter',   TMensagem.ObterMensagem);
  Rotas.Add('mensagem.alterar', TMensagem.AlterarMensagem);
  Rotas.Add('mensagem.excluir', TMensagem.ExcluirMensagem);
end;

class function TMensagem.IncluirMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagem.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into mensagem '+
      '     ( mensagem_id '+
      '     , usuario_id '+
      '     , conversa_id '+
      '     , resposta '+
      '     , confirmacao '+
      '     , conteudo '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ Dados.GetValue<String>('[0].mensagem_id') +
      '     , '+ Dados.GetValue<String>('[0].usuario_id') +
      '     , '+ Dados.GetValue<String>('[0].conversa_id') +
      '     , '+ Dados.GetValue<String>('[0].resposta') +
      '     , '+ Dados.GetValue<String>('[0].confirmacao') +
      '     , '+ QuotedStr(Dados.GetValue<String>('[0].conteudo')) +
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

class function TMensagem.ObterMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TMensagem.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('mensagem', jaDados);
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagem.AlterarMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagem.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('mensagem'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagem.ExcluirMensagem(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagem.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('mensagem'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

function TMensagem.ConsultaEnvolvidos: String;
begin
  Result :=
    'select conversa_usuario.usuario_id '+
    '  from mensagem '+
    ' inner '+
    '  join conversa_usuario '+
    '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
    ' where mensagem.id = ';
end;

end.
