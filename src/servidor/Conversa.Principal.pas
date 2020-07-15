// Eduardo - 12/07/2020

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
    WebSocket.AoReceber(
      procedure(Contexto: TIdContext; sTexto: String)
      var
        cmdRequisicao: TComando;
        cmdResposta: TComando;
      begin
        try
          try
            // Converte o texto da requisição no objeto
            cmdRequisicao := TComando.Create(sTexto);

            // Cria a resposta com cabeçalho da requisição
            cmdResposta := TComando.Create(cmdRequisicao);

            // Cria modulo, retorna e executa comando
            TConversaDados.Dados(Contexto).Redireciona(WebSocket, cmdRequisicao, cmdResposta);
          except on E: Exception do
            begin
              cmdResposta.Erro.Classe   := E.ClassName;
              cmdResposta.Erro.Mensagem := E.Message;

              // Retorna o erro
              WebSocket.Send(Contexto, cmdResposta.Texto);
            end;
          end;
        finally
          FreeAndNil(cmdRequisicao);
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
