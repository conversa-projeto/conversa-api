// Eduardo - 19/07/2020

unit Conversa.Perfil;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TPerfil = class(TBase)
  public
    function Incluir: TJSONObject;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
  end;

implementation

uses
  System.StrUtils;

{ TPerfil }

class procedure TPerfil.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
const
  RotaPerfil: Array[0..3] of String = ('perfil.incluir', 'perfil.obter', 'perfil.alterar', 'perfil.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaPerfil) of
    0,1,2,3:
    begin
      with TPerfil.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaPerfil) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('perfil', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('perfil'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('perfil'));
        end;
      finally
        Free;
      end;
    end;
  end;
end;

function TPerfil.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into perfil '+
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
