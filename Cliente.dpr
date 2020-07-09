program Cliente;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.StrUtils,
  IdTCPClient,
  System.Classes,
  IdSSLOpenSSL,
  WebSocket.Client in 'src\cliente\WebSocket.Client.pas';

var
  WebSocket: TWebSocketClient;
  sBuff: String;
begin
  WebSocket := TWebSocketClient.Create(nil);
  try
    WebSocket.Connect('ws://localhost:82');

    WebSocket.MethodReceive(
      procedure (W: TWebSocketClient; S: String)
      begin
        Writeln(S);
      end
    );

    while True do
    begin
      Readln(sBuff);
      Writeln(WebSocket.SendWait(sBuff));
    end;
  finally
    FreeAndNil(WebSocket);
  end;
end.
