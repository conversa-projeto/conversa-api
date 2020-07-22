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
  Conversa.Dados;

type
  TConversaVCL = class(TForm)
    srcPerfil: TDataSource;
    pgcConversa: TPageControl;
    tshPerfil: TTabSheet;
    dbgridPerfil: TDBGrid;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ConversaVCL: TConversaVCL;

implementation

{$R *.dfm}

end.
