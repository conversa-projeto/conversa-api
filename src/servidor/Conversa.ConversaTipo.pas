// Eduardo - 20/07/2020

unit Conversa.ConversaTipo;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Generics.Collections,
  FireDAC.Comp.Client,
  Conversa.Consulta,
  Conversa.Comando,
  Conversa.Base;

type
  TConversaTipo = class(TBase)
  public
    function Incluir: TJSONObject;
    procedure Obter(var jaSaida: TJSONArray);
    function Alterar: TJSONObject;
    function Excluir: TJSONObject;

    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
  end;

implementation

uses
  System.StrUtils,
  Data.DB,
  System.DateUtils;

{ TConversaTipo }

class procedure TConversaTipo.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
const
  RotaConversaTipo: Array[0..3] of String = ('conversa_tipo.incluir', 'conversa_tipo.obter', 'conversa_tipo.alterar', 'conversa_tipo.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaConversaTipo) of
    0,1,2,3:
    begin
      with TConversaTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaConversaTipo) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            Obter(jaDados);
          end;
          2: cmdResposta.Dados.AddElement(Alterar);
          3: cmdResposta.Dados.AddElement(Excluir);
        end;
      finally
        Free;
      end;
    end;
  end;
end;

function TConversaTipo.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into conversa_tipo '+
    '     ( descricao '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].descricao')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );
  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt));
end;

procedure TConversaTipo.Obter(var jaSaida: TJSONArray);
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
      '  from conversa_tipo '+
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

function TConversaTipo.Alterar: TJSONObject;
var
  I: Integer;
begin
  QryDados.Close;
  QryDados.Open(
    'select * '+
    '  from conversa_tipo '+
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

function TConversaTipo.Excluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'select * '+
    '  from conversa_tipo '+
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

  QryDados.Edit;
  QryDados.FieldByName('excluido_id').AsLargeInt := Usuario;
  QryDados.FieldByName('excluido_em').AsDateTime := Now;
  QryDados.Post;

  Result := TJSONObject.Create;
end;

end.
