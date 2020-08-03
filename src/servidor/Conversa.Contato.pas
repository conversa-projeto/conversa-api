// Eduardo - 20/07/2020

unit Conversa.Contato;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TContato = class(TBase)
  private
    class function IncluirContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TContato }

class procedure TContato.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('contato.incluir', TContato.IncluirContato);
  Rotas.Add('contato.obter',   TContato.ObterContato);
  Rotas.Add('contato.alterar', TContato.AlterarContato);
  Rotas.Add('contato.excluir', TContato.ExcluirContato);
end;

class function TContato.IncluirContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TContato.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into contato '+
      '     ( usuario_id '+
      '     , contato_id '+
      '     , favorito '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ Dados.GetValue<String>('[0].usuario_id') +
      '     , '+ Dados.GetValue<String>('[0].contato_id') +
      '     , '+ Dados.GetValue<String>('[0].favorito') +
      '     , '+ IntToStr(Usuario) +
      '     ); '+
      'select LAST_INSERT_ID() as id '
    );
    cmdResposta.Dados.AddElement(TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt)));
  finally
    Free;
  end;
end;

class function TContato.ObterContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TContato.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('contato', jaDados);
  finally
    Free;
  end;
end;

class function TContato.AlterarContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TContato.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('contato'));
  finally
    Free;
  end;
end;

class function TContato.ExcluirContato(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TContato.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('contato'));
  finally
    Free;
  end;
end;

end.
