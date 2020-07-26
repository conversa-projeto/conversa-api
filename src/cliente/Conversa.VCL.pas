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
  Vcl.ValEdit,
  Conversa.Dados,
  Conversa.DataSet;

type
  TConversaVCL = class(TForm)
    srcTabela: TDataSource;
    Panel1: TPanel;
    btnInserir: TButton;
    btnPostar: TButton;
    btnObter: TButton;
    btnAlterar: TButton;
    btnExcluir: TButton;
    dbgridTabela: TDBGrid;
    vledtTabelas: TValueListEditor;
    procedure btnInserirClick(Sender: TObject);
    procedure btnObterClick(Sender: TObject);
    procedure btnPostarClick(Sender: TObject);
    procedure btnAlterarClick(Sender: TObject);
    procedure btnExcluirClick(Sender: TObject);
    procedure vledtTabelasClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  end;

var
  ConversaVCL: TConversaVCL;

implementation

uses
  Conversa.Consulta;

{$R *.dfm}

procedure TConversaVCL.btnObterClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSOpen;
end;

procedure TConversaVCL.btnInserirClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSAppend;
end;

procedure TConversaVCL.btnAlterarClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSEdit;
end;

procedure TConversaVCL.btnPostarClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSPost;
end;

procedure TConversaVCL.btnExcluirClick(Sender: TObject);
begin
  TClientDataSet(srcTabela.DataSet).WSDelete;
end;

procedure TConversaVCL.vledtTabelasClick(Sender: TObject);
begin
  srcTabela.DataSet := TClientDataSet(Dados.FindComponent(vledtTabelas.Values[vledtTabelas.Keys[vledtTabelas.Row]]))
end;

procedure TConversaVCL.FormShow(Sender: TObject);
begin
  vledtTabelasClick(vledtTabelas);
end;

end.
