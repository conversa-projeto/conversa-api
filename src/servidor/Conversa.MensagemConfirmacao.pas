// Eduardo - 21/07/2020

unit Conversa.MensagemConfirmacao;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TMensagemConfirmacao = class(TBase)
  private
    class function IncluirMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    function ConsultaEnvolvidos: String;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils,
  System.DateUtils;

{ TMensagemConfirmacao }

class procedure TMensagemConfirmacao.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('mensagem_confirmacao.incluir', TMensagemConfirmacao.IncluirMensagemConfirmacao);
  Rotas.Add('mensagem_confirmacao.obter',   TMensagemConfirmacao.ObterMensagemConfirmacao);
  Rotas.Add('mensagem_confirmacao.alterar', TMensagemConfirmacao.AlterarMensagemConfirmacao);
  Rotas.Add('mensagem_confirmacao.excluir', TMensagemConfirmacao.ExcluirMensagemConfirmacao);
end;

class function TMensagemConfirmacao.IncluirMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemConfirmacao.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into mensagem_confirmacao '+
      '     ( usuario_id '+
      '     , mensagem_id '+
      '     , confirmado '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ Dados.GetValue<String>('[0].usuario_id') +
      '     , '+ Dados.GetValue<String>('[0].mensagem_id') +
      '     , '+ QuotedStr(Dados.GetValue<String>('[0].confirmado')) +
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

class function TMensagemConfirmacao.ObterMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TMensagemConfirmacao.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('mensagem_confirmacao', jaDados);
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagemConfirmacao.AlterarMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemConfirmacao.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('mensagem_confirmacao'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagemConfirmacao.ExcluirMensagemConfirmacao(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemConfirmacao.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('mensagem_confirmacao'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

function TMensagemConfirmacao.ConsultaEnvolvidos: String;
begin
  Result :=
    'select conversa_usuario.usuario_id '+
    '  from mensagem_confirmacao '+
    ' inner '+
    '  join mensagem '+
    '    on mensagem.id = mensagem_confirmacao.mensagem_id '+
    ' inner '+
    '  join conversa_usuario '+
    '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
    ' where mensagem_confirmacao.id = ';
end;

end.
