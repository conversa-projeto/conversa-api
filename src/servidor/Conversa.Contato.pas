// Eduardo - 20/07/2020

unit Conversa.Contato;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TContato = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
  end;

implementation

uses
  System.StrUtils;

{ TContato }

class procedure TContato.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
const
  RotaContato: Array[0..3] of String = ('contato.incluir', 'contato.obter', 'contato.alterar', 'contato.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaContato) of
    0,1,2,3:
    begin
      with TContato.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaContato) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('contato', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('contato'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('contato'));
        end;
      finally
        Free;
      end;
    end;
  end;
end;

function TContato.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into contato '+
    '     ( usuario_id '+
    '     , contato_id '+
    '     , favorito '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].usuario_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].contato_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].favorito')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );
  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt));
end;

end.
