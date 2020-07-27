// Eduardo - 26/07/2020

unit Conversa.Autenticacao;

interface

uses
  Winapi.Windows,
  Winapi.Messages,
  System.SysUtils,
  System.Variants,
  System.Classes,
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Forms,
  Vcl.Dialogs,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Vcl.Buttons;

type
  TAutenticacao = class(TForm)
    lbUsuario: TLabel;
    edtUsuario: TEdit;
    lbSenha: TLabel;
    edtSenha: TEdit;
    lbC: TLabel;
    sbtAcessar: TSpeedButton;
    sbtCancelar: TSpeedButton;
    procedure sbtAcessarClick(Sender: TObject);
    procedure sbtCancelarClick(Sender: TObject);
    procedure edtSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  public
    Autenticado: Boolean;
    class function Autentica: Boolean;
  end;

implementation

uses
  Conversa.Dados,
  Conversa.Principal;

{$R *.dfm}

class function TAutenticacao.Autentica: Boolean;
begin
  with TAutenticacao.Create(nil) do
  try
    ShowModal;
    Result := Autenticado;
  finally
    Free;
  end;
end;

procedure TAutenticacao.edtSenhaKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = VK_RETURN then
    sbtAcessarClick(sbtAcessar);
end;

procedure TAutenticacao.sbtAcessarClick(Sender: TObject);
begin
  Dados.Usuario := edtUsuario.Text;
  Dados.Senha := edtSenha.Text;
  Dados.WebSocket.Autenticacao;
  Autenticado := True;
  Close;
end;

procedure TAutenticacao.sbtCancelarClick(Sender: TObject);
begin
  Autenticado := False;
  Close;
end;

end.
