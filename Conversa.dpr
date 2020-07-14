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
  Conversa.Insere in 'src\comum\Conversa.Insere.pas';

begin
  IniciarConversa;
end.
