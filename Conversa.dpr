program Conversa;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  Conversa.Dados in 'src\servidor\Conversa.Dados.pas' {ConversaDados: TDataModule},
  Conversa.WebSocket in 'src\servidor\Conversa.WebSocket.pas',
  Conversa.Comando in 'src\servidor\Conversa.Comando.pas',
  Conversa.Principal in 'src\cliente\Conversa.Principal.pas';

begin
  IniciarConversa;
end.
