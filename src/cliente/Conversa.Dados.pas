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
    cdsUsuario: TClientDataSet;
    cdsUsuarioid: TIntegerField;
    cdsUsuarionome: TStringField;
    cdsUsuarioapelido: TStringField;
    cdsUsuarioemail: TStringField;
    cdsUsuariousuario: TStringField;
    cdsUsuariosenha: TStringField;
    cdsUsuarioperfil_id: TIntegerField;
    cdsUsuarioincluido_id: TIntegerField;
    cdsUsuarioincluido_em: TDateTimeField;
    cdsUsuarioalterado_id: TIntegerField;
    cdsUsuarioalterado_em: TDateTimeField;
    cdsUsuarioexcluido_id: TIntegerField;
    cdsUsuarioexcluido_em: TDateTimeField;
    cdsAnexoTipo: TClientDataSet;
    cdsAnexoTipoid: TIntegerField;
    cdsAnexoTipoincluido_id: TIntegerField;
    cdsAnexoTipoincluido_em: TDateTimeField;
    cdsAnexoTipoalterado_id: TIntegerField;
    cdsAnexoTipoalterado_em: TDateTimeField;
    cdsAnexoTipoexcluido_id: TIntegerField;
    cdsAnexoTipoexcluido_em: TDateTimeField;
    cdsAnexoTipodescricao: TStringField;
    cdsContato: TClientDataSet;
    cdsContatoid: TIntegerField;
    cdsContatoincluido_id: TIntegerField;
    cdsContatoincluido_em: TDateTimeField;
    cdsContatoalterado_id: TIntegerField;
    cdsContatoalterado_em: TDateTimeField;
    cdsContatoexcluido_id: TIntegerField;
    cdsContatoexcluido_em: TDateTimeField;
    cdsContatousuario_id: TIntegerField;
    cdsContatocontato_id: TIntegerField;
    cdsContatofavorito: TIntegerField;
    cdsAnexoTipotipo: TStringField;
    cdsConversa: TClientDataSet;
    cdsConversaid: TIntegerField;
    cdsConversaincluido_id: TIntegerField;
    cdsConversaincluido_em: TDateTimeField;
    cdsConversaalterado_id: TIntegerField;
    cdsConversaalterado_em: TDateTimeField;
    cdsConversaexcluido_id: TIntegerField;
    cdsConversaexcluido_em: TDateTimeField;
    cdsConversadescricao: TStringField;
    cdsConversatipo: TIntegerField;
    cdsConversaTp: TClientDataSet;
    cdsConversaTpid: TIntegerField;
    cdsConversaTpincluido_id: TIntegerField;
    cdsConversaTpincluido_em: TDateTimeField;
    cdsConversaTpalterado_id: TIntegerField;
    cdsConversaTpalterado_em: TDateTimeField;
    cdsConversaTpexcluido_id: TIntegerField;
    cdsConversaTpexcluido_em: TDateTimeField;
    cdsConversaTpdescricao: TStringField;
    cdsConversaUsuario: TClientDataSet;
    cdsConversaUsuarioid: TIntegerField;
    cdsConversaUsuarioincluido_id: TIntegerField;
    cdsConversaUsuarioincluido_em: TDateTimeField;
    cdsConversaUsuarioalterado_id: TIntegerField;
    cdsConversaUsuarioalterado_em: TDateTimeField;
    cdsConversaUsuarioexcluido_id: TIntegerField;
    cdsConversaUsuarioexcluido_em: TDateTimeField;
    cdsConversaUsuariousuario_id: TIntegerField;
    cdsConversaUsuarioconversa_id: TIntegerField;
    cdsMensagem: TClientDataSet;
    cdsMensagemid: TIntegerField;
    cdsMensagemincluido_id: TIntegerField;
    cdsMensagemincluido_em: TDateTimeField;
    cdsMensagemalterado_id: TIntegerField;
    cdsMensagemalterado_em: TDateTimeField;
    cdsMensagemexcluido_id: TIntegerField;
    cdsMensagemexcluido_em: TDateTimeField;
    cdsMensagemmensagem_id: TIntegerField;
    cdsMensagemusuario_id: TIntegerField;
    cdsMensagemconversa_id: TIntegerField;
    cdsMensagemresposta: TIntegerField;
    cdsMensagemconfirmacao: TIntegerField;
    cdsMensagemconteudo: TBlobField;
    cdsMensagemAnexo: TClientDataSet;
    cdsMensagemAnexoid: TIntegerField;
    cdsMensagemAnexoincluido_id: TIntegerField;
    cdsMensagemAnexoincluido_em: TDateTimeField;
    cdsMensagemAnexoalterado_id: TIntegerField;
    cdsMensagemAnexoalterado_em: TDateTimeField;
    cdsMensagemAnexoexcluido_id: TIntegerField;
    cdsMensagemAnexoexcluido_em: TDateTimeField;
    cdsMensagemAnexomensagem_id: TIntegerField;
    cdsMensagemAnexotipo: TIntegerField;
    cdsMensagemAnexolocal: TStringField;
    cdsMensagemAnexotamanho: TIntegerField;
    cdsMensagemConf: TClientDataSet;
    cdsMensagemConfid: TIntegerField;
    cdsMensagemConfincluido_id: TIntegerField;
    cdsMensagemConfincluido_em: TDateTimeField;
    cdsMensagemConfalterado_id: TIntegerField;
    cdsMensagemConfalterado_em: TDateTimeField;
    cdsMensagemConfexcluido_id: TIntegerField;
    cdsMensagemConfexcluido_em: TDateTimeField;
    cdsMensagemConfusuario_id: TIntegerField;
    cdsMensagemConfmensagem_id: TIntegerField;
    cdsMensagemConfconfirmado: TDateTimeField;
    cdsMensagemEvento: TClientDataSet;
    cdsMensagemEventoid: TIntegerField;
    cdsMensagemEventoincluido_id: TIntegerField;
    cdsMensagemEventoincluido_em: TDateTimeField;
    cdsMensagemEventoalterado_id: TIntegerField;
    cdsMensagemEventoalterado_em: TDateTimeField;
    cdsMensagemEventoexcluido_id: TIntegerField;
    cdsMensagemEventoexcluido_em: TDateTimeField;
    cdsMensagemEventousuario_id: TIntegerField;
    cdsMensagemEventomensagem_id: TIntegerField;
    cdsMensagemEventotipo: TIntegerField;
    cdsMensagemEventoTp: TClientDataSet;
    cdsMensagemEventoTpid: TIntegerField;
    cdsMensagemEventoTpdescricao: TStringField;
    cdsMensagemEventoTpincluido_id: TIntegerField;
    cdsMensagemEventoTpincluido_em: TDateTimeField;
    cdsMensagemEventoTpalterado_id: TIntegerField;
    cdsMensagemEventoTpalterado_em: TDateTimeField;
    cdsMensagemEventoTpexcluido_id: TIntegerField;
    cdsMensagemEventoTpexcluido_em: TDateTimeField;
    procedure DataModuleCreate(Sender: TObject);
  private
    procedure AoReceber(W: TWebSocketClient; S: String);
  public
    WebSocket: TWebSocketClient;
    Usuario: String;
    Senha: String;
  end;

var
  Dados: TDados;

implementation

uses
  Vcl.Dialogs,
  System.JSON,
  System.Generics.Collections,
  Conversa.Comando,
  Conversa.Consulta;

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

procedure TDados.AoReceber(W: TWebSocketClient; S: String);
var
  cmdNotificacao: TComando;
begin
  cmdNotificacao := TComando.Create;
  try
    cmdNotificacao.Texto := S;
    ShowMessage(cmdNotificacao.Texto);
  finally
    FreeAndNil(cmdNotificacao);
  end;
end;

procedure TDados.DataModuleCreate(Sender: TObject);
begin
  WebSocket := TWebSocketClient.Create(Self);
  WebSocket.Conectar('ws://localhost:82');
  WebSocket.AoReceber(AoReceber);
  WebSocket.AoAutenticar(
    function: TJSONObject
    begin
      Result :=
        TJSONObject.Create
          .AddPair('usuario', Usuario)
          .AddPair('senha',   Senha);
    end
  );
  WebSocket.AoErro(
    procedure (Erro: TClass; Mensagem: String)
    begin
      if Erro = ErroAutenticar then
        raise Exception.Create(Mensagem)
      else
      if Erro = ErroReconectar then
        raise Exception.Create(Mensagem)
    end
  );

  cdsAnexoTipo.WSCreate(WebSocket,        'anexo_tipo');
  cdsContato.WSCreate(WebSocket,          'contato');
  cdsConversa.WSCreate(WebSocket,         'conversa');
  cdsConversaTp.WSCreate(WebSocket,       'conversa_tipo');
  cdsConversaUsuario.WSCreate(WebSocket,  'conversa_usuario');
  cdsMensagem.WSCreate(WebSocket,         'mensagem');
  cdsMensagemAnexo.WSCreate(WebSocket,    'mensagem_anexo');
  cdsMensagemConf.WSCreate(WebSocket,     'mensagem_confirmacao');
  cdsMensagemEvento.WSCreate(WebSocket,   'mensagem_evento');
  cdsMensagemEventoTp.WSCreate(WebSocket, 'mensagem_evento_tipo');
  cdsPerfil.WSCreate(WebSocket,           'perfil');
  cdsUsuario.WSCreate(WebSocket,          'usuario');
end;

end.
