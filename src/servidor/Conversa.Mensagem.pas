// Eduardo - 20/07/2020

unit Conversa.Mensagem;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TMensagem = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
  end;

implementation

uses
  System.StrUtils;

{ TMensagem }

class procedure TMensagem.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
const
  RotaMensagem: Array[0..3] of String = ('mensagem.incluir', 'mensagem.obter', 'mensagem.alterar', 'mensagem.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaMensagem) of
    0,1,2,3:
    begin
      with TMensagem.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaMensagem) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('mensagem', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('mensagem'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('mensagem'));
        end;
        Envolvidos(
          aiEnvolvidos,
            'select conversa_usuario.usuario_id '+
            '  from mensagem '+
            ' inner '+
            '  join conversa_usuario '+
            '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
            ' where mensagem.id = '
        );
      finally
        Free;
      end;
    end;
  end;
end;

function TMensagem.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into mensagem '+
    '     ( mensagem_id '+
    '     , usuario_id '+
    '     , conversa_id '+
    '     , resposta '+
    '     , confirmacao '+
    '     , conteudo '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].mensagem_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].usuario_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].conversa_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].resposta')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].confirmacao')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].conteudo')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );

  Identificador := QryDados.FieldByName('id').AsLargeInt;

  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(Identificador));
end;

end.
