// Eduardo - 09/07/2020

program Conversa;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Conversa.Dados in 'src\servidor\Conversa.Dados.pas' {ConversaDados: TDataModule},
  Conversa.WebSocket in 'src\servidor\Conversa.WebSocket.pas',
  Conversa.Comando in 'src\comum\Conversa.Comando.pas',
  Conversa.Principal in 'src\servidor\Conversa.Principal.pas',
  Conversa.Consulta in 'src\comum\Conversa.Consulta.pas',
  Conversa.Insere in 'src\comum\Conversa.Insere.pas',
  Conversa.Base in 'src\servidor\Conversa.Base.pas',
  Conversa.Perfil in 'src\servidor\Conversa.Perfil.pas',
  Conversa.Usuario in 'src\servidor\Conversa.Usuario.pas',
  Conversa.Contato in 'src\servidor\Conversa.Contato.pas',
  Conversa.MensagemEventoTipo in 'src\servidor\Conversa.MensagemEventoTipo.pas',
  Conversa.AnexoTipo in 'src\servidor\Conversa.AnexoTipo.pas',
  Conversa.ConversaTipo in 'src\servidor\Conversa.ConversaTipo.pas',
  Conversa.Conversa in 'src\servidor\Conversa.Conversa.pas',
  Conversa.ConversaUsuario in 'src\servidor\Conversa.ConversaUsuario.pas',
  Conversa.Mensagem in 'src\servidor\Conversa.Mensagem.pas',
  Conversa.MensagemEvento in 'src\servidor\Conversa.MensagemEvento.pas',
  Conversa.MensagemAnexo in 'src\servidor\Conversa.MensagemAnexo.pas';

begin
  IniciarConversa;
end.
