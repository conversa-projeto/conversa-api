// Eduardo - 19/07/2020

unit Conversa.Base;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Conversa.Consulta,
  Data.DB;

type
  TBase = class
  private
    FUsuario: Int64;
    FjaDados: TJSONArray;
    FConexao: TFDConnection;
    FQryDados: TFDQuery;
    FIDTabela: Int64;
  public
    constructor Create(jaDados: TJSONArray; Conexao: TFDConnection; Usuario: Int64);
    destructor Destroy; override;
    function TabelaParaJSONObject(qry: TFDQuery): TJSONObject;
    function ObtemUsuario(iID: Int64): TJSONObject;
    procedure ObterBase(sTabela: String; var jaSaida: TJSONArray);
    function AlterarBase(sTabela: String): TJSONObject;
    function ExcluirBase(sTabela: String): TJSONObject;
    procedure Envolvidos(var aiEnvolvidos: TArray<Int64>; const sConsulta: String);
    property Usuario: Int64 read FUsuario write FUsuario;
    property Dados: TJSONArray read FjaDados write FjaDados;
    property Conexao: TFDConnection read FConexao write FConexao;
    property QryDados: TFDQuery read FQryDados write FQryDados;
    property Identificador: Int64 read FIDTabela write FIDTabela;
  end;

implementation

uses
  System.StrUtils,
  System.DateUtils,
  System.NetEncoding;

{ TBase }

constructor TBase.Create(jaDados: TJSONArray; Conexao: TFDConnection; Usuario: Int64);
begin
  FConexao := Conexao;
  FQryDados := TFDQuery.Create(nil);
  FQryDados.Connection := FConexao;
  FjaDados := TJSONArray(jaDados.Clone);
  FUsuario := Usuario;
  Identificador := -1;
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
    if field is TBlobField then
      Result.AddPair(field.FieldName, TEncoding.UTF8.GetString(TBlobField(field).AsBytes))
    else
      raise Exception.Create('TBase: Tipo do campo não esperado!'+ sLineBreak +'Campo: '+ field.FieldName);
  end;
end;

procedure TBase.ObterBase(sTabela: String; var jaSaida: TJSONArray);
var
  consulta: TConsulta;
  sTexto: String;
begin
  consulta := TConsulta.Create(Dados);
  try
    sTexto := consulta.Texto;
    QryDados.Close;
    QryDados.Open(
      'select * '+
      '  from '+ sTabela +
      ' where excluido_id is null '+
      IfThen(not sTexto.IsEmpty, '   and '+ sTexto)
    );
    QryDados.First;
    while not QryDados.Eof do
    begin
      jaSaida.AddElement(TabelaParaJSONObject(QryDados));
      QryDados.Next;
    end;
  finally
    FreeAndNil(consulta);
  end;
end;

function TBase.AlterarBase(sTabela: String): TJSONObject;
var
  I: Integer;
begin
  QryDados.Close;
  QryDados.Open(
    'select * '+
    '  from '+ sTabela +
    ' where id = '+ QuotedStr(Dados.GetValue<String>('[0].id'))
  );

  if QryDados.IsEmpty then
    raise Exception.Create('Erro ao localizar o registro para exclusão!');

  if not QryDados.FieldByName('excluido_id').IsNull then
  begin
    with ObtemUsuario(QryDados.FieldByName('excluido_id').AsInteger) do
    try
      raise Exception.Create('Registro já excluido por "'+ GetValue('apelido').Value +'" em "'+ QryDados.FieldByName('excluido_em').AsString +'"!');
    finally
      Free;
    end;
  end;

  Identificador := Dados.GetValue<Int64>('[0].id');

  QryDados.Edit;

  with TJSONObject(Dados.Items[0]) do
  begin
    for I := 0 to Pred(Count) do
    begin
      if MatchStr(Pairs[I].JsonString.Value, ['id', 'incluido_id', 'incluido_em', 'alterado_id', 'alterado_em', 'excluido_id', 'excluido_em']) then
        Continue
      else
      if Pairs[I].JsonValue is TJSONString then
        QryDados.FieldByName(Pairs[I].JsonString.Value).AsString := TJSONString(Pairs[I].JsonValue).Value
      else
      if Pairs[I].JsonValue is TJSONNumber then
        QryDados.FieldByName(Pairs[I].JsonString.Value).AsFloat := TJSONNumber(Pairs[I].JsonValue).AsDouble
      else
      if Pairs[I].JsonValue is TJSONBool then
        QryDados.FieldByName(Pairs[I].JsonString.Value).AsBoolean := TJSONBool(Pairs[I].JsonValue).AsBoolean
      else
      if Pairs[I].JsonValue is TJSONNull then
        QryDados.FieldByName(Pairs[I].JsonString.Value).Clear
    end;
  end;

  QryDados.FieldByName('alterado_id').AsLargeInt := Usuario;
  QryDados.FieldByName('alterado_em').AsDateTime := Now;
  QryDados.Post;

  Result := TJSONObject.Create;
end;

function TBase.ExcluirBase(sTabela: String): TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'select * '+
    '  from '+ sTabela +
    ' where id = '+ QuotedStr(Dados.GetValue<String>('[0].id'))
  );

  if QryDados.IsEmpty then
    raise Exception.Create('Erro ao localizar o registro para exclusão!');

  if not QryDados.FieldByName('excluido_id').IsNull then
  begin
    with ObtemUsuario(QryDados.FieldByName('excluido_id').AsInteger) do
    try
      raise Exception.Create('Registro já excluido por "'+ GetValue('apelido').Value +'" em "'+ QryDados.FieldByName('excluido_em').AsString +'"!');
    finally
      Free;
    end;
  end;

  Identificador := Dados.GetValue<Int64>('[0].id');

  QryDados.Edit;
  QryDados.FieldByName('excluido_id').AsLargeInt := Usuario;
  QryDados.FieldByName('excluido_em').AsDateTime := Now;
  QryDados.Post;

  Result := TJSONObject.Create;
end;

procedure TBase.Envolvidos(var aiEnvolvidos: TArray<Int64>; const sConsulta: String);
begin
  if Identificador = - 1 then
    Exit;
  QryDados.Close;
  QryDados.Open(sConsulta + IntToStr(Identificador));
  if QryDados.IsEmpty then
    Exit;
  SetLength(aiEnvolvidos, QryDados.RecordCount);
  while not QryDados.Eof do
  begin
    aiEnvolvidos[Pred(QryDados.RecNo)] := QryDados.FieldByName('usuario_id').AsLargeInt;
    QryDados.Next;
  end;
end;

end.
