// Eduardo - 21/07/2020

program Cliente;

uses
  Vcl.Forms,
  Conversa.Principal in 'Conversa.Principal.pas' {Principal},
  Conversa.Dados in 'Conversa.Dados.pas' {Dados: TDataModule},
  Conversa.Consulta in '..\comum\Conversa.Consulta.pas',
  Conversa.Comando in '..\comum\Conversa.Comando.pas',
  Conversa.Autenticacao in 'Conversa.Autenticacao.pas' {Autenticacao};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDados, Dados);
  if TAutenticacao.Autentica then
    Application.CreateForm(TPrincipal, Principal);
  Application.Run;
end.
