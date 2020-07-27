// Eduardo - 20/07/2020

unit Conversa.MensagemEvento;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TMensagemEvento = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
  end;

implementation

uses
  System.StrUtils;

{ TMensagemEvento }

class procedure TMensagemEvento.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
const
  RotaMensagemEvento: Array[0..3] of String = ('mensagem_evento.incluir', 'mensagem_evento.obter', 'mensagem_evento.alterar', 'mensagem_evento.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaMensagemEvento) of
    0,1,2,3:
    begin
      with TMensagemEvento.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaMensagemEvento) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('mensagem_evento', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('mensagem_evento'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('mensagem_evento'));
        end;
        Envolvidos(
          aiEnvolvidos,
            'select conversa_usuario.usuario_id '+
            '  from mensagem_evento '+
            ' inner '+
            '  join mensagem '+
            '    on mensagem.id = mensagem_evento.mensagem_id '+
            ' inner '+
            '  join conversa_usuario '+
            '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
            ' where mensagem_evento.id = '
        );
      finally
        Free;
      end;
    end;
  end;
end;

function TMensagemEvento.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into mensagem_evento '+
    '     ( usuario_id '+
    '     , mensagem_id '+
    '     , tipo '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].usuario_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].mensagem_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].tipo')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );

  Identificador := QryDados.FieldByName('id').AsLargeInt;

  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(Identificador));
end;

end.
