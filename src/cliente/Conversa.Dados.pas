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
    procedure DataModuleCreate(Sender: TObject);
  private
    WebSocket: TWebSocketClient;
    procedure Autenticacao;
    procedure AoReceber(W: TWebSocketClient; S: String);
  public
    { Public declarations }
  end;

var
  Dados: TDados;

implementation

uses
  System.JSON,
  Conversa.Comando,
  Conversa.Consulta;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDados.Autenticacao;
var
  cmdRequisicao: TComando;
begin
  // Autenticação
  cmdRequisicao := TComando.Create;
  try
    cmdRequisicao.Recurso := 'autenticacao';
    cmdRequisicao.Dados.AddElement(
      TJSONObject.Create
        .AddPair('usuario', 'eduardo')
        .AddPair('senha',   '123456')
    );
    WebSocket.SendWait(cmdRequisicao.Texto);
  finally
    FreeAndNil(cmdRequisicao);
  end;
end;

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
  WebSocket.Connect('ws://localhost:82');
  WebSocket.MethodReceive(AoReceber);

  Autenticacao;

  cdsPerfil
    .WSCreate
    .WSSetGet(
      function (consulta: TConsulta): TJSONArray
      var
        cmdRequisicao: TComando;
        cmdRetorno: TComando;
      begin
        cmdRequisicao := TComando.Create;
        try
          cmdRequisicao.Recurso := 'perfil.obter';
          consulta.ParaArray(cmdRequisicao.Dados);
          cmdRetorno := TComando.Create(WebSocket.SendWait(cmdRequisicao.Texto));
          try
            Result := TJSONArray(cmdRetorno.Dados.Clone);
          finally
            FreeAndNil(cmdRetorno);
          end;
        finally
          FreeAndNil(cmdRequisicao);
        end;
      end
    );

  cdsPerfil.WSOpen(
    TConsulta.Create
      .EmNumero('id', [1, 2, 3])
      .Contem('descricao', '%a%')
  );
end;

end.
