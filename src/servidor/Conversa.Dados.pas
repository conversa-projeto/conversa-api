// Eduardo - 12/07/2020

unit Conversa.Dados;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.DateUtils,
  System.StrUtils,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  IdContext,
  Conversa.Comando,
  Conversa.Consulta,
  Conversa.WebSocket;

type
  TConversaDados = class(TDataModule)
    conMariaDB: TFDConnection;
    qryMariaDB: TFDQuery;
  private
    FContexto: TIdContext;
    FAutenticado: Boolean;
    FUsuario: Int64;
    FRotas: TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>;
    procedure NotificaEnvolvidos(const WebSocket: TWebSocketServer; const Contexto: TIdContext; const cmdResposta: TComando; const aiEnvolvidos: TArray<Int64>);
    function Autentica(cmdRequisicao: TComando): TJSONObject;
  public
    class function Dados(const Contexto: TIdContext): TConversaDados;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Redireciona(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
    procedure ExecutaComando(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
  end;

const
  sl = sLineBreak;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  Conversa.Perfil,
  Conversa.Usuario,
  Conversa.Contato,
  Conversa.MensagemEventoTipo,
  Conversa.AnexoTipo,
  Conversa.ConversaTipo,
  Conversa.Conversa,
  Conversa.ConversaUsuario,
  Conversa.Mensagem,
  Conversa.MensagemEvento,
  Conversa.MensagemAnexo,
  Conversa.MensagemConfirmacao;

class function TConversaDados.Dados(const Contexto: TIdContext): TConversaDados;
begin
  if not Assigned(Contexto.Data) then
    Contexto.Data := TConversaDados.Create(nil);
  Result := TConversaDados(Contexto.Data);
  Result.FContexto := Contexto;
end;

constructor TConversaDados.Create(AOwner: TComponent);
begin
  inherited;
  FAutenticado := False;
  FRotas := TDictionary<String, TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>>.Create;
  TPerfil.Registrar(FRotas);
  TUsuario.Registrar(FRotas);
  TContato.Registrar(FRotas);
  TMensagemEventoTipo.Registrar(FRotas);
  TAnexoTipo.Registrar(FRotas);
  TConversaTipo.Registrar(FRotas);
  TConversa.Registrar(FRotas);
  TConversaUsuario.Registrar(FRotas);
  TMensagem.Registrar(FRotas);
  TMensagemEvento.Registrar(FRotas);
  TMensagemAnexo.Registrar(FRotas);
  TMensagemConfirmacao.Registrar(FRotas);
end;

destructor TConversaDados.Destroy;
begin
  FreeAndNil(FRotas);
  inherited;
end;

procedure TConversaDados.Redireciona(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
begin
  if FAutenticado then
    ExecutaComando(WebSocket, cmdRequisicao, cmdResposta)
  else
  begin
    cmdResposta.Dados.AddElement(Autentica(cmdRequisicao));
    WebSocket.Send(FContexto, cmdResposta.Texto);
  end;
end;

function TConversaDados.Autentica(cmdRequisicao: TComando): TJSONObject;
var
  joAutenticacao: TJSONObject;
  jaUsuario: TJSONArray;
begin
  Result := TJSONObject.Create;

  if not cmdRequisicao.Recurso.Equals('autenticacao') then
  begin
    Result.AddPair('autenticado', TJSONBool.Create(False)).AddPair('motivo', 'Recurso "autenticacao" não foi solicitado!');
    Exit;
  end;

  joAutenticacao := nil;

  if cmdRequisicao.Dados.Count > 0 then
    if cmdRequisicao.Dados.Items[0] is TJSONObject then
      joAutenticacao := TJSONObject(cmdRequisicao.Dados.Items[0]);

  if not Assigned(joAutenticacao) or
     not Assigned(joAutenticacao.FindValue('usuario')) or
     not Assigned(joAutenticacao.FindValue('senha')) then
  begin
    Result.AddPair('autenticado', TJSONBool.Create(False)).AddPair('motivo', 'Parâmetros "usuario" ou "senha" não informados!');
    Exit;
  end;

  jaUsuario := TJSONArray.Create;
  try
    FUsuario := TUsuario.AutenticaUsuario(joAutenticacao.GetValue('usuario').Value, joAutenticacao.GetValue('senha').Value, conMariaDB);
    FAutenticado := FUsuario <> -1;

    if FAutenticado then
      Result.AddPair('autenticado', TJSONBool.Create(True)).AddPair('id', TJSONNumber.Create(FUsuario))
    else
      Result.AddPair('autenticado', TJSONBool.Create(False)).AddPair('motivo', 'Parâmetros "usuario" ou "senha" incorretos!');
  finally
    FreeAndNil(jaUsuario);
  end;
end;

procedure TConversaDados.ExecutaComando(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
var
  aiEnvolvidos: TArray<Int64>;
  Metodo: TFunc<TComando, TComando, TFDConnection, Int64, TArray<Int64>>;
begin
  // Rotas
  if FRotas.TryGetValue(cmdRequisicao.Recurso, Metodo) then
    aiEnvolvidos := Metodo(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);

  // Notificar todos usuários envolvidos quando há alterações nas tabelas compartilhadas
  if Length(aiEnvolvidos) > 0 then
    NotificaEnvolvidos(WebSocket, FContexto, cmdResposta, aiEnvolvidos)
  else // Avisa somente o usuário atual
    WebSocket.Send(FContexto, cmdResposta.Texto);
end;

procedure TConversaDados.NotificaEnvolvidos(const WebSocket: TWebSocketServer; const Contexto: TIdContext; const cmdResposta: TComando; const aiEnvolvidos: TArray<Int64>);
var
  Clients: TList;
  I: Integer;
  function EstaEnvolvido(id: Int64): Boolean;
  var
    iTemp: Int64;
  begin
    Result := False;
    for iTemp in aiEnvolvidos do
      if iTemp = id then
        Exit(True);
  end;
begin
  Clients := WebSocket.Contexts.LockList;
  try
    for I := 0 to Pred(Clients.Count) do
      if TIdContext(Clients[I]).Connection.Connected and EstaEnvolvido(TConversaDados(TIdContext(Clients[I]).Data).FUsuario) then
        TWebSocketIOHandlerHelper(TIdContext(Clients[I]).Connection.IOHandler).WriteString(cmdResposta.Texto);
  finally
    WebSocket.Contexts.UnlockList;
  end;
end;

end.
