// Eduardo - 20/07/2020

unit Conversa.MensagemEventoTipo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TMensagemEventoTipo = class(TBase)
  private
    class function IncluirMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TMensagemEventoTipo }

class procedure TMensagemEventoTipo.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('mensagem_evento_tipo.incluir', TMensagemEventoTipo.IncluirMensagemEventoTipo);
  Rotas.Add('mensagem_evento_tipo.obter',   TMensagemEventoTipo.ObterMensagemEventoTipo);
  Rotas.Add('mensagem_evento_tipo.alterar', TMensagemEventoTipo.AlterarMensagemEventoTipo);
  Rotas.Add('mensagem_evento_tipo.excluir', TMensagemEventoTipo.ExcluirMensagemEventoTipo);
end;

class function TMensagemEventoTipo.IncluirMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemEventoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into mensagem_evento_tipo '+
      '     ( descricao '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ QuotedStr(Dados.GetValue<String>('[0].descricao')) +
      '     , '+ IntToStr(Usuario) +
      '     ); '+
      'select LAST_INSERT_ID() as id '
    );
    cmdResposta.Dados.AddElement(TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt)));
  finally
    Free;
  end;
end;

class function TMensagemEventoTipo.ObterMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TMensagemEventoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('mensagem_evento_tipo', jaDados);
  finally
    Free;
  end;
end;

class function TMensagemEventoTipo.AlterarMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemEventoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('mensagem_evento_tipo'));
  finally
    Free;
  end;
end;

class function TMensagemEventoTipo.ExcluirMensagemEventoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemEventoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('mensagem_evento_tipo'));
  finally
    Free;
  end;
end;

end.
