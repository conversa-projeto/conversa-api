// Eduardo - 09/07/2020

program Cliente;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.StrUtils,
  IdTCPClient,
  System.JSON,
  System.Classes,
  IdSSLOpenSSL,
  Conversa.WebSocket in 'src\cliente\Conversa.WebSocket.pas',
  Conversa.Comando in 'src\comum\Conversa.Comando.pas',
  Conversa.Consulta in 'src\comum\Conversa.Consulta.pas';

var
  WebSocket: TWebSocketClient;
  cmdRequisicao: TComando;
  consulta: TConsulta;
begin
  WebSocket := TWebSocketClient.Create(nil);
  try
    WebSocket.Connect('ws://localhost:82');

    WebSocket.MethodReceive(
      procedure (W: TWebSocketClient; S: String)
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
      end
    );

    // Autenticação
    cmdRequisicao := TComando.Create;
    try
      cmdRequisicao.Recurso := 'acesso';
      cmdRequisicao.Metodo := 'obter';
      WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
    finally
      FreeAndNil(cmdRequisicao);
    end;

    while True do
    begin
      Readln;

      cmdRequisicao := TComando.Create;
      try
        consulta := TConsulta.Create;
        try
          cmdRequisicao.Recurso := 'arquivo.tipo';
          cmdRequisicao.Metodo := 'obter';

          consulta.EmNumero('id', [1, 2, 3]);
          consulta.Contem('descricao', '%e%');

          consulta.ParaArray(cmdRequisicao.Dados);

          WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
        finally
          FreeAndNil(consulta);
        end;
      finally
        FreeAndNil(cmdRequisicao);
      end;

      cmdRequisicao := TComando.Create;
      try
        consulta := TConsulta.Create;
        try
          cmdRequisicao.Recurso := 'mensagem';
          cmdRequisicao.Metodo := 'remover';

          consulta.IgualNumero('id', 1);

          consulta.ParaArray(cmdRequisicao.Dados);

          WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
        finally
          FreeAndNil(consulta);
        end;
      finally
        FreeAndNil(cmdRequisicao);
      end;
    end;
  finally
    FreeAndNil(WebSocket);
  end;
end.
