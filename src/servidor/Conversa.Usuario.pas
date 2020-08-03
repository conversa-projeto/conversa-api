// Eduardo - 20/07/2020

unit Conversa.Usuario;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TUsuario = class(TBase)
  private
    class function IncluirUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
    class function AutenticaUsuario(sUsuario, sSenha: String; Conexao: TFDConnection): Int64; static;
  end;

implementation

uses
  System.StrUtils,
  Data.DB;

{ TUsuario }

class procedure TUsuario.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('usuario.incluir', TUsuario.IncluirUsuario);
  Rotas.Add('usuario.obter',   TUsuario.ObterUsuario);
  Rotas.Add('usuario.alterar', TUsuario.AlterarUsuario);
  Rotas.Add('usuario.excluir', TUsuario.ExcluirUsuario);
end;

class function TUsuario.IncluirUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into usuario '+
      '     ( nome '+
      '     , apelido '+
      '     , email '+
      '     , usuario '+
      '     , senha '+
      '     , perfil_id '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ QuotedStr(Dados.GetValue<String>('[0].nome')) +
      '     , '+ QuotedStr(Dados.GetValue<String>('[0].apelido')) +
      '     , '+ QuotedStr(Dados.GetValue<String>('[0].email')) +
      '     , '+ QuotedStr(Dados.GetValue<String>('[0].usuario')) +
      '     , '+ QuotedStr(Dados.GetValue<String>('[0].senha')) +
      '     , '+ Dados.GetValue<String>('[0].perfil_id') +
      '     , '+ IntToStr(Usuario) +
      '     ); '+
      'select LAST_INSERT_ID() as id '
    );
    cmdResposta.Dados.AddElement(TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt)));
  finally
    Free;
  end;
end;

class function TUsuario.ObterUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('usuario', jaDados);
  finally
    Free;
  end;
end;

class function TUsuario.AlterarUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('usuario'));
  finally
    Free;
  end;
end;

class function TUsuario.ExcluirUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('usuario'));
  finally
    Free;
  end;
end;

class function TUsuario.AutenticaUsuario(sUsuario, sSenha: String; Conexao: TFDConnection): Int64;
var
  qry: TFDQuery;
  sTexto: String;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conexao;
    qry.Open(
      'select id '+
      '  from usuario '+
      ' where excluido_id is null '+
      '   and usuario = '+ QuotedStr(sUsuario) +
      '   and senha   = '+ QuotedStr(sSenha) +
      IfThen(not sTexto.IsEmpty, '   and '+ sTexto)
    );
    if qry.IsEmpty then
      Result := -1
    else
      Result := qry.FieldByName('id').AsLargeInt;
  finally
    FreeAndNil(qry);
  end;
end;

end.
