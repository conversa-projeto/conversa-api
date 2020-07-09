program Servidor;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  IdCustomHTTPServer,
  IdContext,
  System.JSON,
  Conversa.Dados in 'src\servidor\Conversa.Dados.pas' {ConversaDados: TDataModule},
  WebSocket.Server in 'src\servidor\WebSocket.Server.pas';

var
  WebSocket: TWebSocketServer;
  sBuff: String;
begin
  WebSocket := TWebSocketServer.Create;
  try
    WebSocket.MethodReceive(
      procedure(Context: TIdContext; sText: String)
      begin
        Writeln(sText);
        WebSocket.Send(Context, 'OK');
      end
    );

    WebSocket.Port(82);
    WebSocket.Start;

    while True do
    begin
      ReadLn(sBuff);
      WebSocket.SendAll(sBuff);
    end;
  finally
    FreeAndNil(WebSocket);
  end;
end.
