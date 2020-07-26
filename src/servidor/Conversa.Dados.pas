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
    procedure NotificaEnvolvidos(const WebSocket: TWebSocketServer; const Contexto: TIdContext; const cmdResposta: TComando; const sTabela: String);
    function Autentica(cmdRequisicao: TComando): TJSONObject;
  public
    class function Dados(const Contexto: TIdContext): TConversaDados;
    constructor Create(AOwner: TComponent); override;
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
      Result.AddPair('autenticado', TJSONBool.Create(True))
    else
      Result.AddPair('autenticado', TJSONBool.Create(False)).AddPair('motivo', 'Parâmetros "usuario" ou "senha" incorretos!');
  finally
    FreeAndNil(jaUsuario);
  end;
end;

procedure TConversaDados.ExecutaComando(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
begin
  // Perfil
  TPerfil.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TUsuario.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TContato.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TMensagemEventoTipo.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TAnexoTipo.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TConversaTipo.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TConversa.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TConversaUsuario.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TMensagem.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TMensagemEvento.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TMensagemAnexo.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);
  TMensagemConfirmacao.Rotas(cmdRequisicao, cmdResposta, conMariaDB, FUsuario);

//  // Notificar todos usuários envolvidos quando há alterações nas tabelas compartilhadas
//  if MatchStr(sTabela, ['conversa', 'conversa_usuario', 'mensagem', 'mensagem_confirmacao', 'mensagem_status']) then
//    NotificaEnvolvidos(WebSocket, FContexto, cmdResposta, sTabela)
//  else // Avisa somente o usuário atual
    WebSocket.Send(FContexto, cmdResposta.Texto);
end;

procedure TConversaDados.NotificaEnvolvidos(const WebSocket: TWebSocketServer; const Contexto: TIdContext; const cmdResposta: TComando; const sTabela: String);
var
  Clients: TList;
  I: Integer;
  aEnvolvidos: TArray<Int64>;

  function ObtemEnvolvidos: TArray<Int64>;
  var
    jaEnvolvidos: TJSONArray;
    jvItem: TJSONValue;
    sID: String;
  begin
    jaEnvolvidos := TJSONArray.Create;
    try
      sID := '1'; // verificar como obter da resposta

      for jvItem in jaEnvolvidos do
      begin
        SetLength(Result, Succ(Length(Result)));
        Result[Pred(Length(Result))] := TJSONNumber(TJSONObject(jvItem).GetValue('usuario_id')).AsInt64;
      end;
    finally
      FreeAndNil(jaEnvolvidos);
    end;
  end;

  function EstaEnvolvido(id: Int64): Boolean;
  var
    iTemp: Int64;
  begin
    Result := False;
    for iTemp in aEnvolvidos do
      if iTemp = id then
        Exit(True);
  end;
begin
  aEnvolvidos := ObtemEnvolvidos;

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
