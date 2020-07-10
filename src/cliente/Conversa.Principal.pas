unit Conversa.Principal;

interface

uses
  System.SysUtils,
  System.JSON,
  IdContext,
  IdCustomHTTPServer,
  Conversa.WebSocket,
  Conversa.Comando;

  procedure IniciarConversa;

implementation

uses
  Conversa.Dados;

procedure IniciarConversa;
var
  WebSocket: TWebSocketServer;
begin
  WebSocket := TWebSocketServer.Create;
  try
    WebSocket.MethodReceive(
      procedure(Context: TIdContext; sText: String)
      var
        cmdRequisicao: TComando;
        cmdResposta: TComando;
      begin
        cmdResposta := TComando.Create;
        try
          cmdRequisicao := TComando.Create;
          try
            try
              cmdRequisicao.Text := sText;
              TConversaDados.CriarDados;
              ConversaDados.ExecutaComando(cmdRequisicao, cmdResposta);
              cmdResposta.Recurso := cmdRequisicao.Recurso;
              cmdResposta.Metodo  := cmdRequisicao.Metodo;
            finally
              WebSocket.Send(Context, cmdResposta.AsString);
            end;
          finally
            FreeAndNil(cmdRequisicao);
          end;
        finally
          FreeAndNil(cmdResposta);
        end;
      end
    );

    WebSocket.Port(82);
    WebSocket.Start;

    while True do
      Readln;
  finally
    FreeAndNil(WebSocket);
  end;
end;

end.
