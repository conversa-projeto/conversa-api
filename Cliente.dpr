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

      {$Region' Incluir perfil '}
//      cmdRequisicao := TComando.Create;
//      try
//        cmdRequisicao.Recurso := 'perfil.incluir';
//        cmdRequisicao.Dados
//          .AddElement(TJSONObject.Create
//            .AddPair('descricao', 'Desenvolvedor')
//        );
//        WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
//      finally
//        FreeAndNil(cmdRequisicao);
//      end;
//
//      cmdRequisicao := TComando.Create;
//      try
//        cmdRequisicao.Recurso := 'perfil.incluir';
//        cmdRequisicao.Dados
//          .AddElement(TJSONObject.Create
//            .AddPair('descricao', 'Administrador')
//        );
//        WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
//      finally
//        FreeAndNil(cmdRequisicao);
//      end;
//
//      cmdRequisicao := TComando.Create;
//      try
//        cmdRequisicao.Recurso := 'perfil.incluir';
//        cmdRequisicao.Dados
//          .AddElement(TJSONObject.Create
//            .AddPair('descricao', 'Usuario')
//        );
//        WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
//      finally
//        FreeAndNil(cmdRequisicao);
//      end;
//
//      cmdRequisicao := TComando.Create;
//      try
//        cmdRequisicao.Recurso := 'perfil.incluir';
//        cmdRequisicao.Dados
//          .AddElement(TJSONObject.Create
//            .AddPair('descricao', 'Colaborador')
//        );
//        WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
//      finally
//        FreeAndNil(cmdRequisicao);
//      end;
      {$EndRegion}

      {$Region' Obter '}
//      cmdRequisicao := TComando.Create;
//      try
//        consulta := TConsulta.Create;
//        try
//          cmdRequisicao.Recurso := 'perfil.obter';
//          consulta.EmNumero('id', [1, 2, 3]);
//          consulta.Contem('descricao', '%a%');
//          consulta.ParaArray(cmdRequisicao.Dados);
//          WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
//        finally
//          FreeAndNil(consulta);
//        end;
//      finally
//        FreeAndNil(cmdRequisicao);
//      end;

      cmdRequisicao := TComando.Create;
      try
        consulta := TConsulta.Create;
        try
          cmdRequisicao.Recurso := 'perfil.obter';
          WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
        finally
          FreeAndNil(consulta);
        end;
      finally
        FreeAndNil(cmdRequisicao);
      end;
      {$EndRegion}

      {$Region' Alterar '}
//      cmdRequisicao := TComando.Create;
//      try
//        cmdRequisicao.Recurso := 'perfil.alterar';
//        cmdRequisicao.Dados
//          .AddElement(
//            TJSONObject.Create
//              .AddPair('id', TJSONNumber.Create(2))
//              .AddPair('descricao', 'Desenvolvedor I')
//        );
//        WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
//      finally
//        FreeAndNil(cmdRequisicao);
//      end;
      {$EndRegion}

      {$Region' Excluir '}
//      cmdRequisicao := TComando.Create;
//      try
//        cmdRequisicao.Recurso := 'perfil.excluir';
//        cmdRequisicao.Dados.AddElement(TJSONObject.Create.AddPair('id', TJSONNumber.Create(1)));
//        WriteLn(WebSocket.SendWait(cmdRequisicao.Texto));
//      finally
//        FreeAndNil(cmdRequisicao);
//      end;
      {$EndRegion}
    end;
  finally
    FreeAndNil(WebSocket);
  end;
end.
