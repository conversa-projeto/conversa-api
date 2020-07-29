// Eduardo - 12/07/2020

unit Conversa.Principal;

interface

uses
  System.SysUtils,
  System.JSON,
  IdContext,
  IdCustomHTTPServer,
  Conversa.WebSocket,
  Conversa.Comando,
  Conversa.Configuracoes;

  procedure IniciarConversa;

implementation

uses
  Conversa.Dados;

procedure IniciarConversa;
var
  console: String;
  WebSocket: TWebSocketServer;
  Configuracoes: TConfiguracoes;
begin
  Configuracoes := TConfiguracoes.Create('conversa');
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

            // Cria modulo de dados, retorna e executa comando
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

    // Se não foi configurada a porta, define padrão
    if not Configuracoes.Existe['porta'] then
      Configuracoes.Numero['porta'] := 82;

    WebSocket.Porta(Round(Configuracoes.Numero['porta']));
    WebSocket.Start;

    Writeln('Servidor iniciado na porta: ', WebSocket.Porta);

    while console.IsEmpty do
      Readln(console);
  finally
    FreeAndNil(WebSocket);
    FreeAndNil(Configuracoes);
  end;
end;

end.
