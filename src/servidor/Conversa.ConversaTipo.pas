// Eduardo - 20/07/2020

unit Conversa.ConversaTipo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TConversaTipo = class(TBase)
  public
    function Incluir: TJSONObject;
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
            ObterBase('conversa_tipo', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('conversa_tipo'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('conversa_tipo'));
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

end.
