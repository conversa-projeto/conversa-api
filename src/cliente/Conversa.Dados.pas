// Eduardo - 21/07/2020

unit Conversa.Dados;

interface

uses
  System.SysUtils,
  System.Classes,
  Data.DB,
  Datasnap.DBClient,
  Conversa.DataSet,
  Conversa.WebSocket;

type
  TDados = class(TDataModule)
    cdsPerfil: TClientDataSet;
    cdsPerfilid: TIntegerField;
    cdsPerfildescricao: TStringField;
    cdsPerfilincluido_id: TIntegerField;
    cdsPerfilalterado_id: TIntegerField;
    cdsPerfilexcluido_id: TIntegerField;
    cdsPerfilincluido_em: TDateTimeField;
    cdsPerfilalterado_em: TDateTimeField;
    cdsPerfilexcluido_em: TDateTimeField;
    cdsUsuario: TClientDataSet;
    cdsUsuarioid: TIntegerField;
    cdsUsuarionome: TStringField;
    cdsUsuarioapelido: TStringField;
    cdsUsuarioemail: TStringField;
    cdsUsuariousuario: TStringField;
    cdsUsuariosenha: TStringField;
    cdsUsuarioperfil_id: TIntegerField;
    cdsUsuarioincluido_id: TIntegerField;
    cdsUsuarioincluido_em: TDateTimeField;
    cdsUsuarioalterado_id: TIntegerField;
    cdsUsuarioalterado_em: TDateTimeField;
    cdsUsuarioexcluido_id: TIntegerField;
    cdsUsuarioexcluido_em: TDateTimeField;
    procedure DataModuleCreate(Sender: TObject);
  private
    WebSocket: TWebSocketClient;
    procedure AoReceber(W: TWebSocketClient; S: String);
  public
    { Public declarations }
  end;

var
  Dados: TDados;

implementation

uses
  System.JSON,
  System.Generics.Collections,
  Conversa.Comando,
  Conversa.Consulta;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDados.AoReceber(W: TWebSocketClient; S: String);
var
  cmdNotificacao: TComando;
begin
  cmdNotificacao := TComando.Create;
  try
    cmdNotificacao.Texto := S;
    Writeln(cmdNotificacao.Texto);
  finally
    FreeAndNil(cmdNotificacao);
  end;
end;

procedure TDados.DataModuleCreate(Sender: TObject);
begin
  WebSocket := TWebSocketClient.Create(Self);
  WebSocket.Conectar('ws://localhost:82');
  WebSocket.AoReceber(AoReceber);
  WebSocket.AoAutenticar(
    function: TJSONObject
    begin
      Result :=
        TJSONObject.Create
          .AddPair('usuario', 'eduardo')
          .AddPair('senha',   '123456');
    end
  );
  WebSocket.AoErro(
    procedure (Erro: TClass; Mensagem: String)
    begin
      if Erro = ErroAutenticar then
        raise Exception.Create(Mensagem);
    end
  );

  cdsPerfil.WSCreate(WebSocket, 'perfil');
  cdsUsuario.WSCreate(WebSocket, 'usuario');
end;

end.
