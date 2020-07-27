// Eduardo - 20/07/2020

unit Conversa.Conversa;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TConversa = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
  end;

implementation

uses
  System.StrUtils;

{ TConversa }

class procedure TConversa.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
const
  RotaConversa: Array[0..3] of String = ('conversa.incluir', 'conversa.obter', 'conversa.alterar', 'conversa.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaConversa) of
    0,1,2,3:
    begin
      with TConversa.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaConversa) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('conversa', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('conversa'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('conversa'));
        end;
        Envolvidos(
          aiEnvolvidos,
          'select usuario_id '+
          '  from conversa '+
          ' inner '+
          '  join conversa_usuario '+
          '    on conversa_usuario.conversa_id = conversa.id '+
          ' where conversa.id = '
        );
      finally
        Free;
      end;
    end;
  end;
end;

function TConversa.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into conversa '+
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

  Identificador := QryDados.FieldByName('id').AsLargeInt;

  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(Identificador));
end;

end.
