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
  private
    procedure Obter(jaSaida: TJSONArray);
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
begin
  case IndexStr(cmdRequisicao.Recurso, RotaConversa) of
    0,1,2,3:
    begin
      with TConversa.Create(cmdRequisicao.Dados, Conexao, Usuario) do
      try
        case IndexStr(cmdRequisicao.Recurso, RotaConversa) of
          0: cmdResposta.Dados.AddElement(Incluir);
          1: Obter(cmdRequisicao.Dados);
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

procedure TConversa.Obter(jaSaida: TJSONArray);
begin
  QryDados.Open(
    'select conversa.id'+
    '     , cast(if(conversa.tipo = 1, usuario.nome, conversa.descricao) as varchar(100)) as descricao'+
    '     , conversa.tipo'+
    '     , conversa.incluido_id'+
    '     , conversa.incluido_em'+
    '     , conversa.alterado_id'+
    '     , conversa.alterado_em'+
    '     , conversa.excluido_id'+
    '     , conversa.excluido_em'+
    '     , usuario.nome'+
    '     , mensagem.id'+
    '     , mensagem.conteudo'+
    '     , mensagem.usuario_id'+
    '     , mensagem.incluido_em as msg_incluido_em'+
    '  from conversa.conversa'+
    ' inner '+
    '  join conversa.conversa_usuario as cvs_usuario'+
    '    on cvs_usuario.excluido_em is null'+
    '   and cvs_usuario.conversa_id = conversa.id'+
    '   and cvs_usuario.usuario_id = '+ Usuario.ToString +
    '  left '+
    '  join conversa.usuario'+
    '    on usuario.excluido_em is null'+
    '   and usuario.id = ( select conversa_usuario.usuario_id'+
    '                        from conversa.conversa_usuario'+
    '                       where conversa_usuario.excluido_em is null'+
    '                         and conversa_usuario.conversa_id = conversa.id'+
    '                         and conversa_usuario.usuario_id <> '+ Usuario.ToString +')'+
    '  left '+
    '  join conversa.mensagem'+
    '    on mensagem.id = (select msg.id'+
    '                        from conversa.mensagem as msg'+
    '                       where msg.excluido_em is null'+
    '                         and msg.conversa_id = conversa.conversa.id'+
    '                       order'+
    '                          by msg.incluido_em DESC'+
    '                       limit 1'+
    '                      )'+
    '  left '+
    '  join conversa.usuario as usuario_msg'+
    '    on usuario_msg.id = mensagem.usuario_id'+
    ' where conversa.excluido_em is null'
  );
  QryDados.First;
  while not QryDados.Eof do
  begin
    jaSaida.AddElement(TabelaParaJSONObject(QryDados));
    QryDados.Next;
  end;
end;

end.
