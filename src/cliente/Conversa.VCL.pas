// Eduardo - 21/07/2020

unit Conversa.VCL;

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
  Data.DB,
  Datasnap.DBClient,
  Vcl.Grids,
  Vcl.DBGrids,
  Vcl.ComCtrls,
  Vcl.StdCtrls,
  Vcl.ExtCtrls,
  Conversa.Dados,
  Conversa.DataSet;

type
  TConversaVCL = class(TForm)
    srcPerfil: TDataSource;
    pgcConversa: TPageControl;
    tshPerfil: TTabSheet;
    dbgridPerfil: TDBGrid;
    Panel1: TPanel;
    btnInserir: TButton;
    Button2: TButton;
    btnObter: TButton;
    Button1: TButton;
    Button3: TButton;
    tshUsuario: TTabSheet;
    DBGrid1: TDBGrid;
    srcUsuario: TDataSource;
    procedure btnInserirClick(Sender: TObject);
    procedure btnObterClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure pgcConversaChange(Sender: TObject);
  private
    FDataSet: TClientDataSet;
  public
    { Public declarations }
  end;

var
  ConversaVCL: TConversaVCL;

implementation

uses
  Conversa.Consulta;

{$R *.dfm}

procedure TConversaVCL.btnObterClick(Sender: TObject);
begin
  FDataSet.WSOpen;
end;

procedure TConversaVCL.btnInserirClick(Sender: TObject);
begin
  FDataSet.WSAppend;
end;

procedure TConversaVCL.Button1Click(Sender: TObject);
begin
  FDataSet.WSEdit;
end;

procedure TConversaVCL.Button2Click(Sender: TObject);
begin
  FDataSet.WSPost;
end;

procedure TConversaVCL.Button3Click(Sender: TObject);
begin
  FDataSet.WSDelete;
end;

procedure TConversaVCL.pgcConversaChange(Sender: TObject);
begin
  case pgcConversa.ActivePageIndex of
    0: FDataSet := Dados.cdsPerfil;
    1: FDataSet := Dados.cdsUsuario;
  end;
end;

end.
