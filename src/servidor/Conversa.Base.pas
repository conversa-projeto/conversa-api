// Eduardo - 19/07/2020

unit Conversa.Base;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Conversa.Consulta,
  Conversa.Comando;

type
  TBase = class
  private
    FUsuario: Int64;
    FjaDados: TJSONArray;
    FConexao: TFDConnection;
    FQryDados: TFDQuery;
  public
    constructor Create(jaDados: TJSONArray; Conexao: TFDConnection; Usuario: Int64);
    destructor Destroy; override;
    function TabelaParaJSONObject(qry: TFDQuery): TJSONObject;
    function ObtemUsuario(iID: Int64): TJSONObject;
    property Usuario: Int64 read FUsuario write FUsuario;
    property Dados: TJSONArray read FjaDados write FjaDados;
    property Conexao: TFDConnection read FConexao write FConexao;
    property QryDados: TFDQuery read FQryDados write FQryDados;
  end;

implementation

uses
  System.StrUtils,
  Data.DB,
  System.DateUtils;

{ TBase }

constructor TBase.Create(jaDados: TJSONArray; Conexao: TFDConnection; Usuario: Int64);
begin
  FConexao := Conexao;
  FQryDados := TFDQuery.Create(nil);
  FQryDados.Connection := FConexao;
  FjaDados := TJSONArray(jaDados.Clone);
  FUsuario := Usuario;
end;

destructor TBase.Destroy;
begin
  FreeAndNil(FQryDados);
  FreeAndNil(FjaDados);
  inherited;
end;

function TBase.ObtemUsuario(iID: Int64): TJSONObject;
var
  jaUsuario: TJSONArray;
  qryUsuario: TFDQuery;
begin
  qryUsuario := TFDQuery.Create(nil);
  try
    qryUsuario.Connection := FConexao;
    jaUsuario := TJSONArray.Create;
    try
      qryUsuario.Close;
      qryUsuario.Open(
        'select * '+
        '  from usuario '+
        ' where id = '+ IntToStr(iID)
      );
      Result := TabelaParaJSONObject(qryUsuario);
    finally
      FreeAndNil(jaUsuario);
    end;
  finally
    FreeAndNil(qryUsuario);
  end;
end;

function TBase.TabelaParaJSONObject(qry: TFDQuery): TJSONObject;
var
  field: TField;
begin
  Result := TJSONObject.Create;
  for field in qry.Fields do
  begin
    if field.IsNull then
      Result.AddPair(field.FieldName, TJSONNull.Create)
    else
    if field is TStringField then
      Result.AddPair(field.FieldName, field.AsString)
    else
    if field is TNumericField then
      Result.AddPair(field.FieldName, TJSONNumber.Create(field.AsFloat))
    else
    if (field is TDateTimeField) or (field is TSQLTimeStampField) then
      Result.AddPair(field.FieldName, DateToISO8601(field.AsDateTime))
    else
      raise Exception.Create('TPerfil: Tipo do campo não esperado!'+ sLineBreak +'Campo: '+ field.FieldName);
  end;
end;

end.
