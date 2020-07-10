// Eduardo - 09/07/2020
(*
   - Exemplo de uma chamada do cliente para o servidor ou do servidor para o cliente
{
  "recurso": "conversa.mensagem", // (classe, tabela, diretorio) local do recurso - obrigatorio
  "metodo": "obter",              // (criar, obter, alterar, remover) acao solicitada - obrigatorio
  "dados": [1, 2, 3]              // lista dos dados da requisicao - opcional
}

   - Toda requisição do cliente para o servidor deve haver uma resposta
   - Nenhuma requisição do servidor ao cliente deve ter resposta
{
  "recurso": "conversa.mensagem", // (classe, tabela, diretorio) local do recurso que foi solicitado - obrigatorio
  "metodo": "obter",              // (criar, obter, alterar, remover) acao executada - obrigatorio
  "dados": [3, 2, 1]              // lista dos dados da resposta - opcional
}
*)

unit Conversa.Comando;

interface

uses
  System.JSON,
  System.SysUtils,
  System.Generics.Collections;

type
  TComando = class
  private
    FjaDados: TJSONArray;
    FText: String;
    FRecurso: String;
    FMetodo: String;
    function GetString: String;
    procedure SetText(const Value: String);
  public
    property Text: String read FText write SetText;
    property AsString: String read GetString;
    property Recurso: String read FRecurso write FRecurso;
    property Metodo: String read FMetodo write FMetodo;
    property Dados: TJSONArray read FjaDados;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

{ TProtocolo }

constructor TComando.Create;
begin
  FjaDados := TJSONArray.Create;
  FText := EmptyStr;
end;

destructor TComando.Destroy;
begin
  if Assigned(FjaDados) then
    FreeAndNil(FjaDados);
  inherited;
end;

function TComando.GetString: String;
var
  joComando: TJSONObject;
begin
  joComando := TJSONObject.Create;
  try
    joComando.AddPair('recurso', FRecurso);
    joComando.AddPair('metodo',  FMetodo);
    joComando.AddPair('dados',   TJSONArray(FjaDados.Clone));
    Result := joComando.ToJSON;
  finally
    FreeAndNil(joComando);
  end;
end;

procedure TComando.SetText(const Value: String);
var
  oComando: TJSONObject;
begin
  oComando := TJSONObject(TJSONObject.ParseJSONValue(Value));
  try
    if not Assigned(oComando) then
      raise Exception.Create('Erro ao converter os dados para JSON: '+ Value);

    try
      if not Assigned(oComando.GetValue('recurso')) then
        raise Exception.Create('Erro ao obter o recurso!');

      if not Assigned(oComando.GetValue('metodo')) then
        raise Exception.Create('Erro ao obter o metodo!');
    except on E: Exception do
      begin
        if Assigned(oComando) then
          FreeAndNil(oComando);

        raise Exception.Create(E.Message);
      end;
    end;

    FRecurso := oComando.GetValue('recurso').Value;
    FMetodo := oComando.GetValue('metodo').Value;

    if Assigned(FjaDados) then
      FreeAndNil(FjaDados);

    if Assigned(oComando.GetValue('dados')) and (oComando.GetValue('dados') is TJSONArray) then
      FjaDados := TJSONArray(oComando.GetValue('dados').Clone)
    else
      FjaDados := TJSONArray.Create;

  finally
    FreeAndNil(oComando);
  end;
  FText := Value;
end;

end.
