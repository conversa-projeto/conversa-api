// Eduardo - 20/07/2020

unit Conversa.MensagemEvento;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TMensagemEvento = class(TBase)
  private
    class function IncluirMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    function ConsultaEnvolvidos: String;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;
implementation

uses
  System.StrUtils;

{ TMensagemEvento }

class procedure TMensagemEvento.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('mensagem_evento.incluir', TMensagemEvento.IncluirMensagemEvento);
  Rotas.Add('mensagem_evento.obter',   TMensagemEvento.ObterMensagemEvento);
  Rotas.Add('mensagem_evento.alterar', TMensagemEvento.AlterarMensagemEvento);
  Rotas.Add('mensagem_evento.excluir', TMensagemEvento.ExcluirMensagemEvento);
end;

class function TMensagemEvento.IncluirMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemEvento.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into mensagem_evento '+
      '     ( usuario_id '+
      '     , mensagem_id '+
      '     , tipo '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ Dados.GetValue<String>('[0].usuario_id') +
      '     , '+ Dados.GetValue<String>('[0].mensagem_id') +
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

class function TMensagemEvento.ObterMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TMensagemEvento.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('mensagem_evento', jaDados);
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagemEvento.AlterarMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemEvento.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('mensagem_evento'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagemEvento.ExcluirMensagemEvento(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemEvento.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('mensagem_evento'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

function TMensagemEvento.ConsultaEnvolvidos: String;
begin
  Result :=
    'select conversa_usuario.usuario_id '+
    '  from mensagem_evento '+
    ' inner '+
    '  join mensagem '+
    '    on mensagem.id = mensagem_evento.mensagem_id '+
    ' inner '+
    '  join conversa_usuario '+
    '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
    ' where mensagem_evento.id = ';
end;

end.
