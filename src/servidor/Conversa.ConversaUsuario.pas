// Eduardo - 20/07/2020

unit Conversa.ConversaUsuario;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TConversaUsuario = class(TBase)
  private
    class function IncluirConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    function ConsultaEnvolvidos: String;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TConversaUsuario }

class procedure TConversaUsuario.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('conversa_usuario.incluir', TConversaUsuario.IncluirConversaUsuario);
  Rotas.Add('conversa_usuario.obter',   TConversaUsuario.ObterConversaUsuario);
  Rotas.Add('conversa_usuario.alterar', TConversaUsuario.AlterarConversaUsuario);
  Rotas.Add('conversa_usuario.excluir', TConversaUsuario.ExcluirConversaUsuario);
end;

class function TConversaUsuario.IncluirConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversaUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into conversa_usuario '+
      '     ( usuario_id '+
      '     , conversa_id '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ Dados.GetValue<String>('[0].usuario_id') +
      '     , '+ Dados.GetValue<String>('[0].conversa_id') +
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

class function TConversaUsuario.ObterConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TConversaUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('conversa_usuario', jaDados);
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TConversaUsuario.AlterarConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversaUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('conversa_usuario'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TConversaUsuario.ExcluirConversaUsuario(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TConversaUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('conversa_usuario'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

function TConversaUsuario.ConsultaEnvolvidos: String;
begin
  Result :=
    'select usuario_conversa.usuario_id '+
    '  from conversa_usuario '+
    ' inner '+
    '  join conversa_usuario as usuario_conversa '+
    '    on usuario_conversa.conversa_id = conversa_usuario.conversa_id '+
    ' where conversa_usuario.id = ';
end;

end.
