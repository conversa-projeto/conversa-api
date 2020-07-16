﻿// Eduardo - 12/07/2020

unit Conversa.Dados;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.DateUtils,
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
  Conversa.Insere,
  Conversa.WebSocket;

type
  TConversaDados = class(TDataModule)
    conMariaDB: TFDConnection;
  private
    FContexto: TIdContext;
    FAutenticado: Boolean;
    function TabelaParaJSONObject(qry: TFDQuery): TJSONObject;
    procedure Criar(jaItems, jaRetorno: TJSONArray);
    procedure Obter(sConsulta: String; jaRetorno: TJSONArray);
    procedure Alterar(sConsulta: String; jaItems, jaRetorno: TJSONArray);
    procedure Remover(sConsulta: String; jaRetorno: TJSONArray);
    function AbreTabela(sConsulta: String): TFDQuery;
    procedure NotificaEnvolvidos(const WebSocket: TWebSocketServer; const Contexto: TIdContext; const cmdRequisicao: TComando);
    function Autentica(cmdRequisicao: TComando): TJSONObject;
  public
    class function Dados(const Contexto: TIdContext): TConversaDados;
    constructor Create(AOwner: TComponent); override;
    procedure Redireciona(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
    procedure ExecutaComando(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
  end;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.StrUtils;

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

  if not cmdRequisicao.Recurso.Equals('autenticacao') and not cmdRequisicao.Metodo.Equals('obter') then
  begin
    Result.AddPair('autenticado', TJSONBool.Create(False)).AddPair('motivo', 'Recurso "autenticacao" com metodo "obter" não foi solicitado!');
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
    Obter(
      'select id '+
      '  from usuario '+
      ' where usuario = '+ QuotedStr(joAutenticacao.GetValue('usuario').Value) +
      '   and senha = '+ QuotedStr(joAutenticacao.GetValue('senha').Value),
      jaUsuario
    );
    FAutenticado := jaUsuario.Count = 1;
    if FAutenticado then
      Result.AddPair('autenticado', TJSONBool.Create(True))
    else
      Result.AddPair('autenticado', TJSONBool.Create(False)).AddPair('motivo', 'Parâmetros "usuario" ou "senha" incorretos!');
  finally
    FreeAndNil(jaUsuario);
  end;
end;

procedure TConversaDados.ExecutaComando(const WebSocket: TWebSocketServer; const cmdRequisicao: TComando; var cmdResposta: TComando);
var
  consulta: TConsulta;
  sTabela: String;
  sTexto: String;
begin
  sTabela := cmdRequisicao.Recurso.Replace('.', '_').Replace('/', '_').Replace('\', '_');
 
  case IndexStr(cmdRequisicao.Metodo, ['criar', 'obter', 'alterar', 'remover']) of
    0: // criar
    begin
      Criar(cmdRequisicao.Dados, cmdResposta.Dados);
    end;
    1: // obter
    begin
      consulta := TConsulta.Create(cmdRequisicao.Dados);
      try
        sTexto := consulta.Texto;
        Obter('select * from '+ sTabela +' '+ IfThen(not sTexto.IsEmpty, ' where '+ sTexto), cmdResposta.Dados);
      finally
        FreeAndNil(consulta);
      end;
    end;
    2: // alterar
    begin
      consulta := TConsulta.Create(TJSONArray(cmdRequisicao.Dados.Items[0]));
      try
        sTexto := consulta.Texto;
        Alterar('select * from '+ sTabela +' '+ IfThen(not sTexto.IsEmpty, ' where '+ sTexto), TJSONArray(cmdRequisicao.Dados.Items[1]), cmdResposta.Dados);
      finally
        FreeAndNil(consulta);
      end;
    end;
    3: // remover
    begin
      consulta := TConsulta.Create(cmdRequisicao.Dados);
      try
        sTexto := consulta.Texto;
        Remover('select * from '+ sTabela +' '+ IfThen(not sTexto.IsEmpty, ' where '+ sTexto), cmdResposta.Dados);
      finally
        FreeAndNil(consulta);
      end;
    end;
  else
    raise Exception.Create('Metodo: "'+ cmdRequisicao.Metodo +'" inválido!');
  end;
  
  // Notificar todos usuários envolvidos quando há alterações nas tabelas compartilhadas
  if MatchStr(cmdRequisicao.Metodo, ['criar', 'alterar', 'remover']) and
     MatchStr(sTabela, ['conversa', 'conversa_usuario', 'mensagem', 'mensagem_confirmacao', 'mensagem_status']) then
    NotificaEnvolvidos(WebSocket, FContexto, cmdResposta)
  else // Avisa somente o usuário atual
    WebSocket.Send(FContexto, cmdResposta.Texto);
end;

procedure TConversaDados.NotificaEnvolvidos(const WebSocket: TWebSocketServer; const Contexto: TIdContext; const cmdRequisicao: TComando);
var
  Clients: TList;
  I: Integer;
begin
  Clients := WebSocket.Contexts.LockList;
  try
    for I := 0 to Pred(Clients.Count) do
      if TIdContext(Clients[I]).Connection.Connected {obter os usuários envolvidos na alteração} then
        TWebSocketIOHandlerHelper(TIdContext(Clients[I]).Connection.IOHandler).WriteString(cmdRequisicao.Texto);
  finally
    WebSocket.Contexts.UnlockList;
  end;
end;

function TConversaDados.TabelaParaJSONObject(qry: TFDQuery): TJSONObject;
var
  field: TField;
begin
  Result := TJSONObject.Create;
  for field in qry.Fields do
  begin
    if field.IsNull then
      Result.AddPair(field.FieldName, TJSONNull.Create)
    else
    if field is TStringField then
      Result.AddPair(field.FieldName, field.AsString)
    else
    if field is TNumericField then
      Result.AddPair(field.FieldName, TJSONNumber.Create(field.AsFloat))
    else
    if (field is TDateTimeField) or (field is TSQLTimeStampField) then
      Result.AddPair(field.FieldName, DateToISO8601(field.AsDateTime))
    else
      raise Exception.Create(Self.Name +': Tipo do campo não esperado!'+ sLineBreak +'Campo: '+ field.FieldName);
  end;
end;

function TConversaDados.AbreTabela(sConsulta: String): TFDQuery;
begin
  Result := TFDQuery.Create(nil);
  try
    Result.Connection := conMariaDB;
    Result.Open(sConsulta);    
  except on E: Exception do
    begin
      FreeAndNil(Result);
      raise Exception.Create(E.Message);
    end;
  end;
end;

procedure TConversaDados.Criar(jaItems, jaRetorno: TJSONArray);
begin
  with TInsere.Create(jaItems, conMariaDB) do
  try
    Executar(jaRetorno);
  finally
    Free;
  end;
end;

procedure TConversaDados.Obter(sConsulta: String; jaRetorno: TJSONArray);
var
  qry: TFDQuery;
begin
  qry := AbreTabela(sConsulta);
  try
    qry.First;
    while not qry.Eof do
    begin
      jaRetorno.AddElement(TabelaParaJSONObject(qry));
      qry.Next;
    end;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TConversaDados.Alterar(sConsulta: String; jaItems, jaRetorno: TJSONArray);
var
  qry: TFDQuery;
begin
  qry := AbreTabela(sConsulta);
  try
    qry.First;
    while not qry.Eof do
    begin
      qry.Edit;
      // fazer a alteração
      jaRetorno.AddElement(TabelaParaJSONObject(qry));
      qry.Next;
    end;
    if qry.State = dsEdit then
    begin
      qry.Post;
      qry.ApplyUpdates(0);
      qry.CommitUpdates;
    end;
  finally
    FreeAndNil(qry);
  end;
end;

procedure TConversaDados.Remover(sConsulta: String; jaRetorno: TJSONArray);
var
  qry: TFDQuery;
begin
  qry := AbreTabela(sConsulta);
  try
    qry.First;
    while not qry.Eof do
    begin
      jaRetorno.AddElement(TabelaParaJSONObject(qry));
      qry.Delete;
    end;
    if qry.State = dsEdit then
    begin
      qry.Post;
      qry.ApplyUpdates(0);
      qry.CommitUpdates;
    end;
  finally
    FreeAndNil(qry);
  end;
end;

end.
