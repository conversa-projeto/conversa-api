// Eduardo - 20/07/2020

unit Conversa.Usuario;

interface

uses
  System.JSON,
  System.SysUtils,
  FireDAC.Comp.Client,
  Conversa.Comando,
  Conversa.Base;

type
  TUsuario = class(TBase)
  public
    function Incluir: TJSONObject;
    class function AutenticaUsuario(sUsuario, sSenha: String; Conexao: TFDConnection): Int64; static;
    class procedure Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
  end;

implementation

uses
  System.StrUtils,
  Data.DB;

{ TUsuario }

class procedure TUsuario.Rotas(cmdRequisicao, cmdResposta: TComando; Conexao: TFDConnection; Usuario: Int64);
const
  RotaUsuario: Array[0..3] of String = ('usuario.incluir', 'usuario.obter', 'usuario.alterar', 'usuario.excluir');
var
  jaDados: TJSONArray;
begin
  case IndexStr(cmdRequisicao.Recurso, RotaUsuario) of
    0,1,2,3:
    begin
      with TUsuario.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaUsuario) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1:
          begin
            jaDados := cmdResposta.Dados;
            ObterBase('usuario', jaDados);
          end;
          2: cmdResposta.Dados.AddElement(AlterarBase('usuario'));
          3: cmdResposta.Dados.AddElement(ExcluirBase('usuario'));
        end;
      finally
        Free;
      end;
    end;
  end;
end;

function TUsuario.Incluir: TJSONObject;
begin
  QryDados.Close;
  QryDados.Open(
    'insert '+
    '  into usuario '+
    '     ( nome '+
    '     , apelido '+
    '     , email '+
    '     , usuario '+
    '     , senha '+
    '     , perfil_id '+
    '     , incluido_id '+
    '     ) '+
    'values '+
    '     ( '+ QuotedStr(Dados.GetValue<String>('[0].nome')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].apelido')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].email')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].usuario')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].senha')) +
    '     , '+ QuotedStr(Dados.GetValue<String>('[0].perfil_id')) +
    '     , '+ IntToStr(Usuario) +
    '     ); '+
    'select LAST_INSERT_ID() as id '
  );
  Result := TJSONObject.Create.AddPair('id', TJSONNumber.Create(QryDados.FieldByName('id').AsLargeInt));
end;

class function TUsuario.AutenticaUsuario(sUsuario, sSenha: String; Conexao: TFDConnection): Int64;
var
  qry: TFDQuery;
  sTexto: String;
begin
  qry := TFDQuery.Create(nil);
  try
    qry.Connection := Conexao;
    qry.Open(
      'select id '+
      '  from usuario '+
      ' where excluido_id is null '+
      '   and usuario = '+ QuotedStr(sUsuario) +
      '   and senha   = '+ QuotedStr(sSenha) +
      IfThen(not sTexto.IsEmpty, '   and '+ sTexto)
    );
    if qry.IsEmpty then
      Result := -1
    else
      Result := qry.FieldByName('id').AsLargeInt;
  finally
    FreeAndNil(qry);
  end;
end;

end.
