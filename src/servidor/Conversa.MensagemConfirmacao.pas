// Eduardo - 21/07/2020

unit Conversa.MensagemConfirmacao;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TMensagemConfirmacao = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
  end;

implementation

uses
  System.StrUtils;

{ TMensagemConfirmacao }

class procedure TMensagemConfirmacao.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
const
  RotaMensagemConfirmacao: Array[0..3] of String = ('mensagem_confirmacao.incluir', 'mensagem_confirmacao.obter', 'mensagem_confirmacao.alterar', 'mensagem_confirmacao.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaMensagemConfirmacao) of
    0,1,2,3:
    begin
      with TMensagemConfirmacao.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaMensagemConfirmacao) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('mensagem_confirmacao', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('mensagem_confirmacao'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('mensagem_confirmacao'));
        end;
        Envolvidos(
          aiEnvolvidos,
            'select conversa_usuario.usuario_id '+
            '  from mensagem_confirmacao '+
            ' inner '+
            '  join mensagem '+
            '    on mensagem.id = mensagem_confirmacao.mensagem_id '+
            ' inner '+
            '  join conversa_usuario '+
            '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
            ' where mensagem_confirmacao.id = '
        );
      finally
        Free;
      end;
    end;
  end;
end;

function TMensagemConfirmacao.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into mensagem_confirmacao '+
    '     ( descricao '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].descricao')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );

  Identificador := QryDados.FieldByName('id').AsLargeInt;

  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(Identificador));
end;

end.
