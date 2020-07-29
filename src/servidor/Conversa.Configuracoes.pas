// Eduardo - 28/07/2020

unit Conversa.Configuracoes;

interface

uses
  System.JSON;

type
  TConfiguracoes = class
  private
    FArquivo: String;
    FJSON: TJSONObject;
    function ObtemExiste(sKey: String): Boolean;
    function ObtemTexto(sKey: String): String;
    procedure DefineTexto(sKey: String; const Value: String);
    function ObtemNumero(sKey: String): Double;
    procedure DefineNumero(sKey: String; const Value: Double);
    function ObtemBooleano(sKey: String): Boolean;
    procedure DefineBooleano(sKey: String; const Value: Boolean);
    function ObtemListaTexto(sKey: String): TArray<String>;
    procedure DefineListaTexto(sKey: String; const Value: TArray<String>);
  public
    property Existe[sKey: String]: Boolean read ObtemExiste;
    property Texto[sKey: String]: String read ObtemTexto write DefineTexto;
    property Numero[sKey: String]: Double read ObtemNumero write DefineNumero;
    property Booleano[sKey: String]: Boolean read ObtemBooleano write DefineBooleano;
    property ListaTexto[sKey: String]: TArray<String> read ObtemListaTexto write DefineListaTexto;
    constructor Create(sArquivo: String);
    destructor Destroy; override;
  end;

implementation

uses
  System.SysUtils,
  System.Classes;

{ TConfig }

constructor TConfiguracoes.Create(sArquivo: String);
var
  ss: TStringStream;
begin
  FArquivo := sArquivo;
  if not FileExists(FArquivo +'.json') then
    FJSON := TJSONObject.Create
  else
  begin
    ss := TStringStream.Create;
    try
      ss.LoadFromFile(FArquivo +'.json');
      FJSON := TJSONObject(TJSONObject.ParseJSONValue(ss.DataString));
      if not Assigned(FJSON) then
        FJSON := TJSONObject.Create;
    finally
      ss.DisposeOf;
    end;
  end;
end;

destructor TConfiguracoes.Destroy;
var
  ss: TStringStream;
begin
  ss := TStringStream.Create(TJSONValue(FJSON).Format);
  try
    ss.SaveToFile(FArquivo +'.json');
  finally
    ss.DisposeOf;
  end;

  FJSON.DisposeOf;
  inherited;
end;

function TConfiguracoes.ObtemExiste(sKey: String): Boolean;
begin
  Result := Assigned(FJSON.FindValue(sKey));
end;

function TConfiguracoes.ObtemBooleano(sKey: String): Boolean;
begin
  Result := False;
  if Assigned(FJSON.FindValue(sKey)) then
    Result := TJSONBool(FJSON.GetValue(sKey)).AsBoolean;
end;

function TConfiguracoes.ObtemNumero(sKey: String): Double;
begin
  Result := 0;
  if Assigned(FJSON.FindValue(sKey)) then
    Result := TJSONNumber(FJSON.GetValue(sKey)).AsDouble;
end;

function TConfiguracoes.ObtemTexto(sKey: String): String;
begin
  if Assigned(FJSON.FindValue(sKey)) then
    Result := FJSON.GetValue(sKey).Value;
end;

function TConfiguracoes.ObtemListaTexto(sKey: String): TArray<String>;
var
  vJSON: TJSONValue;
begin
  Result := [];
  for vJSON in TJSONArray(FJSON.GetValue(sKey)) do
  begin
    SetLength(Result, Succ(Length(Result)));
    Result[Pred(Length(Result))] := TJSONString(vJSON).Value;
  end;
end;

procedure TConfiguracoes.DefineBooleano(sKey: String; const Value: Boolean);
begin
  if Assigned(FJSON.GetValue(sKey)) then
    FJSON.RemovePair(sKey).Free;
  FJSON.AddPair(sKey, TJSONBool.Create(Value));
end;

procedure TConfiguracoes.DefineNumero(sKey: String; const Value: Double);
begin
  if Assigned(FJSON.GetValue(sKey)) then
    FJSON.RemovePair(sKey).Free;
  FJSON.AddPair(sKey, TJSONNumber.Create(Value));
end;

procedure TConfiguracoes.DefineTexto(sKey: String; const Value: String);
begin
  if Assigned(FJSON.GetValue(sKey)) then
    FJSON.RemovePair(sKey).Free;
  FJSON.AddPair(sKey, Value);
end;

procedure TConfiguracoes.DefineListaTexto(sKey: String; const Value: TArray<String>);
var
  sItem: String;
  aJSON: TJSONArray;
begin
  if Assigned(FJSON.GetValue(sKey)) then
    FJSON.RemovePair(sKey).Free;

  aJSON := TJSONArray.Create;
  FJSON.AddPair(sKey, aJSON);

  for sItem in Value do
    aJSON.Add(sItem);
end;

end.
