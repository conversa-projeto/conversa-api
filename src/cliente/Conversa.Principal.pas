// Eduardo - 21/07/2020

unit Conversa.Principal;

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
  Vcl.ValEdit,
  Conversa.Dados,
  Conversa.DataSet;

type
  TPrincipal = class(TForm)
    srcTabela: TDataSource;
    Panel1: TPanel;
    btnInserir: TButton;
    btnPostar: TButton;
    btnObter: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    dbgridTabela: TDBGrid;
    vledtTabelas: TValueListEditor;
    pnlUsuario: TPanel;
    procedure btnInserirClick(Sender: TObject);
    procedure btnObterClick(Sender: TObject);
    procedure btnPostarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure vledtTabelasClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  Principal: TPrincipal;

implementation

uses
  Conversa.Consulta;

{$R *.dfm}

procedure TPrincipal.btnObterClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSOpen;
end;

procedure TPrincipal.btnInserirClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSAppend;
end;

procedure TPrincipal.btnAlterarClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSEdit;
end;

procedure TPrincipal.btnPostarClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSPost;
end;

procedure TPrincipal.btnExcluirClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSDelete;
end;

procedure TPrincipal.vledtTabelasClick(Sender: TObject);
begin
  srcTabela.DataSet := TClientDataSet(Dados.FindComponent(vledtTabelas.Values[vledtTabelas.Keys[vledtTabelas.Row]]))
end;

procedure TPrincipal.FormShow(Sender: TObject);
begin
  vledtTabelasClick(vledtTabelas);

  Dados.cdsUsuario.WSOpen(
    TConsulta.Create
      .IgualNumero('id', Dados.WebSocket.IDUsuario)
  );
  pnlUsuario.Caption := Dados.cdsUsuario.FieldByName('nome').AsString;
  Dados.cdsUsuario.WSClose;
end;

end.
