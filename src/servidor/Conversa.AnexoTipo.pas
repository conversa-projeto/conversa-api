// Eduardo - 20/07/2020

unit Conversa.AnexoTipo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TAnexoTipo = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
  end;

implementation

uses
  System.StrUtils;

{ TAnexoTipo }

class procedure TAnexoTipo.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
const
  RotaAnexoTipo: Array[0..3] of String = ('anexo_tipo.incluir', 'anexo_tipo.obter', 'anexo_tipo.alterar', 'anexo_tipo.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaAnexoTipo) of
    0,1,2,3:
    begin
      with TAnexoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaAnexoTipo) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('anexo_tipo', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('anexo_tipo'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('anexo_tipo'));
        end;
      finally
        Free;
      end;
    end;
  end;
end;

function TAnexoTipo.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into anexo_tipo '+
    '     ( descricao '+
    '     , tipo '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].descricao')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].tipo')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );
  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt));
end;

end.
