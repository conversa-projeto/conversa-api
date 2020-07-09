program Conversa;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  IdCustomHTTPServer,
  IdContext,
  System.JSON,
  Conversa.Dados in 'src\servidor\Conversa.Dados.pas' {ConversaDados: TDataModule},
  Conversa.WebSocket in 'src\servidor\Conversa.WebSocket.pas';

var
  WebSocket: TWebSocketServer;
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
  finally
    FreeAndNil(WebSocket);
  end;
end.
