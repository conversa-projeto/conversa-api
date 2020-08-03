// Eduardo - 20/07/2020

unit Conversa.AnexoTipo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TAnexoTipo = class(TBase)
  private
    class function IncluirAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TAnexoTipo }

class procedure TAnexoTipo.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('anexo_tipo.incluir', TAnexoTipo.IncluirAnexoTipo);
  Rotas.Add('anexo_tipo.obter',   TAnexoTipo.ObterAnexoTipo);
  Rotas.Add('anexo_tipo.alterar', TAnexoTipo.AlterarAnexoTipo);
  Rotas.Add('anexo_tipo.excluir', TAnexoTipo.ExcluirAnexoTipo);
end;

class function TAnexoTipo.IncluirAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TAnexoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into anexo_tipo '+
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
    cmdResposta.Dados.AddElement(TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt)));
  finally
    Free;
  end;
end;

class function TAnexoTipo.ObterAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TAnexoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('anexo_tipo', jaDados);
  finally
    Free;
  end;
end;

class function TAnexoTipo.AlterarAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TAnexoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('anexo_tipo'));
  finally
    Free;
  end;
end;

class function TAnexoTipo.ExcluirAnexoTipo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TAnexoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('anexo_tipo'));
  finally
    Free;
  end;
end;

end.
