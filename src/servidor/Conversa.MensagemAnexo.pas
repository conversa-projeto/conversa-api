// Eduardo - 20/07/2020

unit Conversa.MensagemAnexo;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;


type
  TMensagemAnexo = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
  end;

implementation

uses
  System.StrUtils;

{ TMensagemAnexo }

class procedure TMensagemAnexo.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
const
  RotaMensagemAnexo: Array[0..3] of String = ('mensagem_anexo.incluir', 'mensagem_anexo.obter', 'mensagem_anexo.alterar', 'mensagem_anexo.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaMensagemAnexo) of
    0,1,2,3:
    begin
      with TMensagemAnexo.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaMensagemAnexo) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('mensagem_anexo', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('mensagem_anexo'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('mensagem_anexo'));
        end;
        Envolvidos(
          aiEnvolvidos,
            'select conversa_usuario.usuario_id '+
            '  from mensagem_anexo '+
            ' inner '+
            '  join mensagem '+
            '    on mensagem.id = mensagem_anexo.mensagem_id '+
            ' inner '+
            '  join conversa_usuario '+
            '    on conversa_usuario.conversa_id = mensagem.conversa_id '+
            ' where mensagem_anexo.id = '
        );
      finally
        Free;
      end;
    end;
  end;
end;

function TMensagemAnexo.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into mensagem_anexo '+
    '     ( mensagem_id '+
    '     , tipo '+
    '     , local '+
    '     , tamanho '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].mensagem_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].tipo')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].local')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].tamanho')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );

  Identificador := QryDados.FieldByName('id').AsLargeInt;

  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(Identificador));
end;

end.
