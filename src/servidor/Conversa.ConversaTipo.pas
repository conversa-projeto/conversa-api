// Eduardo - 20/07/2020

unit Conversa.ConversaTipo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TConversaTipo = class(TBase)
  private
    class function IncluirConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TConversaTipo }

class procedure TConversaTipo.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('conversa_tipo.incluir', TConversaTipo.IncluirConversaTipo);
  Rotas.Add('conversa_tipo.obter',   TConversaTipo.ObterConversaTipo);
  Rotas.Add('conversa_tipo.alterar', TConversaTipo.AlterarConversaTipo);
  Rotas.Add('conversa_tipo.excluir', TConversaTipo.ExcluirConversaTipo);
end;

class function TConversaTipo.IncluirConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversaTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into conversa_tipo '+
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

class function TConversaTipo.ObterConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TConversaTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('conversa_tipo', jaDados);
  finally
    Free;
  end;
end;

class function TConversaTipo.AlterarConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversaTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('conversa_tipo'));
  finally
    Free;
  end;
end;

class function TConversaTipo.ExcluirConversaTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversaTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('conversa_tipo'));
  finally
    Free;
  end;
end;

end.
