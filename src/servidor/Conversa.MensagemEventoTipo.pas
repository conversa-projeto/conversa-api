// Eduardo - 20/07/2020

unit Conversa.MensagemEventoTipo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TMensagemEventoTipo = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
  end;

implementation

uses
  System.StrUtils;

{ TMensagemEventoTipo }

class procedure TMensagemEventoTipo.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
const
  RotaMensagemEventoTipo: Array[0..3] of String = ('mensagem_evento_tipo.incluir', 'mensagem_evento_tipo.obter', 'mensagem_evento_tipo.alterar', 'mensagem_evento_tipo.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaMensagemEventoTipo) of
    0,1,2,3:
    begin
      with TMensagemEventoTipo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaMensagemEventoTipo) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('mensagem_evento_tipo', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('mensagem_evento_tipo'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('mensagem_evento_tipo'));
        end;
      finally
        Free;
      end;
    end;
  end;
end;

function TMensagemEventoTipo.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into mensagem_evento_tipo '+
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
