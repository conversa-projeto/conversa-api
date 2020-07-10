unit Conversa.Dados;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.DateUtils,
  System.Generics.Collections,
  Data.DB,
  FireDAC.Stan.Intf,
  FireDAC.Stan.Option,
  FireDAC.Stan.Error,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.Stan.Def,
  FireDAC.Stan.Pool,
  FireDAC.Stan.Async,
  FireDAC.Phys,
  FireDAC.Phys.MySQL,
  FireDAC.Phys.MySQLDef,
  FireDAC.FMXUI.Wait,
  FireDAC.Stan.Param,
  FireDAC.DatS,
  FireDAC.DApt.Intf,
  FireDAC.DApt,
  FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,
  Conversa.Comando;

type
  TConversaDados = class(TDataModule)
    conMariaDB: TFDConnection;
    qryUsuario: TFDQuery;
    qryUsuarioid: TFDAutoIncField;
    qryUsuarionome: TStringField;
    qryUsuarioapelido: TStringField;
    qryUsuarioemail: TStringField;
    qryUsuariousuario: TStringField;
    qryUsuariosenha: TStringField;
    qryMensagemStatus: TFDQuery;
    qryMensagemStatusid: TFDAutoIncField;
    qryMensagemStatusdescricao: TStringField;
    qryMensagemArquivo: TFDQuery;
    qryMensagemArquivoid: TFDAutoIncField;
    qryMensagemArquivomensagem_id: TIntegerField;
    qryMensagemArquivoarquivo_id: TIntegerField;
    qryMensagem: TFDQuery;
    qryMensagemid: TFDAutoIncField;
    qryMensagemconversa_id: TIntegerField;
    qryMensagemusuario_id: TIntegerField;
    qryMensagemstatus2: TIntegerField;
    qryMensagemconfirmacao: TIntegerField;
    qryMensagemconteudo: TStringField;
    qryConversaUsuario: TFDQuery;
    qryConversaUsuarioid: TFDAutoIncField;
    qryConversaUsuariousuario_id: TIntegerField;
    qryConversaUsuarioconversa_id: TIntegerField;
    qryConversaTipo: TFDQuery;
    qryConversaTipoid: TFDAutoIncField;
    qryConversaTipodescricao: TStringField;
    qryConversa: TFDQuery;
    qryConversaid: TFDAutoIncField;
    qryConversadescricao: TStringField;
    qryConversatipo2: TIntegerField;
    qryContato: TFDQuery;
    qryContatoid: TFDAutoIncField;
    qryContatousuario_id: TIntegerField;
    qryContatocontato_id: TIntegerField;
    qryArquivoTipo: TFDQuery;
    qryArquivoTipoid: TFDAutoIncField;
    qryArquivoTipodescricao: TStringField;
    qryArquivo: TFDQuery;
    qryArquivoid: TFDAutoIncField;
    qryArquivoarquivo: TStringField;
    qryArquivotipo2: TIntegerField;
    qryArquivotamanho: TIntegerField;
  private
    function TabelaParaJSONArray(qry: TFDQuery): TJSONArray;
    function TabelaParaJSONObject(qry: TFDQuery): TJSONObject;
    function ObterUsuario(iID: Integer): TJSONObject;
  public
    class procedure CriarDados;
    procedure ExecutaComando(const cmdRequisicao: TComando; var cmdResposta: TComando);
  end;

threadvar
  ConversaDados: TConversaDados;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

uses
  System.StrUtils;

class procedure TConversaDados.CriarDados;
begin
  if not Assigned(ConversaDados) then
    ConversaDados := TConversaDados.Create(nil);
end;

procedure TConversaDados.ExecutaComando(const cmdRequisicao: TComando; var cmdResposta: TComando);
begin
  if cmdRequisicao.Recurso.Equals('usuario') and cmdRequisicao.Metodo.Equals('obter') then
  begin
    if cmdRequisicao.Dados.Count = 0 then
      raise Exception.Create('Informe o ID do usuário para obte-lo!');
    cmdResposta.Dados.AddElement(ObterUsuario(StrToInt(cmdRequisicao.Dados.Items[0].Value)));
  end;
end;

function TConversaDados.ObterUsuario(iID: Integer): TJSONObject;
var
  sSQL: String;
begin
  sSQL := qryUsuario.SQL.Text;
  qryUsuario.Open(sSQL +' where id = '+ IntToStr(iID));
  Result := TabelaParaJSONObject(qryUsuario);
  qryUsuario.Close;
  qryUsuario.SQL.Text := sSQL;
end;

function TConversaDados.TabelaParaJSONObject(qry: TFDQuery): TJSONObject;
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
      raise Exception.Create(Self.Name +': Tipo do campo não esperado!'+ sLineBreak +'Campo: '+ field.FieldName);
  end;
end;

function TConversaDados.TabelaParaJSONArray(qry: TFDQuery): TJSONArray;
begin
  Result := TJSONArray.Create;
  qry.First;
  while not qry.Eof do
  begin
    Result.AddElement(TabelaParaJSONObject(qry));
    qry.Next;
  end;
end;

end.
