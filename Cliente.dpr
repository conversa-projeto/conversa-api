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
  joInsere: TJSONObject;
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
      cmdRequisicao.Recurso := 'autenticacao';
      cmdRequisicao.Metodo := 'obter';
      cmdRequisicao.Dados.AddElement(
        TJSONObject.Create
          .AddPair('usuario', 'eduardo')
          .AddPair('senha',   '123456')
      );
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
        joInsere := TJSONObject.Create;
        try
          cmdRequisicao.Recurso := 'arquivo.tipo';
          cmdRequisicao.Metodo := 'criar';

          cmdRequisicao.Dados.Add(
            TJSONObject.Create.AddPair(
              'pai',
              TJSONArray.Create.Add(
                TJSONObject.Create
                  .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-1)))
                  .AddPair('descricao', 'pai')
              ).Add(
                TJSONObject.Create
                  .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-2)))
                  .AddPair('descricao', 'mae')
              )
            )
          ).Add(
            TJSONObject.Create.AddPair(
              'filha',
              TJSONArray.Create.Add(
                TJSONObject.Create
                  .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-3)))
                  .AddPair('pai_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-1)))
                  .AddPair('descricao', 'filha')
              ).Add(
                TJSONObject.Create
                  .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-4)))
                  .AddPair('pai_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-2)))
                  .AddPair('descricao', 'filho')
              )
            )
          ).Add(
            TJSONObject.Create.AddPair(
              'neta',
              TJSONArray.Create.Add(
                TJSONObject.Create
                  .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-5)))
                  .AddPair('filha_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-3)))
                  .AddPair('descricao', 'neto')
              ).Add(
                TJSONObject.Create
                  .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-6)))
                  .AddPair('filha_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-3)))
                  .AddPair('descricao', 'netinho')
              ).Add(
                TJSONObject.Create
                  .AddPair('id', TJSONObject.Create.AddPair('primaria', TJSONNumber.Create(-7)))
                  .AddPair('filha_id', TJSONObject.Create.AddPair('estrangeira', TJSONNumber.Create(-4)))
                  .AddPair('descricao', 'netao')
              )
            )
          );

          WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
        finally
          FreeAndNil(joInsere);
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
