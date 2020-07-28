// Eduardo - 28/07/2020

unit Conversa.Configuracoes;

interface

uses
  System.JSON;

type
  TConfiguracoes = class
    FDados: TJSONObject;
    FArquivo: String;
  public
    constructor Create(sArquivo: String);
    destructor Destroy; override;
    property Dados: TJSONObject read FDados write FDados;
  end;

implementation

uses
  System.SysUtils,
  System.Classes;

{ TConfiguracoes }

constructor TConfiguracoes.Create(sArquivo: String);
var
  sl: TStringStream;
begin
  FArquivo := sArquivo;
  if FileExists(FArquivo) then
  begin
    sl := TStringStream.Create;
    try
      sl.LoadFromFile(FArquivo);
      if not sl.DataString.IsEmpty then
        FDados := TJSONObject(TJSONObject.ParseJSONValue(sl.DataString));
    finally
      FreeAndNil(sl);
    end;
  end;
end;

destructor TConfiguracoes.Destroy;
var
  sl: TStringStream;
begin
  sl := TStringStream.Create(FDados.Format);
  try
    sl.SaveToFile(FArquivo);
  finally
    FreeAndNil(sl);
  end;
  FreeAndNil(FDados);
  inherited;
end;

end.
