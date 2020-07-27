// Eduardo - 20/07/2020

unit Conversa.ConversaUsuario;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TConversaUsuario = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
  end;

implementation

uses
  System.StrUtils;

{ TConversaUsuario }

class procedure TConversaUsuario.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64; var aiEnvolvidos: TArray<Int64>);
const
  RotaConversaUsuario: Array[0..3] of String = ('conversa_usuario.incluir', 'conversa_usuario.obter', 'conversa_usuario.alterar', 'conversa_usuario.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaConversaUsuario) of
    0,1,2,3:
    begin
      with TConversaUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaConversaUsuario) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('conversa_usuario', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('conversa_usuario'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('conversa_usuario'));
        end;
        Envolvidos(
          aiEnvolvidos,
          'select usuario_conversa.usuario_id '+
          '  from conversa_usuario '+
          ' inner '+
          '  join conversa_usuario as usuario_conversa '+
          '    on usuario_conversa.conversa_id = conversa_usuario.conversa_id '+
          ' where conversa_usuario.id = '
        );
      finally
        Free;
      end;
    end;
  end;
end;

function TConversaUsuario.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into conversa_usuario '+
    '     ( usuario_id '+
    '     , conversa_id '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].usuario_id')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].conversa_id')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );

  Identificador := QryDados.FieldByName('id').AsLargeInt;

  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(Identificador));
end;

end.
