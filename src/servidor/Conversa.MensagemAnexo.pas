// Eduardo - 20/07/2020

unit Conversa.MensagemAnexo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base,
  System.Generics.Collections;

type
  TMensagemAnexo = class(TBase)
  private
    class function IncluirMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ObterMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function AlterarMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    class function ExcluirMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
    function ConsultaEnvolvidos: String;
  public
    class procedure Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
  end;

implementation

uses
  System.StrUtils;

{ TMensagemAnexo }

class procedure TMensagemAnexo.Registrar(Rotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>);
begin
  Rotas.Add('mensagem_anexo.incluir', TMensagemAnexo.IncluirMensagemAnexo);
  Rotas.Add('mensagem_anexo.obter',   TMensagemAnexo.ObterMensagemAnexo);
  Rotas.Add('mensagem_anexo.alterar', TMensagemAnexo.AlterarMensagemAnexo);
  Rotas.Add('mensagem_anexo.excluir', TMensagemAnexo.ExcluirMensagemAnexo);
end;

class function TMensagemAnexo.IncluirMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemAnexo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    QryDados.Close;
    QryDados.Open(
      'insert '+
      '  into mensagem_anexo '+
      '     ( mensagem_id '+
      '     , tipo '+
      '     , local '+
      '     , tamanho '+
      '     , incluido_id '+
      '     ) '+
      'values '+
      '     ( '+ Dados.GetValue<String>('[0].mensagem_id') +
      '     , '+ Dados.GetValue<String>('[0].tipo') +
      '     , '+ QuotedStr(Dados.GetValue<String>('[0].local')) +
      '     , '+ Dados.GetValue<String>('[0].tamanho') +
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

class function TMensagemAnexo.ObterMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
var
  jaDados: TJSONArray;
begin
  with TMensagemAnexo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    jaDados := cmdResposta.Dados;
    ObterBase('mensagem_anexo', jaDados);
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagemAnexo.AlterarMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemAnexo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(AlterarBase('mensagem_anexo'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

class function TMensagemAnexo.ExcluirMensagemAnexo(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64): TArray<Int64>;
begin
  with TMensagemAnexo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
  try
    cmdResposta.Dados.AddElement(ExcluirBase('mensagem_anexo'));
    Envolvidos(Result, ConsultaEnvolvidos);
  finally
    Free;
  end;
end;

function TMensagemAnexo.ConsultaEnvolvidos: String;
begin
  Result :=
    'select conversa_usuario.usuario_id '+
    '  from mensagem_anexo '+
    ' inner '+
    '  join mensagem '+
    '    on mensagem.id = mensagem_anexo.mensagem_id '+
    ' inner '+
    '  join conversa_usuario '+
    '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
    ' where mensagem_anexo.id = ';
end;

end.
