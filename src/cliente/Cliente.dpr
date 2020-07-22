// Eduardo - 21/07/2020

program Cliente;

uses
  Vcl.Forms,
  Conversa.VCL in 'Conversa.VCL.pas' {ConversaVCL},
  Conversa.Dados in 'Conversa.Dados.pas' {Dados: TDataModule},
  Conversa.Consulta in '..\comum\Conversa.Consulta.pas',
  Conversa.Comando in '..\comum\Conversa.Comando.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDados, Dados);
  Application.CreateForm(TConversaVCL, ConversaVCL);
  Application.Run;
end.
